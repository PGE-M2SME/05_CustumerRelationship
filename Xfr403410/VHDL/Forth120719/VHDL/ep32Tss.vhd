-- ****************************************************************
-- *               150nm Extreme Temperarture Radiation           *
-- *                    Hardened SOC ASIC Project                 *
-- *==============================================================*
-- * FPGA Project:        32-Bit CPU in Altera SOPC Builder       *
-- * File:                ep32.vhd                                *
-- * Author:              C.H.Ting                                *
-- * Description:         ep32 CPU Block                          *
-- *                                                              *
-- * Revision History:                                            *
-- * Date         By Who        Modification                      *
-- * 06/06/05     C.H. Ting     Convert EP24 to 32-bits.          *
-- * 06/10/05     Robyn King    Made compatible with Altera SOPC  *
-- *                            Builder.                          *
-- * 06/27/05     C.H. Ting     Removed Line Drawing Engine.      *
-- * 07/27/05     Robyn King    Cleaned up code.                  *
-- * 08/07/10     C. H. Ting    Return to eP32p                   *
-- * 11/18/10     Chen-Hanson Ting Port to LatticeXP2 Brevia Kit  *
-- * 12/02/21     Nicolas Roddier Modify ITs                      *
-- ****************************************************************
 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_unsigned.all;


entity ep32 is 
	generic(width: integer := 32);
  port(
    -- input port
    clk:            in      std_logic;
    SRst:           in      std_logic;
    interrupt:      in      std_logic;
    data_i:         in      std_logic_vector(31 downto 0);
    intack:         out     std_logic;
    read:           out     std_logic;
    write:          out     std_logic;
    addr:           out     std_logic_vector(31 downto 0);
    data_o:     out     std_logic_vector(31 downto 0);
    Monitor:     out     std_logic_vector(5 downto 0)
  );
end entity ep32;

architecture behavioral of ep32 is

	type stack is array(31 downto 0) of std_logic_vector(width downto 0);
	signal s_stack,r_stack: stack;
    attribute syn_ramstyle : string;
    attribute syn_ramstyle of s_stack,r_stack : signal is "distributed";

	signal slot: integer range 0 to 5;
	signal sp,sp1,rp,rp1: std_logic_vector(7 downto 0); 
	signal t,s,sum: std_logic_vector(width downto 0);
	signal a,r: std_logic_vector(width downto 0);
	signal t_in,r_in,a_in: std_logic_vector(width downto 0);
	signal code: std_logic_vector(5 downto 0);
	signal t_sel: std_logic_vector(3 downto 0);
	signal p_sel: std_logic_vector(1 downto 0);	
	signal a_sel: std_logic_vector(2 downto 0);
	signal r_sel: std_logic_vector(1 downto 0);
	signal addr_sel: std_logic;
	signal spush,spopp,rpush,rpopp,inten,intload,intset,
		tload,rload,aload,pload,iload,reset,z: std_logic;
	signal r_z,int_z: std_logic;
	signal i,p,p_in: std_logic_vector(width-1 downto 0);
  
  -- machine instructions selected by code

	constant bra : std_logic_vector(5 downto 0) :="000000";
	constant ret : std_logic_vector(5 downto 0) :="000001";
	constant bz  : std_logic_vector(5 downto 0) :="000010";
	constant bc  : std_logic_vector(5 downto 0) :="000011";

	constant call: std_logic_vector(5 downto 0) :="000100";
	constant nxt : std_logic_vector(5 downto 0) :="000101";
	constant ei  : std_logic_vector(5 downto 0) :="000110";
	constant di  : std_logic_vector(5 downto 0) :="000111";

	constant ldp : std_logic_vector(5 downto 0) :="001001";
	constant ldi : std_logic_vector(5 downto 0) :="001010";
	constant ld  : std_logic_vector(5 downto 0) :="001011";

	constant stp : std_logic_vector(5 downto 0) :="001101";
	constant rr8 : std_logic_vector(5 downto 0) :="001110";
	constant st  : std_logic_vector(5 downto 0) :="001111";

	constant com : std_logic_vector(5 downto 0) :="010000";
	constant shl : std_logic_vector(5 downto 0) :="010001";
	constant shr : std_logic_vector(5 downto 0) :="010010";
	constant mul : std_logic_vector(5 downto 0) :="010011";

	constant xorr: std_logic_vector(5 downto 0) :="010100";
	constant andd: std_logic_vector(5 downto 0) :="010101";
	constant div : std_logic_vector(5 downto 0) :="010110";
	constant addd: std_logic_vector(5 downto 0) :="010111";

	constant popr: std_logic_vector(5 downto 0) :="011000";
	constant lda : std_logic_vector(5 downto 0) :="011001";
	constant dup : std_logic_vector(5 downto 0) :="011010";
	constant over: std_logic_vector(5 downto 0) :="011011";

	constant pushr: std_logic_vector(5 downto 0) :="011100";
	constant sta : std_logic_vector(5 downto 0) :="011101";
	constant nop : std_logic_vector(5 downto 0) :="011110";
	constant drop: std_logic_vector(5 downto 0) :="011111";

