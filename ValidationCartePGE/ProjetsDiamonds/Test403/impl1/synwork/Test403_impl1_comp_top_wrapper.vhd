--
-- Synopsys
-- Vhdl wrapper for top level design, written on Wed Mar 10 11:55:08 2021
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity wrapper_for_Top is
   port (
      Clk_FPGA : in std_logic;
      Clk : in std_logic;
      Hsync : in std_logic;
      De : in std_logic;
      Vsync : in std_logic;
      PinDat : in std_logic_vector(23 downto 0);
      Led : out std_logic
   );
end wrapper_for_Top;

architecture rtl of wrapper_for_Top is

component Top
 port (
   Clk_FPGA : in std_logic;
   Clk : in std_logic;
   Hsync : in std_logic;
   De : in std_logic;
   Vsync : in std_logic;
   PinDat : in std_logic_vector (23 downto 0);
   Led : out std_logic
 );
end component;

signal tmp_Clk_FPGA : std_logic;
signal tmp_Clk : std_logic;
signal tmp_Hsync : std_logic;
signal tmp_De : std_logic;
signal tmp_Vsync : std_logic;
signal tmp_PinDat : std_logic_vector (23 downto 0);
signal tmp_Led : std_logic;

begin

tmp_Clk_FPGA <= Clk_FPGA;

tmp_Clk <= Clk;

tmp_Hsync <= Hsync;

tmp_De <= De;

tmp_Vsync <= Vsync;

tmp_PinDat <= PinDat;

Led <= tmp_Led;



u1:   Top port map (
		Clk_FPGA => tmp_Clk_FPGA,
		Clk => tmp_Clk,
		Hsync => tmp_Hsync,
		De => tmp_De,
		Vsync => tmp_Vsync,
		PinDat => tmp_PinDat,
		Led => tmp_Led
       );
end rtl;
