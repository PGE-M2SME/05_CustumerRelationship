library ieee;
use ieee.std_logic_1164.all;
 
package PackageVideo is
 
  -- Outputs of Video Timing Process
	type VideoTimingOutput is record
		HSync				: std_logic;                --	Horizontal Synchronous Pulse
		VSync				: std_logic;                --	Vertical Synchronous Pulse
		FV					: std_logic;				--	Frame validated
		LV					: std_logic;				--	Line validated
		DV					: std_logic;				--	Data validated
		T1LV, T2LV, T3LV	: std_logic;				--	TXLV : Trigger de Line Validated avec X coup de clock d'avance
		T1FV, T2FV			: std_logic;				--	TXFV : Trigger de Frame Validated avec X lignes d'avance
		TFV					: std_logic;				--	Trigger de Frame Validated avec un coup de clock d'avance
		SoF					: std_logic;
	end record VideoTimingOutput;
 
 
  -- (Extra-) Outputs for triggers
	type ExtraTriggers is record
			-- Horizontal Length
		T4HLength			: std_logic;
		T3HLength			: std_logic;
		T2HLength			: std_logic;
		T1HLength			: std_logic;
		T0HLength			: std_logic;
			-- Horizontal Resolution
		T4HResolution		: std_logic;
		T3HResolution		: std_logic;
		T2HResolution		: std_logic;
		T1HResolution		: std_logic;
			-- Vertical Length
		T3VLength			: std_logic;
		T2VLength			: std_logic;
		T1VLength			: std_logic;
		T0VLength			: std_logic;
			-- Vertical Resolution
		T3VResolution		: std_logic;
		T2VResolution		: std_logic;
		T1VResolution		: std_logic;
	end record ExtraTriggers;
 
  -- Inputs of Video Timing Process
	type VidParameter is record
		HLength	 	: std_logic_vector(11 downto 0);	--	Total number of pixel clocks in a row
		HRes		: std_logic_vector(11 downto 0); 	--	Horiztonal display width in pixels
		HFP			: std_logic_vector(7 downto 0);		--	Horiztonal front porch width in pixels
		HSyncPulse	: std_logic_vector(7 downto 0);		--	Horiztonal sync pulse width in pixels
		HBP			: std_logic_vector(8 downto 0);		--	Horiztonal back porch width in pixels
		HPolSync	: std_logic;						--	Horizontal sync pulse polarity (1 = positive, 0 = negative)
		
		VLength	 	: std_logic_vector(11 downto 0);	--	Total number of pixel clocks in column
		VRes		: std_logic_vector(11 downto 0); 	--	Vertical display width in pixels
		VFP			: std_logic_vector(3 downto 0);		--	Vertical front porch width in pixels
		VSyncPulse	: std_logic_vector(3 downto 0);		--	Vertical sync pulse width in pixels
		VBP			: std_logic_vector(5 downto 0);		--	Vertical back porch width in pixels
		VPolSync	: std_logic;						--	Vertical sync pulse polarity (1 = positive, 0 = negative)
	end record VidParameter;


				-- Initialisation of Video Timing Parameters
	constant VidTimInit : VideoTimingOutput :=	(
													HSync => '0',
													VSync => '0',
													FV => '0',
													LV => '0',
													DV => '0',
													T1LV => '1',
													T2LV => '1',
													T3LV => '1',
													T1FV => '1',
													T2FV => '1',
													TFV => '1',
													SoF => '0'
												);
												
				-- Initialisation of Video Parameters			
	constant ParamInit	: VidParameter :=	(
												HLength => X"000",
												HRes => X"000",		
												HFP => X"00",
												HSyncPulse => X"00",
												HBP => '0' & X"00",
												HPolSync => '0',
												VLength => X"000",
												VRes => X"000",
												VFP => X"0",
												VSyncPulse => X"0",
												VBP => "00" & X"0",
												VPolSync => '0'
											);

				-- 640x480 @60Hz ( 25.175 MHz)
	constant Resolution640x480 : VidParameter :=(
													HLength => X"320",
													HRes => X"280",		
													HFP => X"10",
													HSyncPulse => X"60",
													HBP => '0' & X"30",
													HPolSync => '0',
													VLength => X"20D",
													VRes => X"1E0",
													VFP => X"A",
													VSyncPulse => X"2",
													VBP => "10" & X"1",
													VPolSync => '0'
												);

				-- 768x576 @60Hz ( 34.96 MHz)
	constant Resolution768x576 : VidParameter :=(	
													HLength => X"3D0",
													HRes => X"300",		
													HFP => X"18",
													HSyncPulse => X"50",
													HBP => '0' & X"68",
													HPolSync => '0',
													VLength => X"255",
													VRes => X"240",
													VFP => X"1",
													VSyncPulse => X"3",
													VBP => "01" & X"1",
													VPolSync => '1'
												);
												
				-- 800x600 @60Hz ( 40 MHz)								
	constant Resolution800x600 : VidParameter :=(	
													HLength => X"420",
													HRes => X"320",		
													HFP => X"28",
													HSyncPulse => X"80",
													HBP => '0' & X"58",
													HPolSync => '1',
													VLength => X"274",
													VRes => X"258",
													VFP => X"1",
													VSyncPulse => X"4",
													VBP => "01" & X"7",
													VPolSync => '1'
												);

				-- 1024x768 @60Hz ( 65 MHz)
	constant Resolution1024x768 : VidParameter :=(	
													HLength => X"540",
													HRes => X"400",		
													HFP => X"18",
													HSyncPulse => X"88",
													HBP => '0' & X"A0",
													HPolSync => '0',
													VLength => X"326",
													VRes => X"300",
													VFP => X"3",
													VSyncPulse => X"6",
													VBP => "01" & X"D",
													VPolSync => '0'
												);
				-- 1152x864 @60Hz ( 81.62 MHz)								
	constant Resolution1152x864 : VidParameter :=(	
													HLength => X"5F0",
													HRes => X"480",		
													HFP => X"40",
													HSyncPulse => X"78",
													HBP => '0' & X"B8",
													HPolSync => '0',
													VLength => X"37F",
													VRes => X"360",
													VFP => X"1",
													VSyncPulse => X"3",
													VBP => "01" & X"B",
													VPolSync => '0'
												);
												
				-- 1280x720 @60Hz ( 74.25 MHz) -- 720p								
	constant Resolution1280x720 : VidParameter :=(	
													HLength => X"670",
													HRes => X"500",		
													HFP => X"48",
													HSyncPulse => X"50",
													HBP => '0' & X"D8",
													HPolSync => '1',
													VLength => X"2EE",
													VRes => X"2D0",
													VFP => X"3",
													VSyncPulse => X"5",
													VBP => "01" & X"6",
													VPolSync => '1'
												);
												
				-- 1280x800 @60Hz ( 83.46 MHz)								
	constant Resolution1280x800 : VidParameter :=(	
													HLength => X"690",
													HRes => X"500",		
													HFP => X"40",
													HSyncPulse => X"88",
													HBP => '0' & X"C8",
													HPolSync => '0',
													VLength => X"33C",
													VRes => X"320",
													VFP => X"1",
													VSyncPulse => X"3",
													VBP => "01" & X"8",
													VPolSync => '1'
												);
												
				-- 1280x960 @60Hz ( 102.1 MHz)								
	constant Resolution1280x960 : VidParameter :=(	
													HLength => X"6B0",
													HRes => X"500",		
													HFP => X"50",
													HSyncPulse => X"88",
													HBP => '0' & X"D8",
													HPolSync => '0',
													VLength => X"3E2",
													VRes => X"3C0",
													VFP => X"1",
													VSyncPulse => X"3",
													VBP => "01" & X"E",
													VPolSync => '1'
												);
												
				-- 1280x1024 @60Hz ( 108 MHz)								
	constant Resolution1280x1024 : VidParameter :=(	
													HLength => X"698",
													HRes => X"500",		
													HFP => X"30",
													HSyncPulse => X"70",
													HBP => '0' & X"F8",
													HPolSync => '1',
													VLength => X"42A",
													VRes => X"400",
													VFP => X"1",
													VSyncPulse => X"3",
													VBP => "10" & X"6",
													VPolSync => '1'
												);
												
				-- 1368x768 @60Hz ( 85.86 MHz)								
	constant Resolution1368x768 : VidParameter :=(	
													HLength => X"708",
													HRes => X"558",		
													HFP => X"48",
													HSyncPulse => X"90",
													HBP => '0' & X"D8",
													HPolSync => '0',
													VLength => X"31D",
													VRes => X"300",
													VFP => X"1",
													VSyncPulse => X"3",
													VBP => "01" & X"7",
													VPolSync => '1'
												);
												
				-- 1400x1050 @60Hz ( 122.61 MHz)								
	constant Resolution1400x1050 : VidParameter :=(	
													HLength => X"758",
													HRes => X"578",		
													HFP => X"58",
													HSyncPulse => X"98",
													HBP => '0' & X"F0",
													HPolSync => '0',
													VLength => X"43F",
													VRes => X"41A",
													VFP => X"1",
													VSyncPulse => X"3",
													VBP => "10" & X"1",
													VPolSync => '1'
												);

				-- 1440x900 @60Hz ( 106.47 MHz)								
	constant Resolution1440x900 : VidParameter :=(	
													HLength => X"770",
													HRes => X"5A0",		
													HFP => X"50",
													HSyncPulse => X"98",
													HBP => '0' & X"E8",
													HPolSync => '0',
													VLength => X"3A4",
													VRes => X"384",
													VFP => X"1",
													VSyncPulse => X"3",
													VBP => "01" & X"C",
													VPolSync => '1'
												);
												
				-- 1600x1200 @60Hz ( 162 MHz)								
	constant Resolution1600x1200 : VidParameter :=(	
													HLength => X"870",
													HRes => X"640",		
													HFP => X"40",
													HSyncPulse => X"C0",
													HBP => '1' & X"30",
													HPolSync => '1',
													VLength => X"4E2",
													VRes => X"4B0",
													VFP => X"1",
													VSyncPulse => X"3",
													VBP => "10" & X"E",
													VPolSync => '1'
												);
												
				-- 1680x1050 @60Hz ( 147.14 MHz)								
	constant Resolution1680x1050 : VidParameter :=(	
													HLength => X"8D0",
													HRes => X"690",		
													HFP => X"68",
													HSyncPulse => X"B8",
													HBP => '1' & X"20",
													HPolSync => '0',
													VLength => X"43F",
													VRes => X"41A",
													VFP => X"1",
													VSyncPulse => X"3",
													VBP => "10" & X"1",
													VPolSync => '1'
												);
												
				-- 1792x1344 @60Hz ( 204.8 MHz)								
	constant Resolution1792x1344 : VidParameter :=(	
													HLength => X"990",
													HRes => X"700",		
													HFP => X"80",
													HSyncPulse => X"C8",
													HBP => '1' & X"48",
													HPolSync => '0',
													VLength => X"572",
													VRes => X"540",
													VFP => X"1",
													VSyncPulse => X"3",
													VBP => "10" & X"E",
													VPolSync => '1'
												);

				-- 1856x1392 @60Hz ( 218.3 MHz)								
	constant Resolution1856x1392 : VidParameter :=(	
													HLength => X"9E0",
													HRes => X"740",		
													HFP => X"60",
													HSyncPulse => X"F0",
													HBP => '1' & X"60",
													HPolSync => '0',
													VLength => X"59F",
													VRes => X"570",
													VFP => X"1",
													VSyncPulse => X"3",
													VBP => "10" & X"B",
													VPolSync => '1'
												);

				-- 1920x1080 @60Hz ( 148.5 MHz)	--	1080p								
	constant Resolution1920x1080 : VidParameter :=(	
													HLength => X"898",
													HRes => X"780",		
													HFP => X"58",
													HSyncPulse => X"2C",
													HBP => '0' & X"94",
													HPolSync => '1',
													VLength => X"465",
													VRes => X"438",
													VFP => X"4",
													VSyncPulse => X"5",
													VBP => "10" & X"4",
													VPolSync => '1'
												);


				-- 1920x1200 ( Reduced blanking)								
	constant Resolution1920x1200RB : VidParameter :=(	
													HLength => X"820",
													HRes => X"780",		
													HFP => X"30",
													HSyncPulse => X"20",
													HBP => '0' & X"50",
													HPolSync => '0',
													VLength => X"4D3",
													VRes => X"4B0",
													VFP => X"1",
													VSyncPulse => X"3",
													VBP => "01" & X"F",
													VPolSync => '1'
												);
												
				-- 1920x1200 @60Hz ( 193.16 MHz)								
	constant Resolution1920x1200 : VidParameter :=(	
													HLength => X"A20",
													HRes => X"780",		
													HFP => X"80",
													HSyncPulse => X"D0",
													HBP => '1' & X"50",
													HPolSync => '0',
													VLength => X"4DA",
													VRes => X"4B0",
													VFP => X"1",
													VSyncPulse => X"3",
													VBP => "10" & X"6",
													VPolSync => '1'
												);
												
				-- 1920x1440 @60Hz ( 234 MHz)								
	constant Resolution1920x1440 : VidParameter :=(	
													HLength => X"A28",
													HRes => X"780",		
													HFP => X"80",
													HSyncPulse => X"D0",
													HBP => '1' & X"58",
													HPolSync => '0',
													VLength => X"4DA",
													VRes => X"5A0",
													VFP => X"1",
													VSyncPulse => X"3",
													VBP => "11" & X"8",
													VPolSync => '1'
												);
												
