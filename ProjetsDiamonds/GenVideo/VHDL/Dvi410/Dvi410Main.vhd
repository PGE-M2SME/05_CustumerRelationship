library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Dvi410 is
generic(FPGA_FAMILY : string := "ECP3"); 
port(         
-- Configuration in the SysClk domain
        SysClk : in std_logic; 
        SRst : in std_logic; 
        ConfWe : in std_logic;
        ConfAdd : in std_logic_vector(15 downto 0);
        ConfDat : in std_logic_vector(15 downto 0);
        DviResH : out std_logic_vector(11 downto 0);
-- DVI domain
        ClkDvi : in std_logic;
        NewFrame, ReqNewRow, FifoRd : out std_logic;
        DataIn : in std_logic_vector(23 downto 0);
-- TFP410 outputs
        PinTfpVs : out std_logic;
        PinTfpHs : out std_logic;
        PinTfpDe : out std_logic;
        PinTfpClk : out std_logic;
        PinTfpDat : out std_logic_vector(23 downto 0)
);
end;

architecture rtl of Dvi410 is

COMPONENT Dvi410Cnt 
port(   clk: in std_logic ;
        arst: in std_logic ;
        len_h: in std_logic_vector ( 11 downto 0 );
        len_v: in std_logic_vector ( 11 downto 0 );
        cnt_h: out std_logic_vector ( 11 downto 0 );
        cnt_v: out std_logic_vector ( 11 downto 0 ) );
end COMPONENT;

COMPONENT Dvi410Timing 
port(   clk: in std_logic; 
        cnt_v: in std_logic_vector ( 11 downto 0 );
        cnt_h: in std_logic_vector ( 11 downto 0 );
        siz_v: in std_logic_vector ( 11 downto 0 );
        siz_h: in std_logic_vector ( 11 downto 0 );
        fifo_rd: out std_logic;
        dvi_de: out std_logic);
end COMPONENT;

COMPONENT Dvi410Sync 
port(   clk: in std_logic; 
        cnt_v: in std_logic_vector ( 11 downto 0 );
        cnt_h: in std_logic_vector ( 11 downto 0 );
        sync_hse: in std_logic_vector ( 11 downto 0 );
        sync_hss: in std_logic_vector ( 11 downto 0 );
        sync_vse: in std_logic_vector ( 11 downto 0 );
        sync_vss: in std_logic_vector ( 11 downto 0 );
        sync_pol: in std_logic_vector ( 1 downto 0 );
	    hs, vs: out std_logic);
end COMPONENT;

COMPONENT Dvi410Request 
port(   clkdvi: in std_logic;
        cnt_v: in std_logic_vector ( 11 downto 0 );
        cnt_h: in std_logic_vector ( 11 downto 0 );
        len_v: in std_logic_vector ( 11 downto 0 );
        siz_v: in std_logic_vector ( 11 downto 0 );
        siz_h: in std_logic_vector ( 11 downto 0 );
        vsync: in std_logic_vector ( 11 downto 0 );
        dvi_nf: out std_logic;
        req_row: out std_logic);

end COMPONENT;

COMPONENT Dvi410Conf 
port(   clk: in std_logic ;
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
end COMPONENT;

component ODDRXC 
port(
	Clk, Da, Db, Rst : in std_logic;
	Q : out std_logic);
end component;

signal cnt_h, cnt_v : std_logic_vector(11 downto 0);
signal form_vln, form_vsz, form_vss, form_vse : std_logic_vector(11 downto 0);
signal form_hln, form_hsz, form_hss, form_hse : std_logic_vector(11 downto 0);

signal form_pol : std_logic_vector(1 downto 0);
signal sync_vp, sync_hp : std_logic;

signal dvi_nf0 : std_logic;

begin

pResolution: process(ClkDvi)
begin
  if ClkDvi'event and ClkDvi='1' then
    if dvi_nf0 = '1' then
      DviResH <= form_hsz;
    end if;
  end if;
end process pResolution;

U_conf : Dvi410Conf PORT MAP(clk=>SysClk, srst=>srst, we=>ConfWe, 
                       dat=>ConfDat, add=>ConfAdd,
                       form_vln=>form_vln, form_vsz=>form_vsz, 
                       form_vss=>form_vss, form_vse=>form_vse,
                       form_hln=>form_hln, form_hsz=>form_hsz, 
                       form_hss=>form_hss, form_hse=>form_hse,
                       form_pol=>form_pol);

U_gen_cnt : Dvi410Cnt PORT MAP(clk=>ClkDvi, arst=>srst,
                             len_h=>form_hln, len_v=>form_vln, 
                             cnt_h=>cnt_h, cnt_v=>cnt_v);

U_gen_sync : Dvi410Sync PORT MAP(clk=>ClkDvi, cnt_h=>cnt_h, cnt_v=>cnt_v, 
                               sync_vss=>form_vss, sync_vse=>form_vse,
                               sync_hss=>form_hss, sync_hse=>form_hse,
                               sync_pol=>form_pol, hs=>PinTfpHs, vs=>PinTfpVs);

U_gen_tim : Dvi410Timing PORT MAP(clk=>ClkDvi, cnt_h=>cnt_h, cnt_v=>cnt_v,
                                siz_v=>form_vsz, siz_h=>form_hsz, 
                                fifo_rd=>FifoRd, dvi_de=>PinTfpDe);

U_gen_req : Dvi410Request PORT MAP(clkdvi=>ClkDvi, cnt_h=>cnt_h, cnt_v=>cnt_v,
                                 len_v=>form_vln, siz_v=>form_vsz, 
                                 vsync=>form_vss, siz_h=>form_hsz, 
                                 dvi_nf=>dvi_nf0, req_row=>ReqNewRow);

NewFrame <= dvi_nf0;
								 
gen_dat: process(ClkDvi)
begin
  if ClkDvi'event and ClkDvi='1' then
    PinTfpDat <= DataIn;
  end if;
end process gen_dat;

uGenTfpClkXP2 : if FPGA_FAMILY = "XP2" generate

uTfpClk : ODDRXC port map(Clk=>ClkDvi, Da=>'1', Db=>'0', Rst=>'0', Q=>PinTfpClk);

end generate;

end rtl;

