library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Dvi410Conf is
port( 	clk: in std_logic ;
        srst: in std_logic ;
	we: in std_logic ;
	add: in std_logic_vector(15 downto 0) ;
	dat: in std_logic_vector(15 downto 0) ;
	form_vln: out std_logic_vector ( 11 downto 0 );
	form_vsz: out std_logic_vector ( 11 downto 0 );
	form_vss: out std_logic_vector ( 11 downto 0 );
	form_vse: out std_logic_vector ( 11 downto 0 );
	form_hln: out std_logic_vector ( 11 downto 0 );
	form_hsz: out std_logic_vector ( 11 downto 0 );
	form_hss: out std_logic_vector ( 11 downto 0 );
	form_hse: out std_logic_vector ( 11 downto 0 );
        form_pol: out std_logic_vector (1 downto 0) );
end;

architecture rtl of Dvi410Conf is

constant HS_1024_768_100 : std_logic_vector(23 downto 0) := X"400540";--570";
constant HP_1024_768_100 : std_logic_vector(23 downto 0) := X"4384A0";--4484B8";
constant VS_1024_768_100 : std_logic_vector(23 downto 0) := X"30031B";--32E";
constant VP_1024_768_100 : std_logic_vector(23 downto 0) := X"301304";
constant HS_1152_864_75 : std_logic_vector(23 downto 0) := X"480610";
constant HP_1152_864_75 : std_logic_vector(23 downto 0) := X"4C8548";
constant VS_1152_864_75 : std_logic_vector(23 downto 0) := X"360386";
constant VP_1152_864_75 : std_logic_vector(23 downto 0) := X"361364";
constant HS_1152_864_85 : std_logic_vector(23 downto 0) := X"480610";
constant HP_1152_864_85 : std_logic_vector(23 downto 0) := X"4C8548";
constant VS_1152_864_85 : std_logic_vector(23 downto 0) := X"36038B";
constant VP_1152_864_85 : std_logic_vector(23 downto 0) := X"361364";
constant HS_1280_1024_60 : std_logic_vector(23 downto 0) := X"5006B0";
constant HP_1280_1024_60 : std_logic_vector(23 downto 0) := X"5505D8";
constant VS_1280_1024_60 : std_logic_vector(23 downto 0) := X"400424";
constant VP_1280_1024_60 : std_logic_vector(23 downto 0) := X"401404";
constant HS_1280_1024_75 : std_logic_vector(23 downto 0) := X"5006C0";
constant HP_1280_1024_75 : std_logic_vector(23 downto 0) := X"5585E0";
constant VS_1280_1024_75 : std_logic_vector(23 downto 0) := X"40042D";
constant VP_1280_1024_75 : std_logic_vector(23 downto 0) := X"401404";
constant HS_1400_1050_60 : std_logic_vector(23 downto 0) := X"578758";
constant HP_1400_1050_60 : std_logic_vector(23 downto 0) := X"5D0668";
constant VS_1400_1050_60 : std_logic_vector(23 downto 0) := X"41A43F";
constant VP_1400_1050_60 : std_logic_vector(23 downto 0) := X"41B41E";
constant HS_1400_1050_75 : std_logic_vector(23 downto 0) := X"578768";
constant HP_1400_1050_75 : std_logic_vector(23 downto 0) := X"5D8670";
constant VS_1400_1050_75 : std_logic_vector(23 downto 0) := X"41A448";
constant VP_1400_1050_75 : std_logic_vector(23 downto 0) := X"41B41E";
constant HS_1440_900_60 : std_logic_vector(23 downto 0) := X"5A0770";
constant HP_1440_900_60 : std_logic_vector(23 downto 0) := X"5F0688";
constant VS_1440_900_60 : std_logic_vector(23 downto 0) := X"3843A4";
constant VP_1440_900_60 : std_logic_vector(23 downto 0) := X"385388";
constant HS_1440_900_75 : std_logic_vector(23 downto 0) := X"5A0790";
constant HP_1440_900_75 : std_logic_vector(23 downto 0) := X"600698";
constant VS_1440_900_75 : std_logic_vector(23 downto 0) := X"3843AC";
constant VP_1440_900_75 : std_logic_vector(23 downto 0) := X"385388";
constant HS_1600_1024_60 : std_logic_vector(23 downto 0) := X"640860";
constant HP_1600_1024_60 : std_logic_vector(23 downto 0) := X"6A8750";
constant VS_1600_1024_60 : std_logic_vector(23 downto 0) := X"400424";
constant VP_1600_1024_60 : std_logic_vector(23 downto 0) := X"401404";
constant HS_1600_1024_70 : std_logic_vector(23 downto 0) := X"640870";
constant HP_1600_1024_70 : std_logic_vector(23 downto 0) := X"6A8758";
constant VS_1600_1024_70 : std_logic_vector(23 downto 0) := X"40042A";
constant VP_1600_1024_70 : std_logic_vector(23 downto 0) := X"401404";
constant HS_1680_1050_60 : std_logic_vector(23 downto 0) := X"6908D0";
constant HP_1680_1050_60 : std_logic_vector(23 downto 0) := X"6F87B0";
constant VS_1680_1050_60 : std_logic_vector(23 downto 0) := X"41A43F";
constant VP_1680_1050_60 : std_logic_vector(23 downto 0) := X"41B41E";