-- mux to t register, selected by t_sel
	constant not_t: std_logic_vector :="0000";
	constant s_xor_t: std_logic_vector :="0001";
	constant s_and_t: std_logic_vector :="0010";
	constant s_or_t: std_logic_vector :="0011";
	constant sum_t: std_logic_vector :="0100";
	constant shr_sum: std_logic_vector :="0101";
	constant shr_t: std_logic_vector :="0110";
	constant shr_t_t: std_logic_vector :="0111";
	constant shl_sum_a_t: std_logic_vector :="1000";
	constant shl_t_a_t: std_logic_vector :="1001";
	constant shl_t: std_logic_vector :="1010";
	constant s_t: std_logic_vector :="1011";
	constant a_t: std_logic_vector :="1100";
	constant r_t: std_logic_vector :="1101";
	constant data_t: std_logic_vector :="1110";
	constant rr8_t: std_logic_vector :="1111";

-- mux to a register, selected by a_sel
	constant t_a: std_logic_vector :="001";
	constant a1_a: std_logic_vector :="010";
	constant shr_sum_a: std_logic_vector :="011";
	constant shr_t_a: std_logic_vector :="100";
	constant shl_sum_a: std_logic_vector :="101";

-- mux to r register, selected by r_sel
	constant rout_r: std_logic_vector :="00";
	constant t_r: std_logic_vector :="01";
	constant r1_r: std_logic_vector :="10";
	constant p_r: std_logic_vector :="11";

-- mux to p register, selected by p_sel
	constant pi_p: std_logic_vector :="00";
	constant p1_p: std_logic_vector :="01";
	constant r_p: std_logic_vector :="10";
	constant int_p: std_logic_vector :="11";

-- mux to memory bus, selected by addr_sel
	constant p_addr: std_logic :='0';
	constant a_addr: std_logic :='1';

begin

Monitor(0) <= '1' when ((slot=0) and (int_z='1') and (inten='1')) else '0';
Monitor(1) <= intload;
Monitor(2) <= inten;
Monitor(3) <= intset;
Monitor(4) <= int_z;
Monitor(5) <= '0';

intack <= '1' when ((slot=0) and (int_z='1') and (inten='1')) else '0';

	data_o<= t(width-1 downto 0);
--	intack <= inten;			
	s <= s_stack(conv_integer(sp));
	
	sum <= (('0'&t(width-1 downto 0)) + ('0'&s(width-1 downto 0)));

	with t_sel select
	t_in <= (not t) when not_t,
		(t xor s) when s_xor_t,
		(t and s) when s_and_t,
		sum when sum_t,
		(t(width-1 downto 0) & '0') when shl_t,
		(t(width-1 downto 0) & a(width-1)) when shl_t_a_t,
		(sum(width-1 downto 0) & a(width-1)) when shl_sum_a_t,
		('0'&sum(width downto 1)) when shr_sum,
		('0'&t(width-1)&t(width-1 downto 1)) when shr_t,
		("00"&t(width-1 downto 1)) when shr_t_t,
		s when s_t,
		a when a_t,
		r when r_t,
		t(width)&t(7 downto 0)&t(width-1 downto 8) when rr8_t, 
		'0'&data_i(width-1 downto 0) when others;

	with slot select
	code <= i(29 downto 24) when 1,
		i(23 downto 18) when 2,
		i(17 downto 12) when 3,
		i(11 downto 6) when 4,
		i(5 downto 0) when 5,
		nop when others;
