library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Dvi410Sync is
port( 	clk: in std_logic; 
	cnt_v: in std_logic_vector ( 11 downto 0 );
	cnt_h: in std_logic_vector ( 11 downto 0 );
	sync_hse: in std_logic_vector ( 11 downto 0 );
	sync_hss: in std_logic_vector ( 11 downto 0 );
	sync_vse: in std_logic_vector ( 11 downto 0 );
	sync_vss: in std_logic_vector ( 11 downto 0 );
	sync_pol: in std_logic_vector ( 1 downto 0 );
	hs, vs: out std_logic);
end;

architecture rtl of Dvi410Sync is

signal dvi_if_vs, dvi_if_hs : std_logic;
signal boundh, boundv : std_logic_vector ( 1 downto 0 );

begin

pGenSyncs: process(clk)
begin
  if clk'event and clk='1' then
    if cnt_v >= sync_vss then
      boundv(0) <= '1';
    else
      boundv(0) <= '0';
    end if;
    if cnt_v < sync_vse then
      boundv(1) <= '1';
    else
      boundv(1) <= '0';
    end if;
    if boundv = "11" then
      dvi_if_vs <= sync_pol(1);
    else
      dvi_if_vs <= not sync_pol(1);
    end if;
    if cnt_h >= sync_hss then
      boundh(0) <= '1';
    else
      boundh(0) <= '0';
    end if;
    if cnt_h < sync_hse then
      boundh(1) <= '1';
    else
      boundh(1) <= '0';
    end if;
    if boundh = "11" then
      dvi_if_hs <= sync_pol(0);
    else
      dvi_if_hs <= not sync_pol(0);
    end if;
  end if;
end process pGenSyncs;

pGenOutputs: process(clk)
begin
  if clk'event and clk='1' then
    vs <= dvi_if_vs;
    hs <= dvi_if_hs;
  end if;
end process pGenOutputs;

end rtl;

