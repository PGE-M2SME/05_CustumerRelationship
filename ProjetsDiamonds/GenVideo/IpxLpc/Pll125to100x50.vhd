-- VHDL netlist generated by SCUBA Diamond (64-bit) 3.11.2.446
-- Module  Version: 5.7
--C:\lscc\diamond\3.11_x64\ispfpga\bin\nt64\scuba.exe -w -n Pll125to100x50 -lang vhdl -synth synplify -arch ep5c00 -type pll -fin 125 -phase_cntl STATIC -fclkop 100 -fclkop_tol 0.0 -fb_mode CLOCKTREE -noclkos -fclkok 50 -fclkok_tol 0.0 -clkoki 0 -norst -noclkok2 -bw 

-- Wed Jan 06 16:31:40 2021

library IEEE;
use IEEE.std_logic_1164.all;
-- synopsys translate_off
library ecp3;
use ecp3.components.all;
-- synopsys translate_on

entity Pll125to100x50 is
    port (
        CLK: in std_logic; 
        CLKOP: out std_logic; 
        CLKOK: out std_logic; 
        LOCK: out std_logic);
end Pll125to100x50;

architecture Structure of Pll125to100x50 is

    -- internal signal declarations
    signal CLKOP_t: std_logic;
    signal scuba_vlo: std_logic;

    -- local component declarations
    component EHXPLLF
        generic (FEEDBK_PATH : in String; CLKOK_INPUT : in String; 
                DELAY_PWD : in String; DELAY_VAL : in Integer; 
                CLKOS_TRIM_DELAY : in Integer; 
                CLKOS_TRIM_POL : in String; 
                CLKOP_TRIM_DELAY : in Integer; 
                CLKOP_TRIM_POL : in String; CLKOK_BYPASS : in String; 
                CLKOS_BYPASS : in String; CLKOP_BYPASS : in String; 
                PHASE_DELAY_CNTL : in String; DUTY : in Integer; 
                PHASEADJ : in String; CLKOK_DIV : in Integer; 
                CLKOP_DIV : in Integer; CLKFB_DIV : in Integer; 
                CLKI_DIV : in Integer; FIN : in String);
        port (CLKI: in std_logic; CLKFB: in std_logic; RST: in std_logic; 
            RSTK: in std_logic; WRDEL: in std_logic; DRPAI3: in std_logic; 
            DRPAI2: in std_logic; DRPAI1: in std_logic; DRPAI0: in std_logic; 
            DFPAI3: in std_logic; DFPAI2: in std_logic; DFPAI1: in std_logic; 
            DFPAI0: in std_logic; FDA3: in std_logic; FDA2: in std_logic; 
            FDA1: in std_logic; FDA0: in std_logic; CLKOP: out std_logic; 
            CLKOS: out std_logic; CLKOK: out std_logic; CLKOK2: out std_logic; 
            LOCK: out std_logic; CLKINTFB: out std_logic);
    end component;
    component VLO
        port (Z: out std_logic);
    end component;
    attribute FREQUENCY_PIN_CLKOP : string; 
    attribute FREQUENCY_PIN_CLKI : string; 
    attribute FREQUENCY_PIN_CLKOK : string; 
    attribute FREQUENCY_PIN_CLKOP of PLLInst_0 : label is "100.000000";
    attribute FREQUENCY_PIN_CLKI of PLLInst_0 : label is "125.000000";
    attribute FREQUENCY_PIN_CLKOK of PLLInst_0 : label is "50.000000";
    attribute syn_keep : boolean;
    attribute NGD_DRC_MASK : integer;
    attribute NGD_DRC_MASK of Structure : architecture is 1;

begin
    -- component instantiation statements
    scuba_vlo_inst: VLO
        port map (Z=>scuba_vlo);

    PLLInst_0: EHXPLLF
        generic map (FEEDBK_PATH=> "CLKOP", CLKOK_BYPASS=> "DISABLED", 
        CLKOS_BYPASS=> "DISABLED", CLKOP_BYPASS=> "DISABLED", 
        CLKOK_INPUT=> "CLKOP", DELAY_PWD=> "DISABLED", DELAY_VAL=>  0, 
        CLKOS_TRIM_DELAY=>  0, CLKOS_TRIM_POL=> "RISING", 
        CLKOP_TRIM_DELAY=>  0, CLKOP_TRIM_POL=> "RISING", 
        PHASE_DELAY_CNTL=> "STATIC", DUTY=>  8, PHASEADJ=> "0.0", 
        CLKOK_DIV=>  2, CLKOP_DIV=>  8, CLKFB_DIV=>  4, CLKI_DIV=>  5, 
        FIN=> "125.000000")
        port map (CLKI=>CLK, CLKFB=>CLKOP_t, RST=>scuba_vlo, 
            RSTK=>scuba_vlo, WRDEL=>scuba_vlo, DRPAI3=>scuba_vlo, 
            DRPAI2=>scuba_vlo, DRPAI1=>scuba_vlo, DRPAI0=>scuba_vlo, 
            DFPAI3=>scuba_vlo, DFPAI2=>scuba_vlo, DFPAI1=>scuba_vlo, 
            DFPAI0=>scuba_vlo, FDA3=>scuba_vlo, FDA2=>scuba_vlo, 
            FDA1=>scuba_vlo, FDA0=>scuba_vlo, CLKOP=>CLKOP_t, 
            CLKOS=>open, CLKOK=>CLKOK, CLKOK2=>open, LOCK=>LOCK, 
            CLKINTFB=>open);

    CLKOP <= CLKOP_t;
end Structure;

-- synopsys translate_off
library ecp3;
configuration Structure_CON of Pll125to100x50 is
    for Structure
        for all:EHXPLLF use entity ecp3.EHXPLLF(V); end for;
        for all:VLO use entity ecp3.VLO(V); end for;
    end for;
end Structure_CON;

-- synopsys translate_on
