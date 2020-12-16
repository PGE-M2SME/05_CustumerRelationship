library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Dvi410Request is
port( 	clkdvi: in std_logic;
        cnt_v: in std_logic_vector ( 11 downto 0 );
	cnt_h: in std_logic_vector ( 11 downto 0 );
	len_v: in std_logic_vector ( 11 downto 0 );
	siz_v: in std_logic_vector ( 11 downto 0 );
	siz_h: in std_logic_vector ( 11 downto 0 );
	vsync: in std_logic_vector ( 11 downto 0 );
        dvi_nf: out std_logic;
        req_row: out std_logic);

end;

architecture rtl of Dvi410Request is

signal vs, vs0 : std_logic;
signal hs, hs0 : std_logic;
signal bnd : std_logic_vector(3 downto 0);
signal bnd1, bnd2, bnd3 : std_logic_vector(11 downto 0);

begin

gen_vals: process(clkdvi)
begin
  if clkdvi'event and clkdvi='1' then
    bnd1 <= siz_v - X"002";
    bnd2 <= len_v - X"002";
    bnd3 <= len_v - X"001";
  end if;
end process gen_vals;

gen_dvi_domain: process(clkdvi)
begin
  if clkdvi'event and clkdvi='1' then
    if cnt_v = vsync then
      vs <= '1';
    else
      vs <= '0';
    end if;
    if cnt_h < siz_h then
      bnd(0) <= '1';
    else
      bnd(0) <= '0';
    end if;
    if cnt_v < bnd1 then
      bnd(1) <= '1';
    else
      bnd(1) <= '0';
    end if;
    if cnt_v = bnd2 then
      bnd(2) <= '1';
    else
      bnd(2) <= '0';
    end if;
    if cnt_v = bnd3 then
      bnd(3) <= '1';
    else
      bnd(3) <= '0';
    end if;
    if ((bnd(0) = '1') and (bnd(3 downto 1) /= "000")) then
      hs <= '1';
    else
      hs <= '0';
    end if;
  end if;
end process gen_dvi_domain;

gen_sys_domain: process(clkdvi)
begin
  if clkdvi'event and clkdvi='1' then
    vs0 <= vs;
    if ((vs0 = '0') and (vs = '1')) then
      dvi_nf <= '1';
    else
      dvi_nf <= '0';
    end if;
    hs0 <= hs;
    if ((hs0 = '0') and (hs = '1')) then
      req_row <= '1';
    else
      req_row <= '0';
    end if;
  end if;
end process gen_sys_domain;

end rtl;