end package PackageVideo;

----------------------------------------------------------------------
--						TACHYSSEMA DEVElOPPEMENT					--
--																	--
--		AUTHORS : REAUTE DE NADAILLAC Alexandre (sous la tutelle	--
--		de Nicolas Roddier)											--
--				  													--
--		DESCRIPION DU PRODUIT : Gnrateur de 9 Mires en signal		--
--		vido pour des connecteurs DVI ou HDMI slectionnes par 4	--
--		interrupteur avec possibilit de changer de rsolution		--
--				  													--
--																	--
--	LIEU : TACHYSSEMA DEVELOPPEMENT				DATE: 04/05/2018	--
----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.PackageVideo.all;

---------------------------------------------------------------------
--                                                                 --
--                         ENTITY DECLARATION                      --
--                                                                 --
---------------------------------------------------------------------
entity VideoTiming is
	port(
				-- Common Inputs
				
			Clk			: in std_logic;				--	Pixel frequency in MHz
			SRst 		: in std_logic;				--	Syncronous reset
			
				-- Signal Video
				
			VParam		: in VidParameter;			--	Video Resolution Parameters
			
				-- Counters
			HCounter 	: in std_logic_vector(11 downto 0);
			VCounter 	: in std_logic_vector(10 downto 0);
			
				-- Reste du systme
				
			ExtraTrigs	: out ExtraTriggers;
			TimVid		: out VideoTimingOutput		-- Video Timing Parameters (HSync, VSync, FV, LV DV)
		);
end VideoTiming;

----------------------------------------------------------------------
--                                                                	--
--                       ARCHITECTURE DEFINITION                  	--
--                                                                	--
----------------------------------------------------------------------
architecture Behavioral of VideoTiming is

----------------------------------------------------------------------
-- 						INTERNAL SIGNAL DECLARATIONS:				--
----------------------------------------------------------------------
-- Declaration of internal signals
-- Signals register Counters
signal HCount : std_logic_vector(11 downto 0);
signal VCount : std_logic_vector(10 downto 0);

-- Signals Register some Value
signal HFPD, HFPF, VFPD, VFPF, StockHPSd, StockHPSf, StockVPSd, StockVPSf	: std_logic_vector(11 downto 0);
signal VPHL6, VPVL4, VPVL3, VPVL2, VPVL1									: std_logic_vector(11 downto 0);
signal VPHR6, VPHR3, VPVR3, VPVR2, VPVR1									: std_logic_vector(11 downto 0);
signal VPVSUM																: std_logic_vector(12 downto 0);

-- Different used Triggers for Pipeline
signal THLN4, THLN3, THLN2, THLN1, THLN0, TVLN3, TVLN2, TVLN1, TVLN0		: std_logic;
signal THRN4, THRN3, THRN2, THRN1, TVRN3, TVRN2, TVRN1						: std_logic;
signal TLVN4, TLVN3, TLVN2, TLVN1, TFV2, TFV1, TFV0, TrigFV					: std_logic;
signal THPSd, THPSf, THPS, TVPSd, TVPSf, TVPS, T1VPSd, T1VPSf				: std_logic;

begin

pVideoTiming : process(Clk)
begin
	if rising_edge(Clk) then
		
		if (SRst = '1') then					--	Synchronous Reset
			HCount		<= (others => '0');	VCount		<= (others => '0');
			TimVid		<= VidTimInit;		VPHL6		<= (others => '1');
			VPVL4		<= (others => '1');	VPVL3		<= (others => '1');
			VPVL2		<= (others => '1');	VPVL1		<= (others => '1');
			VPHR6		<= (others => '1');	VPVR3		<= (others => '1');
			VPVR2		<= (others => '1');	VPVR1		<= (others => '1');
			HFPD		<= (others => '0');	HFPF		<= (others => '0');
			VFPD		<= (others => '0');	VFPF		<= (others => '0');
			StockHPSd	<= (others => '1');	StockHPSf	<= (others => '1');
			StockVPSd	<= (others => '1');	StockVPSf	<= (others => '1');
			THLN3		<= '0';				THLN2		<= '0';
			THLN1		<= '0';				THLN0		<= '0';
			TVLN3		<= '0';				TVLN2		<= '0';
			TVLN1		<= '0';				TVLN0		<= '0';
			THRN3		<= '0';				THRN2		<= '0';
			THRN1		<= '0';				TVRN3		<= '0';
			TVRN2		<= '0';				TVRN1		<= '0';
			TLVN4		<= '1';				TLVN3		<= '1';
			TLVN2		<= '1';				TLVN1		<= '1';
			TFV2		<= '1';				TFV1		<= '1';
			TFV0		<= '1';				TrigFV		<= '1';
			THPSd		<= '0';				THPSf		<= '1';
			THPS		<= '0';				T1VPSd		<= '0';
			T1VPSf		<= '0';				TVPSd		<= '0';
			TVPSf		<= '1';				TVPS		<= '0';
		else
			HFPD		<= VParam.HRes + VParam.HFP;	StockHPSd	<= HFPD - 3;
			HFPF		<= HFPD + VParam.HSyncPulse;	StockHPSf	<= HFPF - 3;
			VFPD		<= VParam.VRes + VParam.VFP;	StockVPSd	<= VFPD - 1;
			VFPF		<= VFPD + VParam.VSyncPulse;	StockVPSf	<= VFPF - 1;
			VPHL6		<= VParam.HLength - 6;			VPVL4		<= VParam.VLength - 4;
			VPVL3		<= VParam.VLength - 3;			VPVL2		<= VParam.VLength - 2;
			VPVL1		<= VParam.VLength - 1;			VPHR6		<= VParam.HRes - 6;
			VPVR3		<= VParam.VRes - 3;				VPVR2		<= VParam.VRes - 2;
			VPVR1		<= VParam.VRes - 1;				
			
			HCount <= HCounter;
			VCount <= VCounter;
			
			------------------------------------------------------------------
			--				Triggers Length Vertical and Horizontal			--
			------------------------------------------------------------------
			
			-- Horizontal
			
			if (HCount = VPHL6) then	THLN4		<= '1';
			else						THLN4		<= '0';
			end if;
			
			if (THLN4 = '1') then		THLN3		<= '1';
			else						THLN3		<= '0';
			end if;
			
			if (THLN3 = '1') then		THLN2		<= '1';
			else						THLN2		<= '0';
			end if;
			
			if (THLN2 = '1') then		THLN1		<= '1';
			else						THLN1		<= '0';
			end if;
			
			if (THLN1 = '1') then		THLN0		<= '1';
			else						THLN0		<= '0';
			end if;
			
			-- Vertical
			
			if (VCount = VPVL4) then	TVLN3		<= '1';
			else						TVLN3		<= '0';
			end if;
			
			if (VCount = VPVL3) then	TVLN2		<= '1';
			else						TVLN2		<= '0';
			end if;
			
			if (VCount = VPVL2) then	TVLN1		<= '1';
			else						TVLN1		<= '0';
			end if;
			
			if (VCount = VPVL1) then	TVLN0		<= '1';
			else						TVLN0		<= '0';
			end if;
			
			------------------------------------------------------------------
			--			Triggers Resolution Vertical and Horizontal			--
			------------------------------------------------------------------
			
			-- Horizontal
			
			if (HCount = VPHR6) then	THRN4		<= '1';
			else						THRN4		<= '0';
			end if;
			
			if (THRN4 = '1') then		THRN3		<= '1';
			else						THRN3		<= '0';
			end if;
			
			if (THRN3 = '1') then		THRN2		<= '1';
			else						THRN2		<= '0';
			end if;
			
			if (THRN2 = '1') then		THRN1		<= '1';
			else						THRN1		<= '0';
			end if;
			
			-- Vertical
			
			if (VCount = VPVR3) then	TVRN3		<= '1';
			else						TVRN3		<= '0';
			end if;
			
			if (VCount = VPVR2) then	TVRN2		<= '1';
			else						TVRN2		<= '0';
			end if;
			
			if (VCount = VPVR1) then	TVRN1		<= '1';
			else						TVRN1		<= '0';
			end if;
			
			------------------------------------------------------------------
			--			Triggers Synchronous Pulse Vertical and Horizontal	--
			------------------------------------------------------------------
			
			-- Horizontal
			
			if (HCount =  StockHPSd) then	THPSd		<= '1';
			elsif (THLN1 = '1')	then		THPSd		<= '0';
			end if;
			
			if (HCount = StockHPSf) then	THPSf		<= '0';
			elsif (THLN1 = '1')	then		THPSf		<= '1';
			end if;
			
			if (THPSd = '1' and THPSf = '1') then	THPS		<= '1';
			else									THPS		<= '0';
			end if;
			
			-- Vertical
			
			if (VCount = StockVPSd) then	T1VPSd	<= '1';
			else							T1VPSd	<= '0';
			end if;
			
			if (T1VPSd	= '1' and THLN2 = '1') then	TVPSd		<= '1';
			elsif (TVLN0 = '1')	then				TVPSd		<= '0';
			end if;
			
			if (VCount = StockVPSf) then	T1VPSf	<= '1';
			else							T1VPSf	<= '0';
			end if;
			
			if (T1VPSf	= '1' and THLN2 = '1') then	TVPSf		<= '0';
			elsif (TVLN0 = '1')	then				TVPSf		<= '1';
			end if;
			
			if (TVPSd = '1' and TVPSf = '1') then	TVPS		<= '1';
			else									TVPS		<= '0';
			end if;
			
			------------------------------------------------------------------------------------------------------
			--								Cration des Signaux du Video Timing								--
			------------------------------------------------------------------------------------------------------
			
			-- Cration de T3LV--
			
			if (THLN4 = '1') then		TLVN4		<= '1';
			elsif (THRN4 = '1') then	TLVN4		<= '0';
			else						TLVN4		<= TLVN4;
			end if;
			
			TimVid.T3LV		<= TLVN4;
			
			-- Cration de T2LV--
			
			if (THLN3 = '1') then		TLVN3		<= '1';
			elsif (THRN3 = '1') then	TLVN3		<= '0';
			else						TLVN3		<= TLVN3;
			end if;
			
			TimVid.T2LV		<= TLVN3;
			
			-- Cration de T1LV--
			
			if (THLN2 = '1') then		TLVN2		<= '1';
			elsif (THRN2 = '1') then	TLVN2		<= '0';
			else						TLVN2		<= TLVN2;
			end if;
			
			TimVid.T1LV		<= TLVN2;
			
			-- Cration de LV--
			
			if (THLN1 = '1') then		TLVN1		<= '1';
			elsif (THRN1 = '1') then	TLVN1		<= '0';
			else						TLVN1		<= TLVN1;
			end if;
			
			TimVid.LV		<= TLVN1;
			
			-- Cration de T2FV --
			
			if (TVLN2 = '1' and THLN1 = '1') then		TFV2		<= '1';
			elsif (TVRN3 = '1' and THLN1 = '1') then	TFV2		<= '0';
			else										TFV2		<= TFV2;
			end if;
			
			TimVid.T2FV		<= TFV2;
			
			-- Cration de T1FV --
			
			if (TVLN1 = '1' and THLN1 = '1') then		TFV1		<= '1';
			elsif (TVRN2 = '1' and THLN1 = '1') then	TFV1		<= '0';
			else										TFV1		<= TFV1;
			end if;
			
			TimVid.T1FV		<= TFV1;
			
			-- Cration de TFV --
			
			if (TVLN0 = '1' and THLN2 = '1') then		TFV0		<= '1';
			elsif (TVRN1 = '1' and THLN2 = '1') then	TFV0		<= '0';
			else										TFV0		<= TFV0;
			end if;
			
			TimVid.TFV		<= TFV0;
	
			-- Syncronous Horizontal Pulse
			
			if (THPS = '1') then	TimVid.HSync<=	not(VParam.HPolSync);	-- Deactivate Horizontal Syncronous Pulse
			else					TimVid.HSync<=	VParam.HPolSync;		-- Active (low or up) Horizontal Syncronous Pulse
			end if;
			
			-- Syncronous Vertical Pulse
			
			if (TVPS = '1') then	TimVid.VSync<=	not(VParam.VPolSync);	-- Deactivate Vertical Syncronous Pulse
			else					TimVid.VSync<=	VParam.VPolSync;		-- Active (low or up) Vertical Syncronous Pulse
			end if;
			
			-- Frame validated
			
			if (TVLN0 = '1' and THLN1 = '1') then		TrigFV		<= '1';
			elsif (TVRN1 = '1' and THLN1 = '1') then	TrigFV		<= '0';
			else										TrigFV		<= TFV0;
			end if;
			
			TimVid.FV		<= TrigFV;
	
	
			--	Data validated
			if (TFV0 = '1' and TLVN1 = '1') then	TimVid.DV	<= '1';
			else									TimVid.DV	<= '0';
			end if;
			
			VPVSUM <= ('0' & VPVL1) + VPVR1;
			if (VCount = VPVSUM(12 downto 1)) then	TimVid.SoF		<= TLVN2 and not TLVN3;
			else									TimVid.SoF		<= '0';
			end if;
			
		end if;
	end if;

