LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.math_real.all;

ENTITY adder IS
	GENERIC( N : INTEGER := 32); --parallelism
	PORT(
		A, B : IN UNSIGNED (N-1 DOWNTO 0); --INPUT OPERANDS
		Cin : IN STD_LOGIC; --INPUT CARRY
		OUTPUT : OUT UNSIGNED (N-1 DOWNTO 0); --OUTPUT OPERANDS 
		Cout : OUT STD_LOGIC; -- OUTPUT CARRY
		OV : OUT STD_LOGIC); -- overflow flag
END ENTITY adder;

--Ripple Carry Adder
ARCHITECTURE RCA OF adder IS
SIGNAL C : STD_LOGIC_VECTOR (N DOWNTO 0);
SIGNAL P, G : STD_LOGIC_VECTOR (N-1 DOWNTO 0);

BEGIN
C(0) <= Cin;
Cout <= C(N);
g1: FOR i IN 0 to N-1 GENERATE
		G(i) <= A(i) AND B(i);
		P(i) <= A(i) XOR B(i);
		C(i+1) <= G(i) OR (P(i) AND C(i));
		OUTPUT(i) <= P(i) XOR C(i);
	END GENERATE;
OV <= C(N) XOR C(N-1);
END ARCHITECTURE;

--Combinational adder based on Kogge Stone architecture
ARCHITECTURE KS OF adder IS --WORKS ONLY WITH N=32!!!
SIGNAL C_fast : STD_LOGIC_VECTOR (N DOWNTO 0);
SIGNAL P_L0, G_L0 : STD_LOGIC_VECTOR (N-1 DOWNTO 0);
SIGNAL P_L1, G_L1 : STD_LOGIC_VECTOR (N-1 DOWNTO 1);
SIGNAL P_L2, G_L2 : STD_LOGIC_VECTOR (N-1 DOWNTO 3);
SIGNAL P_L3, G_L3 : STD_LOGIC_VECTOR (N-1 DOWNTO 7);
SIGNAL P_L4, G_L4 : STD_LOGIC_VECTOR (N-1 DOWNTO 15);
SIGNAL P_L5, G_L5 : STD_LOGIC_VECTOR (N-1 DOWNTO 31);


BEGIN
C_fast(0) <= Cin;
Cout <= C_fast(N);
S0: FOR i IN 0 to N-1 GENERATE
		G_L0(i) <= A(i) AND B(i);
		P_L0(i) <= A(i) XOR B(i);
	END GENERATE;

S1: FOR i IN 0 to N-1 GENERATE
	S1_LOW:	IF i=0 GENERATE
				C_fast(i+1) <= G_L0(i) OR (C_fast(i) AND P_L0(i));
			END GENERATE S1_LOW;
	S1_UP:  IF i>=1 GENERATE 
			P_L1(i) <= P_L0(i) AND P_L0(i-1);
			G_L1(i) <= G_L0(i) OR (G_L0(i-1) AND P_L0(i));
			END GENERATE S1_UP;
	END GENERATE S1;
	
S2: FOR i IN 1 to N-1 GENERATE
	S2_LOW:	IF i<=2 AND i>=1 GENERATE
				C_fast(i+1) <= G_L1(i) OR (C_fast(i-1) AND P_L1(i));
			END GENERATE S2_LOW;
	S2_UP:  IF i>=3 GENERATE 
			P_L2(i) <= P_L1(i) AND P_L1(i-2);
			G_L2(i) <= G_L1(i) OR (G_L1(i-2) AND P_L1(i));
			END GENERATE S2_UP;
	END GENERATE S2;
	
S3: FOR i IN 3 to N-1 GENERATE
	S3_LOW:	IF i<=6 AND i>=3 GENERATE
				C_fast(i+1) <= G_L2(i) OR (C_fast(i-3) AND P_L2(i));
			END GENERATE S3_LOW;
	S3_UP:  IF i>=7 GENERATE 
			P_L3(i) <= P_L2(i) AND P_L2(i-4);
			G_L3(i) <= G_L2(i) OR (G_L2(i-4) AND P_L2(i));
			END GENERATE S3_UP;
	END GENERATE S3;
	
