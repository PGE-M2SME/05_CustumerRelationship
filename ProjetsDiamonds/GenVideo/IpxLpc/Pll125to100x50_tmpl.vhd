-- VHDL module instantiation generated by SCUBA Diamond (64-bit) 3.11.2.446
-- Module  Version: 5.7
-- Wed Jan 06 16:31:40 2021

-- parameterized module component declaration
component Pll125to100x50
    port (CLK: in std_logic; CLKOP: out std_logic; CLKOK: out std_logic; 
        LOCK: out std_logic);
end component;

-- parameterized module component instance
__ : Pll125to100x50
    port map (CLK=>__, CLKOP=>__, CLKOK=>__, LOCK=>__);
