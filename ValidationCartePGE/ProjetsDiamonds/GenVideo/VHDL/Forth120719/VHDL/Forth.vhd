-- ****************************************************************
-- *         (C) Copyright 2002, eForth Technology Inc.           *
-- *                     ALL RIGHTS RESERVED                      *
-- *==============================================================*
-- * Project:             FG in PROASIC                           *
-- * File:                ep32_chip.vhd                           *
-- * Author:              Chien-Chia Wu                           *
-- * Description:         Top level block                         *
-- *                                                              *
-- * Hierarchy:parent:                                            *
-- *           child :                                            * 
-- *                                                              *
-- * Revision History:                                            *
-- * Date         By Who          Modification                    *
-- * 09/19/02     Chien-Chia Wu   Branch from ep16a.              *
-- * 01/02/03     Chien-Chia Wu   Add SDI.                        *
-- * 01/29/03     Chien-Chia Wu   Add Boot.                       *
-- * 02/24/03     Chien-Chia Wu   Modify the module as 32-bits    * 
-- *                              version.                        * 
-- * 02/27/03     Chien-Chia Wu   Modify SDRAM as byte-assecable. *
-- * 03/02/03     Chien-Chia Wu   Add internal SRAM module.       *
-- * 06/29/06     Chen-Hanson Ting Add HMPP/Shifter/Controller.   *
-- * 11/18/10     Chen-Hanson Ting Port to LatticeXP2 Brevia Kit  *
-- * 12/02/21     Nicolas Roddier Port to XP2/ECP3 FPGAs          *
-- ****************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_unsigned.all;

entity Forth is
generic(FPGA_FAMILY : string := "ECP3";
        HEXFILE : string := "ep32q.hex"); 
port(
    Clk, SRst, Ce16, PortRx, TrgIntRe : in std_logic;
    PortTx, PpWe : out std_logic;
    PpAdd : out std_logic_vector(7 downto 0);
    PokeDat : out std_logic_vector(31 downto 0);
    PeekDat : in std_logic_vector(31 downto 0);
    Monitor: out std_logic_vector(7 downto 0)
  );
end entity Forth;

architecture rtl of Forth is

-- Changer aussi le générateur de .hex dans META32Q.F si on veut 8K, 16K,...
constant FORTH_ADD_DEPTH : integer := 4096; --8192
constant FORTH_ADD_WIDTH : integer := 12; --13

component ep32 is 
    port(
      -- input port
      clk:        in      std_logic;
      SRst:        in      std_logic;
      interrupt:  in      std_logic;
      data_i:     in      std_logic_vector(31 downto 0);
      intack:     out     std_logic;
      read:       out     std_logic;
      write:      out     std_logic;
      addr:       out     std_logic_vector(31 downto 0);
    data_o:     out     std_logic_vector(31 downto 0);
    Monitor:     out     std_logic_vector(5 downto 0)
    );
end component;

component uart is
    port(
      -- input
      Clk, SRst, Ce16:      	in      std_logic;
      ce_i:       	in      std_logic;
      read_i:     	in      std_logic;
      write_i:    	in      std_logic;
      addr_i:     	in      std_logic_vector(1 downto 0);
      data_i:     	in      std_logic_vector(31 downto 0);
      -- output   	
      data_o:     	out     std_logic_vector(31 downto 0);
      -- external interface
      rxd_i:      	in      std_logic;
      txd_o:      	out     std_logic
    );
  end component;

component pmi_ram_dq is
     generic (
       pmi_addr_depth : integer := 512; 
       pmi_addr_width : integer := 9; 
       pmi_data_width : integer := 18; 
       pmi_regmode : string := "reg"; 
       pmi_gsr : string := "disable"; 
       pmi_resetmode : string := "sync"; 
       pmi_optimization : string := "speed";
       pmi_init_file : string := "none"; 
       pmi_init_file_format : string := "binary"; 
       pmi_write_mode : string := "normal"; 
       pmi_family : string := "EC"; 
       module_type : string := "pmi_ram_dq" 
    );
    port (
     Data : in std_logic_vector((pmi_data_width-1) downto 0);
     Address : in std_logic_vector((pmi_addr_width-1) downto 0);
     Clock: in std_logic;
     ClockEn: in std_logic;
     WE: in std_logic;
     Reset: in std_logic;
     Q : out std_logic_vector((pmi_data_width-1) downto 0)
   );
