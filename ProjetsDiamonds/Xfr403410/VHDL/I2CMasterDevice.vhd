library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity I2cMasterDevice is
generic(FREQ_MHZ : integer := 100; RATE_KHZ : integer := 400);
port( 
	Clk, SRst: in std_logic ;
    TrgStart, TrgDatW, TrgDatR, TrgStop: in std_logic ;
	DoneTrg: out std_logic ;
	DatW: in std_logic_vector ( 7 downto 0 );
	DatR: out std_logic_vector ( 7 downto 0 );
	Sda: inout std_logic ;
	Scl: out std_logic  );
end;

architecture rtl of I2cMasterDevice is

-- Signals and constants for State Machine
signal State, StateD : std_logic_vector(3 downto 0);
constant ST_IDLE   : std_logic_vector(3 downto 0) := X"0";
constant ST_START1 : std_logic_vector(3 downto 0) := X"1";
constant ST_START2 : std_logic_vector(3 downto 0) := X"2";
constant ST_STOP1  : std_logic_vector(3 downto 0) := X"3";
constant ST_STOP2  : std_logic_vector(3 downto 0) := X"4";
constant ST_STOP3  : std_logic_vector(3 downto 0) := X"5";
constant ST_STOP4  : std_logic_vector(3 downto 0) := X"6";
constant ST_XFER1  : std_logic_vector(3 downto 0) := X"7";
constant ST_XFER2  : std_logic_vector(3 downto 0) := X"8";
constant ST_XFER3  : std_logic_vector(3 downto 0) := X"9";
constant ST_XFER4  : std_logic_vector(3 downto 0) := X"A";

-- Signals for generating delays and counters
signal Dly, ModeW, lSda, lScl : std_logic;
signal NumClk : std_logic_vector(3 downto 0);
signal CntDly, DatSrW, DatSrR : std_logic_vector(7 downto 0);

constant CLKDIV : integer := (FREQ_MHZ * 1000 / RATE_KHZ / 3) - 2;

begin

-- Process to control the state machine

pGenState: process (Clk)
begin
if Clk'Event and Clk = '1' then
  if SRst = '1' then
    State <= ST_IDLE;
  elsif ((State = ST_IDLE) and (TrgStart = '1')) then
    State <= ST_START1;
  elsif ((State = ST_START1) and (Dly = '1')) then
    State <= ST_START2;
  elsif ((State = ST_START2) and (TrgDatW = '1')) then
    State <= ST_XFER1;
  elsif ((State = ST_START2) and (TrgDatR = '1')) then
    State <= ST_XFER1;
  elsif ((State = ST_XFER1) and (Dly = '1')) then
    State <= ST_XFER2;
  elsif ((State = ST_XFER2) and (Dly = '1')) then
    State <= ST_XFER3;
  elsif ((State = ST_XFER3) and (Dly = '1') and (NumClk /= X"8")) then
    State <= ST_XFER1;
  elsif State = ST_XFER4 then
    State <= ST_XFER1;
  elsif ((State = ST_XFER3) and (TrgDatW = '1')) then
    State <= ST_XFER4;
  elsif ((State = ST_XFER3) and (TrgDatR = '1')) then
    State <= ST_XFER4;
  elsif ((State = ST_XFER3) and (TrgStop = '1')) then
    State <= ST_STOP1;
  elsif ((State = ST_STOP1) and (Dly = '1')) then
    State <= ST_STOP2;
  elsif ((State = ST_STOP2) and (Dly = '1')) then
    State <= ST_STOP3;
  elsif ((State = ST_STOP3) and (Dly = '1')) then
    State <= ST_STOP4;
  elsif ((State = ST_STOP4) and (Dly = '1')) then
    State <= ST_IDLE;
  end if;
  if SRst = '1' then
    StateD <= ST_IDLE;
  else
    StateD <= State;
  end if;
  if SRst = '1' then
    ModeW <= '1';
  elsif TrgDatW = '1' then
    ModeW <= '1';
  elsif TrgDatR = '1' then
    ModeW <= '0';
  end if;
