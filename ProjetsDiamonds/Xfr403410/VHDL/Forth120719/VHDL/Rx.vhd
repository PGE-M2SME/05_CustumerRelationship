--
--
-- Module Rx: Receive UART
--
-- 
-- --------------------------------------------------------------------
--
--   Description:
--
--   This VHDL module is the "receive" side of a UART. The baud rate is adjustable.
--   Words are 8 bits and parity is not accepted.
--
-- --------------------------------------------------------------------
--
--   Interface signals:
--
--   Inputs:
--     Clk  : system clock routed on a dedicated global clock resource
--     Ce16 : clock enable to reduce the effective clock period to 16 times the baud rate
--     SRst : synchronous reset, active high 
--     Rx   : actual serial stream into the UART
--   Output:
--     Dat  : 8-bit data received
--     Trg  : trigger to indicate a new character has been received
--
--   Operation:
--
--     1. The Clk and Ce16 signals must be valid as specified
--     2. The SRst signal must be low
--     3. A data stream is received
--     4. At completion, the data is presented on the port "Dat" and "Trg" is pulsed high
--
-- --------------------------------------------------------------------
--
--   Disclaimer:
--
--   This source code is intended as a design reference to illustrate
--   how to receive a character via a UART. This function is used on the  
--   Tachyssema platforms.
--
--   It is the user's responsibility to formally verify the functionality and 
--   performance of this code when merged with the rest of his design.
--
--   Tachyssema provides no warranty regarding the use or functionality of this code.
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

entity Rx is
    Port ( Clk : in std_logic;
           Ce16 : in std_logic;
           SRst : in std_logic;
           Rx : in std_logic;
           Trg : out std_logic;
           Dat : out std_logic_vector(7 downto 0));
end Rx;

architecture Behavioral of Rx is

signal Rx0, Rx1, RcvState : std_logic;
signal Cnt, XDat : std_logic_vector(7 downto 0);

begin

pRxBuff: process(Clk) begin
  if Clk'event and Clk='1' then
    Rx0 <= Rx;
    Rx1 <= Rx0;
  end if;
end process pRxBuff;

pGenCnt: process(Clk) begin
  if Clk'event and Clk='1' then
    if ((Rx0 = '0') and (Rx1 = '1') and (RcvState = '0')) then
      Cnt <= X"00";
    elsif ((Ce16 = '1') and (RcvState = '1')) then
      Cnt <= Cnt + X"01";
    end if; 
  end if;
end process pGenCnt;

gen_state: process(Clk) begin
  if Clk'event and Clk='1' then
    if SRst = '1' then
      RcvState <= '0';
    elsif ((Rx0 = '0') and (Rx1 = '1') and (RcvState = '0')) then
      RcvState <= '1';
    elsif ((Ce16 = '1') and (RcvState = '1') and (Cnt = X"08") and (Rx1 = '1')) then
      RcvState <= '0';
    elsif ((Ce16 = '1') and (RcvState = '1') and (Cnt = X"98")) then
      RcvState <= '0';
    end if; 
  end if;
end process gen_state;

pGenDat: process(Clk) begin
  if Clk'event and Clk='1' then
    if ((Ce16 = '1') and (RcvState = '1')) then
      if Cnt = X"18" then
        XDat(0) <= Rx1;
      end if;
      if Cnt = X"28" then
        XDat(1) <= Rx1;
      end if;
      if Cnt = X"38" then
        XDat(2) <= Rx1;
      end if;
      if Cnt = X"48" then
        XDat(3) <= Rx1;
      end if;
      if Cnt = X"58" then
        XDat(4) <= Rx1;
      end if;
      if Cnt = X"68" then
        XDat(5) <= Rx1;
      end if;
      if Cnt = X"78" then
        XDat(6) <= Rx1;
      end if;
      if Cnt = X"88" then
        XDat(7) <= Rx1;
      end if;
    end if; 
  end if;
end process pGenDat;

pGenTrg: process(Clk) begin
  if Clk'event and Clk='1' then
    if ((Ce16 = '1') and (RcvState = '1') and (Cnt = X"98") and (Rx1 = '1')) then
      Dat <= XDat;
      Trg <= '1';
    else
      Trg <= '0';
    end if; 
  end if;
end process pGenTrg;

end Behavioral;
