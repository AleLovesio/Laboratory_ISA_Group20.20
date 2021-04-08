LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY multiplier_mbe_dadda IS
   PORT( 
      A, B  : IN     std_logic_vector (23 DOWNTO 0);
      PROD 	: OUT    std_logic_vector (47 DOWNTO 0)
   );

END ENTITY multiplier_mbe_dadda;

ARCHITECTURE Structural OF multiplier_mbe_dadda IS
	TYPE p_type IS array (0 TO 12) of std_logic_vector (24 DOWNTO 0);
	TYPE sel_type IS array (0 TO 12) of std_logic_vector (1 DOWNTO 0);
	TYPE s_type IS array (0 TO 12) of std_logic;
	SIGNAL AA, A_int : std_logic_vector (24 DOWNTO 0);
	SIGNAL B_int : std_logic_vector (25 DOWNTO 0);
	SIGNAL p, q, b_ext : p_type;
	SIGNAL sel : sel_type;
	SIGNAL S : s_type;
	TYPE p_ext_type IS array (integer range <>) of std_logic_vector(48 DOWNTO 0);
	SIGNAL p_ext_1 : p_ext_type(0 TO 12);
	SIGNAL p_ext_2 : p_ext_type(0 TO 8);
	SIGNAL p_ext_3 : p_ext_type(0 TO 5);
	SIGNAL p_ext_4 : p_ext_type(0 TO 3);
	SIGNAL p_ext_5 : p_ext_type(0 TO 2);
	SIGNAL p_ext_6 : p_ext_type(0 TO 1);
	SIGNAL RES : unsigned (49 downto 0);
	SIGNAL COUT : std_logic;
	COMPONENT half_adder IS
	PORT( A, B  		: IN     std_logic;
      	  SUM, COUT 	: OUT    std_logic);
	END COMPONENT;

	COMPONENT full_adder IS
	PORT( A, B, CIN 	: IN     std_logic;
      	  SUM, COUT 	: OUT    std_logic);
	END COMPONENT;
	
BEGIN
		--Booth encoder
		AA <= std_logic_vector(A) & '0';
		A_int <= '0' & std_logic_vector(A);
		B_int <= "00" & std_logic_vector(B);

		--Generation of the first partil product
		
		--Circuit to obtain the sel signal for the mux			
		sel(0)(0) <= B_int(0) XOR '0';
		sel(0)(1) <= B_int(0) XOR B_int(1);

		--Mux to obtain the correct value for q_j
		q(0) <= (others => '0')	WHEN sel(0)="00" ELSE
				A_int 			WHEN sel(0)="01" ELSE
				AA				WHEN sel(0)="10" ELSE
				A_int;

		--Complement all bits in case of negative result usign the extended version of b_2j+1
Gen0:	FOR i IN 0 TO 24 GENERATE
			b_ext(0)(i) <= B_int(1);
		END GENERATE Gen0;
		p(0) <= q(0) XOR b_ext(0);
		S(0) <= B_int(1);

		--Generate for all other cases
BEGen:	FOR j IN 1 TO 12 GENERATE
						
			--Circuit to obtain the sel signal for the mux			
			sel(j)(0) <= B_int(2*j) XOR B_int(2*j-1);
			sel(j)(1) <= B_int(2*j) XOR B_int(2*j+1);

			--Mux to obtain the correct value for q_j
			q(j) <= (others => '0')	WHEN sel(j)="00" ELSE
					A_int 				WHEN sel(j)="01" ELSE
					AA				WHEN sel(j)="10" ELSE
					A_int;

			--Complement all bits in case of negative result using the extended version of b_2j+1
Genj:		FOR i IN 0 TO 24 GENERATE
				b_ext(j)(i) <= B_int(2*j+1);
			END GENERATE Genj;
			p(j) <= q(j) XOR b_ext(j);
			S(j) <= B_int(2*j+1);
		END GENERATE BEGen;
	
	p_ext_1(0)(27 downto 0) <= (not S(0)) & S(0) & S(0) & p(0);
	p_ext_1(11)(47 downto 20) <= (not S(11)) & p(11) & '0' & S(10);
	p_ext_1(12)(47 downto 22) <= p(12)(23 DOWNTO 0) & '0' & S(11);
	gensmth: for i in 1 to 10 generate
				p_ext_1(i)(2*i+26 downto 2*i-2) <= '1' & (not S(i)) & p(i) & '0' & S(i-1);
	end generate;