end process;

ExtraTrigs.T4HLength <= THLN4;
ExtraTrigs.T3HLength <= THLN3;
ExtraTrigs.T2HLength <= THLN2;
ExtraTrigs.T1HLength <= THLN1;
ExtraTrigs.T0HLength <= THLN0;
ExtraTrigs.T4HResolution <= THRN4;
ExtraTrigs.T3HResolution <= THRN3;
ExtraTrigs.T2HResolution <= THRN2;
ExtraTrigs.T1HResolution <= THRN1;
ExtraTrigs.T3VLength <= TVLN3;
ExtraTrigs.T2VLength <= TVLN2;
ExtraTrigs.T1VLength <= TVLN1;
ExtraTrigs.T0VLength <= TVLN0;
ExtraTrigs.T3VResolution <= TVRN3;
ExtraTrigs.T2VResolution <= TVRN2;
ExtraTrigs.T1VResolution <= TVRN1;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---------------------------------------------------------------------
--                                                                 --
--                         ENTITY DECLARATION                      --
--                                                                 --
---------------------------------------------------------------------
entity BarreCode is
	port(
				-- Common Inputs
				
			Clk, Rst		: in std_logic;
			
				-- VideoTiming
			
			TLV, TFV	: in std_logic;
			
			-- DataGenRGB

			Trigger			: in std_logic_vector(1 downto 0);
			
			RGB 			: out std_logic_vector(23 downto 0)		-- Colors
		);
end BarreCode;

----------------------------------------------------------------------
--                                                                	--
--                       ARCHITECTURE DEFINITION                  	--
--                                                                	--
----------------------------------------------------------------------
architecture Behavioral of BarreCode is

begin

pBC : process(Clk)
begin

	if (rising_edge(Clk)) then
		if (Rst = '1') then
			RGB <= (others => '0');
		else
			if (TFV = '1' and TLV = '1') then
				if (Trigger = "01") then
					RGB <= X"000000";
					
				elsif (Trigger = "10") then
					RGB <= X"FFFFFF";
				else
					RGB <= X"777777";
				end if;
			else
				RGB <= (others => '0');
			end if;
		end if;
	end if;

end process;


end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---------------------------------------------------------------------
--                                                                 --
--                         ENTITY DECLARATION                      --
--                                                                 --
---------------------------------------------------------------------
entity ContourBlanc is
	port(
				-- Common Inputs
				
			Clk, Rst	: in std_logic;
			
				-- VideoTiming
			
			DV, TLV, TFV	: in std_logic;
			
				-- DataGenRGB
			
			Trigger			: in std_logic_vector(1 downto 0);
			
				-- Outputs
			
			RGB 			: out std_logic_vector(23 downto 0)			-- Colors
		);
end ContourBlanc;

----------------------------------------------------------------------
--                                                                	--
--                       ARCHITECTURE DEFINITION                  	--
--                                                                	--
----------------------------------------------------------------------
architecture Behavioral of ContourBlanc is

begin

pCB : process(Clk)
begin

	if (rising_edge(Clk)) then
		if (Rst = '1') then
			RGB <= (others => '0');
			
		else					
			if (TFV = '1' and (DV = '1' or TLV = '1')) then
				if (Trigger = "01" or Trigger = "10") then
					RGB <= (others => '1');	
				else
					RGB <=(others => '0');	

				end if;

			else
				RGB <= (others => '0');
			end if;
		end if;
	end if;

end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---------------------------------------------------------------------
--                                                                 --
--                         ENTITY DECLARATION                      --
--                                                                 --
---------------------------------------------------------------------
entity Counters is
	port(
				-- Common Inputs
				
			Clk						: in std_logic;
			SRst 							: in std_logic;				--	Syncronous reset
			
				-- Signal Video
				
			TriggerHCount, TriggerVCount	: in std_logic;				-- Signals who command to the counters to run or start again
			
				-- Outputs
			HCounter 						: out std_logic_vector(11 downto 0);
			VCounter 						: out std_logic_vector(10 downto 0)
		);
end Counters;

----------------------------------------------------------------------
--                                                                	--
--                       ARCHITECTURE DEFINITION                  	--
--                                                                	--
----------------------------------------------------------------------
architecture Behavioral of Counters is

----------------------------------------------------------------------
-- 						INTERNAL SIGNAL DECLARATIONS:				--
----------------------------------------------------------------------
-- Declaration of internal signals
signal HCount																: std_logic_vector(11 downto 0);	--	HCount : Compteur Horizontal allant de 0  4095 en passant par 2600
signal VCount																: std_logic_vector(10 downto 0);	--	Compteur Vertical allant de 0  2047 en passant par 1500
signal StopHCount, StopVCount												: std_logic;

begin

pCounters : process(Clk)
begin
	if rising_edge(Clk) then
		
		if (SRst = '1') then					--	Synchronous Reset
			HCount		<= (others => '0');
			VCount		<= (others => '0');
			StopHCount	<= '0';
			StopVCount	<= '0';
			
		else
			
			------------------------------------------------------------------
			--							Counters							--
			------------------------------------------------------------------
			if (StopHCount = '0') then
				HCount	<= HCount + 1;
			else
				HCount	<= (others => '0');
			end if;	
			
			if (StopVCount = '0') then
				if (StopHCount = '1') then
					VCount	<= VCount + 1;
				else
					VCount	<= VCount;
				end if;
			else
				VCount		<= (others => '0');
			end if;
			------------------------------------------------------------------
			--							Stop Counters						--
			------------------------------------------------------------------
			if (TriggerHCount = '1') then
				StopHCount	<= '1';
			else
				StopHCount	<= '0';
			end if;
			
			if (TriggerVCount = '1' and TriggerHCount = '1') then
				StopVCount	<= '1';
			else
				StopVCount	<= '0';
			end if;
			
		end if;
	end if;

end process;

Hcounter 					<= Hcount;
VCounter 					<= Vcount;

end Behavioral;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

entity DivN is
    generic(N: integer := 8);
    port( 
			Clk				: in STD_LOGIC;
			SRst			: in STD_LOGIC;
			Trg				: in STD_LOGIC;
			--Done			: out STD_LOGIC;
			Busy			: out STD_LOGIC;
			Numerator		: in STD_LOGIC_VECTOR (N-1 downto 0);
			Denominator		: in STD_LOGIC_VECTOR (N-1 downto 0);
			Quotient, Rest	: out STD_LOGIC_VECTOR (N-1 downto 0)
		);
end DivN;

architecture Behavioral of DivN is

signal Q	: std_logic_vector(N*2-1 downto 0);
signal Diff	: std_logic_vector(N     downto 0);
signal Count: integer range 0 to N+1;
	
begin
	Diff <= ('0' & Q(N*2-2 downto N-1)) + not ('0' & Denominator) + '1';
   
	process(Clk)
	begin
		if Rising_edge(Clk) then
			if SRst = '1' then Q <= (others => '0');
			elsif Trg = '1' then Q <= conv_std_logic_vector(0,N) & Numerator;
			elsif Count<N then
				if Diff(N)='1' then
					Q <= Q(N*2-2 downto 0) & '0';
				else
					Q <= Diff(N-1 downto 0) & Q(N-2 downto 0) & '1';
				end if;
			end if;
		end if;
	end process;

	process(Clk)
	begin
		if Rising_edge(Clk) then
			if SRst = '1' then Count <= N+1;
			elsif Trg = '1' then Count <= 0;
			elsif Count<N+1 then
				Count <= Count+1;
			end if;
			
			--if Count=N then Done <= '1'; else Done <= '0'; end if;
		end if;
	end process;
	
	process(Clk)
	begin
		if Rising_edge(Clk) then
			if SRst = '1' then Busy <= '0';
			elsif Trg = '1' then Busy <= '1';
			elsif Count=N then Busy <= '0';
			end if;
			
			if SRst = '1' then Quotient <= (others => '0'); Rest <= (others => '0');
			elsif Count=N then Quotient <= Q(N-1 downto 0); Rest <= Q(N*2-1 downto N);
			end if;
		end if;
	end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---------------------------------------------------------------------
--                                                                 --
--                         ENTITY DECLARATION                      --
--                                                                 --
---------------------------------------------------------------------
entity GreenRed is
	port(
				-- Common Inputs
				
			Clk, Rst		: in std_logic;
			
				-- VideoTiming
			
			DV, TLV, TFV	: in std_logic;
			
			-- DataGenRGB
			
			Trigger			: in std_logic;
			
			-- Outputs
			
			RGB 			: out std_logic_vector(23 downto 0)			-- Colors
		);
end GreenRed;

----------------------------------------------------------------------
--                                                                	--
--                       ARCHITECTURE DEFINITION                  	--
--                                                                	--
----------------------------------------------------------------------
architecture rtl of GreenRed is

begin

pVBM : process(Clk)
begin

	if (rising_edge(Clk)) then
		if (Rst = '1') then
			RGB <= (others => '0');
		else					
			if (TFV = '1' and (DV = '1' or TLV = '1')) then
				if (Trigger = '0') then
					RGB <= X"FF0000";
				--	Rouge/Red
				else
					RGB <= X"00FF00";
				--	Vert/Green
				end if;
			else
				RGB <= (others => '0');
			end if;
		end if;
	end if;

end process;

end rtl;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---------------------------------------------------------------------
--                                                                 --
--                         ENTITY DECLARATION                      --
--                                                                 --
---------------------------------------------------------------------
entity HorizontalBandMire is
	port(
				-- Common Inputs
				
			Clk, Rst	: in std_logic;
			
				-- VideoTiming
			
			TFV		: in std_logic;
			
				-- DataGenRGB
			
			Trigger	: in std_logic_vector(2 downto 0);
			
				-- Outputs
			
			RGB			: out std_logic_vector(23 downto 0)			-- Colors
		);
end HorizontalBandMire;

----------------------------------------------------------------------
--                                                                	--
--                       ARCHITECTURE DEFINITION                  	--
--                                                                	--
----------------------------------------------------------------------
architecture Behavioral of HorizontalBandMire is

begin

pHBM : process(Clk)
begin
	if (rising_edge(Clk)) then
		if (Rst = '1') then
			RGB <= (others => '0');
		else
			if (TFV = '1') then
					
				if (Trigger = "001") then
					RGB <= (others => '1');
				--	Blanc/White
					
				elsif (Trigger = "010") then
					RGB <= X"FFFF00";	
				--	Jaune/Yellow
					
				elsif (Trigger = "011") then
					RGB <= X"00FFFF";	
				--	Cyan
						
				elsif (Trigger = "100") then
					RGB <= X"00FF00";	
				--	Vert/Green
					
				elsif (Trigger = "101") then
					RGB <= X"FF00FF";
				--	Magenta
					
				elsif (Trigger = "110") then
					RGB <= X"FF0000";
				--	Rouge/Red
					
				elsif (Trigger = "111") then
					RGB <= X"0000FF";
				--	Bleu/Blue
					
				else
					RGB <= (others => '0');
					-- Noir/Black
				end if;
			else
				RGB <= (others => '0');
			end if;
		end if;
	end if;


