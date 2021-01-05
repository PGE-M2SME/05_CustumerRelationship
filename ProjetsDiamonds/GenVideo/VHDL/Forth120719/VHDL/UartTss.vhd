library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity uart is
    Port ( Clk, Ce16, SRst : in std_logic;
           
    ce_i:       	in      std_logic;
    read_i:     in      std_logic;
    write_i:    in      std_logic;
    addr_i:     in      std_logic_vector(1 downto 0);
    data_i:     in      std_logic_vector(31 downto 0);
    -- output
    data_o:     out     std_logic_vector(31 downto 0);
    -- external interface
    rxd_i:      in      std_logic;
    txd_o:      out     std_logic
  );
end uart;
    
architecture rtl of uart is

component Rx 
    Port ( Clk : in std_logic;
           Ce16 : in std_logic;
           SRst : in std_logic;
           Rx : in std_logic;
           Trg : out std_logic;
           Dat : out std_logic_vector(7 downto 0));
end component;

component Tx 
    Port ( Clk : in std_logic;
           Ce16 : in std_logic;
           SRst : in std_logic;
           Tx : out std_logic;
           Trg : in std_logic;
           Dat : in std_logic_vector(7 downto 0);
           TxReady : out std_logic);
end component;

signal TrgRx, TrgTx, TxEn: std_logic;
signal RxFull, TxEmpty: std_logic;
signal DatTx, DatRx, DatRxB: std_logic_vector(7 downto 0);

begin

data_o <= X"000000" & "0000000" & TxEmpty when addr_i = "01" else
          X"000000" & "0000000" & RxFull  when addr_i = "10" else
		  X"000000" & DatRxB;

uRx: Rx 
  port map (Clk=>Clk, Ce16=>Ce16, SRst=>SRst,
            Rx=>rxd_i, Trg=>TrgRx, Dat=>DatRx);
			
uTx: Tx 
  port map (Clk=>Clk, Ce16=>Ce16, SRst=>SRst, TxReady=>TxEmpty,
            Tx=>txd_o, Trg=>TrgTx, Dat=>DatTx);

TxEn <= ce_i and write_i;

pTx: process(Clk) begin
  if Clk'event and Clk='1' then
    TrgTx <= TxEn;
    if TxEn = '1' then
      DatTx <= data_i(7 downto 0);
    end if; 
  end if;
end process pTx;

pRx: process(Clk) begin
  if Clk'event and Clk='1' then
    if TrgRx = '1' then
      DatRxB <= DatRx;
    end if; 
    if SRst = '1' then
	  RxFull <= '0';
	elsif TrgRx = '1' then
	  RxFull <= '1';
    elsif ((ce_i = '1') and (addr_i = "11")) then
	  RxFull <= '0';
    end if; 
  end if;
end process pRx;

end rtl;
                            
