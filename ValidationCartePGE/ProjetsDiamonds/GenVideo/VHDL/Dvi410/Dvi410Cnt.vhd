library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Dvi410Cnt is
port( 	clk: in std_logic ;
	arst: in std_logic ;
	len_h: in std_logic_vector ( 11 downto 0 );
	len_v: in std_logic_vector ( 11 downto 0 );
	cnt_h: out std_logic_vector ( 11 downto 0 );
	cnt_v: out std_logic_vector ( 11 downto 0 ) );
end;

architecture rtl of Dvi410Cnt is

signal srst0, srst1, srst2 : std_logic;
signal cnth, cntv : std_logic_vector(11 downto 0);

begin

gen_cnt_vh: process(clk)
begin
  if clk'event and clk='1' then
    srst0 <= arst;
    srst1 <= srst0;
    srst2 <= srst1;
    if srst2 = '1' then
      cnth <= X"001";
    elsif cnth < len_h then
      cnth <= cnth + X"001";
    else
      cnth <= X"001";
    end if;
    if srst2 = '1' then
      cntv <= X"001";
    elsif cnth = len_h then
      if cntv < len_v then
        cntv <= cntv + X"001";
      else
        cntv <= X"001";
      end if;
    end if;
    cnt_h <= cnth - X"001";
    cnt_v <= cntv - X"001";
  end if;
end process gen_cnt_vh;

end rtl;

