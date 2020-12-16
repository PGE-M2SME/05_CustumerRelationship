library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Dvi410Timing is
port( 	clk: in std_logic; 
	cnt_v: in std_logic_vector ( 11 downto 0 );
	cnt_h: in std_logic_vector ( 11 downto 0 );
	siz_v: in std_logic_vector ( 11 downto 0 );
	siz_h: in std_logic_vector ( 11 downto 0 );
	fifo_rd: out std_logic;
	dvi_de: out std_logic);
end;

architecture rtl of Dvi410Timing is

signal act_bound : std_logic_vector(1 downto 0);
signal bound_sr : std_logic_vector(15 downto 0);

begin

gen_bounds: process(clk)
begin
  if clk'event and clk='1' then
    if cnt_v < siz_v then
      act_bound(0) <= '1';
    else
      act_bound(0) <= '0';
    end if;
    if cnt_h < siz_h then
      act_bound(1) <= '1';
    else
      act_bound(1) <= '0';
    end if;
    if act_bound = "11" then
      bound_sr(0) <= '1';
    else
      bound_sr(0) <= '0';
    end if;
    bound_sr(15 downto 1) <= bound_sr(14 downto 0);
    fifo_rd <= bound_sr(1);
    dvi_de <= bound_sr(5);
  end if;
end process gen_bounds;

end rtl;