constant HS_640_480_F120 : std_logic_vector(23 downto 0) := X"280FB8";
constant HP_640_480_F120 : std_logic_vector(23 downto 0) := X"924964";
constant VS_640_480_F120: std_logic_vector(23 downto 0) := X"1E01F1";
constant VP_640_480_F120 : std_logic_vector(23 downto 0) := X"1E11E4";
constant HS_800_600_F120 : std_logic_vector(23 downto 0) := X"320C8F";
constant HP_800_600_F120 : std_logic_vector(23 downto 0) := X"7E7837";
constant VS_800_600_F120: std_logic_vector(23 downto 0) := X"25826E";
constant VP_800_600_F120 : std_logic_vector(23 downto 0) := X"25925C";
constant HS_1024_768_F120 : std_logic_vector(23 downto 0) := X"4009D3";
constant HP_1024_768_F120 : std_logic_vector(23 downto 0) := X"70576D";
constant VS_1024_768_F120: std_logic_vector(23 downto 0) := X"30031B";
constant VP_1024_768_F120 : std_logic_vector(23 downto 0) := X"301304";
constant HS_1152_864_F120 : std_logic_vector(23 downto 0) := X"4808BA";
constant HP_1152_864_F120 : std_logic_vector(23 downto 0) := X"6BD735";
constant VS_1152_864_F120: std_logic_vector(23 downto 0) := X"36037F";
constant VP_1152_864_F120 : std_logic_vector(23 downto 0) := X"361364";
constant HS_1280_1024_F120 : std_logic_vector(23 downto 0) := X"50075E";
constant HP_1280_1024_F120 : std_logic_vector(23 downto 0) := X"6576DF";
constant VS_1280_1024_F120: std_logic_vector(23 downto 0) := X"400424";
constant VP_1280_1024_F120 : std_logic_vector(23 downto 0) := X"401404";
constant HS_1400_1050_F120 : std_logic_vector(23 downto 0) := X"57872F";
constant HP_1400_1050_F120 : std_logic_vector(23 downto 0) := X"67F717";
constant VS_1400_1050_F120: std_logic_vector(23 downto 0) := X"41A43F";
constant VP_1400_1050_F120 : std_logic_vector(23 downto 0) := X"41B41E";
constant HS_1440_900_F120 : std_logic_vector(23 downto 0) := X"5A0861";
constant HP_1440_900_F120 : std_logic_vector(23 downto 0) := X"7287C0";
constant VS_1440_900_F120: std_logic_vector(23 downto 0) := X"3843A4";
constant VP_1440_900_F120 : std_logic_vector(23 downto 0) := X"385388";
constant HS_1600_1024_F120 : std_logic_vector(23 downto 0) := X"64075E";
constant HP_1600_1024_F120 : std_logic_vector(23 downto 0) := X"70375C";
constant VS_1600_1024_F120: std_logic_vector(23 downto 0) := X"400424";
constant VP_1600_1024_F120 : std_logic_vector(23 downto 0) := X"401404";
constant HS_1680_1050_F120 : std_logic_vector(23 downto 0) := X"69072F";
constant HP_1680_1050_F120 : std_logic_vector(23 downto 0) := X"71372D";
constant VS_1680_1050_F120: std_logic_vector(23 downto 0) := X"41A43F";
constant VP_1680_1050_F120 : std_logic_vector(23 downto 0) := X"41B41E";