--	HA_0_0 : half_adder PORT MAP (A => p_ext_1()(), B => p_ext_1()(), SUM => p_ext_2()(), COUT => p_ext_2()());
--  FA_0_0 : full_adder PORT MAP (A => p_ext_1()(), B => p_ext_1()(), CIN => p_ext_1()(), SUM => p_ext_2()(), COUT => p_ext_2()());

	-- d6
	HA_0_00 : half_adder PORT MAP (A => p_ext_1(0)(16), B => p_ext_1(1)(16), SUM => p_ext_2(0)(16), COUT => p_ext_2(0)(17));
	HA_0_01 : half_adder PORT MAP (A => p_ext_1(0)(17), B => p_ext_1(1)(17), SUM => p_ext_2(1)(17), COUT => p_ext_2(0)(18));
	FA_0_02 : full_adder PORT MAP (A => p_ext_1(0)(18), B => p_ext_1(1)(18), CIN => p_ext_1(2)(18), SUM => p_ext_2(1)(18), COUT => p_ext_2(0)(19));
	HA_0_03 : half_adder PORT MAP (A => p_ext_1(3)(18), B => p_ext_1(4)(18), SUM => p_ext_2(2)(18), COUT => p_ext_2(1)(19));
	FA_0_04 : full_adder PORT MAP (A => p_ext_1(0)(19), B => p_ext_1(1)(19), CIN => p_ext_1(2)(19), SUM => p_ext_2(2)(19), COUT => p_ext_2(0)(20));
	HA_0_05 : half_adder PORT MAP (A => p_ext_1(3)(19), B => p_ext_1(4)(19), SUM => p_ext_2(3)(19), COUT => p_ext_2(1)(20));
	FA_0_06 : full_adder PORT MAP (A => p_ext_1(0)(20), B => p_ext_1(1)(20), CIN => p_ext_1(2)(20), SUM => p_ext_2(2)(20), COUT => p_ext_2(0)(21));
	FA_0_07 : full_adder PORT MAP (A => p_ext_1(3)(20), B => p_ext_1(4)(20), CIN => p_ext_1(5)(20), SUM => p_ext_2(3)(20), COUT => p_ext_2(1)(21));
	HA_0_08 : half_adder PORT MAP (A => p_ext_1(6)(20), B => p_ext_1(7)(20), SUM => p_ext_2(4)(20), COUT => p_ext_2(2)(21));
	FA_0_09 : full_adder PORT MAP (A => p_ext_1(0)(21), B => p_ext_1(1)(21), CIN => p_ext_1(2)(21), SUM => p_ext_2(3)(21), COUT => p_ext_2(0)(22));
	FA_0_10 : full_adder PORT MAP (A => p_ext_1(3)(21), B => p_ext_1(4)(21), CIN => p_ext_1(5)(21), SUM => p_ext_2(4)(21), COUT => p_ext_2(1)(22));
	HA_0_11 : half_adder PORT MAP (A => p_ext_1(6)(21), B => p_ext_1(7)(21), SUM => p_ext_2(5)(21), COUT => p_ext_2(2)(22));
	FA_0_12 : full_adder PORT MAP (A => p_ext_1(0)(22), B => p_ext_1(1)(22), CIN => p_ext_1(2)(22), SUM => p_ext_2(3)(22), COUT => p_ext_2(0)(23));
	FA_0_13 : full_adder PORT MAP (A => p_ext_1(3)(22), B => p_ext_1(4)(22), CIN => p_ext_1(5)(22), SUM => p_ext_2(4)(22), COUT => p_ext_2(1)(23));
	FA_0_14 : full_adder PORT MAP (A => p_ext_1(6)(22), B => p_ext_1(7)(22), CIN => p_ext_1(8)(22), SUM => p_ext_2(5)(22), COUT => p_ext_2(2)(23));
	HA_0_15 : half_adder PORT MAP (A => p_ext_1(9)(22), B => p_ext_1(10)(22), SUM => p_ext_2(6)(22), COUT => p_ext_2(3)(23));
	FA_0_16 : full_adder PORT MAP (A => p_ext_1(0)(23), B => p_ext_1(1)(23), CIN => p_ext_1(2)(23), SUM => p_ext_2(4)(23), COUT => p_ext_2(0)(24));
	FA_0_17 : full_adder PORT MAP (A => p_ext_1(3)(23), B => p_ext_1(4)(23), CIN => p_ext_1(5)(23), SUM => p_ext_2(5)(23), COUT => p_ext_2(1)(24));
	FA_0_18 : full_adder PORT MAP (A => p_ext_1(6)(23), B => p_ext_1(7)(23), CIN => p_ext_1(8)(23), SUM => p_ext_2(6)(23), COUT => p_ext_2(2)(24));
	HA_0_19 : half_adder PORT MAP (A => p_ext_1(9)(23), B => p_ext_1(10)(23), SUM => p_ext_2(7)(23), COUT => p_ext_2(3)(24));
	FA_0_20 : full_adder PORT MAP (A => p_ext_1(0)(24), B => p_ext_1(1)(24), CIN => p_ext_1(2)(24), SUM => p_ext_2(4)(24), COUT => p_ext_2(0)(25));
	FA_0_21 : full_adder PORT MAP (A => p_ext_1(3)(24), B => p_ext_1(4)(24), CIN => p_ext_1(5)(24), SUM => p_ext_2(5)(24), COUT => p_ext_2(1)(25));
	FA_0_22 : full_adder PORT MAP (A => p_ext_1(6)(24), B => p_ext_1(7)(24), CIN => p_ext_1(8)(24), SUM => p_ext_2(6)(24), COUT => p_ext_2(2)(25));
	FA_0_23 : full_adder PORT MAP (A => p_ext_1(9)(24), B => p_ext_1(10)(24), CIN => p_ext_1(11)(24), SUM => p_ext_2(7)(24), COUT => p_ext_2(3)(25));
	FA_0_24 : full_adder PORT MAP (A => p_ext_1(0)(25), B => p_ext_1(1)(25), CIN => p_ext_1(2)(25), SUM => p_ext_2(4)(25), COUT => p_ext_2(0)(26));
	FA_0_25 : full_adder PORT MAP (A => p_ext_1(3)(25), B => p_ext_1(4)(25), CIN => p_ext_1(5)(25), SUM => p_ext_2(5)(25), COUT => p_ext_2(1)(26));
	FA_0_26 : full_adder PORT MAP (A => p_ext_1(6)(25), B => p_ext_1(7)(25), CIN => p_ext_1(8)(25), SUM => p_ext_2(6)(25), COUT => p_ext_2(2)(26));
	FA_0_27 : full_adder PORT MAP (A => p_ext_1(9)(25), B => p_ext_1(10)(25), CIN => p_ext_1(11)(25), SUM => p_ext_2(7)(25), COUT => p_ext_2(3)(26));
	FA_0_28 : full_adder PORT MAP (A => p_ext_1(0)(26), B => p_ext_1(1)(26), CIN => p_ext_1(2)(26), SUM => p_ext_2(4)(26), COUT => p_ext_2(0)(27));
	FA_0_29 : full_adder PORT MAP (A => p_ext_1(3)(26), B => p_ext_1(4)(26), CIN => p_ext_1(5)(26), SUM => p_ext_2(5)(26), COUT => p_ext_2(1)(27));
	FA_0_30 : full_adder PORT MAP (A => p_ext_1(6)(26), B => p_ext_1(7)(26), CIN => p_ext_1(8)(26), SUM => p_ext_2(6)(26), COUT => p_ext_2(2)(27));
	FA_0_31 : full_adder PORT MAP (A => p_ext_1(9)(26), B => p_ext_1(10)(26), CIN => p_ext_1(11)(26), SUM => p_ext_2(7)(26), COUT => p_ext_2(3)(27));
	FA_0_32 : full_adder PORT MAP (A => p_ext_1(0)(27), B => p_ext_1(1)(27), CIN => p_ext_1(2)(27), SUM => p_ext_2(4)(27), COUT => p_ext_2(0)(28));
	FA_0_33 : full_adder PORT MAP (A => p_ext_1(3)(27), B => p_ext_1(4)(27), CIN => p_ext_1(5)(27), SUM => p_ext_2(5)(27), COUT => p_ext_2(1)(28));
	FA_0_34 : full_adder PORT MAP (A => p_ext_1(6)(27), B => p_ext_1(7)(27), CIN => p_ext_1(8)(27), SUM => p_ext_2(6)(27), COUT => p_ext_2(2)(28));
	FA_0_35 : full_adder PORT MAP (A => p_ext_1(9)(27), B => p_ext_1(10)(27), CIN => p_ext_1(11)(27), SUM => p_ext_2(7)(27), COUT => p_ext_2(3)(28));
	FA_0_36 : full_adder PORT MAP (A => p_ext_1(1)(28), B => p_ext_1(2)(28), CIN => p_ext_1(3)(28), SUM => p_ext_2(4)(28), COUT => p_ext_2(0)(29));
	FA_0_37 : full_adder PORT MAP (A => p_ext_1(4)(28), B => p_ext_1(5)(28), CIN => p_ext_1(6)(28), SUM => p_ext_2(5)(28), COUT => p_ext_2(1)(29));
	FA_0_38 : full_adder PORT MAP (A => p_ext_1(7)(28), B => p_ext_1(8)(28), CIN => p_ext_1(9)(28),SUM => p_ext_2(6)(28), COUT => p_ext_2(2)(29));
	HA_0_39 : half_adder PORT MAP (A => p_ext_1(10)(28), B => p_ext_1(11)(28), SUM => p_ext_2(7)(28), COUT => p_ext_2(3)(29));
	FA_0_40 : full_adder PORT MAP (A => p_ext_1(2)(29), B => p_ext_1(3)(29), CIN => p_ext_1(4)(29), SUM => p_ext_2(4)(29), COUT => p_ext_2(0)(30));
	FA_0_41 : full_adder PORT MAP (A => p_ext_1(5)(29), B => p_ext_1(6)(29), CIN => p_ext_1(7)(29), SUM => p_ext_2(5)(29), COUT => p_ext_2(1)(30));
	FA_0_42 : full_adder PORT MAP (A => p_ext_1(8)(29), B => p_ext_1(9)(29), CIN => p_ext_1(10)(29), SUM => p_ext_2(6)(29), COUT => p_ext_2(2)(30));
	FA_0_43 : full_adder PORT MAP (A => p_ext_1(2)(30), B => p_ext_1(3)(30), CIN => p_ext_1(4)(30), SUM => p_ext_2(3)(30), COUT => p_ext_2(0)(31));
	FA_0_44 : full_adder PORT MAP (A => p_ext_1(5)(30), B => p_ext_1(6)(30), CIN => p_ext_1(7)(30), SUM => p_ext_2(4)(30), COUT => p_ext_2(1)(31));
	HA_0_45 : half_adder PORT MAP (A => p_ext_1(8)(30), B => p_ext_1(9)(30), SUM => p_ext_2(5)(30), COUT => p_ext_2(2)(31));
	FA_0_46 : full_adder PORT MAP (A => p_ext_1(3)(31), B => p_ext_1(4)(31), CIN => p_ext_1(5)(31), SUM => p_ext_2(3)(31), COUT => p_ext_2(0)(32));
	FA_0_47 : full_adder PORT MAP (A => p_ext_1(6)(31), B => p_ext_1(7)(31), CIN => p_ext_1(8)(31), SUM => p_ext_2(4)(31), COUT => p_ext_2(1)(32));
	FA_0_48 : full_adder PORT MAP (A => p_ext_1(3)(32), B => p_ext_1(4)(32), CIN => p_ext_1(5)(32), SUM => p_ext_2(2)(32), COUT => p_ext_2(0)(33));
	HA_0_49 : half_adder PORT MAP (A => p_ext_1(6)(32), B => p_ext_1(7)(32), SUM => p_ext_2(3)(32), COUT => p_ext_2(1)(33));
	FA_0_50 : full_adder PORT MAP (A => p_ext_1(4)(33), B => p_ext_1(5)(33), CIN => p_ext_1(6)(33), SUM => p_ext_2(2)(33), COUT => p_ext_2(0)(34));
	HA_0_51 : half_adder PORT MAP (A => p_ext_1(4)(34), B => p_ext_1(5)(34), SUM => p_ext_2(1)(34), COUT => p_ext_2(0)(35));

