library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Top is
    port 
    (
    
	 Clk_FPGA : in std_logic;
     Clk    :   in std_logic;
     Hsync        :   in std_logic;
	 De        :   in std_logic;
     Vsync		:in  std_logic;
	 PinDat    : in std_logic_vector(23 downto 0);
	 Led      : out std_logic
    );
end entity Top;



architecture rtl of Top is

signal DEanalys : std_logic;
signal     Clkanalys    :    std_logic;
 signal    Hsyncanalys    :    std_logic;
signal     Vsyncanalys		:  std_logic;
signal	 PinDatanalys    :  std_logic_vector(23 downto 0);
signal			cpt :  std_logic_vector(23 downto 0);
signal sLed : std_logic;
signal sclkFPGA : std_logic;



    begin
   
 DEanalys <= De;
Clkanalys   <= Clk;
   Hsyncanalys <= Hsync;

   Vsyncanalys <= Vsync;
   PinDatanalys<= PinDat ;
   sclkFPGA  <= Clk_FPGA;
   
   
   pled: process(Clk_FPGA)
   begin
		if rising_edge(Clk_FPGA) then
			cpt <= cpt + 1;
			if cpt >= 5000000 then  
				sLed <= not(sLed) ;
				cpt <= (others => '0') ;
			end if;
		end if;
	

    end process pled;
   Led <= sLed;
   
   
end architecture rtl;