constant HS_1024_768_F160 : std_logic_vector(23 downto 0) := X"400D1A";
constant HP_1024_768_F160 : std_logic_vector(23 downto 0) := X"8A9911";
constant VS_1024_768_F160: std_logic_vector(23 downto 0) := X"30031B";
constant VP_1024_768_F160 : std_logic_vector(23 downto 0) := X"301304";
constant HS_1152_864_F160 : std_logic_vector(23 downto 0) := X"480BA3";
constant HP_1152_864_F160 : std_logic_vector(23 downto 0) := X"8318A9";
constant VS_1152_864_F160: std_logic_vector(23 downto 0) := X"36037F";
constant VP_1152_864_F160 : std_logic_vector(23 downto 0) := X"361364";
constant HS_1280_1024_F160 : std_logic_vector(23 downto 0) := X"5009D3";
constant HP_1280_1024_F160 : std_logic_vector(23 downto 0) := X"791819";
constant VS_1280_1024_F160: std_logic_vector(23 downto 0) := X"400424";
constant VP_1280_1024_F160 : std_logic_vector(23 downto 0) := X"401404";
constant HS_1400_1050_F160 : std_logic_vector(23 downto 0) := X"578995";
constant HP_1400_1050_F160 : std_logic_vector(23 downto 0) := X"7B284A";
constant VS_1400_1050_F160: std_logic_vector(23 downto 0) := X"41A43F";
constant VP_1400_1050_F160 : std_logic_vector(23 downto 0) := X"41B41E";
constant HS_1440_900_F160 : std_logic_vector(23 downto 0) := X"5A0B2D";
constant HP_1440_900_F160 : std_logic_vector(23 downto 0) := X"88E926";
constant VS_1440_900_F160: std_logic_vector(23 downto 0) := X"3843A4";
constant VP_1440_900_F160 : std_logic_vector(23 downto 0) := X"385388";
constant HS_1600_1024_F160 : std_logic_vector(23 downto 0) := X"6409D3";
constant HP_1600_1024_F160 : std_logic_vector(23 downto 0) := X"83D8E5";
constant VS_1600_1024_F160: std_logic_vector(23 downto 0) := X"400424";
constant VP_1600_1024_F160 : std_logic_vector(23 downto 0) := X"401404";
constant HS_1680_1050_F160 : std_logic_vector(23 downto 0) := X"690995";
constant HP_1680_1050_F160 : std_logic_vector(23 downto 0) := X"8468FE";
constant VS_1680_1050_F160: std_logic_vector(23 downto 0) := X"41A43F";
constant VP_1680_1050_F160 : std_logic_vector(23 downto 0) := X"41B41E";

signal wed : std_logic;
signal dat0010, dat0011, dat0012, dat0013, dat0014 : std_logic;
signal dat0015, dat0016, dat0017, dat0018 : std_logic;
signal dat0110, dat0116, dat0118, dat011A, dat011C, dat0120 : std_logic;
signal dat0123, dat0125, dat0126, dat0129, dat012B, dat012D : std_logic;
signal dat0210, dat0216, dat021C, dat0220, dat0226, dat022B, dat022D : std_logic;
signal dat0307, dat030A, dat0310, dat0316, dat031C : std_logic;
signal dat0320, dat0326, dat032B, dat032D : std_logic;

begin