end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---------------------------------------------------------------------
--                                                                 --
--                         ENTITY DECLARATION                      --
--                                                                 --
---------------------------------------------------------------------
entity HorizontalShadesGray is
	port(
				-- Common Inputs
				
			Clk			: in std_logic;
			Rst			: in std_logic;
			
				-- Divs
				
			NHSG		: in std_logic_vector(11 downto 0);
			
				-- VideoTiming
			
			TLV, TFV	: in std_logic;
			
			-- DataGenRGB
			
			DebIn		: in std_logic_vector(11 downto 0);
			Trigger		: in std_logic;
			
			DebOut		: out std_logic_vector(11 downto 0);
			RGB 		: out std_logic_vector(23 downto 0)			-- Colors
		);
end HorizontalShadesGray;

----------------------------------------------------------------------
--                                                                	--
--                       ARCHITECTURE DEFinInITION                  --
--                                                                	--
----------------------------------------------------------------------
architecture Behavioral of HorizontalShadesGray is

----------------------------------------------------------------------
-- 						INTERNAL SIGNAL DECLARATIONS:				--
----------------------------------------------------------------------
-- Declaration of internal signals
signal R, G, B	: std_logic_vector(7 downto 0);
signal Color	: std_logic_vector(3 downto 0);
signal DO		: std_logic_vector(11 downto 0);

begin

pHSG : process(Clk)
begin
	if (rising_edge(Clk)) then
		if (Rst = '1') then
			DO <= NHSG;
			Color	<= (others => '0');
			R		<= (others => '0');
			G		<= (others => '0');
			B		<= (others => '0');
			
		else

			if (TFV = '1') then	
				if (TLV = '1') then
					if (Color = X"F") then
						R	<= X"FF";
						G	<= X"FF";
						B	<= X"FF";
						
					elsif (Trigger = '1') then
						Color	<= Color + 1;
						DO 	<= DebIn + NHSG;
					
					else
						Color	<= Color;
						R		<= Color & X"0";
						G		<= Color & X"0";
						B		<= Color & X"0";
						DO	<= DO;
						
					end if;
				else
					Color		<= Color;
					R			<= X"00";
					G			<= X"00";
					B			<= X"00";
				end if;
			else
				Color			<= X"0";
				R				<= X"00";
				G				<= X"00";
				B				<= X"00";
				DO <= NHSG;
			end if;

		end if;
	end if;

end process;

RGB		<= R&G&B;
DebOut	<= DO;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---------------------------------------------------------------------
--                                                                 --
--                         ENTITY DECLARATION                      --
--                                                                 --
---------------------------------------------------------------------
entity PatchWork is
	port(
				-- Common Inputs
				
			Clk, Rst		: in std_logic;
			
				-- VideoTiming
			
			TLV, TFV		: in std_logic;
			
			-- DataGenRGB

			Trigger1, Trigger2	: in std_logic_vector(2 downto 0);
			
			RGB 				: out std_logic_vector(23 downto 0)			-- Colors
		);
end PatchWork;

----------------------------------------------------------------------
-- Choix des valeurs, correspondent  un VGA 640x480@60 Hz Industry	--
-- standard (pixel clock 25.175 MHz)								--
----------------------------------------------------------------------

----------------------------------------------------------------------
--                                                                	--
--                       ARCHITECTURE DEFINITION                  	--
--                                                                	--
----------------------------------------------------------------------
architecture Behavioral of PatchWork is

begin

pPW : process(Clk)
begin
	if (rising_edge(Clk)) then
		if (Rst = '1') then
			RGB <= (others => '0');
		else
			if (TFV = '1' and TLV = '1') then
						
				-- Premire ligne
				if (Trigger2 = "001") then
					if (Trigger1 = "001") then
						RGB <= (others => '1');
					--	Blanc/White
							
					elsif (Trigger1 = "010") then
						RGB <= X"FFFF00";	
					--	Jaune/Yellow
				
					elsif (Trigger1 = "011") then
						RGB <= X"00FFFF";	
					--	Cyan
					
					elsif (Trigger1 = "100") then
						RGB <= X"00FF00";	
					--	Vert/Green
					
					elsif (Trigger1 = "101") then
						RGB <= X"FF00FF";
					--	Magenta
						
					elsif (Trigger1 = "110") then
						RGB <= X"FF0000";	
					--	Rouge/Red
					
					elsif (Trigger1 = "111") then
						RGB <= X"0000FF";	
					--	Bleu/Blue
					else
						RGB <= (others => '0');	
						-- Noir/Black
				
					end if;
	
				
				-- Deuxime Ligne
				elsif (Trigger2 = "010") then
					if (Trigger1 = "001") then
						RGB <= X"FFFF00";	
					--	Jaune/Yellow
						
					elsif (Trigger1 = "010") then
						RGB <= X"00FFFF";
					--	Cyan
					
					elsif (Trigger1 = "011") then
						RGB <= X"00FF00";	
					--	Vert/Green
						
					elsif (Trigger1 = "100") then
						RGB <= X"FF00FF";
					--	Magenta
					
					elsif (Trigger1 = "101") then
						RGB <= X"FF0000";
					--	Rouge/Red
					
					elsif (Trigger1 = "110") then
						RGB <= X"0000FF";
					--	Bleu/Blue
					
					elsif (Trigger1 = "111") then
						RGB <= (others => '0');
					--	Noir/Black
					else
						RGB <= (others => '1');
						-- Blanc/White
				
					end if;
				
				-- Troisime Ligne
				elsif (Trigger2 = "011") then
					if (Trigger1 = "001") then
						RGB <= X"00FFFF";
					--	Cyan
						
					elsif (Trigger1 = "010") then
						RGB <= X"00FF00";
						--	Vert/Green
					
					elsif (Trigger1 = "011") then
						RGB <= X"FF00FF";	
						--	Magenta
					
					elsif (Trigger1 = "100") then
						RGB <= X"FF0000";
						--	Rouge/Red
						
					elsif (Trigger1 = "101") then
						RGB <= X"0000FF";
						--	Bleu/Blue
					
					elsif (Trigger1 = "110") then
						RGB <= (others => '0');
						--	Noir/Black
					
					elsif (Trigger1 = "111") then
						RGB <= (others => '1');
						-- Blanc/White
					else
						RGB <= X"FFFF00";
						-- Jaune/Yellow
					
					end if;
					
				-- Quatrime Ligne
				elsif (Trigger2 = "100") then
					if (Trigger1 = "001") then
						RGB <= X"00FF00";
					--	Vert/Green
						
					elsif (Trigger1 = "010") then
						RGB <= X"FF00FF";
					--	Magenta
					
					elsif (Trigger1 = "011") then
						RGB <= X"FF0000";
					--	Rouge/Red
					
					elsif (Trigger1 = "100") then
						RGB <= X"0000FF";
					--	Bleu/Blue
					
					elsif (Trigger1 = "101") then
						RGB <= (others => '0');
					--	Noir/Black
					
					elsif (Trigger1 = "110") then
						RGB <= (others => '1');
					--	Blanc/White
					
					elsif (Trigger1 = "111") then
						RGB <= X"FFFF00";
					--	Jaune/Yellow
					else
						RGB <= X"00FFFF";
						-- Cyan
					
					end if;
					
				-- Cinquime Ligne
				elsif (Trigger2 = "101") then
					if (Trigger1 = "001") then
						RGB <= X"FF00FF";
					--	Magenta
						
					elsif (Trigger1 = "010") then
						RGB <= X"FF0000";	
					--	Rouge/Red
				
					elsif (Trigger1 = "011") then
						RGB <= X"0000FF";
					--	Bleu/Blue
					
					elsif (Trigger1 = "100") then
						RGB <= (others => '0');
					--	Noir/Black
					
					elsif (Trigger1 = "101") then
						RGB <= (others => '1');
					--	Blanc/White
						
					elsif (Trigger1 = "110") then
						RGB <= X"FFFF00";
					--	Jaune/Yellow
						
					elsif (Trigger1 = "111") then
						RGB <= X"00FFFF";
					--	Cyan
					else
						RGB <= X"00FF00";
						-- Vert/Green
				
					end if;
				
				-- Sixime Ligne
				elsif (Trigger2 = "110") then
					if (Trigger1 = "001") then
						RGB <= X"FF0000";
					--	Rouge/Red
						
					elsif (Trigger1 = "010") then
						RGB <= X"0000FF";
					--	Bleu/Blue
					
					elsif (Trigger1 = "011") then
						RGB <= (others => '0');
					--	Noir/Black
					
					elsif (Trigger1 = "100") then
						RGB <= (others => '1');
					--	Blanc/White
						
					elsif (Trigger1 = "101") then
						RGB <= X"FFFF00";
						--	Jaune/Yellow
					
					elsif (Trigger1 = "110") then
						RGB <= X"00FFFF";
					--	Cyan
						
					elsif (Trigger1 = "111") then
						RGB <= X"00FF00";
					--	Vert/Green
					else
						RGB <= X"FF00FF";
						-- Magenta
				
					end if;
	
				-- Septime Ligne
				elsif (Trigger2 = "111") then
					if (Trigger1 = "001") then
						RGB <= X"0000FF";
					--	Bleu/Blue
							
					elsif (Trigger1 = "010") then
						RGB <= (others => '0');
					--	Noir/Black
					
					elsif (Trigger1 = "011") then
						RGB <= (others => '1');	
					--	Blanc/White
						
					elsif (Trigger1 = "100") then
						RGB <= X"FFFF00";
					--	Jaune/Yellow
						
					elsif (Trigger1 = "101") then
						RGB <= X"00FFFF";
					--	Cyan
						
					elsif (Trigger1 = "110") then
						RGB <= X"00FF00";
					--	Vert/Green
						
					elsif (Trigger1 = "111") then
						RGB <= X"FF00FF";
					--	Magenta
					else
						RGB <= X"FF0000";
						-- Rouge/Red
					
					end if;
	
					
				--- Huitime Ligne
				else
					if (Trigger1 = "001") then
						RGB <= (others => '0');	
					--	Noir/Black
							
					elsif (Trigger1 = "010") then
						RGB <= (others => '1');
					--	Blanc/White
					
					elsif (Trigger1 = "011") then
						RGB <= X"FFFF00";
					--	Jaune/Yellow
						
					elsif (Trigger1 = "100") then
						RGB <= X"00FFFF";
					--	Cyan
						
					elsif (Trigger1 = "101") then
						RGB <= X"00FF00";
						--	Vert/Green
						
					elsif (Trigger1 = "110") then
						RGB <= X"FF00FF";
						--	Magenta
						
					elsif (Trigger1 = "111") then
						RGB <= X"FF0000";
						--	Rouge/Red
					else
						RGB <= X"0000FF";
						-- Bleu/Blue
					
					end if;
				end if;
			else
				RGB <= (others => '0');
			end if;
		end if;
	end if;


end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---------------------------------------------------------------------
--                                                                 --
--                         ENTITY DECLARATION                      --
--                                                                 --
---------------------------------------------------------------------
entity RectShadesGray is
	port(
				-- Common Inputs
				
			Clk, Rst	: in std_logic;
			
				-- VideoTiming
			
			TLV, TFV	: in std_logic;
			
			-- DataGenRGB
			
			Trigger			: in std_logic_vector(4 downto 0);
			
			-- Outputs
			
			RGB 			: out std_logic_vector(23 downto 0)			-- Colors
		);
end RectShadesGray;

----------------------------------------------------------------------
--                                                                	--
--                       ARCHITECTURE DEFINITION                  	--
--                                                                	--
----------------------------------------------------------------------
architecture Behavioral of RectShadesGray is

begin

p2RSG : process(Clk)
begin
	if (rising_edge(Clk)) then
		if (Rst = '1') then
			RGB <= (others => '0');
			
		else						
			if (TFV = '1') then
				if (TLV = '1') then
					if (Trigger = "00001") then
						RGB <= (others => '0');
						
					elsif (Trigger(3) = '1') then
						if (Trigger(2 downto 0) = "001") then
							RGB <= (others => '0');
							
						elsif (Trigger(2 downto 0) = "010") then
							RGB <= (others => '0');
						
						elsif (Trigger(2 downto 0) = "011") then
							RGB <= X"333333";
							
						elsif (Trigger(2 downto 0) = "100") then
							RGB <= X"666666";
						
						else
							RGB <= (others => '1');
						end if;
						
					elsif (Trigger(4) = '1') then
						if (Trigger(2 downto 0) = "001") then
							RGB <= (others => '0');
							
						elsif (Trigger(2 downto 0) = "010") then
							RGB <= (others => '1');
						
						elsif (Trigger(2 downto 0) = "011") then
							RGB <= X"CCCCCC";
							
						elsif (Trigger(2 downto 0) = "100") then
							RGB <= X"999999";
							
						else
							RGB <= (others => '1');
						end if;
						
					else
						RGB <= (others => '1');
					end if;
				else
					RGB <= (others => '0');
				end if;
			else
				RGB <= (others => '0');
			end if;
		end if;
	end if;