--  p_ext_2
	p_ext_2(0)(15 DOWNTO 0) <= p_ext_1(0)(15 DOWNTO 0);
	p_ext_2(1)(15 DOWNTO 0) <= p_ext_1(1)(15 DOWNTO 0);
	p_ext_2(2)(15 DOWNTO 2) <= p_ext_1(2)(15 DOWNTO 2);
	p_ext_2(3)(15 DOWNTO 4) <= p_ext_1(3)(15 DOWNTO 4);
	p_ext_2(4)(15 DOWNTO 6) <= p_ext_1(4)(15 DOWNTO 6);
	p_ext_2(5)(15 DOWNTO 8) <= p_ext_1(5)(15 DOWNTO 8);
	p_ext_2(6)(15 DOWNTO 10) <= p_ext_1(6)(15 DOWNTO 10);
	p_ext_2(7)(15 DOWNTO 12) <= p_ext_1(7)(15 DOWNTO 12);
	p_ext_2(8)(15 DOWNTO 14) <= p_ext_1(8)(15 DOWNTO 14);

	GenCol16_1:
	for i in 2 to 9 generate
		p_ext_2(i-1)(16) <= p_ext_1(i)(16);
	end generate;

	GenCol17_1:
	for i in 2 to 8 generate
		p_ext_2(i)(17) <= p_ext_1(i)(17);
	end generate;

	GenCol18_1:
	for i in 5 to 10 generate
		p_ext_2(i-2)(18) <= p_ext_1(i)(18);
	end generate;

	GenCol19_1:
	for i in 5 to 9 generate  --con buco
		p_ext_2(i-1)(19) <= p_ext_1(i)(19);
	end generate;

	GenCol20_1:
	for i in 8 to 11 generate
		p_ext_2(i-3)(20) <= p_ext_1(i)(20);
	end generate;

	GenCol21_1:
	for i in 8 to 10 generate
		p_ext_2(i-2)(21) <= p_ext_1(i)(21);
	end generate;

	GenCol22_1:
	for i in 11 to 12 generate
		p_ext_2(i-4)(22) <= p_ext_1(i)(22);
	end generate;

	p_ext_2(8)(23) <= p_ext_1(11)(23);
	p_ext_2(8)(24) <= p_ext_1(12)(24);
	p_ext_2(8)(25) <= p_ext_1(12)(25);
	p_ext_2(8)(26) <= p_ext_1(12)(26);
	p_ext_2(8)(27) <= p_ext_1(12)(27);
	p_ext_2(8)(28) <= p_ext_1(12)(28);
	
	GenCol29_1:
	for i in 11 to 12 generate
		p_ext_2(i-4)(29) <= p_ext_1(i)(29);
	end generate;

	GenCol30_1:
	for i in 10 to 12 generate
		p_ext_2(i-4)(30) <= p_ext_1(i)(30);
	end generate;

	GenCol31_1:
	for i in 9 to 12 generate
		p_ext_2(i-4)(31) <= p_ext_1(i)(31);
	end generate;

	GenCol32_1:
	for i in 8 to 12 generate
		p_ext_2(i-4)(32) <= p_ext_1(i)(32);
	end generate;

	GenCol33_1:
	for i in 7 to 12 generate
		p_ext_2(i-4)(33) <= p_ext_1(i)(33);
	end generate;

	GenCol34_1:
	for i in 6 to 12 generate
		p_ext_2(i-4)(34) <= p_ext_1(i)(34);
	end generate;

	GenCol35_1:
	for i in 5 to 12 generate
		p_ext_2(i-4)(35) <= p_ext_1(i)(35);
	end generate;

	GenCol36_1:
	for i in 5 to 12 generate
		p_ext_2(i-5)(36) <= p_ext_1(i)(36);
	end generate;

	GenCol37_1:
	for i in 6 to 12 generate
		p_ext_2(i-6)(37) <= p_ext_1(i)(37);
	end generate;

	GenCol38_1:
	for i in 6 to 12 generate
		p_ext_2(i-6)(38) <= p_ext_1(i)(38);
	end generate;

	GenCol39_1:
	for i in 7 to 12 generate
		p_ext_2(i-7)(39) <= p_ext_1(i)(39);
	end generate;

	GenCol40_1:
	for i in 7 to 12 generate
		p_ext_2(i-7)(40) <= p_ext_1(i)(40);
	end generate;

	GenCol41_1:
	for i in 8 to 12 generate
		p_ext_2(i-8)(41) <= p_ext_1(i)(41);
	end generate;

	GenCol42_1:
	for i in 8 to 12 generate
		p_ext_2(i-8)(42) <= p_ext_1(i)(42);
	end generate;

	GenCol43_1:
	for i in 9 to 12 generate
		p_ext_2(i-9)(43) <= p_ext_1(i)(43);
	end generate;

	GenCol44_1:
	for i in 9 to 12 generate
		p_ext_2(i-9)(44) <= p_ext_1(i)(44);
	end generate;

	GenCol45_1:
	for i in 10 to 12 generate
		p_ext_2(i-10)(45) <= p_ext_1(i)(45);
	end generate;

	GenCol46_1:
	for i in 10 to 12 generate
		p_ext_2(i-10)(46) <= p_ext_1(i)(46);
	end generate;

	GenCol47_1:
	for i in 11 to 12 generate
		p_ext_2(i-11)(47) <= p_ext_1(i)(47);
	end generate;