--	icode <= code;
	
	with a_sel select
	a_in <= a+1 when a1_a ,
		('0'&t(0)&a(width-1 downto 1)) when shr_t_a ,
		('0'&sum(0)&a(width-1 downto 1)) when shr_sum_a ,
		('0'&a(width-2 downto 0)&sum(width)) when shl_sum_a ,
		t when others;

	with r_sel select
	r_in <= r-1 when r1_r ,
		'0'&p when p_r ,
		r_stack(conv_integer(rp)) when rout_r ,
		t when others;

	with p_sel select
	p_in <= (p(width-1 downto width-8) & i(width-9 downto 0)) when pi_p ,
		r(width-1 downto 0) when r_p ,
--		("000000000000000000000000000"&interrupt(4 downto 0)) when int_p ,
		("000000000000000000000000000"&"0000"&interrupt) when int_p ,
		p+1 when others;

	with addr_sel select
	addr <= a(width-1 downto 0) when a_addr ,
		p(width-1 downto 0) when others;

	z <= not(t(width-1) or t(30) or t(29) or t(28)
		or t(27) or t(26) or t(25) or t(24)
		or t(23) or t(22) or t(21) or t(20)		
		or t(19) or t(18) or t(17) or t(16)
		or t(15) or t(14) or t(13) or t(12)
		or t(11) or t(10) or t(9) or t(8)
		or t(7) or t(6) or t(5) or t(4)
		or t(3) or t(2) or t(1) or t(0));

	r_z <= not(r(width-1) or r(30) or r(29) or r(28)
		or r(27) or r(26) or r(25) or r(24)
		or r(23) or r(22) or r(21) or r(20)
		or r(19) or r(18) or r(17) or r(16)
		or r(15) or r(14) or r(13) or r(12)
		or r(11) or r(10) or r(9) or r(8)
		or r(7) or r(6) or r(5) or r(4)
		or r(3) or r(2) or r(1) or r(0));

	int_z <= interrupt;
--	int_z <= interrupt(0) or interrupt(1) or interrupt(2)
--        	or interrupt(3) or interrupt(4) ;

pSetItEn: process (Clk)
begin
  if Clk'event and Clk='1' then
    if SRst = '1' then
      intset <= '0';
    elsif ((slot /= 0) and (code = di)) then
      intset <= '0';
    elsif ((slot /= 0) and (code = ei)) then
      intset <= '1';
    end if;
  end if;
end process pSetItEn;


  -- sequential assignments, with slot and code
	decode: process(code,a,z,r_z,int_z,t,slot,sum,inten) begin
		t_sel<="0000"; 
		a_sel<="000";
		p_sel<="00";
		r_sel<="00";
		addr_sel<='0'; 
		spush<='0'; 
		spopp<='0';
		rpush<='0'; 
		rpopp<='0'; 
		tload<='0'; 
		aload<='0';
		pload<='0'; 
		rload<='0'; 
		write<='0'; 
		read<='0'; 
		iload<='0';
		reset<='0';
		intload<='0';
--		intset<='0';

	if slot=0 then
		if (int_z='1' and inten='1') then
			pload<='1';
			p_sel<=int_p;--process interrupts
			rpush<='1'; 
			r_sel<=p_r;
			rload<='1';
			reset<='1';		
		else	
            iload<='1';
			p_sel<=p1_p;--fetch next word
			pload<='1';
		    read<='1'; 
		end if;
	else
	case code is
		when bra =>
			pload<='1';
			p_sel<=pi_p;
			reset<='1';
		when ret => pload<='1'; 
			p_sel<=r_p;
			rpopp<='1';
			r_sel<=rout_r;
			rload<='1';
			reset<='1';
--			intset<='0';
			intload<='1';
		when bz => 
			if z='1' then
				pload<='1';
				p_sel<=pi_p;
			end if;
			tload<='1';
			t_sel<=s_t; 
			spopp<='1'; 
			reset<='1';
		when bc => 
			if t(width)='1' then
				pload<='1';
				p_sel<=pi_p;
			end if;
			tload<='1';
			t_sel<=s_t; 
			spopp<='1'; 
			reset<='1';
		when call =>
			pload<='1';
			p_sel<=pi_p;--process call
			rpush<='1'; 
			r_sel<=p_r;
			rload<='1';
			reset<='1';			
		when nxt => 
			if r_z='0' then
				p_sel<=pi_p;
				pload<='1';
				r_sel<=r1_r;
			else 	
				r_sel<=rout_r;
				rpopp<='1';
			end if;
			rload<='1';
			reset<='1';
		when ei =>
