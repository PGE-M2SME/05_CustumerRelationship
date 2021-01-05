
--
-- Projet de test Ext10/12 sur PFX avec Xv
--   Ext12 en slot1
--   Ext10 en slot2
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.pmi_components.all;
library pmi_work;

entity CopyVideoTop is port(
        PinClk125 : in std_logic;
        PinLedXv : out std_logic;
        PinPortRx : in std_logic;
        PinPortTx : out std_logic;

-- DVI capture
     PinClk403, PinVSync403, PinHSync403, PinDe403 : in std_logic;
     PinDat403 : in std_logic_vector(23 downto 0);

-- DVI generator
     PinClk410, PinVSync410, PinHSync410, PinDe410 : out std_logic;
     PinDat410 : out std_logic_vector(23 downto 0);

     PinSda410 : inout std_logic;
     PinScl410 : out std_logic);

end CopyVideoTop;

architecture rtl of CopyVideoTop is

component Pll125to50
    port (CLK: in std_logic; CLKOP, LOCK: out std_logic);
end component;

component SeqBlk 
generic(FREQMHZ : integer := 100; BAUDRATE : integer := 115200);
port ( Clk, ARst_N : in std_logic;
       SysCnt32 : out std_logic_vector(31 downto 0);
       InitDone, Ce16, Ce7, Ce1ms, Ce1us, SRst : out std_logic;
       StartupPCS : out std_logic_vector(1 downto 0); 
       StartupSDR, StartupDDR2, StartupDDR3 : out std_logic); 
end component;

component I2cMasterCommands 
generic(FPGA_FAMILY : string := "ECP3";
        FREQ_MHZ : integer := 100; 
        RATE_KHZ : integer := 400);
port( 
	Clk, SRst: in std_logic ;

-- Command controls
    Trg, RdWr_N : in std_logic;
    Done, Busy : out std_logic;
    DeviceId, Address : in std_logic_vector(7 downto 0);

-- Write commands 
    We : in std_logic;
    DataW : in std_logic_vector(7 downto 0);
    FifoFull : out std_logic;

-- Read commands
    DataR : out std_logic_vector(7 downto 0);
    RdLen : in std_logic_vector(7 downto 0);
    DataVal : out std_logic;

-- I2C external interface
	Sda: inout std_logic ;
	Scl: out std_logic  
);
end component;

component pmi_fifo is
     generic (
       pmi_data_width : integer := 16; pmi_data_depth : integer := 1024; 
       pmi_full_flag : integer := 1024; pmi_empty_flag : integer := 0; 
       pmi_almost_full_flag : integer := 252; pmi_almost_empty_flag : integer := 4; 
       pmi_regmode : string := "reg"; pmi_family : string := "ECP3" ; 
       module_type : string := "pmi_fifo"; pmi_implementation : string := "LUT");
    port (
     Data : in std_logic_vector(pmi_data_width-1 downto 0);
     Clock: in std_logic; WrEn: in std_logic; RdEn: in std_logic;
     Reset: in std_logic; Q : out std_logic_vector(pmi_data_width-1 downto 0);
     Empty: out std_logic; Full: out std_logic;
     AlmostEmpty: out std_logic; AlmostFull: out std_logic);
end component ;

component Forth  
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
end component;

-- Clocks, Rst,...
signal Clk50, Ce16, SRst, ARst_N, PllLock, InitDone : std_logic;
signal SysCnt32 : std_logic_vector(31 downto 0);

-- Processor interface
signal PpWe : std_logic;
signal PpAdd : std_logic_vector(7 downto 0);
signal PokeDat, PeekDat, MiscReg1, MiscReg2, Timer : std_logic_vector(31 downto 0);

-- I2c interface
signal I2cTrg, I2cRdWr_N, I2cWe, DataVal, FifoRd, I2cBusy : std_logic;
signal RdLen, DataR, I2cDataR : std_logic_vector(7 downto 0);

-- Video signals
signal VSync403, HSync403, De403, VSync410, HSync410, De410 : std_logic;
signal Dat403, Dat410 : std_logic_vector(23 downto 0);

component ODDRXC 
port(
	Clk, Da, Db, Rst : in std_logic;
	Q : out std_logic);
end component;

begin

uPll : Pll125to50 port map (CLK=>PinClk125, CLKOP=>Clk50, LOCK=>PllLock);

ARst_N <= PllLock;

uSeq : SeqBlk generic map (FREQMHZ=>50)
              port map (Clk=>Clk50, ARst_N=>ARst_N, SysCnt32=>SysCnt32, SRst=>SRst, InitDone=>InitDone, Ce16=>Ce16); 