gen_conf_add: process(clk)
begin
  if clk'event and clk='1' then
    wed <= we;
    if add = X"0010" then dat0010 <= '1'; else dat0010 <= '0'; end if;
    if add = X"0011" then dat0011 <= '1'; else dat0011 <= '0'; end if;
    if add = X"0012" then dat0012 <= '1'; else dat0012 <= '0'; end if;
    if add = X"0013" then dat0013 <= '1'; else dat0013 <= '0'; end if;
    if add = X"0014" then dat0014 <= '1'; else dat0014 <= '0'; end if;
    if add = X"0015" then dat0015 <= '1'; else dat0015 <= '0'; end if;
    if add = X"0016" then dat0016 <= '1'; else dat0016 <= '0'; end if;
    if add = X"0017" then dat0017 <= '1'; else dat0017 <= '0'; end if;
    if add = X"0018" then dat0018 <= '1'; else dat0018 <= '0'; end if;

    if add = X"0110" then dat0110 <= '1'; else dat0110 <= '0'; end if;
    if add = X"0116" then dat0116 <= '1'; else dat0116 <= '0'; end if;
    if add = X"0118" then dat0118 <= '1'; else dat0118 <= '0'; end if;
    if add = X"011A" then dat011A <= '1'; else dat011A <= '0'; end if;
    if add = X"011C" then dat011C <= '1'; else dat011C <= '0'; end if;
    if add = X"0120" then dat0120 <= '1'; else dat0120 <= '0'; end if;
    if add = X"0123" then dat0123 <= '1'; else dat0123 <= '0'; end if;
    if add = X"0125" then dat0125 <= '1'; else dat0125 <= '0'; end if;
    if add = X"0126" then dat0126 <= '1'; else dat0126 <= '0'; end if;
    if add = X"0129" then dat0129 <= '1'; else dat0129 <= '0'; end if;
    if add = X"012B" then dat012B <= '1'; else dat012B <= '0'; end if;
    if add = X"012D" then dat012D <= '1'; else dat012D <= '0'; end if;

    if add = X"0210" then dat0210 <= '1'; else dat0210 <= '0'; end if;
    if add = X"0216" then dat0216 <= '1'; else dat0216 <= '0'; end if;
    if add = X"021C" then dat021C <= '1'; else dat021C <= '0'; end if;
    if add = X"0220" then dat0220 <= '1'; else dat0220 <= '0'; end if;
    if add = X"0226" then dat0226 <= '1'; else dat0226 <= '0'; end if;
    if add = X"022B" then dat022B <= '1'; else dat022B <= '0'; end if;
    if add = X"022D" then dat022D <= '1'; else dat022D <= '0'; end if;

    if add = X"0307" then dat0307 <= '1'; else dat0307 <= '0'; end if;
    if add = X"030A" then dat030A <= '1'; else dat030A <= '0'; end if;
    if add = X"0310" then dat0310 <= '1'; else dat0310 <= '0'; end if;
    if add = X"0316" then dat0316 <= '1'; else dat0316 <= '0'; end if;
    if add = X"031C" then dat031C <= '1'; else dat031C <= '0'; end if;
    if add = X"0320" then dat0320 <= '1'; else dat0320 <= '0'; end if;
    if add = X"0326" then dat0326 <= '1'; else dat0326 <= '0'; end if;
    if add = X"032B" then dat032B <= '1'; else dat032B <= '0'; end if;
    if add = X"032D" then dat032D <= '1'; else dat032D <= '0'; end if;
  end if;
end process gen_conf_add;