end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---------------------------------------------------------------------
--                                                                 --
--                         ENTITY DECLARATION                      --
--                                                                 --
---------------------------------------------------------------------
entity SwitchBlackWhite is
	port(
				-- Common Inputs
				
			Clk, Rst		: in std_logic;
			
				-- VideoTiming
			
			TLV, TFV, DV	: in std_logic;
			
			-- Outputs
			
			RGB 				: out std_logic_vector(23 downto 0)		-- Colors
		);
end SwitchBlackWhite;

----------------------------------------------------------------------
--                                                                	--
--                       ARCHITECTURE DEFINITION                  	--
--                                                                	--
----------------------------------------------------------------------
architecture Behavioral of SwitchBlackWhite is

----------------------------------------------------------------------
-- 						INTERNAL SIGNAL DECLARATIONS:				--
----------------------------------------------------------------------
-- Declaration of internal signals
signal Count	: std_logic;
signal R, G, B	: std_logic_vector(7 downto 0);
signal DVOld	: std_logic;

begin

pSBW : process(Clk)
begin
	if (rising_edge(Clk)) then
		
		if (Rst = '1') then
		
			Count				<= '0';
			DVOld				<= '0';
			R 					<= (others => '0');
			G 					<= (others => '0');
			B 					<= (others => '0');
			
		else
			DVOld				<= DV;
			
			if (TFV = '1') then

				if (TLV = '1') then
					Count		<= not(Count);
					R 			<= (others => Count);
					G 			<= (others => Count);
					B 			<= (others => Count);

				else
					if (DV = '0' and DVOld = '1') then
						Count	<= not(Count);
					else
						Count	<= Count;
					end if;
					R 			<= (others => '0');
					G 			<= (others => '0');
					B 			<= (others => '0');

				end if;
			else
				Count	 		<= '0';
				R 				<= (others => '0');
				G 				<= (others => '0');
				B 				<= (others => '0');
			end if;
		
		end if;
	end if;

end process;

RGB <= R&G&B;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---------------------------------------------------------------------
--                                                                 --
--                         ENTITY DECLARATION                      --
--                                                                 --
---------------------------------------------------------------------
entity VerticalBandMire is
	port(
				-- Common Inputs
				
			Clk, Rst	: in std_logic;
			
				-- VideoTiming
			
			TLV, TFV		: in std_logic;
			
			-- DataGenRGB
			
			Trigger			: in std_logic_vector(2 downto 0);
			
			-- Outputs
			
			RGB 			: out std_logic_vector(23 downto 0)			-- Colors
		);
end VerticalBandMire;

----------------------------------------------------------------------
--                                                                	--
--                       ARCHITECTURE DEFINITION                  	--
--                                                                	--
----------------------------------------------------------------------
architecture Behavioral of VerticalBandMire is

begin

pVBM : process(Clk)
begin

	if (rising_edge(Clk)) then
		if (Rst = '1') then
			RGB <= (others => '0');
			
		else					
			if (TFV = '1' and TLV = '1') then
				if (Trigger = "001") then
					RGB <= (others => '1');	
				--	Blanc/White
					
				elsif (Trigger = "010") then
					RGB <= X"FFFF00";
				--	Jaune/Yellow
			
				elsif (Trigger = "011") then
					RGB <= X"00FFFF";	
				--	Cyan
				
				elsif (Trigger = "100") then
					RGB	<= X"00FF00";	
				--	Vert/Green
				
				elsif (Trigger = "101") then
					RGB <= X"FF00FF";	
				--	Magenta
				
				elsif (Trigger = "110") then
					RGB <= X"FF0000";
				--	Rouge/Red
				
				elsif (Trigger = "111") then
					RGB <= X"0000FF";
				--	Bleu/Blue

				else
					RGB <= (others => '0');
					-- Noir/Black

				end if;

			else
				RGB <= (others => '0');
			end if;
		end if;
	end if;

end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---------------------------------------------------------------------
--                                                                 --
--                         ENTITY DECLARATION                      --
--                                                                 --
---------------------------------------------------------------------
entity VerticalShadesGray is
	port(
				-- Common Inputs
				
			Clk			: in std_logic;
			Rst			: in std_logic;
			
				-- Divs
				
			NVSG, NVSG2	: in std_logic_vector(11 downto 0);
			
				-- VideoTiming
			
			TLV, TFV	: in std_logic;
			
			-- DataGenRGB
			
			FinIn		: in std_logic_vector(11 downto 0);
			Trigger		: in std_logic;
			
			FinOut		: out std_logic_vector(11 downto 0);
			RGB 		: out std_logic_vector(23 downto 0)		-- Colors
		);
end VerticalShadesGray;

----------------------------------------------------------------------
--                                                                	--
--                       ARCHITECTURE DEFINITION                  	--
--                                                                	--
----------------------------------------------------------------------
architecture Behavioral of VerticalShadesGray is

----------------------------------------------------------------------
-- 						INTERNAL SIGNAL DECLARATIONS:				--
----------------------------------------------------------------------
-- Declaration of internal signals
signal RGBC, RGB1C	: std_logic_vector(23 downto 0);
signal FO			: std_logic_vector(11 downto 0);

begin

pVSG : process(Clk)
begin
	if (rising_edge(Clk)) then
		if (Rst = '1') then
			FO		<= NVSG2;
			RGB1C	<= (others => '0');
			RGBC	<= (others => '0');
		
		else
			RGBC	<= RGB1C;
			if (TFV = '1' and TLV = '1') then
				if (Trigger = '1') then
					RGB1C	<= RGB1C + X"020202";
					FO		<= FinIn + NVSG;
				else
					RGB1C	<= RGB1C;
					FO		<= FO;
				end if;
			
			else
				RGB1C	<= (others => '0');
				FO		<= NVSG2;
				
			end if;

		end if;
	end if;

end process;

RGB 	<= RGBC;
FinOut	<= FO;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.PackageVideo.all;

---------------------------------------------------------------------
--                                                                 --
--                         ENTITY DECLARATION                      --
--                                                                 --
---------------------------------------------------------------------
entity DataGenRGB is
	port(
				-- Common Inputs

			Clk																: in std_logic;						--	PixelClk
			SRst															: in std_logic;						--	synchronous reset
			
			MireChoice														: in std_logic_vector(3 downto 0);	--	Commande quelle fonction on va afficher
			VParam															: in VidParameter;					--	Video Resolution Parameters
			
				-- Divs
			
			NumbVBM, NumbHBM, NumbVSG, NumbHSG, NumbCenterH, NumbCenterV	: in std_logic_vector(11 downto 0);	-- Numbers for the Creation of mires
			
				-- VideoTiming
			
			HCount															: in std_logic_vector(11 downto 0);
			VCount															: in std_logic_vector(10 downto 0);
			FV, TLV, DV, TFV, T1FV, T2LV, T3LV								: in std_logic;

				-- Outputs
			
			RGB																: out std_logic_vector(23 downto 0)	-- Colors
		);
end DataGenRGB;

----------------------------------------------------------------------
--                                                                	--
--                       ARCHITECTURE DEFINITION                  	--
--                                                                	--
----------------------------------------------------------------------
architecture Behavioral of DataGenRGB is

----------------------------------------------------------------------
-- 						INTERNAL SIGNAL DECLARATIONS:				--
----------------------------------------------------------------------
-- Signals Register Counter et VT
signal HCounter, VPHL5																			: std_logic_vector(11 downto 0);
signal VCounter 																				: std_logic_vector(10 downto 0);
signal A, B, C, D, E																			: std_logic_vector(7 downto 0);

-- Declaration of internal signals
signal RGBC0, RGBC1, RGBC2, RGBC3, RGBC4, RGBC5, RGBC6, RGBC7, RGBC8, RGBC9						: std_logic_vector(23 downto 0);
signal LimitResV1																				: std_logic_vector(11 downto 0);
signal DVOld, T2, T3																		: std_logic;

-- Signaux pour VBM
signal TriggerVBM, TVBM																			: std_logic_vector(2 downto 0);
signal NVBM1, NVBM2, NVBM3, NVBM4, NVBM5, NVBM6, NVBM7, NV2, NV3								: std_logic_vector(11 downto 0);	-- Dcomposition de l'cran en 8 bandes Verticales de mme longueur (le plus possible)
signal TVBM1, TVBM2, TVBM3, TVBM4, TVBM5, TVBM6, TVBM7											: std_logic;

-- Signaux pour HBM
signal TriggerHBM, THBM																			: std_logic_vector(2 downto 0);
signal NHBM1, NHBM2, NHBM3, NHBM4, NHBM5, NHBM6, NHBM7, NH2, NH3								: std_logic_vector(11 downto 0);	-- Dcomposition de l'cran en 8 bandes Horizontales de mme longueur (le plus possible)
signal THBM1, THBM2, THBM3, THBM4, THBM5, THBM6, THBM7											: std_logic;

-- signaux pour VSG
signal FinInVSG, FinOutVSG, LimitFinVSG, NumbVSG2												: std_logic_vector(11 downto 0);
signal TriggerVSG, TVSG, TVSGFin																: std_logic;

-- Signaux pour HSG
signal DebInHSG, DebOutHSG, LimitDebHSG															: std_logic_vector(11 downto 0);
signal TriggerHSG, THSG, THSGDeb																: std_logic;

-- Signaux pour BC
signal TriggerBC																				: std_logic_vector(1 downto 0);
signal TriggerB, TriggerW, Trigger10B, Trigger10W, Trigger8B, Trigger8W							: std_logic;
signal Trigger5B, Trigger5W, Trigger2B, Trigger2W, Trigger1B, Trigger1W, T10B, T10W, T5B, T5W	: std_logic;
signal NBCG0, NBCG1, NBCG2, NBCG3, NBCG4, CenterMire, NP101, NP102, NP103, NP51, NP52, NP53		: std_logic_vector(11 downto 0);
signal NBC10B, NBC10W, NBC10G, NBC8G, NBC1G, NBC2G, NBC5B, NBC5W, NBC5G							: std_logic_vector(11 downto 0);
signal i10, i5, Trig1, Trig8, Trig2, T101, T102, T103, T104, T51, T52, T53, T54					: std_logic;
signal k10																						: integer range 0 to 4;
signal k5																						: integer range 0 to 5;
signal en10, en5, p10, p5, C2																	: std_logic_vector(1 downto 0);
signal C8																						: std_logic_vector(3 downto 0);
signal C1																						: std_logic;

-- Signaux pour 2RSG

signal Trigger2RSG																				: std_logic_vector(4 downto 0);
signal TriggerBlocRect, TBR, T1BR																: std_logic_vector(2 downto 0);
signal TriggerDownUp, TDU																		: std_logic_vector(1 downto 0);
signal TriggerVContour, TriggerVContour1, TriggerVContour2, TriggerVContour3, TriggerVContour4	: std_logic;
signal TriggerHContour, TriggerContour, THCont, TVC1, TVC2, TVC3, TVC4, TDU1, TDU2, TDU3, TDU4	: std_logic;
signal THContDeb, THContFin, TBR1, TBR2, TBR3, TBR4, T1VC4										: std_logic;
signal NBR0, NBR0N1, NBR0N2, NBR1, NBR1P1, NBR1P2												: std_logic_vector(11 downto 0);
signal NVCont1h2d, NVConthdh, NVCont2h1d, NVCont3h, NVCont1d2h, NVContdhd, NVCont2d1h, NVCont3d	: std_logic_vector(11 downto 0);

-- Signaux pour ContourBlanc
signal TriggerContourBlanc																		: std_logic_vector(1 downto 0);
signal TrigVCBb, TrigVCBh																		: std_logic;

-- signaux pour GreenRed
signal HCenter																					: std_logic_vector(11 downto 0);
signal TriggerGR, TGR, T1GR, T2GR																: std_logic;

-- autres signaux
signal RisedgeT3LV, FaledgeT3LV, RisedgeT2LV, FaledgeT2LV, RisedgeTLV, FaledgeTLV				: std_logic;

begin

RisedgeT3LV	<=	'1' when T3LV = '1' and T2LV = '0' else
				'0';
				
FaledgeT3LV	<=	'1' when T3LV = '0' and T2LV = '1' else
				'0';
				
RisedgeT2LV	<=	'1' when T2LV = '1' and TLV = '0' else
				'0';
				
FaledgeT2LV	<=	'1' when T2LV = '0' and TLV = '1' else
				'0';
				