S4: FOR i IN 7 to N-1 GENERATE
	S4_LOW:	IF i<=14 AND i>=7 GENERATE
				C_fast(i+1) <= G_L3(i) OR (C_fast(i-7) AND P_L3(i));
			END GENERATE S4_LOW;
	S4_UP:  IF i>=15 GENERATE 
			P_L4(i) <= P_L3(i) AND P_L3(i-8);
			G_L4(i) <= G_L3(i) OR (G_L3(i-8) AND P_L3(i));
			END GENERATE S4_UP;
	END GENERATE S4;
	
S5: FOR i IN 15 to N-1 GENERATE
	S5_LOW:	IF i<=30 AND i>=15 GENERATE
				C_fast(i+1) <= G_L4(i) OR (C_fast(i-15) AND P_L4(i));
			END GENERATE S5_LOW;
	S5_UP:  IF i>=31 GENERATE 
			P_L5(i) <= P_L4(i) AND P_L4(i-16);
			G_L5(i) <= G_L4(i) OR (G_L4(i-16) AND P_L4(i));
			END GENERATE S5_UP;
	END GENERATE S5;
C_fast(N) <= G_L5(N-1) OR (C_fast(N-32) AND P_L5(N-1));
SUM: FOR i IN 0 to N-1 GENERATE
		OUTPUT(i) <= C_fast(i) XOR P_L0(i);
	END GENERATE SUM;
OV <= C_fast(N) XOR C_fast(N-1);
END ARCHITECTURE;

-- Carry Select Adder, linear progression, blocks of 4 bits made with RCA adders
ARCHITECTURE CSA_linear OF adder IS
SIGNAL C_0, C_1 : STD_LOGIC_VECTOR (N DOWNTO 5);
SIGNAL OUTPUT_0, OUTPUT_1 : STD_LOGIC_VECTOR (N-1 DOWNTO 4);
SIGNAL C : STD_LOGIC_VECTOR (N DOWNTO 0);
SIGNAL P, G, OUTPUT_int : STD_LOGIC_VECTOR (N-1 DOWNTO 0);

BEGIN
C(0) <= Cin;
Cout <= C(N);
g0: FOR i IN 0 to N-1 GENERATE
		G(i) <= A(i) AND B(i);
		P(i) <= A(i) XOR B(i);
	END GENERATE g0;
g1: FOR i IN 0 to 3 GENERATE
		C(i+1) <= G(i) OR (P(i) AND C(i));
		OUTPUT_int(i) <= P(i) XOR C(i);
	END GENERATE g1;
g2: FOR i IN 4 to N-1 GENERATE
	g2_first:	IF (i REM 4 = 0) GENERATE
					C_1(i+1) <= G(i) OR P(i);
					OUTPUT_1(i) <= NOT P(i);
					C_0(i+1) <= G(i);
					OUTPUT_0(i) <= P(i);
					OUTPUT_int(i+3 DOWNTO i) <= OUTPUT_0(i+3 DOWNTO i) WHEN C(i) = '0' ELSE OUTPUT_1(i+3 DOWNTO i);
		g_carry:	FOR j in 1 to 4 GENERATE
						C(i+j) <= C_0(i+j) WHEN C(i) = '0' ELSE C_1(i+j);
					END GENERATE g_carry;
				END GENERATE g2_first;
	g2_next:	IF (i REM 4 /= 0) GENERATE
					C_0(i+1) <= G(i) OR (P(i) AND C_0(i));
					OUTPUT_0(i) <= P(i) XOR C_0(i);
					C_1(i+1) <= G(i) OR (P(i) AND C_1(i));
					OUTPUT_1(i) <= P(i) XOR C_1(i);
				END GENERATE g2_next;
				
	END GENERATE g2;
OV <= C(N) XOR C(N-1);
OUTPUT <= UNSIGNED(OUTPUT_int);
END ARCHITECTURE;

