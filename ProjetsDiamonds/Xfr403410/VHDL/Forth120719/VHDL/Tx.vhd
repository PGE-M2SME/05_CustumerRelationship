--
--
-- Module Tx: Transmit UART
--
-- 
-- --------------------------------------------------------------------
--
--   Description:
--
--   This VHDL module is the "transmit" side of a UART. The baud rate is adjustable.
--   Words are 8 bits and there is no parity generated.
--
-- --------------------------------------------------------------------
--
--  Interfaces:
--
--  Inputs:
--    Clk: std_logic: System clock routed on dedicated resource
--    SRst: std_logic: Active high synchronous reset
--    Ce16: std_logic: Clock enable with 16* uart baudrate
--    Trg: std_logic: Active high start pulse 
--    Dat: std_logic_vector: Parallel data to be transmitted
--
--  Outputs:
--    Tx: std_logic: UART serialized output
--    TxReady: std_logic: Active high signal for transmit completion
--
-- --------------------------------------------------------------------
--
--   Disclaimer:
--
--   This source code is intended as a design reference to illustrate
--   a basic functionality on the Tachyssema modules.
--
--   It is the user's responsibility to formally verify the functionality 
--   and performance of this code when merged with the rest of his design.
--
--   Tachyssema provides no warranty regarding the use or functionality 
--   of this code.
--
-- --------------------------------------------------------------------
--
--                     Tachyssema SARL
--                     20 rue Jean Moulin
--                     F31700 BLAGNAC
--
--                     web:   http://www.tachyssema.com
--                     email: support@tachyssema.com
--
-- --------------------------------------------------------------------
--

library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity Tx is
    Port ( Clk : in std_logic;
           Ce16 : in std_logic;
           SRst : in std_logic;
           Tx : out std_logic;
           Trg : in std_logic;
           Dat : in std_logic_vector(7 downto 0);
           TxReady : out std_logic);
end Tx;

architecture Behavioral of Tx is

signal Cnt, XDat : std_logic_vector(7 downto 0);

begin

pGenCnt: process(Clk) begin
  if Clk'event and Clk='1' then
    if SRst = '1' then
      Cnt <= X"FB";
    elsif Trg = '1' then
      Cnt <= X"00";
    elsif ((Ce16 = '1') and (Cnt < X"EA")) then
      Cnt <= Cnt + X"01";
    end if; 
  end if;
end process pGenCnt;

pGenDat: process(Clk) begin
  if Clk'event and Clk='1' then
    if Trg = '1' then
      XDat <= Dat;
    end if;
    if Cnt < X"10" then
      Tx <= '1';
    elsif Cnt < X"20" then
      Tx <= '0';
    elsif Cnt < X"30" then
      Tx <= XDat(0);
    elsif Cnt < X"40" then
      Tx <= XDat(1);
    elsif Cnt < X"50" then
      Tx <= XDat(2);
    elsif Cnt < X"60" then
      Tx <= XDat(3);
    elsif Cnt < X"70" then
      Tx <= XDat(4);
    elsif Cnt < X"80" then
      Tx <= XDat(5);
    elsif Cnt < X"90" then
      Tx <= XDat(6);
    elsif Cnt < X"A0" then
      Tx <= XDat(7);
    else
      Tx <= '1';
    end if; 
  end if;
end process pGenDat;

pGenTxReady: process(Clk) begin
  if Clk'event and Clk='1' then
    if Trg = '1' then
      TxReady <= '0';
    elsif Cnt > X"E0" then
      TxReady <= '1';
    end if; 
  end if;
end process pGenTxReady;

end Behavioral;