--  d5
	HA_1_00 : half_adder PORT MAP (A => p_ext_2(0)(10), B => p_ext_2(1)(10), SUM => p_ext_3(0)(10), COUT => p_ext_3(0)(11));
	HA_1_01 : half_adder PORT MAP (A => p_ext_2(0)(11), B => p_ext_2(1)(11), SUM => p_ext_3(1)(11), COUT => p_ext_3(0)(12));
	FA_1_02 : full_adder PORT MAP (A => p_ext_2(0)(12), B => p_ext_2(1)(12), CIN => p_ext_2(2)(12), SUM => p_ext_3(1)(12), COUT => p_ext_3(0)(13));
	HA_1_03 : half_adder PORT MAP (A => p_ext_2(3)(12), B => p_ext_2(4)(12), SUM => p_ext_3(2)(12), COUT => p_ext_3(1)(13));
	FA_1_04 : full_adder PORT MAP (A => p_ext_2(0)(13), B => p_ext_2(1)(13), CIN => p_ext_2(2)(13), SUM => p_ext_3(2)(13), COUT => p_ext_3(0)(14));
	HA_1_05 : half_adder PORT MAP (A => p_ext_2(3)(13), B => p_ext_2(4)(13), SUM => p_ext_3(3)(13), COUT => p_ext_3(1)(14));
	FA_1_06 : full_adder PORT MAP (A => p_ext_2(0)(14), B => p_ext_2(1)(14), CIN => p_ext_2(2)(14), SUM => p_ext_3(2)(14), COUT => p_ext_3(0)(15));
	FA_1_07 : full_adder PORT MAP (A => p_ext_2(3)(14), B => p_ext_2(4)(14), CIN => p_ext_2(5)(14), SUM => p_ext_3(3)(14), COUT => p_ext_3(1)(15));
	HA_1_08 : half_adder PORT MAP (A => p_ext_2(6)(14), B => p_ext_2(7)(14), SUM => p_ext_3(4)(14), COUT => p_ext_3(2)(15));
	FA_1_09 : full_adder PORT MAP (A => p_ext_2(0)(15), B => p_ext_2(1)(15), CIN => p_ext_2(2)(15), SUM => p_ext_3(3)(15), COUT => p_ext_3(0)(16));
	FA_1_10 : full_adder PORT MAP (A => p_ext_2(3)(15), B => p_ext_2(4)(15), CIN => p_ext_2(5)(15), SUM => p_ext_3(4)(15), COUT => p_ext_3(1)(16));
	HA_1_11 : half_adder PORT MAP (A => p_ext_2(6)(15), B => p_ext_2(7)(15), SUM => p_ext_3(5)(15), COUT => p_ext_3(2)(16));
	FA_1_12 : full_adder PORT MAP (A => p_ext_2(0)(16), B => p_ext_2(1)(16), CIN => p_ext_2(2)(16), SUM => p_ext_3(3)(16), COUT => p_ext_3(0)(17));
	FA_1_13 : full_adder PORT MAP (A => p_ext_2(3)(16), B => p_ext_2(4)(16), CIN => p_ext_2(5)(16), SUM => p_ext_3(4)(16), COUT => p_ext_3(1)(17));
	FA_1_14 : full_adder PORT MAP (A => p_ext_2(6)(16), B => p_ext_2(7)(16), CIN => p_ext_2(8)(16), SUM => p_ext_3(5)(16), COUT => p_ext_3(2)(17));
	FA_1_15 : full_adder PORT MAP (A => p_ext_2(0)(17), B => p_ext_2(1)(17), CIN => p_ext_2(2)(17), SUM => p_ext_3(3)(17), COUT => p_ext_3(0)(18));
	FA_1_16 : full_adder PORT MAP (A => p_ext_2(3)(17), B => p_ext_2(4)(17), CIN => p_ext_2(5)(17), SUM => p_ext_3(4)(17), COUT => p_ext_3(1)(18));
	FA_1_17 : full_adder PORT MAP (A => p_ext_2(6)(17), B => p_ext_2(7)(17), CIN => p_ext_2(8)(17), SUM => p_ext_3(5)(17), COUT => p_ext_3(2)(18));
	FA_1_18 : full_adder PORT MAP (A => p_ext_2(0)(18), B => p_ext_2(1)(18), CIN => p_ext_2(2)(18), SUM => p_ext_3(3)(18), COUT => p_ext_3(0)(19));
	FA_1_19 : full_adder PORT MAP (A => p_ext_2(3)(18), B => p_ext_2(4)(18), CIN => p_ext_2(5)(18), SUM => p_ext_3(4)(18), COUT => p_ext_3(1)(19));
	FA_1_20 : full_adder PORT MAP (A => p_ext_2(6)(18), B => p_ext_2(7)(18), CIN => p_ext_2(8)(18), SUM => p_ext_3(5)(18), COUT => p_ext_3(2)(19));
	FA_1_21 : full_adder PORT MAP (A => p_ext_2(0)(19), B => p_ext_2(1)(19), CIN => p_ext_2(2)(19), SUM => p_ext_3(3)(19), COUT => p_ext_3(0)(20));
	FA_1_22 : full_adder PORT MAP (A => p_ext_2(3)(19), B => p_ext_2(4)(19), CIN => p_ext_2(5)(19), SUM => p_ext_3(4)(19), COUT => p_ext_3(1)(20));
	FA_1_23 : full_adder PORT MAP (A => p_ext_2(6)(19), B => p_ext_2(7)(19), CIN => p_ext_2(8)(19), SUM => p_ext_3(5)(19), COUT => p_ext_3(2)(20));
	FA_1_24 : full_adder PORT MAP (A => p_ext_2(0)(20), B => p_ext_2(1)(20), CIN => p_ext_2(2)(20), SUM => p_ext_3(3)(20), COUT => p_ext_3(0)(21));
	FA_1_25 : full_adder PORT MAP (A => p_ext_2(3)(20), B => p_ext_2(4)(20), CIN => p_ext_2(5)(20), SUM => p_ext_3(4)(20), COUT => p_ext_3(1)(21));
	FA_1_26 : full_adder PORT MAP (A => p_ext_2(6)(20), B => p_ext_2(7)(20), CIN => p_ext_2(8)(20), SUM => p_ext_3(5)(20), COUT => p_ext_3(2)(21));
	FA_1_27 : full_adder PORT MAP (A => p_ext_2(0)(21), B => p_ext_2(1)(21), CIN => p_ext_2(2)(21), SUM => p_ext_3(3)(21), COUT => p_ext_3(0)(22));
	FA_1_28 : full_adder PORT MAP (A => p_ext_2(3)(21), B => p_ext_2(4)(21), CIN => p_ext_2(5)(21), SUM => p_ext_3(4)(21), COUT => p_ext_3(1)(22));
	FA_1_29 : full_adder PORT MAP (A => p_ext_2(6)(21), B => p_ext_2(7)(21), CIN => p_ext_2(8)(21), SUM => p_ext_3(5)(21), COUT => p_ext_3(2)(22));
	FA_1_30 : full_adder PORT MAP (A => p_ext_2(0)(22), B => p_ext_2(1)(22), CIN => p_ext_2(2)(22), SUM => p_ext_3(3)(22), COUT => p_ext_3(0)(23));
	FA_1_31 : full_adder PORT MAP (A => p_ext_2(3)(22), B => p_ext_2(4)(22), CIN => p_ext_2(5)(22), SUM => p_ext_3(4)(22), COUT => p_ext_3(1)(23));
	FA_1_32 : full_adder PORT MAP (A => p_ext_2(6)(22), B => p_ext_2(7)(22), CIN => p_ext_2(8)(22), SUM => p_ext_3(5)(22), COUT => p_ext_3(2)(23));
	FA_1_33 : full_adder PORT MAP (A => p_ext_2(0)(23), B => p_ext_2(1)(23), CIN => p_ext_2(2)(23), SUM => p_ext_3(3)(23), COUT => p_ext_3(0)(24));
	FA_1_34 : full_adder PORT MAP (A => p_ext_2(3)(23), B => p_ext_2(4)(23), CIN => p_ext_2(5)(23), SUM => p_ext_3(4)(23), COUT => p_ext_3(1)(24));
	FA_1_35 : full_adder PORT MAP (A => p_ext_2(6)(23), B => p_ext_2(7)(23), CIN => p_ext_2(8)(23), SUM => p_ext_3(5)(23), COUT => p_ext_3(2)(24));
	FA_1_36 : full_adder PORT MAP (A => p_ext_2(0)(24), B => p_ext_2(1)(24), CIN => p_ext_2(2)(24), SUM => p_ext_3(3)(24), COUT => p_ext_3(0)(25));
	FA_1_37 : full_adder PORT MAP (A => p_ext_2(3)(24), B => p_ext_2(4)(24), CIN => p_ext_2(5)(24), SUM => p_ext_3(4)(24), COUT => p_ext_3(1)(25));
	FA_1_38 : full_adder PORT MAP (A => p_ext_2(6)(24), B => p_ext_2(7)(24), CIN => p_ext_2(8)(24), SUM => p_ext_3(5)(24), COUT => p_ext_3(2)(25));
	FA_1_39 : full_adder PORT MAP (A => p_ext_2(0)(25), B => p_ext_2(1)(25), CIN => p_ext_2(2)(25), SUM => p_ext_3(3)(25), COUT => p_ext_3(0)(26));
	FA_1_40 : full_adder PORT MAP (A => p_ext_2(3)(25), B => p_ext_2(4)(25), CIN => p_ext_2(5)(25), SUM => p_ext_3(4)(25), COUT => p_ext_3(1)(26));
	FA_1_41 : full_adder PORT MAP (A => p_ext_2(6)(25), B => p_ext_2(7)(25), CIN => p_ext_2(8)(25), SUM => p_ext_3(5)(25), COUT => p_ext_3(2)(26));
	FA_1_42 : full_adder PORT MAP (A => p_ext_2(0)(26), B => p_ext_2(1)(26), CIN => p_ext_2(2)(26), SUM => p_ext_3(3)(26), COUT => p_ext_3(0)(27));
	FA_1_43 : full_adder PORT MAP (A => p_ext_2(3)(26), B => p_ext_2(4)(26), CIN => p_ext_2(5)(26), SUM => p_ext_3(4)(26), COUT => p_ext_3(1)(27));
	FA_1_44 : full_adder PORT MAP (A => p_ext_2(6)(26), B => p_ext_2(7)(26), CIN => p_ext_2(8)(26), SUM => p_ext_3(5)(26), COUT => p_ext_3(2)(27));
	FA_1_45 : full_adder PORT MAP (A => p_ext_2(0)(27), B => p_ext_2(1)(27), CIN => p_ext_2(2)(27), SUM => p_ext_3(3)(27), COUT => p_ext_3(0)(28));
	FA_1_46 : full_adder PORT MAP (A => p_ext_2(3)(27), B => p_ext_2(4)(27), CIN => p_ext_2(5)(27), SUM => p_ext_3(4)(27), COUT => p_ext_3(1)(28));
	FA_1_47 : full_adder PORT MAP (A => p_ext_2(6)(27), B => p_ext_2(7)(27), CIN => p_ext_2(8)(27), SUM => p_ext_3(5)(27), COUT => p_ext_3(2)(28));
	FA_1_48 : full_adder PORT MAP (A => p_ext_2(0)(28), B => p_ext_2(1)(28), CIN => p_ext_2(2)(28), SUM => p_ext_3(3)(28), COUT => p_ext_3(0)(29));
	FA_1_49 : full_adder PORT MAP (A => p_ext_2(3)(28), B => p_ext_2(4)(28), CIN => p_ext_2(5)(28), SUM => p_ext_3(4)(28), COUT => p_ext_3(1)(29));
	FA_1_50 : full_adder PORT MAP (A => p_ext_2(6)(28), B => p_ext_2(7)(28), CIN => p_ext_2(8)(28), SUM => p_ext_3(5)(28), COUT => p_ext_3(2)(29));
	FA_1_51 : full_adder PORT MAP (A => p_ext_2(0)(29), B => p_ext_2(1)(29), CIN => p_ext_2(2)(29), SUM => p_ext_3(3)(29), COUT => p_ext_3(0)(30));
	FA_1_52 : full_adder PORT MAP (A => p_ext_2(3)(29), B => p_ext_2(4)(29), CIN => p_ext_2(5)(29), SUM => p_ext_3(4)(29), COUT => p_ext_3(1)(30));
	FA_1_53 : full_adder PORT MAP (A => p_ext_2(6)(29), B => p_ext_2(7)(29), CIN => p_ext_2(8)(29), SUM => p_ext_3(5)(29), COUT => p_ext_3(2)(30));
	FA_1_54 : full_adder PORT MAP (A => p_ext_2(0)(30), B => p_ext_2(1)(30), CIN => p_ext_2(2)(30), SUM => p_ext_3(3)(30), COUT => p_ext_3(0)(31));
	FA_1_55 : full_adder PORT MAP (A => p_ext_2(3)(30), B => p_ext_2(4)(30), CIN => p_ext_2(5)(30), SUM => p_ext_3(4)(30), COUT => p_ext_3(1)(31));
	FA_1_56 : full_adder PORT MAP (A => p_ext_2(6)(30), B => p_ext_2(7)(30), CIN => p_ext_2(8)(30), SUM => p_ext_3(5)(30), COUT => p_ext_3(2)(31));
	FA_1_57 : full_adder PORT MAP (A => p_ext_2(0)(31), B => p_ext_2(1)(31), CIN => p_ext_2(2)(31), SUM => p_ext_3(3)(31), COUT => p_ext_3(0)(32));
	FA_1_58 : full_adder PORT MAP (A => p_ext_2(3)(31), B => p_ext_2(4)(31), CIN => p_ext_2(5)(31), SUM => p_ext_3(4)(31), COUT => p_ext_3(1)(32));
	FA_1_59 : full_adder PORT MAP (A => p_ext_2(6)(31), B => p_ext_2(7)(31), CIN => p_ext_2(8)(31), SUM => p_ext_3(5)(31), COUT => p_ext_3(2)(32));
	FA_1_60 : full_adder PORT MAP (A => p_ext_2(0)(32), B => p_ext_2(1)(32), CIN => p_ext_2(2)(32), SUM => p_ext_3(3)(32), COUT => p_ext_3(0)(33));
	FA_1_61 : full_adder PORT MAP (A => p_ext_2(3)(32), B => p_ext_2(4)(32), CIN => p_ext_2(5)(32), SUM => p_ext_3(4)(32), COUT => p_ext_3(1)(33));
	FA_1_62 : full_adder PORT MAP (A => p_ext_2(6)(32), B => p_ext_2(7)(32), CIN => p_ext_2(8)(32), SUM => p_ext_3(5)(32), COUT => p_ext_3(2)(33));
	FA_1_63 : full_adder PORT MAP (A => p_ext_2(0)(33), B => p_ext_2(1)(33), CIN => p_ext_2(2)(33), SUM => p_ext_3(3)(33), COUT => p_ext_3(0)(34));
	FA_1_64 : full_adder PORT MAP (A => p_ext_2(3)(33), B => p_ext_2(4)(33), CIN => p_ext_2(5)(33), SUM => p_ext_3(4)(33), COUT => p_ext_3(1)(34));
	FA_1_65 : full_adder PORT MAP (A => p_ext_2(6)(33), B => p_ext_2(7)(33), CIN => p_ext_2(8)(33), SUM => p_ext_3(5)(33), COUT => p_ext_3(2)(34));
	FA_1_66 : full_adder PORT MAP (A => p_ext_2(0)(34), B => p_ext_2(1)(34), CIN => p_ext_2(2)(34), SUM => p_ext_3(3)(34), COUT => p_ext_3(0)(35));
	FA_1_67 : full_adder PORT MAP (A => p_ext_2(3)(34), B => p_ext_2(4)(34), CIN => p_ext_2(5)(34), SUM => p_ext_3(4)(34), COUT => p_ext_3(1)(35));
	FA_1_68 : full_adder PORT MAP (A => p_ext_2(6)(34), B => p_ext_2(7)(34), CIN => p_ext_2(8)(34), SUM => p_ext_3(5)(34), COUT => p_ext_3(2)(35));
	FA_1_69 : full_adder PORT MAP (A => p_ext_2(0)(35), B => p_ext_2(1)(35), CIN => p_ext_2(2)(35), SUM => p_ext_3(3)(35), COUT => p_ext_3(0)(36));
	FA_1_70 : full_adder PORT MAP (A => p_ext_2(3)(35), B => p_ext_2(4)(35), CIN => p_ext_2(5)(35), SUM => p_ext_3(4)(35), COUT => p_ext_3(1)(36));
	FA_1_71 : full_adder PORT MAP (A => p_ext_2(6)(35), B => p_ext_2(7)(35), CIN => p_ext_2(8)(35), SUM => p_ext_3(5)(35), COUT => p_ext_3(2)(36));
	FA_1_72 : full_adder PORT MAP (A => p_ext_2(0)(36), B => p_ext_2(1)(36), CIN => p_ext_2(2)(36), SUM => p_ext_3(3)(36), COUT => p_ext_3(0)(37));
	FA_1_73 : full_adder PORT MAP (A => p_ext_2(3)(36), B => p_ext_2(4)(36), CIN => p_ext_2(5)(36), SUM => p_ext_3(4)(36), COUT => p_ext_3(1)(37));
	HA_1_74 : half_adder PORT MAP (A => p_ext_2(6)(36), B => p_ext_2(7)(36), SUM => p_ext_3(5)(36), COUT => p_ext_3(2)(37));
	FA_1_75 : full_adder PORT MAP (A => p_ext_2(0)(37), B => p_ext_2(1)(37), CIN => p_ext_2(2)(37), SUM => p_ext_3(3)(37), COUT => p_ext_3(0)(38));
	FA_1_76 : full_adder PORT MAP (A => p_ext_2(3)(37), B => p_ext_2(4)(37), CIN => p_ext_2(5)(37), SUM => p_ext_3(4)(37), COUT => p_ext_3(1)(38));
	FA_1_77 : full_adder PORT MAP (A => p_ext_2(0)(38), B => p_ext_2(1)(38), CIN => p_ext_2(2)(38), SUM => p_ext_3(2)(38), COUT => p_ext_3(0)(39));
	HA_1_78 : half_adder PORT MAP (A => p_ext_2(3)(38), B => p_ext_2(4)(38), SUM => p_ext_3(3)(38), COUT => p_ext_3(1)(39));
	FA_1_79 : full_adder PORT MAP (A => p_ext_2(0)(39), B => p_ext_2(1)(39), CIN => p_ext_2(2)(39), SUM => p_ext_3(2)(39), COUT => p_ext_3(0)(40));
	HA_1_80 : half_adder PORT MAP (A => p_ext_2(0)(40), B => p_ext_2(1)(40), SUM => p_ext_3(1)(40), COUT => p_ext_3(0)(41));