--Combinational adder based on Brent Kung architecture
architecture BrentKung of adder is
	signal g0, p0 : std_logic_vector(N-1 downto 0);
	signal g1, p1 : std_logic_vector(N/2-1 downto 0);
	signal g2, p2 : std_logic_vector(N/4-1 downto 0);
	signal g3, p3 : std_logic_vector(N/8-1 downto 0);
	signal g4, p4 : std_logic_vector(N/8-1 downto 0);
	signal g5, p5 : std_logic_vector((3*N)/16-1 downto 0);
	signal g6, p6 : std_logic_vector(N/2-(N+16)/16 downto 0);
begin
	
	gen: 
	for j in 0 to N/16-1 generate
		
		first_line: 
		for i in 0+16*j to 15+16*j generate
			fa1: if j /= 0 and i = 0+16*j generate
					  g0(i) <= (a(i) and b(i)) or (g4(1+2*(j-1)) and (a(i) xor b(i)));
				  end generate;
			other: if i /= 0+16*j generate
					    g0(i) <= a(i) and b(i);
					 end generate;
			fa2: if j = 0 and i = 0+16*j generate
				     g0(i) <= (a(i) and b(i)) or (cin and (a(i) xor b(i)));
				  end generate;
			p0(i) <= a(i) xor b(i);
		end generate;
		
		second_line:
		for i in 0+8*j to 7+8*j generate
			g1(i) <= (p0(2*i+1) and g0(2*i)) or g0(2*i+1);
			p1(i) <= p0(2*i+1) and p0(2*i);
		end generate;
		
		third_line:
		for i in 0+4*j to 3+4*j generate
			g2(i) <= (p1(2*i+1) and g1(2*i)) or g1(2*i+1);
			p2(i) <= p1(2*i+1) and p1(2*i);
		end generate;
	
		g3(0+2*j) <= (p2(1+4*j) and g2(0+4*j)) or g2(1+4*j);
		p3(0+2*j) <= p2(1+4*j) and p2(0+4*j);
		g3(1+2*j) <= (p2(3+4*j) and g2(2+4*j)) or g2(3+4*j);
		p3(1+2*j) <= p2(3+4*j) and p2(2+4*j);
		g4(0+2*j) <= (p2(2+4*j) and g3(0+2*j)) or g2(2+4*j);
		p4(0+2*j) <= p2(2+4*j) and p3(0+2*j);	
		g4(1+2*j) <= (p3(1+2*j) and g3(0+2*j)) or g3(1+2*j);
		p4(1+2*j) <= p3(1+2*j) and p3(0+2*j);
		g5(0+3*j) <= (p1(2+8*j) and g2(0+4*j)) or g1(2+8*j);
		p5(0+3*j) <= p1(2+8*j) and p2(0+4*j);
		g5(1+3*j) <= (p1(4+8*j) and g3(0+2*j)) or g1(4+8*j);
		p5(1+3*j) <= p1(4+8*j) and p3(0+2*j);
		g5(2+3*j) <= (p1(6+8*j) and g4(0+2*j)) or g1(6+8*j);
		p5(2+3*j) <= p1(6+8*j) and p4(0+2*j);
		g6(0+7*j) <= (p0(2+16*j) and g1(0+8*j)) or g0(2+16*j);
		p6(0+7*j) <= p0(2+16*j) and p1(0+8*j);
		g6(1+7*j) <= (p0(4+16*j) and g2(0+4*j)) or g0(4+16*j);
		p6(1+7*j) <= p0(4+16*j) and p2(0+4*j);
		g6(2+7*j) <= (p0(6+16*j) and g5(0+3*j)) or g0(6+16*j);
		p6(2+7*j) <= p0(6+16*j) and p5(0+3*j);
		g6(3+7*j) <= (p0(8+16*j) and g3(0+2*j)) or g0(8+16*j);
		p6(3+7*j) <= p0(8+16*j) and p3(0+2*j);
		g6(4+7*j) <= (p0(10+16*j) and g5(1+3*j)) or g0(10+16*j);
		p6(4+7*j) <= p0(10+16*j) and p5(1+3*j);
		g6(5+7*j) <= (p0(12+16*j) and g4(0+2*j)) or g0(12+16*j);
		p6(5+7*j) <= p0(12+16*j) and p4(0+2*j);
		g6(6+7*j) <= (p0(14+16*j) and g5(2+3*j)) or g0(14+16*j);
		p6(6+7*j) <= p0(14+16*j) and p5(2+3*j);
		
		cin_if:
		if j = 0 generate
			output(0+16*j) <= p0(0+16*j) xor cin;
		end generate;
		g4_if:
		if j /= 0 generate
			output(0+16*j) <= p0(0+16*j) xor g4(1+2*(j-1));
		end generate;
		output(1+16*j) <= p0(1+16*j) xor g0(0+16*j);
		output(2+16*j) <= p0(2+16*j) xor g1(0+8*j);
		output(3+16*j) <= p0(3+16*j) xor g6(0+7*j);
		output(4+16*j) <= p0(4+16*j) xor g2(0+4*j);
		output(5+16*j) <= p0(5+16*j) xor g6(1+7*j);
		output(6+16*j) <= p0(6+16*j) xor g5(0+3*j);
		output(7+16*j) <= p0(7+16*j) xor g6(2+7*j);
		output(8+16*j) <= p0(8+16*j) xor g3(0+2*j);
		output(9+16*j) <= p0(9+16*j) xor g6(3+7*j);
		output(10+16*j) <= p0(10+16*j) xor g5(1+3*j);
		output(11+16*j) <= p0(11+16*j) xor g6(4+7*j);
		output(12+16*j) <= p0(12+16*j) xor g4(0+2*j);
		output(13+16*j) <= p0(13+16*j) xor g6(5+7*j);
		output(14+16*j) <= p0(14+16*j) xor g5(2+3*j);
		output(15+16*j) <= p0(15+16*j) xor g6(6+7*j);
		
		cout_ov:
		if j = N/16-1 generate
			cout <= g4(1+2*j);
			ov <= g4(1+2*j) xor g6(6+7*j);
		end generate;

	end generate;

