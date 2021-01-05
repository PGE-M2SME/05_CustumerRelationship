--
-- Module SeqBlk: Generation of reset sequence (see delay table below)
--                Various rate clock enables (uart & serial number chip)
--                Main clock tick 32-bit counter
--
-- --------------------------------------------------------------------
--
--  Interfaces:
--
--  Generic: 
--    FREQMHZ: integer: value of system clock in MHz
--    BAUDRATE: integer: value of uart baudrate
--
--  Inputs:
--    Clk: std_logic: System clock routed on dedicated resource
--    ARst_N: std_logic: Active low async system reset 
--
--  Outputs:
--    InitDone: std_logic: Active high signal for init seq completion
--    Ce1ms: std_logic: Clock enable with 1ms rate
--    Ce1us: std_logic: Clock enable with 1us rate
--    Ce7: std_logic: Clock enable with 7us rate
--    Ce16: std_logic: Clock enable with 16* uart baudrate
--    SRst: std_logic: Active high synchronous reset
--    StartupPCS: std_logic_vector: Dedicated reset for PCS
--    StartupSDR: std_logic: Dedicated reset for SDR
--    StartupDDR2: std_logic: Dedicated reset for DDR2
--    StartupDDR3: std_logic: Dedicated reset for DDR3
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

entity SeqBlk is
generic(FREQMHZ : integer := 100; BAUDRATE : integer := 115200);
port ( Clk, ARst_N : in std_logic;
       SysCnt32 : out std_logic_vector(31 downto 0);
       InitDone, Ce16, Ce7, Ce1ms, Ce1us, SRst : out std_logic;
       StartupPCS : out std_logic_vector(1 downto 0); 
       StartupSDR, StartupDDR2, StartupDDR3 : out std_logic); 
end;

architecture Behavioral of SeqBlk is

signal lCnt32 : std_logic_vector(31 downto 0);
signal lDone, lSRst : std_logic;
signal Cnt16 : std_logic_vector(7 downto 0);
signal Cnt7 : std_logic_vector(11 downto 0);

signal CntUs : integer range 1 to 1000;
signal CntMs : integer range 1 to 1000;
signal Ce : std_logic;

-- Events; cnt resolution @100MHz is 10ns, 655us for 16bit prescaler
CONSTANT MAINRST     : std_logic_vector(15 downto 0) := X"0005"; -- SRst (3.3ms)
CONSTANT START0PCS   : std_logic_vector(15 downto 0) := X"0100"; -- 167ms: Quad PCS 
CONSTANT START1PCS   : std_logic_vector(15 downto 0) := X"0200"; -- 335ms: Ch PCS 
CONSTANT STARTSDR    : std_logic_vector(15 downto 0) := X"0100"; -- 167ms: Init IP SDR  
CONSTANT STARTDDR2   : std_logic_vector(15 downto 0) := X"0020"; -- 21ms: Init IP DDR2  
CONSTANT STARTDDR3   : std_logic_vector(15 downto 0) := X"0020"; -- 21ms: Init IP DDR3  
CONSTANT ENDINIT     : std_logic_vector(15 downto 0) := X"0210"; -- Must be larger than any startup event

begin

SysCnt32 <= lCnt32;
InitDone <= lDone;
SRst <= lSRst;

pCnt32 : process(Clk, ARst_N)
begin
  if ARst_N = '0' then
    lCnt32 <= (others => '0');
  elsif Clk'event and Clk='1' then
    lCnt32 <= lCnt32 + '1';
  end if;
end process pCnt32;     

pDone : process(Clk, ARst_N)
begin
  if ARst_N = '0' then
    lDone <= '0';
  elsif Clk'event and Clk='1' then
    if lCnt32(31 downto 16) = ENDINIT then
      lDone <= '1';
    end if;
  end if;
end process pDone;