--  p_ext_3
	p_ext_3(0)(9 DOWNTO 0) <= p_ext_2(0)(9 DOWNTO 0);
	p_ext_3(1)(9 DOWNTO 0) <= p_ext_2(1)(9 DOWNTO 0);
	p_ext_3(2)(9 DOWNTO 2) <= p_ext_2(2)(9 DOWNTO 2);
	p_ext_3(3)(9 DOWNTO 4) <= p_ext_2(3)(9 DOWNTO 4);
	p_ext_3(4)(9 DOWNTO 6) <= p_ext_2(4)(9 DOWNTO 6);
	p_ext_3(5)(9 DOWNTO 8) <= p_ext_2(5)(9 DOWNTO 8);

	GenCol10_2:
	for i in 2 to 6 generate
		p_ext_3(i-1)(10) <= p_ext_2(i)(10);
	end generate;

	GenCol11_2:
	for i in 2 to 5 generate
		p_ext_3(i)(11) <= p_ext_2(i)(11);
	end generate;
	
	GenCol12_2:
	for i in 5 to 7 generate
		p_ext_3(i-2)(12) <= p_ext_2(i)(12);
	end generate;

	GenCol13_2:
	for i in 5 to 6 generate
		p_ext_3(i-1)(13) <= p_ext_2(i)(13);
	end generate;

	p_ext_3(5)(14) <= p_ext_2(8)(14);
	p_ext_3(5)(37) <= p_ext_2(6)(37);

	GenCol38_2:
	for i in 5 to 6 generate
		p_ext_3(i-1)(38) <= p_ext_2(i)(38);
	end generate;

	GenCol39_2:
	for i in 3 to 5 generate
		p_ext_3(i)(39) <= p_ext_2(i)(39);
	end generate;
	
	GenCol40_2:
	for i in 2 to 5 generate
		p_ext_3(i)(40) <= p_ext_2(i)(40);
	end generate;

	GenCol41_2:
	for i in 0 to 4 generate
		p_ext_3(i+1)(41) <= p_ext_2(i)(41);
	end generate;

	p_ext_3(0)(47 DOWNTO 42) <= p_ext_2(0)(47 DOWNTO 42);
	p_ext_3(1)(47 DOWNTO 42) <= p_ext_2(1)(47 DOWNTO 42);
	p_ext_3(2)(46 DOWNTO 42) <= p_ext_2(2)(46 DOWNTO 42);
	p_ext_3(3)(44 DOWNTO 42) <= p_ext_2(3)(44 DOWNTO 42);
	p_ext_3(4)(42) <= p_ext_2(4)(42);


