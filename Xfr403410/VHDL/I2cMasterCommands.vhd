library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.pmi_components.all;
library pmi_work;

entity I2cMasterCommands is
generic(FPGA_FAMILY : string := "XP2";
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
end;

architecture rtl of I2cMasterCommands is

component I2cMasterDevice 
generic(FREQ_MHZ : integer := 100; RATE_KHZ : integer := 400);
port( 
	Clk, SRst: in std_logic ;
    TrgStart, TrgDatW, TrgDatR, TrgStop: in std_logic ;
	DoneTrg: out std_logic ;
	DatW: in std_logic_vector ( 7 downto 0 );
	DatR: out std_logic_vector ( 7 downto 0 );
	Sda: inout std_logic ;
	Scl: out std_logic  );
end component;

component pmi_fifo is
     generic (
       pmi_data_width : integer := 16; pmi_data_depth : integer := 1024; 
       pmi_full_flag : integer := 1024; pmi_empty_flag : integer := 0; 
       pmi_almost_full_flag : integer := 252; pmi_almost_empty_flag : integer := 4; 
       pmi_regmode : string := "reg"; pmi_family : string := "EC" ; 
       module_type : string := "pmi_fifo"; pmi_implementation : string := "LUT");
    port (
     Data : in std_logic_vector(pmi_data_width-1 downto 0);
     Clock: in std_logic; WrEn: in std_logic; RdEn: in std_logic;
     Reset: in std_logic; Q : out std_logic_vector(pmi_data_width-1 downto 0);
     Empty: out std_logic; Full: out std_logic;
     AlmostEmpty: out std_logic; AlmostFull: out std_logic);
end component ;

-- Signals and constants for command State Machine
signal CmdState, CmdStateD : std_logic_vector(3 downto 0);
constant CMD_IDLE    : std_logic_vector(3 downto 0) := X"0";
constant CMD_RD : std_logic_vector(3 downto 0) := X"1";
constant CMD_WR : std_logic_vector(3 downto 0) := X"2";

-- Command State Machine events
signal lTrg : std_logic;

-- Signals and constants for I2C State Machine
signal State, StateD : std_logic_vector(3 downto 0);
constant ST_IDLE    : std_logic_vector(3 downto 0) := X"0";
constant ST_RD      : std_logic_vector(3 downto 0) := X"1";
constant ST_WR      : std_logic_vector(3 downto 0) := X"2";
constant ST_XFER_RD : std_logic_vector(3 downto 0) := X"3";
constant ST_XFER_WR : std_logic_vector(3 downto 0) := X"4";
constant ST_START1  : std_logic_vector(3 downto 0) := X"5";
constant ST_START2  : std_logic_vector(3 downto 0) := X"6";
constant ST_STOP1   : std_logic_vector(3 downto 0) := X"7";
constant ST_STOP2   : std_logic_vector(3 downto 0) := X"8";
constant ST_ADD     : std_logic_vector(3 downto 0) := X"9";

-- I2C low level interface 
signal I2cTrgStart, I2cTrgDatW, I2cTrgDatR, I2cTrgStop, I2cTrgDone: std_logic ;
signal NumXfr, SizXfr : std_logic_vector(7 downto 0);
signal lAddress, I2cDatW, I2cDatR, DeviceIdW, DeviceIdR : std_logic_vector ( 7 downto 0 );

-- Write data Fifo
signal FifoEmpty, FifoRd : std_logic;
signal DataFifo : std_logic_vector(7 downto 0);

begin

uDevice : I2cMasterDevice 
generic map(FREQ_MHZ=>FREQ_MHZ, RATE_KHZ=>RATE_KHZ)
port map(Clk=>Clk, SRst=>SRst, Sda=>Sda, Scl=>Scl,
	     TrgStart=>I2cTrgStart, TrgStop=>I2cTrgStop,
         TrgDatW=>I2cTrgDatW, TrgDatR=>I2cTrgDatR,
	     DoneTrg=>I2cTrgDone, DatW=>I2cDatW, DatR=>I2cDatR);

-- Command State Machine process 

lTrg <= '0' when CmdState /= CMD_IDLE else Trg; -- New commands are ignored when I2C already busy

pCommandFSM: process (Clk)
begin
if Clk'Event and Clk = '1' then
  if SRst = '1' then
    CmdState <= CMD_IDLE;
    SizXfr <= (others => '0');
  elsif ((StateD = ST_STOP2) and (State = ST_IDLE)) then
    CmdState <= CMD_IDLE;
    SizXfr <= (others => '0');
  elsif ((lTrg = '1') and (RdWr_N = '0')) then
    CmdState <= CMD_WR;
    SizXfr <= (others => '0');
  elsif ((lTrg = '1') and (RdWr_N = '1')) then
    CmdState <= CMD_RD;
    SizXfr <= RdLen;
  end if;
  if SRst = '1' then CmdStateD <= CMD_IDLE; else CmdStateD <= CmdState; end if;
end if;
end process;

pCommandStatus: process (Clk)
begin
if Clk'Event and Clk = '1' then
  if SRst = '1' then
    Busy <= '0';
  elsif ((StateD = ST_STOP2) and (State = ST_IDLE)) then
    Busy <= '0';
  elsif lTrg = '1' then
    Busy <= '1';
  end if;
  if ((StateD = ST_STOP2) and (State = ST_IDLE)) then
    Done <= '1';
  else
    Done <= '0';
  end if;
end if;
end process;

-- Low level State Machine process 

pLowLevelFSM: process (Clk)
begin
if Clk'Event and Clk = '1' then
  if SRst = '1' then
    State <= ST_IDLE;
  elsif ((State = ST_IDLE) and (CmdStateD = CMD_IDLE) and (CmdState /= CMD_IDLE)) then
    State <= ST_START1;
  elsif ((State = ST_START1) and (I2cTrgDone = '1')) then
    State <= ST_WR;
  elsif ((State = ST_WR) and (I2cTrgDone = '1')) then
    State <= ST_ADD;
  elsif ((State = ST_ADD) and (I2cTrgDone = '1')) then
    if CmdState = CMD_WR then
      if FifoEmpty = '1' then
        State <= ST_STOP2;
      else
        State <= ST_XFER_WR;
      end if;
    else
      if SizXfr = X"00" then
        State <= ST_STOP2;
      else
        State <= ST_STOP1;
      end if;
    end if;
  elsif ((State = ST_STOP1) and (I2cTrgDone = '1')) then
    State <= ST_START2;
  elsif ((State = ST_START2) and (I2cTrgDone = '1')) then
    State <= ST_RD;
  elsif ((State = ST_RD) and (I2cTrgDone = '1')) then
    State <= ST_XFER_RD;
  elsif ((State = ST_XFER_WR) and (I2cTrgDone = '1') and (FifoEmpty = '1')) then
    State <= ST_STOP2;
  elsif ((State = ST_XFER_RD) and (I2cTrgDone = '1') and (NumXfr = SizXfr)) then
    State <= ST_STOP2;
  elsif ((State = ST_STOP2) and (I2cTrgDone = '1')) then
    State <= ST_IDLE;
  end if;
  StateD <= State;
end if;
end process;

-- Write data FIFO

uFifoRxRaw : pmi_fifo 
generic map(pmi_data_width=>8, pmi_data_depth=>16, pmi_full_flag=>16,
            pmi_regmode=>"noreg", pmi_family=>FPGA_FAMILY, pmi_implementation=>"LUT")
port map(Clock=>Clk, Data=>DataW, WrEn=>We, Q=>DataFifo, RdEn=>FifoRd, 
         Full=>FifoFull, Empty=>FifoEmpty, Reset=>SRst);

FifoRd <= '1' when ((State = ST_ADD)     and (I2cTrgDone = '1') and (FifoEmpty = '0')) else 
          '1' when ((State = ST_XFER_WR) and (I2cTrgDone = '1') and (FifoEmpty = '0')) else
          '0';

-- Low level transfer fields, size, & progress 

pLowLeveXfer: process (Clk)
begin
if Clk'Event and Clk = '1' then
  if State = ST_START1 then
    NumXfr <= X"01";
  elsif ((State = ST_XFER_RD) and (I2cTrgDone = '1')) then
    NumXfr <= NumXfr + '1';
  end if;
end if;
end process;

pGenI2cTriggers: process (Clk)
begin
if Clk'Event and Clk = '1' then
  if SRst = '1' then
    I2cTrgStart <= '0';
  elsif ((StateD /= ST_START1) and (State = ST_START1)) then
    I2cTrgStart <= '1';
  elsif ((StateD /= ST_START2) and (State = ST_START2)) then
    I2cTrgStart <= '1';
  else
    I2cTrgStart <= '0';
  end if;
  if SRst = '1' then
    I2cTrgStop <= '0';
  elsif ((StateD /= ST_STOP1) and (State = ST_STOP1)) then
    I2cTrgStop <= '1';
  elsif ((StateD /= ST_STOP2) and (State = ST_STOP2)) then
    I2cTrgStop <= '1';
  else
    I2cTrgStop <= '0';
  end if;
  if SRst = '1' then
    I2cTrgDatW <= '0';
  elsif ((StateD /= ST_WR) and (State = ST_WR)) then
    I2cTrgDatW <= '1';
  elsif ((StateD /= ST_RD) and (State = ST_RD)) then
    I2cTrgDatW <= '1';
  elsif ((StateD /= ST_ADD) and (State = ST_ADD)) then
    I2cTrgDatW <= '1';
  elsif ((StateD /= ST_XFER_WR) and (State = ST_XFER_WR)) then
    I2cTrgDatW <= '1';
  elsif ((I2cTrgDone = '1') and (State = ST_XFER_WR) and (FifoEmpty = '0')) then
    I2cTrgDatW <= '1';
  else
    I2cTrgDatW <= '0';
  end if;
  if SRst = '1' then
    I2cTrgDatR <= '0';
  elsif ((StateD /= ST_XFER_RD) and (State = ST_XFER_RD)) then
    I2cTrgDatR <= '1';
  elsif ((I2cTrgDone = '1') and (State = ST_XFER_RD) and (NumXfr /= SizXfr)) then
    I2cTrgDatR <= '1';
  else
    I2cTrgDatR <= '0';
  end if;
end if;
end process;

--
-- Data transfer betseen high and low level
--

pCaptAtt: process (Clk)
begin
if Clk'Event and Clk = '1' then
  if SRst = '1' then
    DeviceIdW <= X"00";
    DeviceIdR <= X"01";
    lAddress <= X"00";
  elsif lTrg = '1' then
    DeviceIdW <= DeviceId and X"FE";
    DeviceIdR <= DeviceId  or X"01";
    lAddress <= Address;
  end if;
end if;
end process;

I2cDatW <= DeviceIdW when State = ST_WR else
           DeviceIdR when State = ST_RD else
           lAddress when State = ST_ADD else
           DataFifo;

DataR <= I2cDatR;
DataVal <= '1' when ((State = ST_XFER_RD) and (I2cTrgDone = '1')) else
           '0';

end rtl;