--			intset<='1';
			intload<='1';
		when ldp => addr_sel<=a_addr; 
			a_sel<=a1_a;
			aload<='1'; 
			tload<='1';
			t_sel<=data_t; 
			spush<='1'; 
		    read<='1'; 
		when ldi => pload<='1'; 
			p_sel<=p1_p;
			tload<='1';
			t_sel<=data_t; 
			spush<='1'; 
		    read<='1'; 
		when ld => addr_sel<=a_addr; 
			tload<='1';
			t_sel<=data_t; 
			spush<='1'; 
		    read<='1'; 
		when stp => addr_sel<=a_addr; 
			aload<='1'; 
			a_sel<=a1_a;
			tload<='1';
			t_sel<=s_t; 
			spopp<='1'; 
			write<='1'; 
		when st => addr_sel<=a_addr; 
			tload<='1';
			t_sel<=s_t; 
			spopp<='1'; 
			write<='1'; 
		when rr8 => 
			tload<='1';
			t_sel<=rr8_t; 
		when com => 
			tload<='1';
			t_sel<=not_t; 
		when shl => 
			tload<='1';
			t_sel<=shl_t; 
		when shr => 
			tload<='1';
			t_sel<=shr_t; 
		when mul => 
			aload<='1';
			tload<='1';
			if a(0)='1' then
				t_sel<=shr_sum;
				a_sel<=shr_sum_a;
			else	t_sel<=shr_t_t;
				a_sel<=shr_t_a;
			end if;
		when xorr => 
			tload<='1';
			t_sel<=s_xor_t; 
			spopp<='1';
		when andd => 
			tload<='1';
			t_sel<=s_and_t; 
			spopp<='1';
		when div => 
			aload<='1';
			tload<='1';
			a_sel<=shl_sum_a;
			if sum(width)='1' then
				t_sel<=shl_sum_a_t;
			else	t_sel<=shl_t_a_t;
			end if;
		when addd => 
			tload<='1';
			t_sel<=sum_t; 
			spopp<='1';
		when popr => 
			tload<='1';
			t_sel<=r_t; 
			spush<='1';
			r_sel<=rout_r;
			rload<='1';
			rpopp<='1';
		when lda => 
			tload<='1';
			t_sel<=a_t; 
			spush<='1';
		when dup => 
			spush<='1';
		when over => 
			spush<='1';
			tload<='1';
			t_sel<=s_t;
		when pushr => 
			tload<='1';
			t_sel<=s_t; 
			rpush<='1';
			r_sel<=t_r;
			rload<='1';
			spopp<='1';
		when sta => 
			tload<='1';
			t_sel<=s_t; 
			a_sel<=t_a;
			aload<='1'; 
			spopp<='1';
		when nop => reset<='1';
		when drop => 
			tload<='1';
			t_sel<=s_t; 
			spopp<='1';
		when others => null;
	end case;
	end if;
	end process decode;

-- finite state machine, processor control unit	
	sync: process(clk) begin
	  if (clk'event and clk='1') then
		if SRst='1' then -- master reset
			inten <='0';
			slot <= 0;
			sp  <= "00000000";
			sp1 <= "00000001";
			rp  <= "00000000";
			rp1 <= "00000001";
			t <= (others => '0');
			r <= (others => '0');			
			a <= (others => '0');
			p <= (others => '0');
			i <= (others => '0');
			for ii in s_stack'range loop
				s_stack(ii) <= (others => '0');
				r_stack(ii) <= (others => '0');
			end loop;
		else
			if reset='1' or slot=5 then
				slot <= 0;
			else	slot <= slot+1;
			end if;
			if intload='1' then
				inten <= intset;
			end if;
			if iload='1' then
				i <= data_i(width-1 downto 0);
			end if;
			if pload='1' then
				p <= p_in;
			end if;
			if tload='1' then
				t <= t_in;
			end if;
			if rload='1' then
				r <= r_in;
			end if;
			if aload='1' then
				a <= a_in;
			end if;
			if spush='1' then
				s_stack(conv_integer(sp1)) <= t;
				sp <= sp+1;
				sp1 <= sp1+1;
			elsif spopp='1' then
				sp <= sp-1;
				sp1 <= sp1-1;
			end if;
			if rpush='1' then
				r_stack(conv_integer(rp1)) <= r;
				rp <= rp+1;
				rp1 <= rp1+1;
			elsif rpopp='1' then
				rp <= rp-1;
				rp1 <= rp1-1;
			end if;
		end if;
	  end if;
	end process sync;

end behavioral;
