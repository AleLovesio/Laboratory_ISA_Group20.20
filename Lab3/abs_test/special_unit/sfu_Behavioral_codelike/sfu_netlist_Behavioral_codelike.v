
module sfu ( IN_A, IN_B, SFUOP, ZERO, OUTPUT );
  input [31:0] IN_A;
  input [31:0] IN_B;
  output [31:0] OUTPUT;
  input SFUOP;
  output ZERO;
  wire   n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25,
         n26, n27, n28, n29, n30, n31, n32, abs_v_n5, abs_v_n4,
         abs_v_add_32_n30, abs_v_add_32_n29, abs_v_add_32_n28,
         abs_v_add_32_n27, abs_v_add_32_n26, abs_v_add_32_n25,
         abs_v_add_32_n24, abs_v_add_32_n23, abs_v_add_32_n22,
         abs_v_add_32_n21, abs_v_add_32_n20, abs_v_add_32_n19,
         abs_v_add_32_n18, abs_v_add_32_n17, abs_v_add_32_n16,
         abs_v_add_32_n15, abs_v_add_32_n14, abs_v_add_32_n13,
         abs_v_add_32_n12, abs_v_add_32_n11, abs_v_add_32_n10, abs_v_add_32_n9,
         abs_v_add_32_n8, abs_v_add_32_n7, abs_v_add_32_n6, abs_v_add_32_n5,
         abs_v_add_32_n4, abs_v_add_32_n3, abs_v_add_32_n2, abs_v_add_32_n1;
  wire   [31:0] OUTPUT_ABS;
  wire   [30:0] abs_v_COMPL_INPUT;

  INV_X1 U56 ( .A(OUTPUT_ABS[2]), .ZN(n31) );
  INV_X1 U57 ( .A(OUTPUT_ABS[5]), .ZN(n30) );
  INV_X1 U58 ( .A(OUTPUT_ABS[6]), .ZN(n29) );
  INV_X1 U59 ( .A(OUTPUT_ABS[23]), .ZN(n28) );
  INV_X1 U60 ( .A(OUTPUT_ABS[24]), .ZN(n27) );
  INV_X1 U61 ( .A(OUTPUT_ABS[25]), .ZN(n26) );
  INV_X1 U62 ( .A(OUTPUT_ABS[26]), .ZN(n25) );
  INV_X1 U63 ( .A(OUTPUT_ABS[27]), .ZN(n24) );
  INV_X1 U64 ( .A(OUTPUT_ABS[28]), .ZN(n23) );
  INV_X1 U65 ( .A(OUTPUT_ABS[29]), .ZN(n22) );
  NOR4_X1 U66 ( .A1(OUTPUT_ABS[22]), .A2(OUTPUT_ABS[21]), .A3(OUTPUT_ABS[20]), 
        .A4(OUTPUT_ABS[1]), .ZN(n21) );
  NOR4_X1 U67 ( .A1(OUTPUT_ABS[4]), .A2(OUTPUT_ABS[3]), .A3(OUTPUT_ABS[31]), 
        .A4(OUTPUT_ABS[30]), .ZN(n17) );
  NOR4_X1 U68 ( .A1(n12), .A2(n13), .A3(n14), .A4(n15), .ZN(ZERO) );
  NAND4_X1 U69 ( .A1(n24), .A2(n23), .A3(n22), .A4(n31), .ZN(n14) );
  NAND4_X1 U70 ( .A1(n28), .A2(n27), .A3(n26), .A4(n25), .ZN(n15) );
  NAND4_X1 U71 ( .A1(n30), .A2(n29), .A3(n16), .A4(n17), .ZN(n13) );
  NOR3_X1 U72 ( .A1(OUTPUT_ABS[7]), .A2(OUTPUT_ABS[9]), .A3(OUTPUT_ABS[8]), 
        .ZN(n16) );
  NAND4_X1 U73 ( .A1(n18), .A2(n19), .A3(n20), .A4(n21), .ZN(n12) );
  NOR4_X1 U74 ( .A1(OUTPUT_ABS[11]), .A2(OUTPUT_ABS[10]), .A3(OUTPUT_ABS[0]), 
        .A4(n32), .ZN(n18) );
  NOR4_X1 U75 ( .A1(OUTPUT_ABS[15]), .A2(OUTPUT_ABS[14]), .A3(OUTPUT_ABS[13]), 
        .A4(OUTPUT_ABS[12]), .ZN(n19) );
  NOR4_X1 U76 ( .A1(OUTPUT_ABS[19]), .A2(OUTPUT_ABS[18]), .A3(OUTPUT_ABS[17]), 
        .A4(OUTPUT_ABS[16]), .ZN(n20) );
  NOR2_X1 U77 ( .A1(n32), .A2(n31), .ZN(OUTPUT[2]) );
  NOR2_X1 U78 ( .A1(n32), .A2(n30), .ZN(OUTPUT[5]) );
  NOR2_X1 U79 ( .A1(n32), .A2(n29), .ZN(OUTPUT[6]) );
  NOR2_X1 U80 ( .A1(n32), .A2(n28), .ZN(OUTPUT[23]) );
  NOR2_X1 U81 ( .A1(n32), .A2(n27), .ZN(OUTPUT[24]) );
  NOR2_X1 U82 ( .A1(n32), .A2(n26), .ZN(OUTPUT[25]) );
  NOR2_X1 U83 ( .A1(n32), .A2(n25), .ZN(OUTPUT[26]) );
  NOR2_X1 U84 ( .A1(n32), .A2(n24), .ZN(OUTPUT[27]) );
  NOR2_X1 U85 ( .A1(n32), .A2(n23), .ZN(OUTPUT[28]) );
  NOR2_X1 U86 ( .A1(n32), .A2(n22), .ZN(OUTPUT[29]) );
  INV_X1 U87 ( .A(SFUOP), .ZN(n32) );
  AND2_X1 U88 ( .A1(SFUOP), .A2(OUTPUT_ABS[0]), .ZN(OUTPUT[0]) );
  AND2_X1 U89 ( .A1(SFUOP), .A2(OUTPUT_ABS[1]), .ZN(OUTPUT[1]) );
  AND2_X1 U90 ( .A1(SFUOP), .A2(OUTPUT_ABS[12]), .ZN(OUTPUT[12]) );
  AND2_X1 U91 ( .A1(SFUOP), .A2(OUTPUT_ABS[8]), .ZN(OUTPUT[8]) );
  AND2_X1 U92 ( .A1(SFUOP), .A2(OUTPUT_ABS[9]), .ZN(OUTPUT[9]) );
  AND2_X1 U93 ( .A1(SFUOP), .A2(OUTPUT_ABS[13]), .ZN(OUTPUT[13]) );
  AND2_X1 U94 ( .A1(SFUOP), .A2(OUTPUT_ABS[16]), .ZN(OUTPUT[16]) );
  AND2_X1 U95 ( .A1(SFUOP), .A2(OUTPUT_ABS[17]), .ZN(OUTPUT[17]) );
  AND2_X1 U96 ( .A1(SFUOP), .A2(OUTPUT_ABS[20]), .ZN(OUTPUT[20]) );
  AND2_X1 U97 ( .A1(SFUOP), .A2(OUTPUT_ABS[30]), .ZN(OUTPUT[30]) );
  AND2_X1 U98 ( .A1(SFUOP), .A2(OUTPUT_ABS[3]), .ZN(OUTPUT[3]) );
  AND2_X1 U99 ( .A1(SFUOP), .A2(OUTPUT_ABS[4]), .ZN(OUTPUT[4]) );
  AND2_X1 U100 ( .A1(SFUOP), .A2(OUTPUT_ABS[7]), .ZN(OUTPUT[7]) );
  AND2_X1 U101 ( .A1(SFUOP), .A2(OUTPUT_ABS[10]), .ZN(OUTPUT[10]) );
  AND2_X1 U102 ( .A1(SFUOP), .A2(OUTPUT_ABS[11]), .ZN(OUTPUT[11]) );
  AND2_X1 U103 ( .A1(SFUOP), .A2(OUTPUT_ABS[14]), .ZN(OUTPUT[14]) );
  AND2_X1 U104 ( .A1(SFUOP), .A2(OUTPUT_ABS[15]), .ZN(OUTPUT[15]) );
  AND2_X1 U105 ( .A1(SFUOP), .A2(OUTPUT_ABS[18]), .ZN(OUTPUT[18]) );
  AND2_X1 U106 ( .A1(SFUOP), .A2(OUTPUT_ABS[19]), .ZN(OUTPUT[19]) );
  AND2_X1 U107 ( .A1(SFUOP), .A2(OUTPUT_ABS[21]), .ZN(OUTPUT[21]) );
  AND2_X1 U108 ( .A1(SFUOP), .A2(OUTPUT_ABS[22]), .ZN(OUTPUT[22]) );
  AND2_X1 U109 ( .A1(SFUOP), .A2(OUTPUT_ABS[31]), .ZN(OUTPUT[31]) );
  BUF_X1 abs_v_U37 ( .A(IN_A[31]), .Z(abs_v_n5) );
  BUF_X1 abs_v_U36 ( .A(IN_A[31]), .Z(abs_v_n4) );
  XOR2_X1 abs_v_U35 ( .A(abs_v_n5), .B(IN_A[0]), .Z(abs_v_COMPL_INPUT[0]) );
  XOR2_X1 abs_v_U34 ( .A(abs_v_n5), .B(IN_A[10]), .Z(abs_v_COMPL_INPUT[10]) );
  XOR2_X1 abs_v_U33 ( .A(abs_v_n5), .B(IN_A[11]), .Z(abs_v_COMPL_INPUT[11]) );
  XOR2_X1 abs_v_U32 ( .A(abs_v_n5), .B(IN_A[12]), .Z(abs_v_COMPL_INPUT[12]) );
  XOR2_X1 abs_v_U31 ( .A(abs_v_n5), .B(IN_A[13]), .Z(abs_v_COMPL_INPUT[13]) );
  XOR2_X1 abs_v_U30 ( .A(abs_v_n5), .B(IN_A[14]), .Z(abs_v_COMPL_INPUT[14]) );
  XOR2_X1 abs_v_U29 ( .A(abs_v_n5), .B(IN_A[15]), .Z(abs_v_COMPL_INPUT[15]) );
  XOR2_X1 abs_v_U28 ( .A(abs_v_n5), .B(IN_A[16]), .Z(abs_v_COMPL_INPUT[16]) );
  XOR2_X1 abs_v_U27 ( .A(abs_v_n5), .B(IN_A[17]), .Z(abs_v_COMPL_INPUT[17]) );
  XOR2_X1 abs_v_U26 ( .A(abs_v_n5), .B(IN_A[18]), .Z(abs_v_COMPL_INPUT[18]) );
  XOR2_X1 abs_v_U25 ( .A(abs_v_n5), .B(IN_A[19]), .Z(abs_v_COMPL_INPUT[19]) );
  XOR2_X1 abs_v_U24 ( .A(abs_v_n5), .B(IN_A[1]), .Z(abs_v_COMPL_INPUT[1]) );
  XOR2_X1 abs_v_U23 ( .A(abs_v_n5), .B(IN_A[20]), .Z(abs_v_COMPL_INPUT[20]) );
  XOR2_X1 abs_v_U22 ( .A(abs_v_n5), .B(IN_A[21]), .Z(abs_v_COMPL_INPUT[21]) );
  XOR2_X1 abs_v_U21 ( .A(abs_v_n5), .B(IN_A[22]), .Z(abs_v_COMPL_INPUT[22]) );
  XOR2_X1 abs_v_U20 ( .A(abs_v_n4), .B(IN_A[23]), .Z(abs_v_COMPL_INPUT[23]) );
  XOR2_X1 abs_v_U19 ( .A(abs_v_n4), .B(IN_A[24]), .Z(abs_v_COMPL_INPUT[24]) );
  XOR2_X1 abs_v_U18 ( .A(abs_v_n4), .B(IN_A[25]), .Z(abs_v_COMPL_INPUT[25]) );
  XOR2_X1 abs_v_U17 ( .A(abs_v_n4), .B(IN_A[26]), .Z(abs_v_COMPL_INPUT[26]) );
  XOR2_X1 abs_v_U16 ( .A(abs_v_n4), .B(IN_A[27]), .Z(abs_v_COMPL_INPUT[27]) );
  XOR2_X1 abs_v_U15 ( .A(abs_v_n4), .B(IN_A[28]), .Z(abs_v_COMPL_INPUT[28]) );
  XOR2_X1 abs_v_U14 ( .A(abs_v_n4), .B(IN_A[29]), .Z(abs_v_COMPL_INPUT[29]) );
  XOR2_X1 abs_v_U13 ( .A(abs_v_n4), .B(IN_A[2]), .Z(abs_v_COMPL_INPUT[2]) );
  XOR2_X1 abs_v_U12 ( .A(abs_v_n4), .B(IN_A[30]), .Z(abs_v_COMPL_INPUT[30]) );
  XOR2_X1 abs_v_U11 ( .A(IN_A[3]), .B(abs_v_n4), .Z(abs_v_COMPL_INPUT[3]) );
  XOR2_X1 abs_v_U10 ( .A(IN_A[4]), .B(abs_v_n4), .Z(abs_v_COMPL_INPUT[4]) );
  XOR2_X1 abs_v_U9 ( .A(IN_A[5]), .B(abs_v_n4), .Z(abs_v_COMPL_INPUT[5]) );
  XOR2_X1 abs_v_U8 ( .A(IN_A[6]), .B(abs_v_n4), .Z(abs_v_COMPL_INPUT[6]) );
  XOR2_X1 abs_v_U7 ( .A(IN_A[7]), .B(abs_v_n4), .Z(abs_v_COMPL_INPUT[7]) );
  XOR2_X1 abs_v_U6 ( .A(IN_A[8]), .B(abs_v_n4), .Z(abs_v_COMPL_INPUT[8]) );
  XOR2_X1 abs_v_U5 ( .A(IN_A[9]), .B(abs_v_n4), .Z(abs_v_COMPL_INPUT[9]) );
  XOR2_X1 abs_v_add_32_U62 ( .A(abs_v_COMPL_INPUT[7]), .B(abs_v_add_32_n6), 
        .Z(OUTPUT_ABS[7]) );
  AND2_X1 abs_v_add_32_U61 ( .A1(abs_v_COMPL_INPUT[30]), .A2(abs_v_add_32_n29), 
        .ZN(OUTPUT_ABS[31]) );
  XOR2_X1 abs_v_add_32_U60 ( .A(abs_v_COMPL_INPUT[4]), .B(abs_v_add_32_n3), 
        .Z(OUTPUT_ABS[4]) );
  XOR2_X1 abs_v_add_32_U59 ( .A(abs_v_COMPL_INPUT[11]), .B(abs_v_add_32_n10), 
        .Z(OUTPUT_ABS[11]) );
  XOR2_X1 abs_v_add_32_U58 ( .A(abs_v_COMPL_INPUT[15]), .B(abs_v_add_32_n14), 
        .Z(OUTPUT_ABS[15]) );
  XOR2_X1 abs_v_add_32_U57 ( .A(abs_v_COMPL_INPUT[19]), .B(abs_v_add_32_n18), 
        .Z(OUTPUT_ABS[19]) );
  XOR2_X1 abs_v_add_32_U56 ( .A(abs_v_COMPL_INPUT[22]), .B(abs_v_add_32_n21), 
        .Z(OUTPUT_ABS[22]) );
  XOR2_X1 abs_v_add_32_U55 ( .A(abs_v_COMPL_INPUT[3]), .B(abs_v_add_32_n2), 
        .Z(OUTPUT_ABS[3]) );
  XOR2_X1 abs_v_add_32_U54 ( .A(abs_v_COMPL_INPUT[10]), .B(abs_v_add_32_n9), 
        .Z(OUTPUT_ABS[10]) );
  XOR2_X1 abs_v_add_32_U53 ( .A(abs_v_COMPL_INPUT[14]), .B(abs_v_add_32_n13), 
        .Z(OUTPUT_ABS[14]) );
  XOR2_X1 abs_v_add_32_U52 ( .A(abs_v_COMPL_INPUT[18]), .B(abs_v_add_32_n17), 
        .Z(OUTPUT_ABS[18]) );
  XOR2_X1 abs_v_add_32_U51 ( .A(abs_v_COMPL_INPUT[21]), .B(abs_v_add_32_n20), 
        .Z(OUTPUT_ABS[21]) );
  XOR2_X1 abs_v_add_32_U50 ( .A(abs_v_COMPL_INPUT[9]), .B(abs_v_add_32_n8), 
        .Z(OUTPUT_ABS[9]) );
  XOR2_X1 abs_v_add_32_U49 ( .A(abs_v_COMPL_INPUT[8]), .B(abs_v_add_32_n7), 
        .Z(OUTPUT_ABS[8]) );
  XOR2_X1 abs_v_add_32_U48 ( .A(abs_v_COMPL_INPUT[5]), .B(abs_v_add_32_n4), 
        .Z(OUTPUT_ABS[5]) );
  XOR2_X1 abs_v_add_32_U47 ( .A(abs_v_COMPL_INPUT[27]), .B(abs_v_add_32_n26), 
        .Z(OUTPUT_ABS[27]) );
  XOR2_X1 abs_v_add_32_U46 ( .A(abs_v_COMPL_INPUT[23]), .B(abs_v_add_32_n22), 
        .Z(OUTPUT_ABS[23]) );
  XOR2_X1 abs_v_add_32_U45 ( .A(abs_v_COMPL_INPUT[13]), .B(abs_v_add_32_n12), 
        .Z(OUTPUT_ABS[13]) );
  XOR2_X1 abs_v_add_32_U44 ( .A(abs_v_COMPL_INPUT[17]), .B(abs_v_add_32_n16), 
        .Z(OUTPUT_ABS[17]) );
  XOR2_X1 abs_v_add_32_U43 ( .A(abs_v_COMPL_INPUT[20]), .B(abs_v_add_32_n19), 
        .Z(OUTPUT_ABS[20]) );
  XOR2_X1 abs_v_add_32_U42 ( .A(abs_v_COMPL_INPUT[30]), .B(abs_v_add_32_n29), 
        .Z(OUTPUT_ABS[30]) );
  XOR2_X1 abs_v_add_32_U41 ( .A(abs_v_COMPL_INPUT[12]), .B(abs_v_add_32_n11), 
        .Z(OUTPUT_ABS[12]) );
  XOR2_X1 abs_v_add_32_U40 ( .A(abs_v_COMPL_INPUT[16]), .B(abs_v_add_32_n15), 
        .Z(OUTPUT_ABS[16]) );
  XOR2_X1 abs_v_add_32_U39 ( .A(abs_v_COMPL_INPUT[1]), .B(abs_v_add_32_n30), 
        .Z(OUTPUT_ABS[1]) );
  XOR2_X1 abs_v_add_32_U38 ( .A(abs_v_COMPL_INPUT[6]), .B(abs_v_add_32_n5), 
        .Z(OUTPUT_ABS[6]) );
  XOR2_X1 abs_v_add_32_U37 ( .A(abs_v_COMPL_INPUT[28]), .B(abs_v_add_32_n27), 
        .Z(OUTPUT_ABS[28]) );
  XOR2_X1 abs_v_add_32_U36 ( .A(abs_v_COMPL_INPUT[24]), .B(abs_v_add_32_n23), 
        .Z(OUTPUT_ABS[24]) );
  XOR2_X1 abs_v_add_32_U35 ( .A(abs_v_n4), .B(abs_v_COMPL_INPUT[0]), .Z(
        OUTPUT_ABS[0]) );
  XOR2_X1 abs_v_add_32_U34 ( .A(abs_v_COMPL_INPUT[29]), .B(abs_v_add_32_n28), 
        .Z(OUTPUT_ABS[29]) );
  XOR2_X1 abs_v_add_32_U33 ( .A(abs_v_COMPL_INPUT[25]), .B(abs_v_add_32_n24), 
        .Z(OUTPUT_ABS[25]) );
  XOR2_X1 abs_v_add_32_U32 ( .A(abs_v_COMPL_INPUT[26]), .B(abs_v_add_32_n25), 
        .Z(OUTPUT_ABS[26]) );
  XOR2_X1 abs_v_add_32_U31 ( .A(abs_v_COMPL_INPUT[2]), .B(abs_v_add_32_n1), 
        .Z(OUTPUT_ABS[2]) );
  AND2_X1 abs_v_add_32_U30 ( .A1(abs_v_n4), .A2(abs_v_COMPL_INPUT[0]), .ZN(
        abs_v_add_32_n30) );
  AND2_X1 abs_v_add_32_U29 ( .A1(abs_v_COMPL_INPUT[29]), .A2(abs_v_add_32_n28), 
        .ZN(abs_v_add_32_n29) );
  AND2_X1 abs_v_add_32_U28 ( .A1(abs_v_COMPL_INPUT[28]), .A2(abs_v_add_32_n27), 
        .ZN(abs_v_add_32_n28) );
  AND2_X1 abs_v_add_32_U27 ( .A1(abs_v_COMPL_INPUT[27]), .A2(abs_v_add_32_n26), 
        .ZN(abs_v_add_32_n27) );
  AND2_X1 abs_v_add_32_U26 ( .A1(abs_v_COMPL_INPUT[26]), .A2(abs_v_add_32_n25), 
        .ZN(abs_v_add_32_n26) );
  AND2_X1 abs_v_add_32_U25 ( .A1(abs_v_COMPL_INPUT[25]), .A2(abs_v_add_32_n24), 
        .ZN(abs_v_add_32_n25) );
  AND2_X1 abs_v_add_32_U24 ( .A1(abs_v_COMPL_INPUT[24]), .A2(abs_v_add_32_n23), 
        .ZN(abs_v_add_32_n24) );
  AND2_X1 abs_v_add_32_U23 ( .A1(abs_v_COMPL_INPUT[23]), .A2(abs_v_add_32_n22), 
        .ZN(abs_v_add_32_n23) );
  AND2_X1 abs_v_add_32_U22 ( .A1(abs_v_COMPL_INPUT[22]), .A2(abs_v_add_32_n21), 
        .ZN(abs_v_add_32_n22) );
  AND2_X1 abs_v_add_32_U21 ( .A1(abs_v_COMPL_INPUT[21]), .A2(abs_v_add_32_n20), 
        .ZN(abs_v_add_32_n21) );
  AND2_X1 abs_v_add_32_U20 ( .A1(abs_v_COMPL_INPUT[20]), .A2(abs_v_add_32_n19), 
        .ZN(abs_v_add_32_n20) );
  AND2_X1 abs_v_add_32_U19 ( .A1(abs_v_COMPL_INPUT[19]), .A2(abs_v_add_32_n18), 
        .ZN(abs_v_add_32_n19) );
  AND2_X1 abs_v_add_32_U18 ( .A1(abs_v_COMPL_INPUT[18]), .A2(abs_v_add_32_n17), 
        .ZN(abs_v_add_32_n18) );
  AND2_X1 abs_v_add_32_U17 ( .A1(abs_v_COMPL_INPUT[17]), .A2(abs_v_add_32_n16), 
        .ZN(abs_v_add_32_n17) );
  AND2_X1 abs_v_add_32_U16 ( .A1(abs_v_COMPL_INPUT[16]), .A2(abs_v_add_32_n15), 
        .ZN(abs_v_add_32_n16) );
  AND2_X1 abs_v_add_32_U15 ( .A1(abs_v_COMPL_INPUT[15]), .A2(abs_v_add_32_n14), 
        .ZN(abs_v_add_32_n15) );
  AND2_X1 abs_v_add_32_U14 ( .A1(abs_v_COMPL_INPUT[14]), .A2(abs_v_add_32_n13), 
        .ZN(abs_v_add_32_n14) );
  AND2_X1 abs_v_add_32_U13 ( .A1(abs_v_COMPL_INPUT[13]), .A2(abs_v_add_32_n12), 
        .ZN(abs_v_add_32_n13) );
  AND2_X1 abs_v_add_32_U12 ( .A1(abs_v_COMPL_INPUT[12]), .A2(abs_v_add_32_n11), 
        .ZN(abs_v_add_32_n12) );
  AND2_X1 abs_v_add_32_U11 ( .A1(abs_v_COMPL_INPUT[11]), .A2(abs_v_add_32_n10), 
        .ZN(abs_v_add_32_n11) );
  AND2_X1 abs_v_add_32_U10 ( .A1(abs_v_COMPL_INPUT[10]), .A2(abs_v_add_32_n9), 
        .ZN(abs_v_add_32_n10) );
  AND2_X1 abs_v_add_32_U9 ( .A1(abs_v_COMPL_INPUT[9]), .A2(abs_v_add_32_n8), 
        .ZN(abs_v_add_32_n9) );
  AND2_X1 abs_v_add_32_U8 ( .A1(abs_v_COMPL_INPUT[8]), .A2(abs_v_add_32_n7), 
        .ZN(abs_v_add_32_n8) );
  AND2_X1 abs_v_add_32_U7 ( .A1(abs_v_COMPL_INPUT[7]), .A2(abs_v_add_32_n6), 
        .ZN(abs_v_add_32_n7) );
  AND2_X1 abs_v_add_32_U6 ( .A1(abs_v_COMPL_INPUT[6]), .A2(abs_v_add_32_n5), 
        .ZN(abs_v_add_32_n6) );
  AND2_X1 abs_v_add_32_U5 ( .A1(abs_v_COMPL_INPUT[5]), .A2(abs_v_add_32_n4), 
        .ZN(abs_v_add_32_n5) );
  AND2_X1 abs_v_add_32_U4 ( .A1(abs_v_COMPL_INPUT[4]), .A2(abs_v_add_32_n3), 
        .ZN(abs_v_add_32_n4) );
  AND2_X1 abs_v_add_32_U3 ( .A1(abs_v_COMPL_INPUT[3]), .A2(abs_v_add_32_n2), 
        .ZN(abs_v_add_32_n3) );
  AND2_X1 abs_v_add_32_U2 ( .A1(abs_v_COMPL_INPUT[2]), .A2(abs_v_add_32_n1), 
        .ZN(abs_v_add_32_n2) );
  AND2_X1 abs_v_add_32_U1 ( .A1(abs_v_COMPL_INPUT[1]), .A2(abs_v_add_32_n30), 
        .ZN(abs_v_add_32_n1) );
endmodule