--  d4
	HA_2_00 : half_adder PORT MAP (A => p_ext_3(0)(6), B => p_ext_3(1)(6), SUM => p_ext_4(0)(6), COUT => p_ext_4(0)(7));
	HA_2_01 : half_adder PORT MAP (A => p_ext_3(0)(7), B => p_ext_3(1)(7), SUM => p_ext_4(1)(7), COUT => p_ext_4(0)(8));
	FA_2_02 : full_adder PORT MAP (A => p_ext_3(0)(8), B => p_ext_3(1)(8), CIN => p_ext_3(2)(8), SUM => p_ext_4(1)(8), COUT => p_ext_4(0)(9));
	HA_2_03 : half_adder PORT MAP (A => p_ext_3(3)(8), B => p_ext_3(4)(8), SUM => p_ext_4(2)(8), COUT => p_ext_4(1)(9));
	FA_2_04 : full_adder PORT MAP (A => p_ext_3(0)(9), B => p_ext_3(1)(9), CIN => p_ext_3(2)(9), SUM => p_ext_4(2)(9), COUT => p_ext_4(0)(10));
	HA_2_05 : half_adder PORT MAP (A => p_ext_3(3)(9), B => p_ext_3(4)(9), SUM => p_ext_4(3)(9), COUT => p_ext_4(1)(10));

	FA_gen0:	
	for i in 10 to 41 generate
		FA_2_i0: full_adder PORT MAP (A => p_ext_3(0)(i), B=>p_ext_3(1)(i), CIN=>p_ext_3(2)(i), SUM=>p_ext_4(2)(i), COUT=>p_ext_4(0)(i+1));
		FA_2_i1: full_adder PORT MAP (A => p_ext_3(3)(i), B=>p_ext_3(4)(i), CIN=>p_ext_3(5)(i), SUM=>p_ext_4(3)(i), COUT=>p_ext_4(1)(i+1));
	end generate;

	FA_2_70 : full_adder PORT MAP (A => p_ext_3(0)(42), B => p_ext_3(1)(42), CIN => p_ext_3(2)(42), SUM => p_ext_4(2)(42), COUT => p_ext_4(0)(43));
	HA_2_71 : half_adder PORT MAP (A => p_ext_3(3)(42), B => p_ext_3(4)(42), SUM => p_ext_4(3)(42), COUT => p_ext_4(1)(43));
	FA_2_72 : full_adder PORT MAP (A => p_ext_3(0)(43), B => p_ext_3(1)(43), CIN => p_ext_3(2)(43), SUM => p_ext_4(2)(43), COUT => p_ext_4(0)(44));
	HA_2_73 : half_adder PORT MAP (A => p_ext_3(0)(44), B => p_ext_3(1)(44), SUM => p_ext_4(1)(44), COUT => p_ext_4(0)(45));