end component pmi_ram_dq;

  -- interal globle signal
  signal m_clk:                 std_logic;
  signal memory_data_o:         std_logic_vector(31 downto 0);
  signal memory_data_i:         std_logic_vector(31 downto 0);
  signal memory_addr:           std_logic_vector(11 downto 0);
  signal memory_we:             std_logic;

  -- internal signal for system bus
  signal system_addr:           std_logic_vector(31 downto 0);
  signal system_data_o:         std_logic_vector(31 downto 0);
  signal system_read:           std_logic;
  signal system_write:          std_logic;
  
  -- internal signal for cpu
  signal cpu_data_i:            std_logic_vector(31 downto 0);
  signal cpu_addr_o:            std_logic_vector(31 downto 0);
  signal cpu_data_o:            std_logic_vector(31 downto 0);
  signal cpu_m_read:            std_logic;
  signal cpu_m_write:           std_logic;
  signal cpu_intack:            std_logic;
  signal cpu_ready_i:           std_logic;
 
  -- internal signal for uart
  signal uart_ce:               std_logic; 
  signal uart_addr:             std_logic_vector(1 downto 0);
  signal uart_data_i:           std_logic_vector(31 downto 0);
  signal uart_data_o:           std_logic_vector(31 downto 0);
  signal uart_rxd:              std_logic;
  signal uart_txd:              std_logic;

signal ItVec, TrgIntReD : std_logic;

begin

--
--
--

Monitor(7) <= TrgIntRe;
Monitor(6) <= cpu_intack;

--

pInterrupt: process (Clk)
begin
  if Clk'event and Clk='1' then
    TrgIntReD <= TrgIntRe;
    if SRst = '1' then
      ItVec <= '0';
    elsif cpu_intack = '1' then
      ItVec <= '0';
    elsif ((TrgIntRe = '1') and (TrgIntReD = '0')) then
      ItVec <= '1';
    end if;
  end if;
end process pInterrupt;

  -- ************************************************************************   
  --            Component Binding
  -- ************************************************************************   
  -- ========================= CPU Block ===========================     
  cpu1: ep32 
    port map (
      -- input port
      clk => Clk,
      SRst => SRst,
      interrupt => ItVec,
      data_i => cpu_data_i,
      intack => cpu_intack,
      read => cpu_m_read,
      write => cpu_m_write,
      addr => cpu_addr_o,
      data_o => cpu_data_o,
      Monitor => Monitor(5 downto 0)
    );

  -- ************************************************************************   
  --            Internal Globle Signal Circuit
  -- ************************************************************************   

  m_clk <= not Clk;
  system_addr <= cpu_addr_o;
  system_read <= cpu_m_read;
  system_write <= cpu_m_write;
  cpu_ready_i <= '1';

  cpu_data_i <= system_data_o;

  system_data_o <=  cpu_data_o when (system_write='1') else 
			memory_data_o when (system_addr(31 downto 28)="0000") else
			uart_data_o when (system_addr(31 downto 28)="1000") else
			PeekDat when (system_addr(31 downto 28)="1110") else
			(others => 'Z');

  -- ========================= UART Block ===========================     
  uart1 : uart
    port map (
      -- input
      Clk => Clk,
      SRst => SRst, Ce16=>Ce16,
      ce_i => uart_ce,
      read_i => system_read,
      write_i => system_write,
      addr_i => uart_addr,
      data_i => uart_data_i,
      -- output
      data_o => uart_data_o,
      -- external interface
      rxd_i => uart_rxd,
      txd_o => uart_txd
    );
  uart_ce <= '1' when (system_addr(31 downto 28)="1000") else '0';
  uart_addr <= system_addr(1 downto 0);
  uart_data_i <= system_data_o;
  uart_rxd <= PortRx;
  PortTx <= uart_txd;
 
  -- ========================= RAM Block ===========================     
uForthMem : pmi_ram_dq 
generic map(pmi_addr_depth=>FORTH_ADD_DEPTH, pmi_addr_width=>FORTH_ADD_WIDTH,
            pmi_data_width=>32, pmi_regmode=>"noreg", pmi_init_file=>HEXFILE, 
            pmi_init_file_format=>"hex", pmi_family=>FPGA_FAMILY)
port map(Data=>memory_data_i, Address=>memory_addr,
         Clock=>m_clk, ClockEn=>'1', WE=>memory_we,
         Reset=>'0', Q=>memory_data_o);

  memory_we <= system_write when (system_addr(31 downto 28)="0000") else '0';
  memory_addr <= cpu_addr_o(FORTH_ADD_WIDTH - 1 downto 0);
  memory_data_i <= cpu_data_o ;

  -- ========================= GPIO Block ===========================     
  
  PpWe <= system_write when (system_addr(31 downto 28)="1110") else '0';
  PpAdd <= system_addr(7 downto 0);
  PokeDat <= system_data_o;

  end rtl;