gen_conf: process(clk)
begin
  if clk'event and clk='1' then
    if srst = '1' then
      -- form_vln <= VS_1152_864_F120(11 downto 0);
      -- form_vsz <= VS_1152_864_F120(23 downto 12);
      -- form_vss <= VP_1152_864_F120(23 downto 12);
      -- form_vse <= VP_1152_864_F120(11 downto 0);
      -- form_hln <= HS_1152_864_F120(11 downto 0);
      -- form_hsz <= HS_1152_864_F120(23 downto 12);
      -- form_hss <= HP_1152_864_F120(23 downto 12);
      -- form_hse <= HP_1152_864_F120(11 downto 0);
      -- form_pol <= "11";
      form_vln <= VS_1024_768_100(11 downto 0);
      form_vsz <= VS_1024_768_100(23 downto 12);
      form_vss <= VP_1024_768_100(23 downto 12);
      form_vse <= VP_1024_768_100(11 downto 0);
      form_hln <= HS_1024_768_100(11 downto 0);
      form_hsz <= HS_1024_768_100(23 downto 12);
      form_hss <= HP_1024_768_100(23 downto 12);
      form_hse <= HP_1024_768_100(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat0110 = '1')) then
      form_vln <= VS_1024_768_100(11 downto 0);
      form_vsz <= VS_1024_768_100(23 downto 12);
      form_vss <= VP_1024_768_100(23 downto 12);
      form_vse <= VP_1024_768_100(11 downto 0);
      form_hln <= HS_1024_768_100(11 downto 0);
      form_hsz <= HS_1024_768_100(23 downto 12);
      form_hss <= HP_1024_768_100(23 downto 12);
      form_hse <= HP_1024_768_100(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat0116 = '1')) then
      form_vln <= VS_1152_864_75(11 downto 0);
      form_vsz <= VS_1152_864_75(23 downto 12);
      form_vss <= VP_1152_864_75(23 downto 12);
      form_vse <= VP_1152_864_75(11 downto 0);
      form_hln <= HS_1152_864_75(11 downto 0);
      form_hsz <= HS_1152_864_75(23 downto 12);
      form_hss <= HP_1152_864_75(23 downto 12);
      form_hse <= HP_1152_864_75(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat0118 = '1')) then
      form_vln <= VS_1152_864_85(11 downto 0);
      form_vsz <= VS_1152_864_85(23 downto 12);
      form_vss <= VP_1152_864_85(23 downto 12);
      form_vse <= VP_1152_864_85(11 downto 0);
      form_hln <= HS_1152_864_85(11 downto 0);
      form_hsz <= HS_1152_864_85(23 downto 12);
      form_hss <= HP_1152_864_85(23 downto 12);
      form_hse <= HP_1152_864_85(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat011A = '1')) then
      form_vln <= VS_1280_1024_60(11 downto 0);
      form_vsz <= VS_1280_1024_60(23 downto 12);
      form_vss <= VP_1280_1024_60(23 downto 12);
      form_vse <= VP_1280_1024_60(11 downto 0);
      form_hln <= HS_1280_1024_60(11 downto 0);
      form_hsz <= HS_1280_1024_60(23 downto 12);
      form_hss <= HP_1280_1024_60(23 downto 12);
      form_hse <= HP_1280_1024_60(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat011C = '1')) then
      form_vln <= VS_1280_1024_75(11 downto 0);
      form_vsz <= VS_1280_1024_75(23 downto 12);
      form_vss <= VP_1280_1024_75(23 downto 12);
      form_vse <= VP_1280_1024_75(11 downto 0);
      form_hln <= HS_1280_1024_75(11 downto 0);
      form_hsz <= HS_1280_1024_75(23 downto 12);
      form_hss <= HP_1280_1024_75(23 downto 12);
      form_hse <= HP_1280_1024_75(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat0120 = '1')) then
      form_vln <= VS_1400_1050_60(11 downto 0);
      form_vsz <= VS_1400_1050_60(23 downto 12);
      form_vss <= VP_1400_1050_60(23 downto 12);
      form_vse <= VP_1400_1050_60(11 downto 0);
      form_hln <= HS_1400_1050_60(11 downto 0);
      form_hsz <= HS_1400_1050_60(23 downto 12);
      form_hss <= HP_1400_1050_60(23 downto 12);
      form_hse <= HP_1400_1050_60(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat0123 = '1')) then
      form_vln <= VS_1400_1050_75(11 downto 0);
      form_vsz <= VS_1400_1050_75(23 downto 12);
      form_vss <= VP_1400_1050_75(23 downto 12);
      form_vse <= VP_1400_1050_75(11 downto 0);
      form_hln <= HS_1400_1050_75(11 downto 0);
      form_hsz <= HS_1400_1050_75(23 downto 12);
      form_hss <= HP_1400_1050_75(23 downto 12);
      form_hse <= HP_1400_1050_75(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat0125 = '1')) then
      form_vln <= VS_1440_900_60(11 downto 0);
      form_vsz <= VS_1440_900_60(23 downto 12);
      form_vss <= VP_1440_900_60(23 downto 12);
      form_vse <= VP_1440_900_60(11 downto 0);
      form_hln <= HS_1440_900_60(11 downto 0);
      form_hsz <= HS_1440_900_60(23 downto 12);
      form_hss <= HP_1440_900_60(23 downto 12);
      form_hse <= HP_1440_900_60(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat0126 = '1')) then
      form_vln <= VS_1440_900_75(11 downto 0);
      form_vsz <= VS_1440_900_75(23 downto 12);
      form_vss <= VP_1440_900_75(23 downto 12);
      form_vse <= VP_1440_900_75(11 downto 0);
      form_hln <= HS_1440_900_75(11 downto 0);
      form_hsz <= HS_1440_900_75(23 downto 12);
      form_hss <= HP_1440_900_75(23 downto 12);
      form_hse <= HP_1440_900_75(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat0129 = '1')) then
      form_vln <= VS_1600_1024_60(11 downto 0);
      form_vsz <= VS_1600_1024_60(23 downto 12);
      form_vss <= VP_1600_1024_60(23 downto 12);
      form_vse <= VP_1600_1024_60(11 downto 0);
      form_hln <= HS_1600_1024_60(11 downto 0);
      form_hsz <= HS_1600_1024_60(23 downto 12);
      form_hss <= HP_1600_1024_60(23 downto 12);
      form_hse <= HP_1600_1024_60(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat012B = '1')) then
      form_vln <= VS_1600_1024_70(11 downto 0);
      form_vsz <= VS_1600_1024_70(23 downto 12);
      form_vss <= VP_1600_1024_70(23 downto 12);
      form_vse <= VP_1600_1024_70(11 downto 0);
      form_hln <= HS_1600_1024_70(11 downto 0);
      form_hsz <= HS_1600_1024_70(23 downto 12);
      form_hss <= HP_1600_1024_70(23 downto 12);
      form_hse <= HP_1600_1024_70(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat012D = '1')) then
      form_vln <= VS_1680_1050_60(11 downto 0);
      form_vsz <= VS_1680_1050_60(23 downto 12);
      form_vss <= VP_1680_1050_60(23 downto 12);
      form_vse <= VP_1680_1050_60(11 downto 0);
      form_hln <= HS_1680_1050_60(11 downto 0);
      form_hsz <= HS_1680_1050_60(23 downto 12);
      form_hss <= HP_1680_1050_60(23 downto 12);
      form_hse <= HP_1680_1050_60(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat0210 = '1')) then
      form_vln <= VS_1024_768_F160(11 downto 0);
      form_vsz <= VS_1024_768_F160(23 downto 12);
      form_vss <= VP_1024_768_F160(23 downto 12);
      form_vse <= VP_1024_768_F160(11 downto 0);
      form_hln <= HS_1024_768_F160(11 downto 0);
      form_hsz <= HS_1024_768_F160(23 downto 12);
      form_hss <= HP_1024_768_F160(23 downto 12);
      form_hse <= HP_1024_768_F160(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat0216 = '1')) then
      form_vln <= VS_1152_864_F160(11 downto 0);
      form_vsz <= VS_1152_864_F160(23 downto 12);
      form_vss <= VP_1152_864_F160(23 downto 12);
      form_vse <= VP_1152_864_F160(11 downto 0);
      form_hln <= HS_1152_864_F160(11 downto 0);
      form_hsz <= HS_1152_864_F160(23 downto 12);
      form_hss <= HP_1152_864_F160(23 downto 12);
      form_hse <= HP_1152_864_F160(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat021C = '1')) then
      form_vln <= VS_1280_1024_F160(11 downto 0);
      form_vsz <= VS_1280_1024_F160(23 downto 12);
      form_vss <= VP_1280_1024_F160(23 downto 12);
      form_vse <= VP_1280_1024_F160(11 downto 0);
      form_hln <= HS_1280_1024_F160(11 downto 0);
      form_hsz <= HS_1280_1024_F160(23 downto 12);
      form_hss <= HP_1280_1024_F160(23 downto 12);
      form_hse <= HP_1280_1024_F160(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat0220 = '1')) then
      form_vln <= VS_1400_1050_F160(11 downto 0);
      form_vsz <= VS_1400_1050_F160(23 downto 12);
      form_vss <= VP_1400_1050_F160(23 downto 12);
      form_vse <= VP_1400_1050_F160(11 downto 0);
      form_hln <= HS_1400_1050_F160(11 downto 0);
      form_hsz <= HS_1400_1050_F160(23 downto 12);
      form_hss <= HP_1400_1050_F160(23 downto 12);
      form_hse <= HP_1400_1050_F160(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat0226 = '1')) then
      form_vln <= VS_1440_900_F160(11 downto 0);
      form_vsz <= VS_1440_900_F160(23 downto 12);
      form_vss <= VP_1440_900_F160(23 downto 12);
      form_vse <= VP_1440_900_F160(11 downto 0);
      form_hln <= HS_1440_900_F160(11 downto 0);
      form_hsz <= HS_1440_900_F160(23 downto 12);
      form_hss <= HP_1440_900_F160(23 downto 12);
      form_hse <= HP_1440_900_F160(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat022B = '1')) then
      form_vln <= VS_1600_1024_F160(11 downto 0);
      form_vsz <= VS_1600_1024_F160(23 downto 12);
      form_vss <= VP_1600_1024_F160(23 downto 12);
      form_vse <= VP_1600_1024_F160(11 downto 0);
      form_hln <= HS_1600_1024_F160(11 downto 0);
      form_hsz <= HS_1600_1024_F160(23 downto 12);
      form_hss <= HP_1600_1024_F160(23 downto 12);
      form_hse <= HP_1600_1024_F160(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat022D = '1')) then
      form_vln <= VS_1680_1050_F160(11 downto 0);
      form_vsz <= VS_1680_1050_F160(23 downto 12);
      form_vss <= VP_1680_1050_F160(23 downto 12);
      form_vse <= VP_1680_1050_F160(11 downto 0);
      form_hln <= HS_1680_1050_F160(11 downto 0);
      form_hsz <= HS_1680_1050_F160(23 downto 12);
      form_hss <= HP_1680_1050_F160(23 downto 12);
      form_hse <= HP_1680_1050_F160(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat0307 = '1')) then
      form_vln <= VS_640_480_F120(11 downto 0);
      form_vsz <= VS_640_480_F120(23 downto 12);
      form_vss <= VP_640_480_F120(23 downto 12);
      form_vse <= VP_640_480_F120(11 downto 0);
      form_hln <= HS_640_480_F120(11 downto 0);
      form_hsz <= HS_640_480_F120(23 downto 12);
      form_hss <= HP_640_480_F120(23 downto 12);
      form_hse <= HP_640_480_F120(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat030A = '1')) then
      form_vln <= VS_800_600_F120(11 downto 0);
      form_vsz <= VS_800_600_F120(23 downto 12);
      form_vss <= VP_800_600_F120(23 downto 12);
      form_vse <= VP_800_600_F120(11 downto 0);
      form_hln <= HS_800_600_F120(11 downto 0);
      form_hsz <= HS_800_600_F120(23 downto 12);
      form_hss <= HP_800_600_F120(23 downto 12);
      form_hse <= HP_800_600_F120(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat0310 = '1')) then
      form_vln <= VS_1024_768_F120(11 downto 0);
      form_vsz <= VS_1024_768_F120(23 downto 12);
      form_vss <= VP_1024_768_F120(23 downto 12);
      form_vse <= VP_1024_768_F120(11 downto 0);
      form_hln <= HS_1024_768_F120(11 downto 0);
      form_hsz <= HS_1024_768_F120(23 downto 12);
      form_hss <= HP_1024_768_F120(23 downto 12);
      form_hse <= HP_1024_768_F120(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat0316 = '1')) then
      form_vln <= VS_1152_864_F120(11 downto 0);
      form_vsz <= VS_1152_864_F120(23 downto 12);
      form_vss <= VP_1152_864_F120(23 downto 12);
      form_vse <= VP_1152_864_F120(11 downto 0);
      form_hln <= HS_1152_864_F120(11 downto 0);
      form_hsz <= HS_1152_864_F120(23 downto 12);
      form_hss <= HP_1152_864_F120(23 downto 12);
      form_hse <= HP_1152_864_F120(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat031C = '1')) then
      form_vln <= VS_1280_1024_F120(11 downto 0);
      form_vsz <= VS_1280_1024_F120(23 downto 12);
      form_vss <= VP_1280_1024_F120(23 downto 12);
      form_vse <= VP_1280_1024_F120(11 downto 0);
      form_hln <= HS_1280_1024_F120(11 downto 0);
      form_hsz <= HS_1280_1024_F120(23 downto 12);
      form_hss <= HP_1280_1024_F120(23 downto 12);
      form_hse <= HP_1280_1024_F120(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat0320 = '1')) then
      form_vln <= VS_1400_1050_F120(11 downto 0);
      form_vsz <= VS_1400_1050_F120(23 downto 12);
      form_vss <= VP_1400_1050_F120(23 downto 12);
      form_vse <= VP_1400_1050_F120(11 downto 0);
      form_hln <= HS_1400_1050_F120(11 downto 0);
      form_hsz <= HS_1400_1050_F120(23 downto 12);
      form_hss <= HP_1400_1050_F120(23 downto 12);
      form_hse <= HP_1400_1050_F120(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat0326 = '1')) then
      form_vln <= VS_1440_900_F120(11 downto 0);
      form_vsz <= VS_1440_900_F120(23 downto 12);
      form_vss <= VP_1440_900_F120(23 downto 12);
      form_vse <= VP_1440_900_F120(11 downto 0);
      form_hln <= HS_1440_900_F120(11 downto 0);
      form_hsz <= HS_1440_900_F120(23 downto 12);
      form_hss <= HP_1440_900_F120(23 downto 12);
      form_hse <= HP_1440_900_F120(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat032B = '1')) then
      form_vln <= VS_1600_1024_F120(11 downto 0);
      form_vsz <= VS_1600_1024_F120(23 downto 12);
      form_vss <= VP_1600_1024_F120(23 downto 12);
      form_vse <= VP_1600_1024_F120(11 downto 0);
      form_hln <= HS_1600_1024_F120(11 downto 0);
      form_hsz <= HS_1600_1024_F120(23 downto 12);
      form_hss <= HP_1600_1024_F120(23 downto 12);
      form_hse <= HP_1600_1024_F120(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat032D = '1')) then
      form_vln <= VS_1680_1050_F120(11 downto 0);
      form_vsz <= VS_1680_1050_F120(23 downto 12);
      form_vss <= VP_1680_1050_F120(23 downto 12);
      form_vse <= VP_1680_1050_F120(11 downto 0);
      form_hln <= HS_1680_1050_F120(11 downto 0);
      form_hsz <= HS_1680_1050_F120(23 downto 12);
      form_hss <= HP_1680_1050_F120(23 downto 12);
      form_hse <= HP_1680_1050_F120(11 downto 0);
      form_pol <= "11";
    elsif ((wed = '1') and (dat0010 = '1')) then
      form_vln <= dat(11 downto 0);
    elsif ((wed = '1') and (dat0011 = '1')) then
      form_vsz <= dat(11 downto 0);
    elsif ((wed = '1') and (dat0012 = '1')) then
      form_vss <= dat(11 downto 0);
    elsif ((wed = '1') and (dat0013 = '1')) then
      form_vse <= dat(11 downto 0);
    elsif ((wed = '1') and (dat0014 = '1')) then
      form_hln <= dat(11 downto 0);
    elsif ((wed = '1') and (dat0015 = '1')) then
      form_hsz <= dat(11 downto 0);
    elsif ((wed = '1') and (dat0016 = '1')) then
      form_hss <= dat(11 downto 0);
    elsif ((wed = '1') and (dat0017 = '1')) then
      form_hse <= dat(11 downto 0);
    elsif ((wed = '1') and (dat0018 = '1')) then
      form_pol <= dat(1 downto 0);
    end if;
  end if;
end process gen_conf;

end rtl;

