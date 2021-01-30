
module sfu ( IN_A, IN_B, SFUOP, ZERO, OUTPUT );
  input [31:0] IN_A;
  input [31:0] IN_B;
  output [31:0] OUTPUT;
  input SFUOP;
  output ZERO;
  wire   n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25,
         n26, n27, n28, n29, n30, n31, n32, abs_v_n23, abs_v_n22, abs_v_n21,
         abs_v_n20, abs_v_n19, abs_v_n18, abs_v_n17, abs_v_n16, abs_v_n15,
         abs_v_n14, abs_v_n13, abs_v_n12, abs_v_n11, abs_v_n10, abs_v_n9,
         abs_v_n8, abs_v_n7, abs_v_n6, abs_v_n5, abs_v_n2, abs_v_n1, abs_v_n67,
         abs_v_n66, abs_v_n65, abs_v_n64, abs_v_n63, abs_v_n62, abs_v_n61,
         abs_v_n60, abs_v_n59, abs_v_n58, abs_v_n57, abs_v_n56, abs_v_n55,
         abs_v_n54, abs_v_n53, abs_v_n52, abs_v_n51, abs_v_n50, abs_v_n49,
         abs_v_n48, abs_v_n47, abs_v_n46, abs_v_n45, abs_v_n44, abs_v_n43,
         abs_v_n42, abs_v_n41, abs_v_n40, abs_v_n39, abs_v_n38, abs_v_n37,
         abs_v_NEG_OUTPUT_1_, abs_v_NEG_OUTPUT_2_, abs_v_NEG_OUTPUT_3_,
         abs_v_NEG_OUTPUT_4_, abs_v_NEG_OUTPUT_5_, abs_v_NEG_OUTPUT_6_,
         abs_v_NEG_OUTPUT_7_, abs_v_NEG_OUTPUT_8_, abs_v_NEG_OUTPUT_9_,
         abs_v_NEG_OUTPUT_10_, abs_v_NEG_OUTPUT_11_, abs_v_NEG_OUTPUT_12_,
         abs_v_NEG_OUTPUT_13_, abs_v_NEG_OUTPUT_14_, abs_v_NEG_OUTPUT_15_,
         abs_v_NEG_OUTPUT_16_, abs_v_NEG_OUTPUT_17_, abs_v_NEG_OUTPUT_18_,
         abs_v_NEG_OUTPUT_19_, abs_v_NEG_OUTPUT_20_, abs_v_NEG_OUTPUT_21_,
         abs_v_NEG_OUTPUT_22_, abs_v_NEG_OUTPUT_23_, abs_v_NEG_OUTPUT_24_,
         abs_v_NEG_OUTPUT_25_, abs_v_NEG_OUTPUT_26_, abs_v_NEG_OUTPUT_27_,
         abs_v_NEG_OUTPUT_28_, abs_v_NEG_OUTPUT_29_, abs_v_NEG_OUTPUT_30_,
         abs_v_NEG_OUTPUT_31_, abs_v_sub_add_22_b0_n93,
         abs_v_sub_add_22_b0_n92, abs_v_sub_add_22_b0_n91,
         abs_v_sub_add_22_b0_n90, abs_v_sub_add_22_b0_n89,
         abs_v_sub_add_22_b0_n88, abs_v_sub_add_22_b0_n87,
         abs_v_sub_add_22_b0_n86, abs_v_sub_add_22_b0_n85,
         abs_v_sub_add_22_b0_n84, abs_v_sub_add_22_b0_n83,
         abs_v_sub_add_22_b0_n82, abs_v_sub_add_22_b0_n81,
         abs_v_sub_add_22_b0_n80, abs_v_sub_add_22_b0_n79,
         abs_v_sub_add_22_b0_n78, abs_v_sub_add_22_b0_n77,
         abs_v_sub_add_22_b0_n76, abs_v_sub_add_22_b0_n75,
         abs_v_sub_add_22_b0_n74, abs_v_sub_add_22_b0_n73,
         abs_v_sub_add_22_b0_n72, abs_v_sub_add_22_b0_n71,
         abs_v_sub_add_22_b0_n70, abs_v_sub_add_22_b0_n69,
         abs_v_sub_add_22_b0_n68, abs_v_sub_add_22_b0_n67,
         abs_v_sub_add_22_b0_n66, abs_v_sub_add_22_b0_n65,
         abs_v_sub_add_22_b0_n64, abs_v_sub_add_22_b0_n63,
         abs_v_sub_add_22_b0_n62, abs_v_sub_add_22_b0_n61,
         abs_v_sub_add_22_b0_n60, abs_v_sub_add_22_b0_n59,
         abs_v_sub_add_22_b0_n58, abs_v_sub_add_22_b0_n57,
         abs_v_sub_add_22_b0_n56, abs_v_sub_add_22_b0_n55,
         abs_v_sub_add_22_b0_n54, abs_v_sub_add_22_b0_n53,
         abs_v_sub_add_22_b0_n52, abs_v_sub_add_22_b0_n51,
         abs_v_sub_add_22_b0_n50, abs_v_sub_add_22_b0_n49,
         abs_v_sub_add_22_b0_n48, abs_v_sub_add_22_b0_n47,
         abs_v_sub_add_22_b0_n46, abs_v_sub_add_22_b0_n45,
         abs_v_sub_add_22_b0_n44, abs_v_sub_add_22_b0_n43,
         abs_v_sub_add_22_b0_n42, abs_v_sub_add_22_b0_n41,
         abs_v_sub_add_22_b0_n40, abs_v_sub_add_22_b0_n39,
         abs_v_sub_add_22_b0_n38, abs_v_sub_add_22_b0_n37,
         abs_v_sub_add_22_b0_n36, abs_v_sub_add_22_b0_n35,
         abs_v_sub_add_22_b0_n34, abs_v_sub_add_22_b0_n33,
         abs_v_sub_add_22_b0_n32;
  wire   [31:0] OUTPUT_ABS;

  NOR4_X1 U56 ( .A1(OUTPUT_ABS[22]), .A2(OUTPUT_ABS[21]), .A3(OUTPUT_ABS[20]), 
        .A4(OUTPUT_ABS[1]), .ZN(n21) );
  NOR4_X1 U57 ( .A1(OUTPUT_ABS[4]), .A2(OUTPUT_ABS[3]), .A3(OUTPUT_ABS[31]), 
        .A4(OUTPUT_ABS[30]), .ZN(n17) );
  NOR4_X1 U58 ( .A1(n12), .A2(n13), .A3(n14), .A4(n15), .ZN(ZERO) );
  NAND4_X1 U59 ( .A1(n24), .A2(n23), .A3(n22), .A4(n31), .ZN(n14) );
  NAND4_X1 U60 ( .A1(n28), .A2(n27), .A3(n26), .A4(n25), .ZN(n15) );
  NAND4_X1 U61 ( .A1(n30), .A2(n29), .A3(n16), .A4(n17), .ZN(n13) );
  NOR3_X1 U62 ( .A1(OUTPUT_ABS[7]), .A2(OUTPUT_ABS[9]), .A3(OUTPUT_ABS[8]), 
        .ZN(n16) );
  NAND4_X1 U63 ( .A1(n18), .A2(n19), .A3(n20), .A4(n21), .ZN(n12) );
  NOR4_X1 U64 ( .A1(OUTPUT_ABS[11]), .A2(OUTPUT_ABS[10]), .A3(OUTPUT_ABS[0]), 
        .A4(n32), .ZN(n18) );
  NOR4_X1 U65 ( .A1(OUTPUT_ABS[15]), .A2(OUTPUT_ABS[14]), .A3(OUTPUT_ABS[13]), 
        .A4(OUTPUT_ABS[12]), .ZN(n19) );
  NOR4_X1 U66 ( .A1(OUTPUT_ABS[19]), .A2(OUTPUT_ABS[18]), .A3(OUTPUT_ABS[17]), 
        .A4(OUTPUT_ABS[16]), .ZN(n20) );
  NOR2_X1 U67 ( .A1(n32), .A2(n31), .ZN(OUTPUT[2]) );
  NOR2_X1 U68 ( .A1(n32), .A2(n30), .ZN(OUTPUT[5]) );
  NOR2_X1 U69 ( .A1(n32), .A2(n29), .ZN(OUTPUT[6]) );
  NOR2_X1 U70 ( .A1(n32), .A2(n28), .ZN(OUTPUT[23]) );
  NOR2_X1 U71 ( .A1(n32), .A2(n27), .ZN(OUTPUT[24]) );
  NOR2_X1 U72 ( .A1(n32), .A2(n26), .ZN(OUTPUT[25]) );
  NOR2_X1 U73 ( .A1(n32), .A2(n25), .ZN(OUTPUT[26]) );
  NOR2_X1 U74 ( .A1(n32), .A2(n24), .ZN(OUTPUT[27]) );
  NOR2_X1 U75 ( .A1(n32), .A2(n23), .ZN(OUTPUT[28]) );
  NOR2_X1 U76 ( .A1(n32), .A2(n22), .ZN(OUTPUT[29]) );
  INV_X1 U77 ( .A(SFUOP), .ZN(n32) );
  INV_X1 U78 ( .A(OUTPUT_ABS[2]), .ZN(n31) );
  INV_X1 U79 ( .A(OUTPUT_ABS[26]), .ZN(n25) );
  INV_X1 U80 ( .A(OUTPUT_ABS[25]), .ZN(n26) );
  INV_X1 U81 ( .A(OUTPUT_ABS[29]), .ZN(n22) );
  INV_X1 U82 ( .A(OUTPUT_ABS[6]), .ZN(n29) );
  INV_X1 U83 ( .A(OUTPUT_ABS[24]), .ZN(n27) );
  INV_X1 U84 ( .A(OUTPUT_ABS[28]), .ZN(n23) );
  INV_X1 U85 ( .A(OUTPUT_ABS[5]), .ZN(n30) );
  INV_X1 U86 ( .A(OUTPUT_ABS[23]), .ZN(n28) );
  INV_X1 U87 ( .A(OUTPUT_ABS[27]), .ZN(n24) );
  AND2_X1 U88 ( .A1(SFUOP), .A2(OUTPUT_ABS[31]), .ZN(OUTPUT[31]) );
  AND2_X1 U89 ( .A1(SFUOP), .A2(OUTPUT_ABS[1]), .ZN(OUTPUT[1]) );
  AND2_X1 U90 ( .A1(SFUOP), .A2(OUTPUT_ABS[16]), .ZN(OUTPUT[16]) );
  AND2_X1 U91 ( .A1(SFUOP), .A2(OUTPUT_ABS[30]), .ZN(OUTPUT[30]) );
  AND2_X1 U92 ( .A1(SFUOP), .A2(OUTPUT_ABS[3]), .ZN(OUTPUT[3]) );
  AND2_X1 U93 ( .A1(SFUOP), .A2(OUTPUT_ABS[8]), .ZN(OUTPUT[8]) );
  AND2_X1 U94 ( .A1(SFUOP), .A2(OUTPUT_ABS[9]), .ZN(OUTPUT[9]) );
  AND2_X1 U95 ( .A1(SFUOP), .A2(OUTPUT_ABS[17]), .ZN(OUTPUT[17]) );
  AND2_X1 U96 ( .A1(SFUOP), .A2(OUTPUT_ABS[18]), .ZN(OUTPUT[18]) );
  AND2_X1 U97 ( .A1(SFUOP), .A2(OUTPUT_ABS[20]), .ZN(OUTPUT[20]) );
  AND2_X1 U98 ( .A1(SFUOP), .A2(OUTPUT_ABS[4]), .ZN(OUTPUT[4]) );
  AND2_X1 U99 ( .A1(SFUOP), .A2(OUTPUT_ABS[7]), .ZN(OUTPUT[7]) );
  AND2_X1 U100 ( .A1(SFUOP), .A2(OUTPUT_ABS[19]), .ZN(OUTPUT[19]) );
  AND2_X1 U101 ( .A1(SFUOP), .A2(OUTPUT_ABS[21]), .ZN(OUTPUT[21]) );
  AND2_X1 U102 ( .A1(SFUOP), .A2(OUTPUT_ABS[22]), .ZN(OUTPUT[22]) );
  AND2_X1 U103 ( .A1(SFUOP), .A2(OUTPUT_ABS[0]), .ZN(OUTPUT[0]) );
  AND2_X1 U104 ( .A1(SFUOP), .A2(OUTPUT_ABS[12]), .ZN(OUTPUT[12]) );
  AND2_X1 U105 ( .A1(SFUOP), .A2(OUTPUT_ABS[13]), .ZN(OUTPUT[13]) );
  AND2_X1 U106 ( .A1(SFUOP), .A2(OUTPUT_ABS[10]), .ZN(OUTPUT[10]) );
  AND2_X1 U107 ( .A1(SFUOP), .A2(OUTPUT_ABS[11]), .ZN(OUTPUT[11]) );
  AND2_X1 U108 ( .A1(SFUOP), .A2(OUTPUT_ABS[14]), .ZN(OUTPUT[14]) );
  AND2_X1 U109 ( .A1(SFUOP), .A2(OUTPUT_ABS[15]), .ZN(OUTPUT[15]) );
  INV_X1 abs_v_U87 ( .A(IN_A[31]), .ZN(abs_v_n23) );
  CLKBUF_X1 abs_v_U86 ( .A(abs_v_n6), .Z(abs_v_n22) );
  CLKBUF_X1 abs_v_U85 ( .A(abs_v_n8), .Z(abs_v_n21) );
  CLKBUF_X1 abs_v_U84 ( .A(abs_v_n23), .Z(abs_v_n20) );
  CLKBUF_X1 abs_v_U83 ( .A(abs_v_n7), .Z(abs_v_n19) );
  CLKBUF_X1 abs_v_U82 ( .A(abs_v_n10), .Z(abs_v_n18) );
  CLKBUF_X1 abs_v_U81 ( .A(abs_v_n9), .Z(abs_v_n17) );
  CLKBUF_X1 abs_v_U80 ( .A(abs_v_n23), .Z(abs_v_n16) );
  CLKBUF_X1 abs_v_U79 ( .A(abs_v_n23), .Z(abs_v_n15) );
  CLKBUF_X1 abs_v_U78 ( .A(abs_v_n23), .Z(abs_v_n14) );
  CLKBUF_X1 abs_v_U77 ( .A(abs_v_n14), .Z(abs_v_n13) );
  CLKBUF_X1 abs_v_U76 ( .A(abs_v_n20), .Z(abs_v_n12) );
  CLKBUF_X1 abs_v_U75 ( .A(abs_v_n18), .Z(abs_v_n11) );
  CLKBUF_X1 abs_v_U74 ( .A(abs_v_n16), .Z(abs_v_n10) );
  CLKBUF_X1 abs_v_U73 ( .A(abs_v_n15), .Z(abs_v_n9) );
  CLKBUF_X1 abs_v_U72 ( .A(abs_v_n13), .Z(abs_v_n8) );
  CLKBUF_X1 abs_v_U71 ( .A(abs_v_n17), .Z(abs_v_n7) );
  CLKBUF_X1 abs_v_U70 ( .A(abs_v_n12), .Z(abs_v_n6) );
  AOI22_X1 abs_v_U69 ( .A1(IN_A[11]), .A2(abs_v_n20), .B1(abs_v_NEG_OUTPUT_11_), .B2(abs_v_n5), .ZN(abs_v_n65) );
  INV_X1 abs_v_U68 ( .A(abs_v_n65), .ZN(OUTPUT_ABS[11]) );
  AOI22_X1 abs_v_U67 ( .A1(IN_A[15]), .A2(abs_v_n18), .B1(abs_v_NEG_OUTPUT_15_), .B2(abs_v_n5), .ZN(abs_v_n61) );
  INV_X1 abs_v_U66 ( .A(abs_v_n61), .ZN(OUTPUT_ABS[15]) );
  AOI22_X1 abs_v_U65 ( .A1(IN_A[10]), .A2(abs_v_n20), .B1(abs_v_NEG_OUTPUT_10_), .B2(abs_v_n5), .ZN(abs_v_n66) );
  INV_X1 abs_v_U64 ( .A(abs_v_n66), .ZN(OUTPUT_ABS[10]) );
  AOI22_X1 abs_v_U63 ( .A1(IN_A[14]), .A2(abs_v_n18), .B1(abs_v_NEG_OUTPUT_14_), .B2(abs_v_n5), .ZN(abs_v_n62) );
  INV_X1 abs_v_U62 ( .A(abs_v_n62), .ZN(OUTPUT_ABS[14]) );
  AOI22_X1 abs_v_U61 ( .A1(IN_A[0]), .A2(abs_v_n21), .B1(IN_A[0]), .B2(
        abs_v_n5), .ZN(abs_v_n67) );
  INV_X1 abs_v_U60 ( .A(abs_v_n67), .ZN(OUTPUT_ABS[0]) );
  AOI22_X1 abs_v_U59 ( .A1(IN_A[13]), .A2(abs_v_n19), .B1(abs_v_NEG_OUTPUT_13_), .B2(abs_v_n5), .ZN(abs_v_n63) );
  INV_X1 abs_v_U58 ( .A(abs_v_n63), .ZN(OUTPUT_ABS[13]) );
  AOI22_X1 abs_v_U57 ( .A1(IN_A[12]), .A2(abs_v_n19), .B1(abs_v_NEG_OUTPUT_12_), .B2(abs_v_n5), .ZN(abs_v_n64) );
  INV_X1 abs_v_U56 ( .A(abs_v_n64), .ZN(OUTPUT_ABS[12]) );
  AOI22_X1 abs_v_U55 ( .A1(IN_A[27]), .A2(abs_v_n11), .B1(abs_v_NEG_OUTPUT_27_), .B2(abs_v_n1), .ZN(abs_v_n48) );
  INV_X1 abs_v_U54 ( .A(abs_v_n48), .ZN(OUTPUT_ABS[27]) );
  AOI22_X1 abs_v_U53 ( .A1(IN_A[23]), .A2(abs_v_n13), .B1(abs_v_NEG_OUTPUT_23_), .B2(abs_v_n2), .ZN(abs_v_n52) );
  INV_X1 abs_v_U52 ( .A(abs_v_n52), .ZN(OUTPUT_ABS[23]) );
  AOI22_X1 abs_v_U51 ( .A1(IN_A[5]), .A2(abs_v_n8), .B1(abs_v_NEG_OUTPUT_5_), 
        .B2(abs_v_n1), .ZN(abs_v_n41) );
  INV_X1 abs_v_U50 ( .A(abs_v_n41), .ZN(OUTPUT_ABS[5]) );
  AOI22_X1 abs_v_U49 ( .A1(IN_A[7]), .A2(abs_v_n7), .B1(abs_v_NEG_OUTPUT_7_), 
        .B2(abs_v_n1), .ZN(abs_v_n39) );
  INV_X1 abs_v_U48 ( .A(abs_v_n39), .ZN(OUTPUT_ABS[7]) );
  AOI22_X1 abs_v_U47 ( .A1(IN_A[4]), .A2(abs_v_n8), .B1(abs_v_NEG_OUTPUT_4_), 
        .B2(abs_v_n1), .ZN(abs_v_n42) );
  INV_X1 abs_v_U46 ( .A(abs_v_n42), .ZN(OUTPUT_ABS[4]) );
  AOI22_X1 abs_v_U45 ( .A1(IN_A[19]), .A2(abs_v_n16), .B1(abs_v_NEG_OUTPUT_19_), .B2(abs_v_n2), .ZN(abs_v_n57) );
  INV_X1 abs_v_U44 ( .A(abs_v_n57), .ZN(OUTPUT_ABS[19]) );
  AOI22_X1 abs_v_U43 ( .A1(IN_A[22]), .A2(abs_v_n14), .B1(abs_v_NEG_OUTPUT_22_), .B2(abs_v_n2), .ZN(abs_v_n53) );
  INV_X1 abs_v_U42 ( .A(abs_v_n53), .ZN(OUTPUT_ABS[22]) );
  AOI22_X1 abs_v_U41 ( .A1(IN_A[3]), .A2(abs_v_n9), .B1(abs_v_NEG_OUTPUT_3_), 
        .B2(abs_v_n1), .ZN(abs_v_n43) );
  INV_X1 abs_v_U40 ( .A(abs_v_n43), .ZN(OUTPUT_ABS[3]) );
  AOI22_X1 abs_v_U39 ( .A1(IN_A[18]), .A2(abs_v_n16), .B1(abs_v_NEG_OUTPUT_18_), .B2(abs_v_n2), .ZN(abs_v_n58) );
  INV_X1 abs_v_U38 ( .A(abs_v_n58), .ZN(OUTPUT_ABS[18]) );
  AOI22_X1 abs_v_U37 ( .A1(IN_A[21]), .A2(abs_v_n14), .B1(abs_v_NEG_OUTPUT_21_), .B2(abs_v_n2), .ZN(abs_v_n54) );
  INV_X1 abs_v_U36 ( .A(abs_v_n54), .ZN(OUTPUT_ABS[21]) );
  AOI22_X1 abs_v_U35 ( .A1(IN_A[9]), .A2(abs_v_n6), .B1(abs_v_NEG_OUTPUT_9_), 
        .B2(abs_v_n2), .ZN(abs_v_n37) );
  INV_X1 abs_v_U34 ( .A(abs_v_n37), .ZN(OUTPUT_ABS[9]) );
  AOI22_X1 abs_v_U33 ( .A1(IN_A[8]), .A2(abs_v_n6), .B1(abs_v_NEG_OUTPUT_8_), 
        .B2(abs_v_n1), .ZN(abs_v_n38) );
  INV_X1 abs_v_U32 ( .A(abs_v_n38), .ZN(OUTPUT_ABS[8]) );
  AOI22_X1 abs_v_U31 ( .A1(IN_A[17]), .A2(abs_v_n17), .B1(abs_v_NEG_OUTPUT_17_), .B2(abs_v_n2), .ZN(abs_v_n59) );
  INV_X1 abs_v_U30 ( .A(abs_v_n59), .ZN(OUTPUT_ABS[17]) );
  AOI22_X1 abs_v_U29 ( .A1(IN_A[20]), .A2(abs_v_n15), .B1(abs_v_NEG_OUTPUT_20_), .B2(abs_v_n2), .ZN(abs_v_n55) );
  INV_X1 abs_v_U28 ( .A(abs_v_n55), .ZN(OUTPUT_ABS[20]) );
  AOI22_X1 abs_v_U27 ( .A1(IN_A[30]), .A2(abs_v_n9), .B1(abs_v_NEG_OUTPUT_30_), 
        .B2(abs_v_n1), .ZN(abs_v_n44) );
  INV_X1 abs_v_U26 ( .A(abs_v_n44), .ZN(OUTPUT_ABS[30]) );
  AOI22_X1 abs_v_U25 ( .A1(IN_A[16]), .A2(abs_v_n17), .B1(abs_v_NEG_OUTPUT_16_), .B2(abs_v_n2), .ZN(abs_v_n60) );
  INV_X1 abs_v_U24 ( .A(abs_v_n60), .ZN(OUTPUT_ABS[16]) );
  AOI22_X1 abs_v_U23 ( .A1(IN_A[1]), .A2(abs_v_n15), .B1(abs_v_NEG_OUTPUT_1_), 
        .B2(abs_v_n2), .ZN(abs_v_n56) );
  INV_X1 abs_v_U22 ( .A(abs_v_n56), .ZN(OUTPUT_ABS[1]) );
  AOI22_X1 abs_v_U21 ( .A1(IN_A[28]), .A2(abs_v_n11), .B1(abs_v_NEG_OUTPUT_28_), .B2(abs_v_n1), .ZN(abs_v_n47) );
  INV_X1 abs_v_U20 ( .A(abs_v_n47), .ZN(OUTPUT_ABS[28]) );
  AOI22_X1 abs_v_U19 ( .A1(IN_A[24]), .A2(abs_v_n13), .B1(abs_v_NEG_OUTPUT_24_), .B2(abs_v_n2), .ZN(abs_v_n51) );
  INV_X1 abs_v_U18 ( .A(abs_v_n51), .ZN(OUTPUT_ABS[24]) );
  AOI22_X1 abs_v_U17 ( .A1(IN_A[6]), .A2(abs_v_n7), .B1(abs_v_NEG_OUTPUT_6_), 
        .B2(abs_v_n1), .ZN(abs_v_n40) );
  INV_X1 abs_v_U16 ( .A(abs_v_n40), .ZN(OUTPUT_ABS[6]) );
  AOI22_X1 abs_v_U15 ( .A1(IN_A[29]), .A2(abs_v_n10), .B1(abs_v_NEG_OUTPUT_29_), .B2(abs_v_n1), .ZN(abs_v_n46) );
  INV_X1 abs_v_U14 ( .A(abs_v_n46), .ZN(OUTPUT_ABS[29]) );
  AOI22_X1 abs_v_U13 ( .A1(IN_A[25]), .A2(abs_v_n12), .B1(abs_v_NEG_OUTPUT_25_), .B2(abs_v_n2), .ZN(abs_v_n50) );
  INV_X1 abs_v_U12 ( .A(abs_v_n50), .ZN(OUTPUT_ABS[25]) );
  AOI22_X1 abs_v_U11 ( .A1(IN_A[26]), .A2(abs_v_n12), .B1(abs_v_NEG_OUTPUT_26_), .B2(abs_v_n1), .ZN(abs_v_n49) );
  INV_X1 abs_v_U10 ( .A(abs_v_n49), .ZN(OUTPUT_ABS[26]) );
  AOI22_X1 abs_v_U9 ( .A1(IN_A[2]), .A2(abs_v_n10), .B1(abs_v_NEG_OUTPUT_2_), 
        .B2(abs_v_n1), .ZN(abs_v_n45) );
  INV_X1 abs_v_U8 ( .A(abs_v_n45), .ZN(OUTPUT_ABS[2]) );
  INV_X1 abs_v_U7 ( .A(abs_v_n22), .ZN(abs_v_n5) );
  INV_X1 abs_v_U6 ( .A(abs_v_n22), .ZN(abs_v_n2) );
  INV_X1 abs_v_U5 ( .A(abs_v_n21), .ZN(abs_v_n1) );
  AND2_X1 abs_v_U4 ( .A1(abs_v_NEG_OUTPUT_31_), .A2(abs_v_n5), .ZN(
        OUTPUT_ABS[31]) );
  INV_X1 abs_v_sub_add_22_b0_U93 ( .A(abs_v_n5), .ZN(abs_v_sub_add_22_b0_n62)
         );
  INV_X1 abs_v_sub_add_22_b0_U92 ( .A(IN_A[7]), .ZN(abs_v_sub_add_22_b0_n86)
         );
  INV_X1 abs_v_sub_add_22_b0_U91 ( .A(IN_A[9]), .ZN(abs_v_sub_add_22_b0_n84)
         );
  INV_X1 abs_v_sub_add_22_b0_U90 ( .A(IN_A[8]), .ZN(abs_v_sub_add_22_b0_n85)
         );
  INV_X1 abs_v_sub_add_22_b0_U89 ( .A(IN_A[4]), .ZN(abs_v_sub_add_22_b0_n89)
         );
  INV_X1 abs_v_sub_add_22_b0_U88 ( .A(IN_A[3]), .ZN(abs_v_sub_add_22_b0_n90)
         );
  INV_X1 abs_v_sub_add_22_b0_U87 ( .A(IN_A[30]), .ZN(abs_v_sub_add_22_b0_n63)
         );
  INV_X1 abs_v_sub_add_22_b0_U86 ( .A(IN_A[11]), .ZN(abs_v_sub_add_22_b0_n82)
         );
  INV_X1 abs_v_sub_add_22_b0_U85 ( .A(IN_A[10]), .ZN(abs_v_sub_add_22_b0_n83)
         );
  INV_X1 abs_v_sub_add_22_b0_U84 ( .A(IN_A[15]), .ZN(abs_v_sub_add_22_b0_n78)
         );
  INV_X1 abs_v_sub_add_22_b0_U83 ( .A(IN_A[14]), .ZN(abs_v_sub_add_22_b0_n79)
         );
  INV_X1 abs_v_sub_add_22_b0_U82 ( .A(IN_A[13]), .ZN(abs_v_sub_add_22_b0_n80)
         );
  INV_X1 abs_v_sub_add_22_b0_U81 ( .A(IN_A[12]), .ZN(abs_v_sub_add_22_b0_n81)
         );
  INV_X1 abs_v_sub_add_22_b0_U80 ( .A(IN_A[19]), .ZN(abs_v_sub_add_22_b0_n74)
         );
  INV_X1 abs_v_sub_add_22_b0_U79 ( .A(IN_A[18]), .ZN(abs_v_sub_add_22_b0_n75)
         );
  INV_X1 abs_v_sub_add_22_b0_U78 ( .A(IN_A[17]), .ZN(abs_v_sub_add_22_b0_n76)
         );
  INV_X1 abs_v_sub_add_22_b0_U77 ( .A(IN_A[16]), .ZN(abs_v_sub_add_22_b0_n77)
         );
  INV_X1 abs_v_sub_add_22_b0_U76 ( .A(IN_A[22]), .ZN(abs_v_sub_add_22_b0_n71)
         );
  INV_X1 abs_v_sub_add_22_b0_U75 ( .A(IN_A[21]), .ZN(abs_v_sub_add_22_b0_n72)
         );
  INV_X1 abs_v_sub_add_22_b0_U74 ( .A(IN_A[20]), .ZN(abs_v_sub_add_22_b0_n73)
         );
  INV_X1 abs_v_sub_add_22_b0_U73 ( .A(IN_A[1]), .ZN(abs_v_sub_add_22_b0_n92)
         );
  INV_X1 abs_v_sub_add_22_b0_U72 ( .A(IN_A[6]), .ZN(abs_v_sub_add_22_b0_n87)
         );
  INV_X1 abs_v_sub_add_22_b0_U71 ( .A(IN_A[2]), .ZN(abs_v_sub_add_22_b0_n91)
         );
  INV_X1 abs_v_sub_add_22_b0_U70 ( .A(IN_A[29]), .ZN(abs_v_sub_add_22_b0_n64)
         );
  INV_X1 abs_v_sub_add_22_b0_U69 ( .A(IN_A[5]), .ZN(abs_v_sub_add_22_b0_n88)
         );
  INV_X1 abs_v_sub_add_22_b0_U68 ( .A(IN_A[28]), .ZN(abs_v_sub_add_22_b0_n65)
         );
  INV_X1 abs_v_sub_add_22_b0_U67 ( .A(IN_A[27]), .ZN(abs_v_sub_add_22_b0_n66)
         );
  INV_X1 abs_v_sub_add_22_b0_U66 ( .A(IN_A[26]), .ZN(abs_v_sub_add_22_b0_n67)
         );
  INV_X1 abs_v_sub_add_22_b0_U65 ( .A(IN_A[25]), .ZN(abs_v_sub_add_22_b0_n68)
         );
  INV_X1 abs_v_sub_add_22_b0_U64 ( .A(IN_A[24]), .ZN(abs_v_sub_add_22_b0_n69)
         );
  INV_X1 abs_v_sub_add_22_b0_U63 ( .A(IN_A[23]), .ZN(abs_v_sub_add_22_b0_n70)
         );
  INV_X1 abs_v_sub_add_22_b0_U62 ( .A(IN_A[0]), .ZN(abs_v_sub_add_22_b0_n93)
         );
  NAND2_X1 abs_v_sub_add_22_b0_U61 ( .A1(abs_v_sub_add_22_b0_n63), .A2(
        abs_v_sub_add_22_b0_n55), .ZN(abs_v_sub_add_22_b0_n61) );
  AND2_X1 abs_v_sub_add_22_b0_U60 ( .A1(abs_v_sub_add_22_b0_n87), .A2(
        abs_v_sub_add_22_b0_n41), .ZN(abs_v_sub_add_22_b0_n60) );
  AND2_X1 abs_v_sub_add_22_b0_U59 ( .A1(abs_v_sub_add_22_b0_n85), .A2(
        abs_v_sub_add_22_b0_n58), .ZN(abs_v_sub_add_22_b0_n59) );
  AND2_X1 abs_v_sub_add_22_b0_U58 ( .A1(abs_v_sub_add_22_b0_n86), .A2(
        abs_v_sub_add_22_b0_n60), .ZN(abs_v_sub_add_22_b0_n58) );
  AND2_X1 abs_v_sub_add_22_b0_U57 ( .A1(abs_v_sub_add_22_b0_n90), .A2(
        abs_v_sub_add_22_b0_n56), .ZN(abs_v_sub_add_22_b0_n57) );
  AND2_X1 abs_v_sub_add_22_b0_U56 ( .A1(abs_v_sub_add_22_b0_n91), .A2(
        abs_v_sub_add_22_b0_n40), .ZN(abs_v_sub_add_22_b0_n56) );
  AND2_X1 abs_v_sub_add_22_b0_U55 ( .A1(abs_v_sub_add_22_b0_n64), .A2(
        abs_v_sub_add_22_b0_n39), .ZN(abs_v_sub_add_22_b0_n55) );
  AND2_X1 abs_v_sub_add_22_b0_U54 ( .A1(abs_v_sub_add_22_b0_n83), .A2(
        abs_v_sub_add_22_b0_n53), .ZN(abs_v_sub_add_22_b0_n54) );
  AND2_X1 abs_v_sub_add_22_b0_U53 ( .A1(abs_v_sub_add_22_b0_n84), .A2(
        abs_v_sub_add_22_b0_n59), .ZN(abs_v_sub_add_22_b0_n53) );
  AND2_X1 abs_v_sub_add_22_b0_U52 ( .A1(abs_v_sub_add_22_b0_n79), .A2(
        abs_v_sub_add_22_b0_n51), .ZN(abs_v_sub_add_22_b0_n52) );
  AND2_X1 abs_v_sub_add_22_b0_U51 ( .A1(abs_v_sub_add_22_b0_n80), .A2(
        abs_v_sub_add_22_b0_n50), .ZN(abs_v_sub_add_22_b0_n51) );
  AND2_X1 abs_v_sub_add_22_b0_U50 ( .A1(abs_v_sub_add_22_b0_n81), .A2(
        abs_v_sub_add_22_b0_n49), .ZN(abs_v_sub_add_22_b0_n50) );
  AND2_X1 abs_v_sub_add_22_b0_U49 ( .A1(abs_v_sub_add_22_b0_n82), .A2(
        abs_v_sub_add_22_b0_n54), .ZN(abs_v_sub_add_22_b0_n49) );
  AND2_X1 abs_v_sub_add_22_b0_U48 ( .A1(abs_v_sub_add_22_b0_n75), .A2(
        abs_v_sub_add_22_b0_n47), .ZN(abs_v_sub_add_22_b0_n48) );
  AND2_X1 abs_v_sub_add_22_b0_U47 ( .A1(abs_v_sub_add_22_b0_n76), .A2(
        abs_v_sub_add_22_b0_n46), .ZN(abs_v_sub_add_22_b0_n47) );
  AND2_X1 abs_v_sub_add_22_b0_U46 ( .A1(abs_v_sub_add_22_b0_n77), .A2(
        abs_v_sub_add_22_b0_n45), .ZN(abs_v_sub_add_22_b0_n46) );
  AND2_X1 abs_v_sub_add_22_b0_U45 ( .A1(abs_v_sub_add_22_b0_n78), .A2(
        abs_v_sub_add_22_b0_n52), .ZN(abs_v_sub_add_22_b0_n45) );
  AND2_X1 abs_v_sub_add_22_b0_U44 ( .A1(abs_v_sub_add_22_b0_n72), .A2(
        abs_v_sub_add_22_b0_n43), .ZN(abs_v_sub_add_22_b0_n44) );
  AND2_X1 abs_v_sub_add_22_b0_U43 ( .A1(abs_v_sub_add_22_b0_n73), .A2(
        abs_v_sub_add_22_b0_n42), .ZN(abs_v_sub_add_22_b0_n43) );
  AND2_X1 abs_v_sub_add_22_b0_U42 ( .A1(abs_v_sub_add_22_b0_n74), .A2(
        abs_v_sub_add_22_b0_n48), .ZN(abs_v_sub_add_22_b0_n42) );
  AND2_X1 abs_v_sub_add_22_b0_U41 ( .A1(abs_v_sub_add_22_b0_n88), .A2(
        abs_v_sub_add_22_b0_n38), .ZN(abs_v_sub_add_22_b0_n41) );
  AND2_X1 abs_v_sub_add_22_b0_U40 ( .A1(abs_v_sub_add_22_b0_n92), .A2(
        abs_v_sub_add_22_b0_n93), .ZN(abs_v_sub_add_22_b0_n40) );
  AND2_X1 abs_v_sub_add_22_b0_U39 ( .A1(abs_v_sub_add_22_b0_n65), .A2(
        abs_v_sub_add_22_b0_n37), .ZN(abs_v_sub_add_22_b0_n39) );
  AND2_X1 abs_v_sub_add_22_b0_U38 ( .A1(abs_v_sub_add_22_b0_n89), .A2(
        abs_v_sub_add_22_b0_n57), .ZN(abs_v_sub_add_22_b0_n38) );
  AND2_X1 abs_v_sub_add_22_b0_U37 ( .A1(abs_v_sub_add_22_b0_n66), .A2(
        abs_v_sub_add_22_b0_n36), .ZN(abs_v_sub_add_22_b0_n37) );
  AND2_X1 abs_v_sub_add_22_b0_U36 ( .A1(abs_v_sub_add_22_b0_n67), .A2(
        abs_v_sub_add_22_b0_n35), .ZN(abs_v_sub_add_22_b0_n36) );
  AND2_X1 abs_v_sub_add_22_b0_U35 ( .A1(abs_v_sub_add_22_b0_n68), .A2(
        abs_v_sub_add_22_b0_n34), .ZN(abs_v_sub_add_22_b0_n35) );
  AND2_X1 abs_v_sub_add_22_b0_U34 ( .A1(abs_v_sub_add_22_b0_n69), .A2(
        abs_v_sub_add_22_b0_n33), .ZN(abs_v_sub_add_22_b0_n34) );
  AND2_X1 abs_v_sub_add_22_b0_U33 ( .A1(abs_v_sub_add_22_b0_n70), .A2(
        abs_v_sub_add_22_b0_n32), .ZN(abs_v_sub_add_22_b0_n33) );
  AND2_X1 abs_v_sub_add_22_b0_U32 ( .A1(abs_v_sub_add_22_b0_n71), .A2(
        abs_v_sub_add_22_b0_n44), .ZN(abs_v_sub_add_22_b0_n32) );
  XNOR2_X1 abs_v_sub_add_22_b0_U31 ( .A(abs_v_sub_add_22_b0_n62), .B(
        abs_v_sub_add_22_b0_n61), .ZN(abs_v_NEG_OUTPUT_31_) );
  XOR2_X1 abs_v_sub_add_22_b0_U30 ( .A(abs_v_sub_add_22_b0_n82), .B(
        abs_v_sub_add_22_b0_n54), .Z(abs_v_NEG_OUTPUT_11_) );
  XOR2_X1 abs_v_sub_add_22_b0_U29 ( .A(abs_v_sub_add_22_b0_n78), .B(
        abs_v_sub_add_22_b0_n52), .Z(abs_v_NEG_OUTPUT_15_) );
  XOR2_X1 abs_v_sub_add_22_b0_U28 ( .A(abs_v_sub_add_22_b0_n83), .B(
        abs_v_sub_add_22_b0_n53), .Z(abs_v_NEG_OUTPUT_10_) );
  XOR2_X1 abs_v_sub_add_22_b0_U27 ( .A(abs_v_sub_add_22_b0_n79), .B(
        abs_v_sub_add_22_b0_n51), .Z(abs_v_NEG_OUTPUT_14_) );
  XOR2_X1 abs_v_sub_add_22_b0_U26 ( .A(abs_v_sub_add_22_b0_n80), .B(
        abs_v_sub_add_22_b0_n50), .Z(abs_v_NEG_OUTPUT_13_) );
  XOR2_X1 abs_v_sub_add_22_b0_U25 ( .A(abs_v_sub_add_22_b0_n81), .B(
        abs_v_sub_add_22_b0_n49), .Z(abs_v_NEG_OUTPUT_12_) );
  XOR2_X1 abs_v_sub_add_22_b0_U24 ( .A(abs_v_sub_add_22_b0_n66), .B(
        abs_v_sub_add_22_b0_n36), .Z(abs_v_NEG_OUTPUT_27_) );
  XOR2_X1 abs_v_sub_add_22_b0_U23 ( .A(abs_v_sub_add_22_b0_n70), .B(
        abs_v_sub_add_22_b0_n32), .Z(abs_v_NEG_OUTPUT_23_) );
  XOR2_X1 abs_v_sub_add_22_b0_U22 ( .A(abs_v_sub_add_22_b0_n88), .B(
        abs_v_sub_add_22_b0_n38), .Z(abs_v_NEG_OUTPUT_5_) );
  XOR2_X1 abs_v_sub_add_22_b0_U21 ( .A(abs_v_sub_add_22_b0_n86), .B(
        abs_v_sub_add_22_b0_n60), .Z(abs_v_NEG_OUTPUT_7_) );
  XOR2_X1 abs_v_sub_add_22_b0_U20 ( .A(abs_v_sub_add_22_b0_n89), .B(
        abs_v_sub_add_22_b0_n57), .Z(abs_v_NEG_OUTPUT_4_) );
  XOR2_X1 abs_v_sub_add_22_b0_U19 ( .A(abs_v_sub_add_22_b0_n74), .B(
        abs_v_sub_add_22_b0_n48), .Z(abs_v_NEG_OUTPUT_19_) );
  XOR2_X1 abs_v_sub_add_22_b0_U18 ( .A(abs_v_sub_add_22_b0_n71), .B(
        abs_v_sub_add_22_b0_n44), .Z(abs_v_NEG_OUTPUT_22_) );
  XOR2_X1 abs_v_sub_add_22_b0_U17 ( .A(abs_v_sub_add_22_b0_n90), .B(
        abs_v_sub_add_22_b0_n56), .Z(abs_v_NEG_OUTPUT_3_) );
  XOR2_X1 abs_v_sub_add_22_b0_U16 ( .A(abs_v_sub_add_22_b0_n75), .B(
        abs_v_sub_add_22_b0_n47), .Z(abs_v_NEG_OUTPUT_18_) );
  XOR2_X1 abs_v_sub_add_22_b0_U15 ( .A(abs_v_sub_add_22_b0_n72), .B(
        abs_v_sub_add_22_b0_n43), .Z(abs_v_NEG_OUTPUT_21_) );
  XOR2_X1 abs_v_sub_add_22_b0_U14 ( .A(abs_v_sub_add_22_b0_n84), .B(
        abs_v_sub_add_22_b0_n59), .Z(abs_v_NEG_OUTPUT_9_) );
  XOR2_X1 abs_v_sub_add_22_b0_U13 ( .A(abs_v_sub_add_22_b0_n85), .B(
        abs_v_sub_add_22_b0_n58), .Z(abs_v_NEG_OUTPUT_8_) );
  XOR2_X1 abs_v_sub_add_22_b0_U12 ( .A(abs_v_sub_add_22_b0_n76), .B(
        abs_v_sub_add_22_b0_n46), .Z(abs_v_NEG_OUTPUT_17_) );
  XOR2_X1 abs_v_sub_add_22_b0_U11 ( .A(abs_v_sub_add_22_b0_n73), .B(
        abs_v_sub_add_22_b0_n42), .Z(abs_v_NEG_OUTPUT_20_) );
  XOR2_X1 abs_v_sub_add_22_b0_U10 ( .A(abs_v_sub_add_22_b0_n77), .B(
        abs_v_sub_add_22_b0_n45), .Z(abs_v_NEG_OUTPUT_16_) );
  XOR2_X1 abs_v_sub_add_22_b0_U9 ( .A(abs_v_sub_add_22_b0_n92), .B(
        abs_v_sub_add_22_b0_n93), .Z(abs_v_NEG_OUTPUT_1_) );
  XOR2_X1 abs_v_sub_add_22_b0_U8 ( .A(abs_v_sub_add_22_b0_n65), .B(
        abs_v_sub_add_22_b0_n37), .Z(abs_v_NEG_OUTPUT_28_) );
  XOR2_X1 abs_v_sub_add_22_b0_U7 ( .A(abs_v_sub_add_22_b0_n69), .B(
        abs_v_sub_add_22_b0_n33), .Z(abs_v_NEG_OUTPUT_24_) );
  XOR2_X1 abs_v_sub_add_22_b0_U6 ( .A(abs_v_sub_add_22_b0_n87), .B(
        abs_v_sub_add_22_b0_n41), .Z(abs_v_NEG_OUTPUT_6_) );
  XOR2_X1 abs_v_sub_add_22_b0_U5 ( .A(abs_v_sub_add_22_b0_n64), .B(
        abs_v_sub_add_22_b0_n39), .Z(abs_v_NEG_OUTPUT_29_) );
  XOR2_X1 abs_v_sub_add_22_b0_U4 ( .A(abs_v_sub_add_22_b0_n68), .B(
        abs_v_sub_add_22_b0_n34), .Z(abs_v_NEG_OUTPUT_25_) );
  XOR2_X1 abs_v_sub_add_22_b0_U3 ( .A(abs_v_sub_add_22_b0_n67), .B(
        abs_v_sub_add_22_b0_n35), .Z(abs_v_NEG_OUTPUT_26_) );
  XOR2_X1 abs_v_sub_add_22_b0_U2 ( .A(abs_v_sub_add_22_b0_n91), .B(
        abs_v_sub_add_22_b0_n40), .Z(abs_v_NEG_OUTPUT_2_) );
  XOR2_X1 abs_v_sub_add_22_b0_U1 ( .A(abs_v_sub_add_22_b0_n63), .B(
        abs_v_sub_add_22_b0_n55), .Z(abs_v_NEG_OUTPUT_30_) );
endmodule