end if;
end process;

-- Process to generate DoneTrg

pGenDoneTrg: process (Clk)
begin
if Clk'Event and Clk = '1' then
  if SRst = '1' then
    DoneTrg <= '0';
  elsif (State = ST_START2) and (Dly = '1') then
    DoneTrg <= '1';
  elsif ((State = ST_XFER3) and (Dly = '1') and (NumClk = X"8")) then
    DoneTrg <= '1';
  elsif ((State = ST_STOP4) and (Dly = '1')) then
    DoneTrg <= '1';
  else
    DoneTrg <= '0';
  end if;
end if;
end process;

-- Process to generate delay

pGenDelay: process (Clk)
begin
if Clk'Event and Clk = '1' then
  if SRst = '1' then
    CntDly <= (others => '1');
  elsif StateD /= State then
    CntDly <= (others => '0');
  elsif CntDly /= X"FF" then
    CntDly <= CntDly + '1';
  end if;
  if CntDly = conv_std_logic_vector(CLKDIV, 8) then Dly <= '1'; else Dly <= '0'; end if;
end if;
end process;

-- Process to count data bits

pGenNumClk: process (Clk)
begin
if Clk'Event and Clk = '1' then
  if TrgDatW = '1' then
    NumClk <= X"0";
  elsif TrgDatR = '1' then
    NumClk <= X"0";
  elsif ((StateD = ST_XFER3) and (State = ST_XFER1)) then
    NumClk <= NumClk + X"1";
  end if;
end if;
end process;

-- Process to generate CLOCK output

pGenScl: process (Clk)
begin
if Clk'Event and Clk = '1' then
  if SRst = '1' then
    lScl <= '1';
  elsif ((StateD /= ST_START2) and (State = ST_START2)) then
    lScl <= '0';
  elsif ((StateD /= ST_XFER2) and (State = ST_XFER2)) then
    lScl <= '1';
  elsif ((StateD /= ST_XFER2) and (State = ST_XFER3)) then
    lScl <= '0';
  elsif ((StateD /= ST_STOP2) and (State = ST_STOP2)) then
    lScl <= '1';
  end if;
end if;
end process;

Scl <= lScl;

-- Process to generate DATA output

pGenSda: process (Clk)
begin
if Clk'Event and Clk = '1' then
  if SRst = '1' then
    lSda <= '1';
  elsif ((StateD /= ST_START1) and (State = ST_START1)) then
    lSda <= '0';
  elsif ((State = ST_XFER1) and (NumClk /= X"8") and (ModeW = '1')) then
    lSda <= DatSrW(7);
  elsif ((State = ST_XFER1) and (NumClk = X"8") and (ModeW = '1')) then
    lSda <= 'Z';
  elsif ((State = ST_XFER1) and (NumClk /= X"8") and (ModeW = '0')) then
    lSda <= 'Z';
  elsif ((State = ST_XFER1) and (NumClk = X"8") and (ModeW = '0')) then
    lSda <= '0';
  elsif ((State = ST_XFER3) and (NumClk = X"8") and (Dly = '1')) then
    lSda <= '0';
  elsif ((StateD /= ST_STOP1) and (State = ST_STOP1)) then
    lSda <= '0';
  elsif ((StateD /= ST_STOP3) and (State = ST_STOP3)) then
    lSda <= '1';
  end if;
end if;
end process;

Sda <= lSda;

-- Process to generate shifted data

pGenSR: process (Clk)
begin
if Clk'Event and Clk = '1' then
  if TrgDatW = '1' then
    DatSrW <= DatW;
  elsif ((StateD = ST_XFER3) and (State = ST_XFER1)) then
    DatSrW <= DatSrW(6 downto 0) & '0';
  end if;
  if ((State = ST_XFER2) and (Dly = '1') and (NumClk /= X"8")) then
    DatSrR <= DatSrR(6 downto 0) & Sda;
  end if;
  if ((State = ST_XFER3) and (Dly = '1') and (NumClk = X"8")) then
    DatR <= DatSrR;
  end if;
end if;
end process;

end rtl;

