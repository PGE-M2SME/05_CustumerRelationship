
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

-- Processor interface
signal PpWe, ForthIt : std_logic;
signal PpAdd : std_logic_vector(7 downto 0);
signal PokeDat, PeekDat, MiscReg1, MiscReg2, Timer : std_logic_vector(31 downto 0);

-- Random number generator
signal SetRng, RdRng : std_logic;
signal Random32 : std_logic_vector(31 downto 0);

-- Test points
signal SelTp1, SelTp2 : std_logic_vector(3 downto 0);
signal TpVec : std_logic_vector(15 downto 0);


--
-- Forth
--

ForthIt <= '0';

uForth : Forth 
generic map(FPGA_FAMILY=>"ECP3") 
port map(Clk=>Clk50, SRst=>SRst, Ce16=>Ce16, TrgIntRe=>ForthIt, 
         PortRx=>PinPortRx, PortTx=>PinPortTx, Monitor=>open,
         PpWe=>PpWe, PpAdd=>PpAdd, PokeDat=>PokeDat, PeekDat=>PeekDat);

--
-- Forth register space
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
  end if;
end process pSetReg;

PeekDat <= X"0000000" & "000" & InitDone        when PpAdd = X"05" else 
           Timer                                when PpAdd = X"08" else 
           Random32                             when PpAdd = X"13" else 
           MiscReg1                             when PpAdd = X"26" else 
           MiscReg2                             when PpAdd = X"27" else 
           X"00000000";

--
-- Random number generator
--

SetRng <= '1' when ((PpWe = '1') and (PpAdd = X"11")) else '0'; 
RdRng  <= '1' when ((PpWe = '1') and (PpAdd = X"12")) else '0'; 

uRand : Rand32 port map(Clk=>Clk50, SRst=>SRst, 
                        SetSeed=>SetRng, NextRd=>RdRng,
                        Seed=>PokeDat, Random32=>Random32);

--
-- Interface points tests
--

pSetTp: process (Clk50)
begin
  if Clk50'event and Clk50='1' then
    if SRst = '1' then
      SelTp1 <= X"0";
    elsif ((PpWe = '1') and (PpAdd = X"24")) then 
      SelTp1 <= PokeDat(3 downto 0);
    end if;
    if SRst = '1' then
      SelTp2 <= X"0";
    elsif ((PpWe = '1') and (PpAdd = X"25")) then 
      SelTp2 <= PokeDat(3 downto 0);
    end if;
  end if;
end process pSetTp;

PinTp(1) <= TpVec(conv_integer(SelTp1));
PinTp(2) <= TpVec(conv_integer(SelTp2));