pCe16 : process (Clk)
begin
  if Clk'event and Clk='1' then
    if lSRst = '1' then 
      Cnt16 <= X"01";
      Ce16 <= '0';
    elsif Cnt16 = conv_std_logic_vector(FREQMHZ*1000000/16/BAUDRATE, 8) then 
      Cnt16 <= X"01";
      Ce16 <= '1';
    else
      Cnt16 <= Cnt16 + '1';
      Ce16 <= '0';
    end if;
  end if;
end process pCe16;

pCe7 : process (Clk)
begin
  if Clk'event and Clk='1' then
    if lSRst = '1' then 
      Cnt7 <= X"001";
      Ce7 <= '0';
    elsif Cnt7 = conv_std_logic_vector(FREQMHZ*7, 12) then 
      Cnt7 <= X"001";
      Ce7 <= '1';
    else
      Cnt7 <= Cnt7 + '1';
      Ce7 <= '0';
    end if;
  end if;
end process pCe7;

pCe1us: process(Clk)
begin
if Clk'Event and Clk = '1' then 
    if lSRst = '1' then
      CntUs <= 1;  
      Ce <= '0';
    elsif CntUs >= FREQMHZ then
      CntUs <= 1;  
      Ce <= '1';
    else
      CntUs <= CntUs + 1;  
      Ce <= '0';
    end if;
end if;
end process pCe1us;

Ce1us <= Ce;

p1Cems: process(Clk)
begin
if Clk'Event and Clk = '1' then 
    if lSRst = '1' then
      CntMs <= 1;  
    elsif ((CntMs >= 1000) and (Ce = '1')) then
      CntMs <= 1;  
    elsif Ce = '1' then
      CntMs <= CntMs + 1;  
    end if;
    if lSRst = '1' then
      Ce1ms <= '0';
    elsif ((CntMs = 1000) and (Ce = '1')) then
      Ce1ms <= '1';
    else
      Ce1ms <= '0';
    end if;
end if;
end process p1Cems;

pSRst : process(Clk)
begin
  if Clk'event and Clk='1' then
    if ((lDone='0') and (lCnt32(31 downto 16)<MAINRST )) then  -- Level 'logic1' until event  
      lSRst <= '1';
    else
      lSRst <= '0';
    end if;
  end if;
end process pSRst;

pStartupPCS: process(Clk) 
begin
  if Clk'event and Clk='1' then
    if ((lDone='0') and (lCnt32(31 downto 16)<START0PCS)) then  -- Level 'logic1' until event
      StartupPCS(0) <= '1';
    else
      StartupPCS(0) <= '0';
    end if;
    if ((lDone='0') and (lCnt32(31 downto 16)<START1PCS)) then  -- Level 'logic1' until event
      StartupPCS(1) <= '1';
    else
      StartupPCS(1) <= '0';
    end if;
  end if;
end process pStartupPCS;

pStartupSDR: process(Clk)
begin
  if Clk'event and Clk='1' then
    if ((lDone='0') and (lCnt32(31 downto 16)=STARTSDR)) then  -- Level 'logic1' at event for 65536 clks
      StartupSDR <= '1';
    else
      StartupSDR <= '0';
    end if;
  end if;
end process pStartupSDR;

pStartupDDR2: process(Clk)
begin
  if Clk'event and Clk='1' then
    if ((lDone='0') and (lCnt32(31 downto 16)=STARTDDR2)) then  -- Level 'logic1' at event for 65536 clks
      StartupDDR2 <= '1';
    else
      StartupDDR2 <= '0';
    end if;
  end if;
end process pStartupDDR2;

pStartupDDR3: process(Clk)
begin
  if Clk'event and Clk='1' then
    if ((lDone='0') and (lCnt32(31 downto 16)=STARTDDR3)) then  -- Level 'logic1' at event for 65536 clks
      StartupDDR3 <= '1';
    else
      StartupDDR3 <= '0';
    end if;
  end if;
end process pStartupDDR3;

end Behavioral;