end architecture;

--24 bit adder based on Brent Kung architecture
ARCHITECTURE bk_24 of adder is
SIGNAL a_16, b_16, out_16 : UNSIGNED (15 downto 0); 
SIGNAL a_8, b_8, out_8 : UNSIGNED (7 downto 0); 
SIGNAL Carry_connect : STD_LOGIC;

component bk_16 is
	port (a, b : in UNSIGNED (15 downto 0); 
			cin : in std_logic; 
			output : out UNSIGNED (15 downto 0); 
			cout, ov : out std_logic);
end component bk_16;

component bk_8_9 is
	generic (N : integer := 9); --8 or 9 valid only
	port (a, b : in UNSIGNED (N-1 downto 0); 
			cin : in std_logic; 
			output : out UNSIGNED (N-1 downto 0); 
			cout, ov : out std_logic);
end component bk_8_9;

begin
	a_8 				<= A(7 DOWNTO 0);
	b_8 				<= B(7 DOWNTO 0);
	OUTPUT(7 DOWNTO 0)	<= out_8 ;
	a_16 				<= A(23 DOWNTO 8);
	b_16 				<= B(23 DOWNTO 8);
	OUTPUT(23 DOWNTO 8)	<= out_16;
gen1: 	if N = 24 generate
adder1: 	bk_8_9 GENERIC MAP (N => 8) PORT MAP ( a => a_8, b => b_8, cin => Cin, output => out_8, cout => Carry_connect);
adder2: 	bk_16 PORT MAP ( a => a_16, b => b_16, cin => Carry_connect, output => out_16, cout => Cout, ov => OV);
		end generate;

		
end architecture bk_24;

--8-9 bit adder based on Brent Kung architecture
ARCHITECTURE bk_8_9 of adder is

component bk_8_9 is
	generic (N : integer := 9); --8 or 9 valid only
	port (a, b : in UNSIGNED (N-1 downto 0); 
			cin : in std_logic; 
			output : out UNSIGNED (N-1 downto 0); 
			cout, ov : out std_logic);
end component bk_8_9;

begin
	
gen1: 	if N = 8 OR N = 9 generate
adder1: 	bk_8_9 GENERIC MAP (N => N) PORT MAP ( a => A, b => B, cin => Cin, output => OUTPUT, cout => Cout, OV => OV);
		end generate;
		
end architecture bk_8_9;