RisedgeTLV	<=	'1' when TLV = '1' and DV = '0' else
				'0';
				
FaledgeTLV	<=	'1' when TLV = '0' and DV = '1' else
				'0';

pDataGenRGB : process(Clk)
begin

	if (rising_edge(Clk)) then
	
		if (SRst = '1') then
			HCounter<= (others => '0');	VCounter<= (others => '0');	A	<= (others => '0');	B		<= (others => '0');
			C		<= (others => '0');	D		<= (others => '0');	E	<= (others => '0');	VPHL5	<= (others => '1');
			
			DVOld	<= '0';	T2	<= '0';	T3	<= '0';
			
			LimitResV1	<= (others => '1');
			
			TriggerVBM	<= "001";			TVBM	<= "001";
			TVBM1		<= '0';				TVBM2	<= '0';				TVBM3	<= '0';				TVBM4	<= '0';
			TVBM5		<= '0';				TVBM6	<= '0';				TVBM7	<= '0';				NVBM1	<= (others => '1');	
			NVBM2		<= (others => '1');	NVBM3	<= (others => '1');	NVBM4	<= (others => '1');	NVBM5	<= (others => '1');
			NVBM6		<= (others => '1');	NVBM7	<= (others => '1');	NV2		<= (others => '1');	NV3		<= (others => '1');
			
			TriggerHBM	<= "001";			THBM	<= "000";
			THBM1		<= '0';				THBM2	<= '0';				THBM3	<= '0';				THBM4	<= '0';
			THBM5		<= '0';				THBM6	<= '0';				THBM7	<= '0';				NHBM1	<= (others => '1');
			NHBM2		<= (others => '1');	NHBM3	<= (others => '1');	NHBM4	<= (others => '1');	NHBM5	<= (others => '1');
			NHBM6		<= (others => '1');	NHBM7	<= (others => '1');	NH2		<= (others => '1');	NH3		<= (others => '1');
			
			TriggerVSG	<= '0';				TVSG		<= '0';				TVSGFin		<= '0';
			FinOutVSG	<= (others => '0');	LimitFinVSG	<= (others => '1');	NumbVSG2	<= (others => '1');
			
			TriggerHSG	<= '0';				THSG		<= '0';	THSGDeb		<= '0';
			DebOutHSG 	<= (others => '0');	LimitDebHSG	<= (others => '1');
			
			Trigger2RSG		<= "00000";			TriggerBlocRect	<= "000";
			TBR				<= "000";			T1BR			<= "000";
			TBR1			<= '0';				TBR2			<= '0';				TBR3			<= '0';	TBR4			<= '0';
			TriggerDownUp	<= "00";			TDU				<= "00";
			TDU1			<= '0';				TDU2			<= '0';				TDU3			<= '0';	TDU4			<= '0';
			TriggerVContour1<= '0';				TriggerVContour2<= '0';				TriggerVContour3<= '0';	TriggerVContour4<= '0';
			TVC1			<= '0';				TVC2			<= '0';				TVC3			<= '0';	TVC4			<= '0';
			T1VC4			<= '0';				TriggerVContour	<= '0';				TriggerHContour	<= '0';	THContDeb		<= '0';
			THContFin		<= '0';				THCont			<= '0';				TriggerContour	<= '0';
			NBR0			<= (others => '1');	NBR0N1			<= (others => '1');	NBR0N2			<= (others => '1');
			NBR1			<= (others => '1'); NBR1P1			<= (others => '1');	NBR1P2			<= (others => '1');
			NVCont1h2d		<= (others => '1');	NVConthdh		<= (others => '1');	NVCont2h1d		<= (others => '1');
			NVCont3h		<= (others => '1');	NVCont1d2h		<= (others => '1');	NVContdhd		<= (others => '1');
			NVCont2d1h		<= (others => '1');	NVCont3d		<= (others => '1');
			
			TriggerBC	<= "00";			Trigger10B	<= '0';				Trigger10W	<= '0';
			T101		<= '0';				T102		<= '0';				T103		<= '0';
			T104		<= '0';				T51			<= '0';				T52			<= '0';
			T53			<= '0';				T54			<= '0';				Trigger8B	<= '0';
			Trigger8W	<= '0';				Trigger5B	<= '0';				Trigger5W	<= '0';
			Trigger2B	<= '0';				Trigger2W	<= '0';				Trigger1B	<= '0';
			Trigger1W	<= '0';				TriggerW	<= '0';				TriggerB	<= '0';
			NBCG0		<= (others => '1');	NBCG1		<= (others => '1');	NBCG2		<= (others => '1');
			NBCG3		<= (others => '1');	NBCG4		<= (others => '1');	NBC10B		<= (others => '1');
			NBC10W		<= (others => '1');	NBC10G		<= (others => '1');	NBC8G		<= (others => '1');
			NBC5G		<= (others => '1');	NBC5B		<= (others => '1');	NBC5W		<= (others => '1');
			k10			<= 1;				k5			<= 1;				i10			<= '0';
			i5			<= '0';				en10		<= "00";			en5			<= "00";
			p10			<= "00";			p5			<= "00";			NBC2G		<= (others => '1');
			NBC1G		<= (others => '1');	Trig1		<= '0';				Trig2		<= '0';
			Trig8		<= '0';				C1			<= '0';				C2			<= "00";
			C8			<= X"0";			NP101		<= (others => '1');	NP102		<= (others => '1');
			NP103		<= (others => '1');	NP51		<= (others => '1');	NP52		<= (others => '1');
			NP53		<= (others => '1');	T10B		<= '0';				T10W		<= '0';
			T5B			<= '0';				T5W			<= '0';				CenterMire	<= (others => '1');
			
			TriggerContourBlanc	<= "01";	TrigVCBb	<= '0';	TrigVCBh	<= '1';
			
			TriggerGR	<= '0';	TGR <= '0';	T1GR <= '0';	HCenter	<= (others => '1');
			T2GR		<= '0';
			
		else		
			HCounter	<= HCount;	VCounter	<= VCount;
			DVOld		<= DV;
			VPHL5		<= VParam.HLength - 5;
			
			-- Nombres pour VBM
			
			NV2	<= NumbVBM + NumbVBM;	NV3	<= NumbVBM + NumbVBM + NumbVBM;
			
			NVBM1	<= NumbVBM - 4;		NVBM2	<= NV2 - 4;
			NVBM3	<= NV3 - 4;			NVBM4	<= NVBM1 + NV3;
			NVBM5	<= NVBM3 + NV2;		NVBM6	<= NVBM4 + NV2;
			NVBM7	<= NVBM4 + NV3;
			
			-- Nombres pour HBM
			
			NH2	<= NumbHBM + NumbHBM;	NH3	<= NumbHBM + NumbHBM + NumbHBM;
			
			NHBM1	<= NumbHBM - 1;		NHBM2	<= NH2 - 1;
			NHBM3	<= NH3 - 1;			NHBM4	<= NHBM1 + NH3;
			NHBM5	<= NHBM3 + NH2;		NHBM6	<= NHBM4 + NH2;
			NHBM7	<= NHBM4 + NH3;		
			
			-- Nombres pour VSG
			
			FinOutVSG	<= FinInVSG;
			LimitFinVSG	<= FinInVSG - 10;	NumbVSG2	<= NumbVSG + NumbVSG;
			
			-- Nombres pour HSG
			
			DebOutHSG	<= DebInHSG;
			LimitDebHSG	<= DebInHSG - 1;
			
			
			-- Nombres pour BC
			
			CenterMire <= NumbCenterH - 320;
			A <= conv_std_logic_vector(181 - 2, A'length);	B <= conv_std_logic_vector(80 + 10, B'length);
			C <= conv_std_logic_vector(64 + 10, C'length);	D <= conv_std_logic_vector(50 + 10, D'length);
			E <= conv_std_logic_vector(20 + 10, E'length);
			
			NBCG0	<= CenterMire + A;	NBCG1	<= NBCG0 + B;
			NBCG2	<= NBCG1 + C;		NBCG3	<= NBCG2 + D;
			NBCG4	<= NBCG3 + E;
			
			NP101 <= NBCG0 - 3;		NP102 <= NBC10B - 3;	NP103 <= NBC10W - 3;
			
			NP51 <= NBCG2 - 3;		NP52 <= NBC5B - 3;		NP53 <= NBC5W - 3;
			
			if (HCounter = NP101) then		p10 <= "01";
			elsif (HCounter = NP102) then	p10 <= "10";
			elsif (HCounter = NP103) then	p10 <= "11";
			else							p10 <= "00";
			end if;
			
			if (p10 = "01") then	i10 <= '1';
									en10 <= "00";				
			elsif (p10 = "10") then	i10 <= '0';
									en10 <= "01";		
			elsif (p10 = "11") then	en10 <= "10";
			else					i10 <= i10;
									en10 <= "00";
			end if;
				
			if (i10 = '1') then
				NBC10W	<= NBCG0 + 10;
				NBC10B	<= NBCG0 + 20;
			else
				if (T3LV = '1' and DV = '0') then
					k10 <= 1;
				elsif (k10 = 4) then
					NBC10G <= NBC10W + 10;
				else
					if (en10 = "01") then		NBC10W	<= NBC10W + 20;
												NBC10B	<= NBC10B;
												k10		<= k10 + 1;
					elsif (en10 = "10") then	NBC10B	<= NBC10B + 20;
												NBC10W	<= NBC10W;
					else						NBC10B	<= NBC10B;
												NBC10W	<= NBC10W;
					end if;
				end if;
			end if;
			
			NBC8G <= NBCG1 + 64;
			
			if (HCounter = NP51) then		p5 <= "01";
			elsif (HCounter = NP52) then	p5 <= "10";
			elsif (HCounter = NP53) then	p5 <= "11";
			else							p5 <= "00";
			end if;
			
			if (p5 = "01") then				i5	<= '1';
											en5 <= "00";
			elsif (p5 = "10") then			i5	<= '0';
											en5 <= "01";
			elsif (p5 = "11") then			en5 <= "10";
			else							i5	<= i5;
											en5 <= "00";
			end if;
				
			if (i5 = '1') then
				NBC5W	<= NBCG2 + 5;
				NBC5B	<= NBCG2 + 10;
			else
				if (T3LV = '1' and DV = '0') then
					k5 <= 1;
				elsif (k5 = 5) then
					NBC5G <= NBC5W + 5;
				else
					if (en5 = "01") then	NBC5W	<= NBC5W + 10;
											NBC5B	<= NBC5B;
											k5		<= k5 + 1;
					elsif (en5 = "10") then	NBC5B	<= NBC5B + 10;
											NBC5W	<= NBC5W;
					else					NBC5B	<= NBC5B;
											NBC5W	<= NBC5W;
					end if;
				end if;
			end if;
			
			NBC2G <= NBCG3 + 20;	NBC1G <= NBCG4 + 21;
			
			-- Nombres pour 2RSG
			
			NBR0N2	<= NBR0 - 55;			NBR0N1	<= NBR0 - 50;
			NBR0	<= NumbCenterH - 31;	NBR1	<= NumbCenterH + 19;
			NBR1P1	<= NBR1 + 50;			NBR1P2	<= NBR1 + 55;
			
			NVCont1h2d	<= NumbCenterV - 32;	
			NVConthdh	<= NumbCenterV - 37;	-- NVCont1h2d moins 5
			NVCont2h1d	<= NumbCenterV - 87;	-- NVCont1h2d moins 55
			NVCont3h	<= NumbCenterV - 92;	-- NVCont1h2d moins 60
			
			NVCont1d2h	<= NumbCenterV + 28;
			NVContdhd	<= NumbCenterV + 33;	-- NVCont1d2h plus 5
			NVCont2d1h	<= NumbCenterV + 83;	-- NVCont1d2h plus 55
			NVCont3d	<= NumbCenterV + 88;	-- NVCont1d2h plus 60
			
			-- Contour Blanc
			
			LimitResV1	<= VParam.VRes - 2;
			
			------------------------------------------------------------------
			--							Triggers							--
			------------------------------------------------------------------
			if (Hcounter = VPHL5) then	T3 <= '1';
			else						T3 <= '0';
			end if;
			
			if (T3 = '1') then			T2 <= '1';
			else						T2 <= '0';
			end if;
			
			----------------------------------
			--				VBM				--
			----------------------------------
			if (HCounter = NVBM1) then	TVBM1 <= '1';
			else						TVBM1 <= '0';
			end if;
			
			if (HCounter = NVBM2) then	TVBM2 <= '1';
			else						TVBM2 <= '0';
			end if;
			
			if (HCounter = NVBM3) then	TVBM3 <= '1';
			else						TVBM3 <= '0';
			end if;
			
			if (HCounter = NVBM4) then	TVBM4 <= '1';
			else						TVBM4 <= '0';
			end if;
			
			if (HCounter = NVBM5) then	TVBM5 <= '1';
			else						TVBM5 <= '0';
			end if;
			
			if (HCounter = NVBM6) then	TVBM6 <= '1';
			else						TVBM6 <= '0';
			end if;
			
			if (HCounter = NVBM7) then	TVBM7 <= '1';
			else						TVBM7 <= '0';
			end if;
			
			if (T2 = '1') then			TVBM	<= "001";
			elsif (TVBM1 = '1') then	TVBM	<= "010";
			elsif (TVBM2 = '1') then	TVBM	<= "011";
			elsif (TVBM3 = '1') then	TVBM	<= "100";
			elsif (TVBM4 = '1') then	TVBM	<= "101";
			elsif (TVBM5 = '1') then	TVBM	<= "110";
			elsif (TVBM6 = '1') then	TVBM	<= "111";
			elsif (TVBM7 = '1') then	TVBM	<= "000";
			else						TVBM	<= TVBM;
			end if;
			
			TriggerVBM	<= TVBM;
			
			----------------------------------
			--				HBM				--
			----------------------------------
			
			if (VCounter = NHBM1) then	THBM1 <= '1';
			else						THBM1 <= '0';
			end if;
			
			if (VCounter = NHBM2) then	THBM2 <= '1';
			else						THBM2 <= '0';
			end if;
			
			if (VCounter = NHBM3) then	THBM3 <= '1';
			else						THBM3 <= '0';
			end if;
			
			if (VCounter = NHBM4) then	THBM4 <= '1';
			else						THBM4 <= '0';
			end if;
			
			if (VCounter = NHBM5) then	THBM5 <= '1';
			else						THBM5 <= '0';
			end if;
			
			if (VCounter = NHBM6) then	THBM6 <= '1';
			else						THBM6 <= '0';
			end if;
			
			if (VCounter = NHBM7) then	THBM7 <= '1';
			else						THBM7 <= '0';
			end if;
			
			if (THBM1 = '1' and T2 = '1') then		THBM <= "001";
			elsif (THBM2 = '1' and T2 = '1') then	THBM <= "010";
			elsif (THBM3 = '1' and T2 = '1') then	THBM <= "011";
			elsif (THBM4 = '1' and T2 = '1') then	THBM <= "100";
			elsif (THBM5 = '1' and T2 = '1') then	THBM <= "101";
			elsif (THBM6 = '1' and T2 = '1') then	THBM <= "110";
			elsif (THBM7 = '1' and T2 = '1') then	THBM <= "111";
			else									THBM <= "000";
			end if;
			
			if (T1FV = '1' and FV = '0') then		TriggerHBM <= "001";
			elsif (THBM = "001") then				TriggerHBM <= "010";
			elsif (THBM = "010") then				TriggerHBM <= "011";
			elsif (THBM = "011") then				TriggerHBM <= "100";
			elsif (THBM = "100") then				TriggerHBM <= "101";
			elsif (THBM = "101") then				TriggerHBM <= "110";
			elsif (THBM = "110") then				TriggerHBM <= "111";
			elsif (THBM = "111") then				TriggerHBM <= "000";
			else									TriggerHBM <= TriggerHBM;
			end if;
			
			----------------------------------
			--				VSG				--
			----------------------------------
			
			if (HCounter = LimitFinVSG) then	TVSGFin <= '1';
			else								TVSGFin	<= '0';
			end if;
			
			if (T3 = '1') then			TVSG	<= '0';
			elsif (TVSGFin = '1') then	TVSG	<= '1';
			else						TVSG	<= '0';
			end if;
			
			TriggerVSG <= TVSG;
			
			----------------------------------
			--				HSG				--
			----------------------------------
			if (VCounter = LimitDebHSG) then	THSGDeb <= '1';
			else								THSGDeb	<= '0';
			end if;
			
			if (THSGDeb = '1' and T2 = '1') then	THSG <= '1';
			else									THSG <= '0';
			end if;
			
			TriggerHSG <= THSG;
			
			----------------------------------
			--  		Barre Code			--
			----------------------------------
			
			-- TriggerBlack
			
			if (HCounter = NBCG0) then	T101 <= '1';
			else						T101 <= '0';
			end if;
			
			if (HCounter = NBC10W) then	T102 <= '1';
			else						T102 <= '0';
			end if;
			
			if (HCounter = NBC10B) then	T103 <= '1';
			else						T103 <= '0';
			end if;
			
			if (HCounter = NBC10G) then	T104 <= '1';
			else						T104 <= '0';
			end if;
			
			if (T101 = '1') then		T10B <= '1';
										T10W <= '0';
			elsif (T102 = '1') then		T10B <= '0';
										T10W <= '1';
			elsif (T103 = '1') then		T10B <= '1';
										T10W <= '0';
			elsif (T104 = '1') then		T10B <= '0';
										T10W <= '0';
			else						T10B <= T10B;
										T10W <= T10W;
			end if;
			
			Trigger10B <= T10B;
			Trigger10W <= T10W;
			
			if (HCounter = NBCG1) then		Trig8 <= '1';
			elsif (HCounter = NBC8G) then	Trig8 <= '0';
			else							Trig8 <= Trig8;
			end if;
			
			if (Trig8 = '1') then	C8 <= C8 + 1;
			else					C8 <= X"0";
			end if;
			
			if (Trig8 = '1') then	Trigger8B <= not(C8(3));
									Trigger8W <= C8(3);
			else					Trigger8B <= '0';
									Trigger8W <= '0';
			end if;
			
			if (HCounter = NBCG2) then	T51 <= '1';
			else						T51 <= '0';
			end if;
			
			if (HCounter = NBC5W) then	T52 <= '1';
			else						T52 <= '0';
			end if;
			
			if (HCounter = NBC5B) then	T53 <= '1';
			else						T53 <= '0';
			end if;
			
			if (HCounter = NBC5G) then	T54 <= '1';
			else						T54 <= '0';
			end if;
			
			if (T51 = '1') then		T5B <= '1';
									T5W <= '0';
			elsif (T52 = '1') then	T5B <= '0';
									T5W <= '1';
			elsif (T53 = '1') then	T5B <= '1';
									T5W <= '0';
			elsif (T54 = '1') then	T5B <= '0';
									T5W <= '0';
			else					T5B <= T5B;
									T5W <= T5W;
			end if;
			
			Trigger5B <= T5B;
			Trigger5W <= T5W;
			
			if (HCounter = NBCG3) then		Trig2 <= '1';
			elsif (HCounter = NBC2G) then	Trig2 <= '0';
			else							Trig2 <= Trig2;
			end if;
			
			if (Trig2 = '1') then	C2 <= C2 + 1;
			else					C2 <= "00";
			end if;
			
			if (Trig2 = '1') then	Trigger2B <= not(C2(1));
									Trigger2W <= C2(1);
			else					Trigger2B <= '0';
									Trigger2W <= '0';
			end if;
			
			if (HCounter = NBCG4) then		Trig1 <= '1';
			elsif (HCounter = NBC1G) then	Trig1 <= '0';
			else							Trig1 <= Trig1;
			end if;
			
			if (Trig1 = '1') then	C1 <= not(C1);
			else					C1 <= '0';
			end if;
			
			if (Trig1 = '1') then	Trigger1B <= not(C1);
									Trigger1W <= C1;
			else					Trigger1B <= '0';
									Trigger1W <= '0';
			end if;
			
			-- TriggerBlack/White
			
			TriggerB <= Trigger10B or Trigger8B or Trigger5B or Trigger2B or Trigger1B;
			TriggerW <= Trigger10W or Trigger8W or Trigger5W or Trigger2W or Trigger1W;
			
			--	Trigger pour le cas BarreCode
			if (TriggerB = '1') then	TriggerBC <= "01";
			elsif (TriggerW = '1') then	TriggerBC <= "10";
			else						TriggerBC <= "00";
			end if;
			
			------------------------------
			--			2RSG			--
			------------------------------
			
			-- Triggers pour Trigger2RSG
			
			if (VCounter = NVCont3h) then		TVC1 <= '1';
			elsif (VCounter = NVCont2h1d) then	TVC1 <= '0';
			else								TVC1 <= TVC1;
			end if;
			
			TriggerVContour1 <= TVC1;
			
			if (VCounter = NVConthdh) then		TVC2 <= '1';
			elsif (VCounter = NVCont1h2d) then	TVC2 <= '0';
			else								TVC2 <= TVC2;
			end if;
			
			TriggerVContour2 <= TVC2;
			
			if (VCounter = NVCont1d2h) then		TVC3 <= '1';
			elsif (VCounter = NVContdhd) then	TVC3<= '0';
			else								TVC3 <= TVC3;
			end if;
			
			TriggerVContour3 <= TVC3;
			
			if (VCounter = NVCont2d1h) then		T1VC4 <= '1';
			elsif (VCounter = NVCont3d) then	T1VC4 <= '0';
			else								T1VC4 <= T1VC4;
			end if;
			
			TVC4	<= T1VC4;
			TriggerVContour4 <= TVC4;
			
			TriggerVContour <= TriggerVContour1 or TriggerVContour2 or TriggerVContour3 or TriggerVContour4;
			
			if (HCounter = NBR0N2) then	THContDeb <= '1';
			else						THContDeb <= '0';
			end if;
			
			if (HCounter = NBR1P2) then	THContFin <= '1';
			else						THContFin <= '0';
			end if;
			
			if (THContDeb = '1') then		THCont <= '1';
			elsif (THContFin = '1') then	THCont	<= '0';
			else							THCont <= THCont;
			end if;
			
			TriggerHContour <= THCont;
			
			TriggerContour <= TriggerVContour and TriggerHContour;
			
			if (VCounter = NVCont2h1d) then	TDU1 <= '1';
			else							TDU1 <= '0';
			end if;
			
			if (VCounter = NVConthdh) then	TDU2 <= '1';
			else							TDU2 <= '0';
			end if;
			
			if (VCounter = NVContdhd) then	TDU3 <= '1';
			else							TDU3 <= '0';
			end if;
			
			if (VCounter = NVCont2d1h) then	TDU4 <= '1';
			else							TDU4 <= '0';
			end if;
			
			if (TDU1 = '1') then	TDU <= "01";
			elsif (TDU2 = '1') then	TDU <= "00";
			elsif (TDU3 = '1') then	TDU <= "10";
			elsif (TDU4 = '1') then	TDU <= "00";
			else					TDU <= TDU;
			end if;
			
			TriggerDownUp <= TDU;
			
			if (HCounter = NBR0N1) then	TBR1 <= '1';
			else						TBR1 <= '0';
			end if;
			
			if (HCounter = NBR0) then	TBR2 <= '1';
			else						TBR2 <= '0';
			end if;
			
			if (HCounter = NBR1) then	TBR3 <= '1';
			else						TBR3 <= '0';
			end if;
			
			if (HCounter = NBR1P1) then	TBR4 <= '1';
			else						TBR4 <= '0';
			end if;
			
			if (THContDeb = '1') then		T1BR <= "001";
			elsif (TBR1 = '1') then			T1BR <= "010";
			elsif (TBR2 = '1') then			T1BR <= "011";
			elsif (TBR3 = '1') then			T1BR <= "100";
			elsif (TBR4 = '1') then			T1BR <= "001";
			elsif (THContFin = '1') then	T1BR <= "000";
			else							T1BR <= T1BR;
			end if;
			
			TBR <= T1BR;
			TriggerBlocRect <= TBR;
			
			-- Trigger pour le cas 2RSG
			
			if (TriggerContour = '1') then		Trigger2RSG <= "00001";
			elsif (TriggerDownUp /= "00") then	Trigger2RSG <= TriggerDownUp & TriggerBlocRect;
			else								Trigger2RSG <= (others => '0');
			end if;
			
			------------------------------
			--			CB				--
			------------------------------
			if (VCounter = LimitResV1 and RisedgeTLV = '1') then	TrigVCBb <= '1';
			elsif (FV = '0') then									TrigVCBb <= '0';
			else													TrigVCBb <= TrigVCBb;
			end if;
			
			if ((unsigned(VCounter) = 0) or (T1FV = '1' and TFV = '0')) then	TrigVCBh <= '1';
			else																TrigVCBh <= '0';
			end if;
			
			if (TrigVCBh = '1' or TrigVCBb = '1') then				TriggerContourBlanc <= "01";
			elsif (RisedgeT2LV = '1' or FaledgeT3LV = '1') then		TriggerContourBlanc <= "10";
			else													TriggerContourBlanc <= "00";											
			end if;
			
			------------------------------
			--			GreenRed		--
			------------------------------
			
			HCenter <= NumbCenterH - 4;
			
			if (HCounter = HCenter) then		T1GR	<= '1';
			elsif (HCounter = VParam.HRes) then	T1GR	<= '0';
			else								T1GR	<= T1GR;
			end if;
			
			if (T1GR = '1') then	TGR <= '1';
			else					TGR <= '0';
			end if;
						
			if (RisedgeT2LV = '1') then	TriggerGR <= '1';
			elsif (TGR = '1') then		TriggerGR <= '0';
			else						TriggerGR <= TriggerGR;
			end if;
			
		end if;
	end if;
	
end process;

	-- Generateurs de Mire
VBM : entity work.VerticalBandMire
	port map(
				Clk		=> Clk,	Rst		=> SRst,		TLV		=> TLV,
				TFV		=> TFV,	Trigger	=> TriggerVBM,	RGB		=> RGBC0
			);

HBM : entity work.HorizontalBandMire
	port map(
				Clk		=> Clk,			Rst		=> SRst,	TFV		=> TFV,
				Trigger	=> TriggerHBM,	RGB		=> RGBC1
			);

BlocVSG : entity work.VerticalShadesGray
	port map(
				Clk		=> Clk,			Rst		=> SRst,		NVSG	=> NumbVSG,
				NVSG2	=> NumbVSG2,	TLV		=> TLV,			TFV		=> TFV,
				FinIn	=> FinOutVSG,	Trigger	=> TriggerVSG,
				FinOut	=> FinInVSG,	RGB		=> RGBC2
			);

HSG : entity work.HorizontalShadesGray
	port map(
				Clk		=> Clk,			Rst		=> SRst,		NHSG	=> NumbHSG,
				TLV		=> TLV,			TFV		=> TFV,
				DebIn	=> DebOutHSG,	Trigger	=> TriggerHSG,
				DebOut	=> DebInHSG,	RGB		=> RGBC3
			);

PW : entity work.PatchWork
	port map(
				Clk		=> Clk,	Rst		=> SRst,		TLV		=> TLV,
				TFV		=> TFV,	Trigger1=> TriggerVBM,	Trigger2=> TriggerHBM,
				RGB		=> RGBC4
			);

BC : entity work.BarreCode
	port map(
				Clk		=> Clk,	Rst		=> SRst,		TLV		=> TLV,
				TFV		=> TFV,	Trigger	=> TriggerBC,	RGB		=> RGBC5
			);

SBW : entity work.SwitchBlackWhite
	port map(
				Clk		=> Clk,	Rst		=> SRst,	TLV		=> TLV,
				TFV		=> TFV,	DV		=> DV,		RGB		=> RGBC6
			);

TwoRSG : entity work.RectShadesGray
	port map(
				Clk		=> Clk,	Rst		=> SRst,		TLV		=> TLV,
				TFV		=> TFV,	Trigger	=> Trigger2RSG,	RGB		=> RGBC7
			);
			
CB : entity work.ContourBlanc
	port map(
				Clk		=> Clk,	Rst		=> SRst, DV		=> DV,	TLV		=> TLV,
				TFV		=> TFV,	Trigger	=> TriggerContourBlanc,	RGB		=> RGBC8
			);

GR : entity work.GreenRed
	port map(
				Clk		=> Clk,	Rst		=> SRst,		DV		=> DV,	TLV	=> TLV,
				TFV		=> TFV,	Trigger	=> TriggerGR,	RGB		=> RGBC9
			);
			
RGB	<=	RGBC0 when MireChoice = X"0" else
		RGBC1 when MireChoice = X"1" else
		RGBC2 when MireChoice = X"2" else
		RGBC3 when MireChoice = X"3" else
		RGBC4 when MireChoice = X"4" else
		RGBC5 when MireChoice = X"5" else
		RGBC6 when MireChoice = X"6" else
		RGBC7 when MireChoice = X"7" else
		RGBC8 when MireChoice = X"8" else
		RGBC9 when MireChoice = X"9" else
		X"000000";

end Behavioral;

----------------------------------------------------------------------
--						TACHYSSEMA DEVElOPPEMENT					--
--																	--
--		AUTHORS : REAUTE DE NADAILLAC Alexandre (sous la tutelle	--
--		de Nicolas Roddier)											--
--				  													--
--		DESCRIPION DU PRODUIT : Gnrateur de 9 Mires en signal		--
--		vido pour des connecteurs DVI ou HDMI slectionnes par 4	--
--		interrupteur avec possibilit de changer de rsolution		--
--				  													--
--																	--
--	LIEU : TACHYSSEMA DEVELOPPEMENT				DATE: 04/05/2018	--
----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.PackageVideo.all;

---------------------------------------------------------------------
--                                                                 --
--                         ENTITY DECLARATION                      --
--                                                                 --
---------------------------------------------------------------------
entity GenVideoMain is
	port(
				-- Common Inputs
				
			PxlClk, SRst		: in std_logic;
				
			MireChoice			: in std_logic_vector(3 downto 0);		--	Commande quelle mire on va afficher  l'cran
			ResolutionChoice	: in std_logic;							--	Interrupteur permettant de changer de rsolutiion (ici il signale au gnratuer qu'on a chang
																		--	de rsolution et donc il doit refaire les calculs pour adapter les mires  la rsolution)
			VParam				: in VidParameter;						--	Signal regroupant tous les paramtres important de la vido (cf PackageVido)
			
			-- Main Outputs
			
			PinData				: out std_logic_vector(23 downto 0);	--	Donne sous forme (ici) RGB : R (23 downto 16), G (15 downto 8), B (7 downto 0)
			PinTimVid			: out VideoTimingOutput;
			
			-- Triggers Supplmentaires pouvant tre utile pour d'autres blocs
			
			PinExtraTrigs		: out ExtraTriggers;
			
			-- Synchronous reset Output to initialize the other blocks after this block (if needed)
			
			SROut				: out std_logic							
		);
end GenVideoMain;

----------------------------------------------------------------------
--                                                                	--
--                       ARCHITECTURE DEFINITION                  	--
--                                                                	--
----------------------------------------------------------------------
architecture Behavioral of GenVideoMain is

----------------------------------------------------------------------
-- 						INTERNAL SIGNAL DECLARATIONS	:			--
----------------------------------------------------------------------
-- Declaration of internal signals connecting blocks
signal Rst, RstOld1, RstOld2, Reset												: std_logic;
signal TimVidC																	: VideoTimingOutput;
signal RGBC																		: std_logic_vector(23 downto 0);

signal Switch, Trg, Start														: std_logic;

signal NumberVBM, NumberHBM, NumberVSG, NumberHSG, NumberCenterH, NumberCenterV	: std_logic_vector(11 downto 0);
signal Busy, BusyNVSG, BusyNHSG, Busy1											: std_logic;

signal CountH																	: std_logic_vector(11 downto 0);
signal CountV																	: std_logic_vector(10 downto 0);
signal ExtraTrigs																: ExtraTriggers;

begin
			
Rst <= SRst;

pRst : process(PxlClk)								-- Proceessus prolongeant le reset tant que les calculs de Rsolution pour adapter les mires  la rsolution choisie
begin												-- et cration du Signal Busy qui interrompe la gnration des signaux vido tant que les calculs d'adaptation des mires ne sont pas effectus
	if rising_edge(PxlClk) then
		if (Rst = '1') then
			RstOld1 <= '1';	RstOld2 <= '1';
			Busy	<= '1';	Busy1	<= '1';
			Switch	<= '0';
		else
			RstOld1 <= Rst;						RstOld2 <= RstOld1;
			Busy1	<= BusyNVSG or BusyNHSG;	Busy	<= Busy1;
			Switch	<= ResolutionChoice;			-- Permet de dtecter un front montant ou descendant de ResolutionChoice
		end if;
	end if;
end process;

Trg	<=	'1' when Switch /= ResolutionChoice else	-- Signal qui s'active quand il y a un changement de valeur de ResolutionChoice
		'0';

Start	<= Trg or RstOld2; 							-- Signal permettant de lancer les calculs d'adaptatiion des mires  la rsolution choisie

	-- Calcul du nombre de pixels entre chaque couleur pour la rsolution choisie de la Mire  Bandes Verticales (WYCGMRBBl)
pNbVBM : process(PxlClk)
begin
	if (PxlClk'event and PxlClk = '1') then
		if (Rst = '1') then
			NumberVBM <= (others => '0');
		else
			NumberVBM <= "000" & VParam.HRes(11 downto 3);
		end if;
	end if;
end process;

	-- Calcul du nombre de pixels entre chaque couleur pour la rsolution choisie de la Mire  Bandes Horizontales (WYCGMRBBl)
pNbHBM : process(PxlClk)
begin
	if (PxlClk'event and PxlClk = '1') then
		if (Rst = '1') then
			NumberHBM <= (others => '0');
		else
			NumberHBM <= "000" & VParam.VRes(11 downto 3);
		end if;
	end if;
end process;

NVSG : entity work.DivN								-- Calcul du nombre de pixels entre chaque couleur pour la rsolution choisie du dgrad de gris vertical
	generic map	(
					N		=> VParam.HRes'length
				)
	port map(
				Clk			=> PxlClk,		SRst		=> Rst,
				Trg			=> Start,		--Done		=> DoneNVSG,
				Busy		=> BusyNVSG,	Numerator	=> VParam.HRes,
				Denominator	=> X"080",		Quotient	=> NumberVSG,
				Rest		=> open
			);
			
NHSG : entity work.DivN								-- Calcul du nombre de pixels entre chaque couleur pour la rsolution choisie du dgrad de gris horizontal
	generic map	(
					N		=> VParam.VRes'length
				)
	port map(
				Clk			=> PxlClk,		SRst		=> Rst,
				Trg			=> Start,		--Done		=> DoneNHSG,
				Busy		=> BusyNHSG,	Numerator	=> VParam.VRes,
				Denominator	=> X"010",		Quotient	=> NumberHSG,
				Rest		=> open
			);
			
	-- Calcul du centre de la rsolution horizontale pour centrer certaines Mires
pNbCH : process(PxlClk)
begin
	if (PxlClk'event and PxlClk = '1') then
		if (Rst = '1') then
			NumberCenterH <= (others => '0');
		else
			NumberCenterH <= '0' & VParam.HRes(11 downto 1);
		end if;
	end if;
end process;
			
	-- Calcul du centre de la rsolution verticale pour centrer certaines Mires
pNbCV : process(PxlClk)
begin
	if (PxlClk'event and PxlClk = '1') then
		if (Rst = '1') then
			NumberCenterV <= (others => '0');
		else
			NumberCenterV <= '0' & VParam.VRes(11 downto 1);
		end if;
	end if;
end process;

Reset <= Rst or Busy;

TimingVideo : entity work.VideoTiming				-- Cration des signaux de synchronisations pour le signal vido
	port map(
				Clk				=> PxlClk,	SRst			=> Reset,
				VParam			=> VParam,	HCounter		=> CountH,
				VCounter		=> CountV,	ExtraTrigs		=> ExtraTrigs,
				TimVid			=> TimVidC
			);

Compteurs : entity work.Counters					-- Compteur permettant de gnrer les signaux de synchronisation et du gnrateur de donnes des mires RGB
	port map(
				Clk				=> PxlClk,	SRst	=> Reset,
				TriggerHCount	=> ExtraTrigs.T2HLength,
				TriggerVCount	=> ExtraTrigs.T0VLength,
				HCounter		=> CountH,	VCounter=> CountV
			);

Data_Generator_RGB : entity work.DataGenRGB			-- Gnrateur de donnes des mires sous forme RGB
	port map(
				Clk			=> PxlClk,			SRst		=> Reset,
				MireChoice	=> MireChoice,		VParam		=> VParam,
				NumbVBM		=> NumberVBM,		NumbHBM		=> NumberHBM,
				NumbVSG		=> NumberVSG,		NumbHSG		=> NumberHSG,
				NumbCenterH	=> NumberCenterH,	NumbCenterV	=> NumberCenterV,
				HCount		=> CountH,			VCount		=> CountV,
				DV			=> TimVidC.DV,		FV			=> TimVidC.FV,
				TLV			=> TimVidC.T1LV,	TFV			=> TimVidC.TFV,
				T1FV		=> TimVidC.T1FV,	T2LV		=> TimVidC.T2LV,
				T3LV		=> TimVidC.T3LV,	RGB			=> PinData
			);
			
SROut			<= Reset;
PinExtraTrigs	<= ExtraTrigs;
PinTimVid		<= TimVidC;

end Behavioral;