PinLedXv <= SysCnt32(23);

--
-- Forth
--

uForth : Forth port map(Clk=>Clk50, SRst=>SRst, Ce16=>Ce16, TrgIntRe=>'0', 
                        --PortRx=>'1', PortTx=>open, Monitor=>open,
                        PortRx=>PinPortRx, PortTx=>PinPortTx, Monitor=>open,
                        PpWe=>PpWe, PpAdd=>PpAdd, PokeDat=>PokeDat, PeekDat=>PeekDat);

--
-- Registers
--

pSetReg: process (Clk50)
begin
  if Clk50'event and Clk50='1' then
    if SRst = '1' then
      MiscReg1 <= (others => '0');
    elsif ((PpWe = '1') and (PpAdd = X"26")) then 
      MiscReg1 <= PokeDat;
    end if;
    if SRst = '1' then
      MiscReg2 <= (others => '0');
    elsif ((PpWe = '1') and (PpAdd = X"27")) then 
      MiscReg2 <= PokeDat;
    end if;
    if SRst = '1' then
      Timer <= (others => '0');
    elsif ((PpWe = '1') and (PpAdd = X"08")) then 
      Timer <= PokeDat;
    elsif Timer /= X"00000000" then 
      Timer <= Timer + X"FFFFFFFF";
    end if;
    if SRst = '1' then
      RdLen <= X"04";
    elsif ((PpWe = '1') and (PpAdd = X"33")) then 
      RdLen <= PokeDat(7 downto 0);
    end if;
  end if;
end process pSetReg;

PeekDat <= X"0000000" & "000" & InitDone  when PpAdd = X"05" else 
           Timer                          when PpAdd = X"08" else 
           MiscReg1                       when PpAdd = X"26" else 
           MiscReg2                       when PpAdd = X"27" else 
           X"0000000" & "000" & I2cBusy   when PpAdd = X"35" else 
           X"000000" & I2cDataR           when PpAdd = X"34" else
           X"CAFECAFE";

-- 
-- TFP410 interface: Config TFP
--

uMaster : I2cMasterCommands  
generic map(FPGA_FAMILY=>"ECP3", FREQ_MHZ=>50, RATE_KHZ=>100)
port map( 
	Clk=>Clk50, SRst=>SRst,
    Trg=>I2cTrg, RdWr_N=>I2cRdWr_N,
    Done=>open, Busy=>I2cBusy,
    DeviceId=>X"70", Address=>PokeDat(7 downto 0),
    We=>I2cWe, DataW=>PokeDat(7 downto 0), FifoFull=>open,
    DataR=>DataR, RdLen=>RdLen, DataVal=>DataVal,
    Sda=>PinSda410, Scl=>PinScl410);

I2cTrg <= '1' when ((PpWe = '1') and (PpAdd = X"31")) else 
          '1' when ((PpWe = '1') and (PpAdd = X"32")) else 
          '0';

I2cRdWr_N <= '0' when ((PpWe = '1') and (PpAdd = X"31")) else '1';

I2cWe <= '1' when ((PpWe = '1') and (PpAdd = X"30")) else '0';
FifoRd <= '1' when ((PpWe = '1') and (PpAdd = X"34")) else '0';

uFifoRxRaw : pmi_fifo 
generic map(pmi_data_width=>8, pmi_data_depth=>16, pmi_full_flag=>16,
            pmi_regmode=>"noreg", pmi_family=>"ECP3", pmi_implementation=>"LUT")
port map(Clock=>Clk50, Data=>DataR, WrEn=>DataVal, Q=>I2cDataR, RdEn=>FifoRd, Reset=>SRst);

--
-- Copy DVI data
--
 
pGenDat1: process(PinClk403)
begin
  if PinClk403'event and PinClk403='1' then
    VSync403 <= PinVSync403;
    HSync403 <= PinHSync403;
    De403 <= PinDe403;
    Dat403 <= PinDat403;
  end if;
end process pGenDat1;

pGenDat2: process(PinClk403)
begin
  if PinClk403'event and PinClk403='1' then
    VSync410 <= VSync403;
    HSync410 <= HSync403;
    De410 <= De403;
    Dat410 <= Dat403;

    PinVSync410 <= VSync410;
    PinHSync410 <= HSync410;
    PinDe410 <= De410;
    PinDat410 <= Dat410;
  end if;
end process pGenDat2;

--uTfpClk : ODDRXC port map(Clk=>PinClk403, Da=>'1', Db=>'0', Rst=>'0', Q=>PinClk410);
PinClk410 <= PinClk403;
end rtl;