--	p_ext_4
	
	p_ext_4(0)(5 DOWNTO 0) <= p_ext_3(0)(5 DOWNTO 0);
	p_ext_4(1)(5 DOWNTO 0) <= p_ext_3(1)(5 DOWNTO 0);
	p_ext_4(2)(5 DOWNTO 2) <= p_ext_3(2)(5 DOWNTO 2);
	p_ext_4(3)(4) <= p_ext_3(3)(4);

	GenCol6_3:
	for i in 2 to 4 generate
		p_ext_4(i-1)(6) <= p_ext_3(i)(6);
	end generate;

	GenCol7_3:
	for i in 2 to 3 generate
		p_ext_4(i)(7) <= p_ext_3(i)(7);
	end generate;

	p_ext_4(3)(8) <= p_ext_3(5)(8);
	p_ext_4(3)(43) <= p_ext_3(3)(43);

	GenCol44_3:
	for i in 2 to 3 generate
		p_ext_4(i)(44) <= p_ext_3(i)(44);
	end generate;

	GenCol45_3:
	for i in 0 to 2 generate
		p_ext_4(i+1)(45) <= p_ext_3(i)(45);
	end generate;

	GenCol46_3:
	for i in 0 to 2 generate
		p_ext_4(i)(46) <= p_ext_3(i)(46);
	end generate;

	GenCol47_3:
	for i in 0 to 1 generate
		p_ext_4(i)(47) <= p_ext_3(i)(47);
	end generate;

--  d3
	HA_3_00 : half_adder PORT MAP (A => p_ext_4(0)(4), B => p_ext_4(1)(4), SUM => p_ext_5(0)(4), COUT => p_ext_5(0)(5));
	HA_3_01 : half_adder PORT MAP (A => p_ext_4(0)(5), B => p_ext_4(1)(5), SUM => p_ext_5(1)(5), COUT => p_ext_5(0)(6));
	
	FA_gen1:	
	for i in 6 to 45 generate
		FA_3_i0: full_adder PORT MAP (A => p_ext_4(0)(i), B=>p_ext_4(1)(i), CIN=>p_ext_4(2)(i), SUM=>p_ext_5(1)(i), COUT=>p_ext_5(0)(i+1));
	end generate;

	HA_3_42 : half_adder PORT MAP (A => p_ext_4(0)(46), B => p_ext_4(1)(46), SUM => p_ext_5(1)(46), COUT => p_ext_5(0)(47));

--	p_ext_5

	p_ext_5(0)(3 DOWNTO 0) <= p_ext_4(0)(3 DOWNTO 0);
	p_ext_5(1)(3 DOWNTO 0) <= p_ext_4(1)(3 DOWNTO 0);
	p_ext_5(2)(2) <= p_ext_4(2)(2);
	p_ext_5(1)(4) <= p_ext_4(2)(4);
	p_ext_5(2)(4) <= p_ext_4(3)(4);
	p_ext_5(2)(5) <= p_ext_4(2)(5);
	p_ext_5(2)(45 DOWNTO 6) <= p_ext_4(3)(45 DOWNTO 6);
	p_ext_5(2)(46) <= p_ext_4(2)(46);
	p_ext_5(1)(47) <= p_ext_4(0)(47);
	p_ext_5(2)(47) <= p_ext_4(1)(47);

--	d2
	HA_4_00 : half_adder PORT MAP (A => p_ext_5(0)(2), B => p_ext_5(1)(2), SUM => p_ext_6(0)(2), COUT => p_ext_6(0)(3));
	HA_4_01 : half_adder PORT MAP (A => p_ext_5(0)(3), B => p_ext_5(1)(3), SUM => p_ext_6(1)(3), COUT => p_ext_6(0)(4));
	
	FA_gen2:	
	for i in 4 to 47 generate
		FA_4_i0: full_adder PORT MAP (A => p_ext_5(0)(i), B=>p_ext_5(1)(i), CIN=>p_ext_5(2)(i), SUM=>p_ext_6(1)(i), COUT=>p_ext_6(0)(i+1));
	end generate;

--	p_ext_6

	p_ext_6(0)(0) <= p_ext_5(0)(0);
	p_ext_6(0)(1) <= p_ext_5(0)(1);
	p_ext_6(1)(0) <= p_ext_5(1)(0);
	p_ext_6(1)(2) <= p_ext_5(2)(2);
	p_ext_6(1)(1) <= '0';
	p_ext_6(1)(48) <= '0';
	RES <= unsigned('0' & p_ext_6(0)) + unsigned('0' & p_ext_6(1));
	PROD <= STD_LOGIC_VECTOR(RES(47 DOWNTO 0));
--unsigned('0' & p_ext_1(0)) + unsigned('0' & p_ext_1(1)) + unsigned('0' & p_ext_1(2)) + unsigned('0' & p_ext_1(3)) + unsigned('0' & p_ext_1(4)) + --unsigned('0' & p_ext_1(5)) + unsigned('0' & p_ext_1(6)) + unsigned('0' & p_ext_1(7)) + unsigned('0' & p_ext_1(8)) + unsigned('0' & p_ext_1(9)) + unsigned('0' & p_ext_1(10)) + unsigned('0' & p_ext_1(11)) + unsigned('0' & p_ext_1(12)); --
--	HA0: for i in 0 to 3 generate
--		HA00 : half_adder PORT MAP (A => p_ext_1(3*i)(2*i+16), B => p_ext_1(3*i+1)(2*i+16), SUM => p_ext_2(2*i)(2*i+16), COUT => p_ext_2(i)(2*i+17));
--		HA01 : half_adder PORT MAP (A => p_ext_1(3*i)(2*i+17), B => p_ext_1(3*i+1)(2*i+17), SUM => p_ext_2(2*i+1)(2*i+17), COUT => p_ext_2(i)(2*i+18));
--		HA00 : half_adder PORT MAP (A => p_ext_1(3*i)(2*i+16), B => p_ext_1(3*i+1)(2*i+16), SUM => sum_vect_1(2*i)(2*i+16), COUT => carry_vect_1(i)(2*i+17));
--		HA01 : half_adder PORT MAP (A => p_ext_1(3*i)(2*i+17), B => p_ext_1(3*i+1)(2*i+17), SUM => sum_vect_1(2*i+1)(2*i+17), COUT => carry_vect_1(i)(2*i+18));
--	end generate;
--	HA00 : half_adder PORT MAP (A => p_ext_1()(), B => p_ext_1()(), SUM => p_ext_2()(), COUT => p_ext_2()());
--  FA00 : full_adder PORT MAP (A => p_ext_1()(), B => p_ext_1()(), CIN => p_ext_1()(), SUM => p_ext_2()(), COUT => p_ext_2()());
--	sum_vect_1 <=
--	FA0: for i in 0 to 3 generate
--		FA1: for j in i to 4 generate
--			FA00 : full_adder PORT MAP (A => p_ext_1(3*i)(18+j), B => p_ext_1(3*i+1)(18+j), CIN => p_ext_1(3*i+2)(18+j), SUM => p_ext_2(i+j+1)(18+j), COUT => p_ext_2(i)(19+j));
--			FA01 : full_adder PORT MAP (A => p_ext_1(3*i)(19+j), B => p_ext_1(3*i+1)(19+j), CIN => p_ext_1(3*i+2)(19+j), SUM => p_ext_2(i+j+2)(19+j), COUT => p_ext_2(i)(20+j));
--		end generate;
--	end generate;

END ARCHITECTURE Structural;
