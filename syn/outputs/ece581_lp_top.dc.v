/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : Q-2019.12-SP3
// Date      : Mon Nov 13 22:15:44 2023
/////////////////////////////////////////////////////////////


module modA ( soc_in1, soc_in2, soc_carry_in, soc_B2A, soc_C2A, soc_D2A, 
        upf_clk, soc_reset, soc_A_carry_out, soc_A2B, soc_A2D, soc_A_out, 
        soc_A_sum_out, soc_A2C );
  input [0:1] soc_in1;
  input [0:1] soc_in2;
  output [0:1] soc_A_out;
  output [0:1] soc_A_sum_out;
  output [0:1] soc_A2C;
  input soc_carry_in, soc_B2A, soc_C2A, soc_D2A, upf_clk, soc_reset;
  output soc_A_carry_out, soc_A2B, soc_A2D;
  wire   soc_A2B, \soc_A_sum_out[0] , N4, N5, N7, n3, n2, n4, n5, n6;
  assign soc_A2D = soc_A2B;
  assign soc_A2C[0] = \soc_A_sum_out[0] ;
  assign soc_A_sum_out[0] = \soc_A_sum_out[0] ;

  DFFX1_HVT soc_A_carry_out_reg ( .D(n3), .CLK(upf_clk), .Q(soc_A_carry_out)
         );
  DFFARX1_HVT \soc_A_sum_out_reg[1]  ( .D(N4), .CLK(upf_clk), .RSTB(n6), .Q(
        soc_A_sum_out[1]) );
  DFFARX1_HVT \soc_A_out_reg[1]  ( .D(N7), .CLK(upf_clk), .RSTB(n6), .Q(
        soc_A_out[1]) );
  DFFARX1_HVT \soc_A2C_reg[0]  ( .D(N5), .CLK(upf_clk), .RSTB(n6), .Q(
        \soc_A_sum_out[0] ) );
  DFFASX1_HVT \soc_A2C_reg[1]  ( .D(N4), .CLK(upf_clk), .SETB(n6), .Q(
        soc_A2C[1]) );
  DFFASX1_HVT soc_A2D_reg ( .D(N7), .CLK(upf_clk), .SETB(n6), .Q(soc_A2B) );
  INVX0_HVT U3 ( .A(soc_reset), .Y(n4) );
  AND3X1_HVT U4 ( .A1(soc_D2A), .A2(soc_B2A), .A3(soc_C2A), .Y(N7) );
  NBUFFX2_HVT U5 ( .A(soc_reset), .Y(n6) );
  FADDX1_HVT U6 ( .A(soc_in2[1]), .B(soc_carry_in), .CI(soc_in1[1]), .CO(n2), 
        .S(N4) );
  FADDX1_HVT U7 ( .A(soc_in2[0]), .B(n2), .CI(soc_in1[0]), .CO(n5), .S(N5) );
  AO22X1_HVT U8 ( .A1(soc_reset), .A2(n5), .A3(n4), .A4(soc_A_carry_out), .Y(
        n3) );
endmodule


module modB ( soc_in1, soc_in2, soc_reset, upf_clk, soc_A2B, soc_C2B, soc_D2B, 
        soc_B2A, soc_B2C, soc_B2D, soc_B_out, soc_equal, soc_B1_out );
  input [1:0] soc_in1;
  input [1:0] soc_in2;
  input soc_reset, upf_clk, soc_A2B, soc_C2B, soc_D2B;
  output soc_B2A, soc_B2C, soc_B2D, soc_B_out, soc_equal, soc_B1_out;
  wire   soc_B2A, n5, n6, n7, n11, n1, n2, n3, n4, n8, n9, n10, n12, n13, n14,
         n15, n16, n17, n18, n19;
  assign soc_B2D = soc_B2A;
  assign soc_B2C = soc_B2A;

  DFFX1_HVT soc_equal_reg ( .D(n7), .CLK(upf_clk), .Q(soc_equal) );
  DFFARX1_HVT soc_B_out_reg ( .D(n11), .CLK(upf_clk), .RSTB(n19), .Q(soc_B_out) );
  DFFX1_HVT soc_B1_out_reg ( .D(n6), .CLK(upf_clk), .Q(soc_B1_out), .QN(n18)
         );
  DFFX1_HVT soc_B2D_reg ( .D(n5), .CLK(upf_clk), .Q(soc_B2A) );
  INVX1_HVT U3 ( .A(n14), .Y(n19) );
  OR2X2_HVT U4 ( .A1(n18), .A2(n17), .Y(n3) );
  INVX0_HVT U5 ( .A(soc_in2[0]), .Y(n8) );
  INVX0_HVT U6 ( .A(n14), .Y(n17) );
  INVX0_HVT U7 ( .A(soc_in2[1]), .Y(n12) );
  INVX0_HVT U8 ( .A(soc_C2B), .Y(n16) );
  NAND2X0_HVT U9 ( .A1(n3), .A2(n1), .Y(n6) );
  NAND3X0_HVT U10 ( .A1(n17), .A2(n15), .A3(soc_D2B), .Y(n1) );
  AO22X1_HVT U11 ( .A1(n19), .A2(n11), .A3(n13), .A4(soc_B2A), .Y(n5) );
  AND2X1_HVT U12 ( .A1(n16), .A2(n17), .Y(n2) );
  AO21X1_HVT U13 ( .A1(n13), .A2(soc_equal), .A3(n2), .Y(n7) );
  INVX0_HVT U14 ( .A(soc_in1[1]), .Y(n4) );
  NAND2X0_HVT U15 ( .A1(n4), .A2(soc_in2[1]), .Y(n10) );
  AND2X1_HVT U16 ( .A1(soc_in1[0]), .A2(n8), .Y(n9) );
  AO22X1_HVT U17 ( .A1(soc_in1[1]), .A2(n12), .A3(n10), .A4(n9), .Y(n11) );
  INVX0_HVT U18 ( .A(soc_reset), .Y(n14) );
  INVX0_HVT U19 ( .A(n19), .Y(n13) );
  AND2X1_HVT U20 ( .A1(soc_C2B), .A2(soc_A2B), .Y(n15) );
endmodule


module modC ( soc_in2, soc_A2C, upf_clk, soc_B2C, soc_D2C, soc_reset, soc_C2A, 
        soc_C2B, soc_C2D, soc_C_out );
  input [0:1] soc_in2;
  input [0:1] soc_A2C;
  input upf_clk, soc_B2C, soc_D2C, soc_reset;
  output soc_C2A, soc_C2B, soc_C2D, soc_C_out;
  wire   n19, n20, n21, n22, n23, n24, soc_C2A, n4, n1, n2, n3, n5, n6, n7, n8,
         n9, n10, n11, n12, n13, n14, n15, n16, n17, n18;
  assign soc_C2B = soc_C2A;
  assign soc_C2D = soc_C2A;
  assign n13 = soc_in2[0];
  assign n14 = soc_reset;
  assign n15 = soc_A2C[0];
  assign n16 = soc_A2C[1];
  assign n17 = soc_B2C;
  assign n18 = soc_D2C;

  DFFX1_HVT soc_C_out_reg ( .D(n12), .CLK(upf_clk), .Q(soc_C_out) );
  DFFX1_HVT soc_C2A_reg ( .D(n4), .CLK(upf_clk), .Q(soc_C2A) );
  LSDNSSX2_HVT \soc_A2C[0]_UPF_LS  ( .A(n15), .Y(n20) );
  LSDNSSX2_HVT \soc_A2C[1]_UPF_LS  ( .A(n16), .Y(n21) );
  LSDNSSX2_HVT soc_D2C_UPF_LS ( .A(n18), .Y(n23) );
  LSDNSSX2_HVT soc_B2C_UPF_LS ( .A(n17), .Y(n22) );
  LSDNSSX1_HVT \soc_in2[0]_UPF_LS  ( .A(n13), .Y(n19) );
  LSDNSSX2_HVT soc_reset_UPF_LS ( .A(n14), .Y(n24) );
  NAND2X0_HVT U2 ( .A1(n10), .A2(soc_C_out), .Y(n5) );
  INVX0_HVT U3 ( .A(n23), .Y(n3) );
  AND3X1_HVT U4 ( .A1(n1), .A2(n2), .A3(n8), .Y(n12) );
  OR2X1_HVT U5 ( .A1(n9), .A2(n11), .Y(n1) );
  NAND2X0_HVT U6 ( .A1(n6), .A2(n5), .Y(n2) );
  INVX0_HVT U7 ( .A(n24), .Y(n10) );
  NAND2X0_HVT U8 ( .A1(n5), .A2(n3), .Y(n8) );
  NAND2X0_HVT U9 ( .A1(n7), .A2(n22), .Y(n6) );
  NBUFFX2_HVT U10 ( .A(n24), .Y(n7) );
  OR2X1_HVT U11 ( .A1(n21), .A2(n20), .Y(n9) );
  NBUFFX2_HVT U12 ( .A(n10), .Y(n11) );
  AO22X1_HVT U13 ( .A1(n7), .A2(n19), .A3(n11), .A4(soc_C2A), .Y(n4) );
endmodule


module modD ( soc_in1, upf_clk, soc_A_sum_out, soc_A2D, soc_B2D, soc_C2D, 
        soc_D2A, soc_D2B, soc_D2C, soc_D_out, soc_reset, soc_oddeven_enable, 
        soc_D1_out );
  input [0:1] soc_in1;
  input [0:1] soc_A_sum_out;
  input upf_clk, soc_A2D, soc_B2D, soc_C2D, soc_reset, soc_oddeven_enable;
  output soc_D2A, soc_D2B, soc_D2C, soc_D_out, soc_D1_out;
  wire   n19, n20, n21, n22, n23, soc_D2A, n24, n25, D, N5, n6, n7, n1, n2, n3,
         n4, n5, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18;
  assign soc_D2C = soc_D2A;
  assign soc_D2B = soc_D2A;
  assign n12 = soc_in1[0];
  assign n13 = soc_reset;
  assign n14 = soc_oddeven_enable;
  assign n15 = soc_A2D;
  assign n16 = soc_A_sum_out[0];
  assign n17 = soc_B2D;
  assign n18 = soc_C2D;

  DFFARX1_HVT D_reg ( .D(N5), .CLK(upf_clk), .RSTB(n1), .Q(D) );
  DFFX1_HVT soc_D1_out_reg ( .D(n11), .CLK(upf_clk), .Q(soc_D1_out) );
  DFFX1_HVT soc_D_out_reg ( .D(n7), .CLK(upf_clk), .Q(soc_D_out) );
  DFFX1_HVT soc_D2A_reg ( .D(n6), .CLK(upf_clk), .Q(soc_D2A) );
  LSDNSSX8_HVT soc_B2D_UPF_LS ( .A(n17), .Y(n22) );
  LSDNSSX8_HVT soc_A2D_UPF_LS ( .A(n15), .Y(n21) );
  LSDNSSX1_HVT \soc_A_sum_out[0]_UPF_LS  ( .A(n16), .Y(n20) );
  LSDNSSX2_HVT soc_C2D_UPF_LS ( .A(n18), .Y(n23) );
  LSDNSSX1_HVT \soc_in1[0]_UPF_LS  ( .A(n12), .Y(n19) );
  LSDNSSX1_HVT soc_oddeven_enable_UPF_LS ( .A(n14), .Y(n25) );
  LSDNSSX1_HVT soc_reset_UPF_LS ( .A(n13), .Y(n24) );
  AO21X1_HVT U3 ( .A1(n3), .A2(n22), .A3(n4), .Y(n11) );
  NBUFFX2_HVT U4 ( .A(n10), .Y(n1) );
  NBUFFX2_HVT U5 ( .A(n24), .Y(n2) );
  INVX0_HVT U6 ( .A(n25), .Y(n8) );
  AND3X1_HVT U7 ( .A1(n23), .A2(n21), .A3(n10), .Y(n3) );
  AND2X1_HVT U8 ( .A1(soc_D1_out), .A2(n9), .Y(n4) );
  NBUFFX2_HVT U9 ( .A(n24), .Y(n10) );
  INVX0_HVT U10 ( .A(n2), .Y(n9) );
  NAND2X0_HVT U11 ( .A1(n2), .A2(n8), .Y(n5) );
  MUX21X1_HVT U12 ( .A1(n20), .A2(soc_D_out), .S0(n5), .Y(n7) );
  AO22X1_HVT U13 ( .A1(n25), .A2(D), .A3(n8), .A4(n19), .Y(N5) );
  AO22X1_HVT U14 ( .A1(n1), .A2(N5), .A3(n9), .A4(soc_D2A), .Y(n6) );
endmodule


module ece581_lp_top ( soc_in1, soc_in2, soc_reset, soc_oddeven_enable, 
        soc_carry_in, upf_clk, soc_A_carry_out, soc_B_out, soc_C_out, 
        soc_D_out, soc_equal, soc_B1_out, soc_D1_out, soc_A_out, soc_A_sum_out, 
        en_A, en_B, en_C, en_D );
  input [0:1] soc_in1;
  input [0:1] soc_in2;
  output [0:1] soc_A_out;
  output [0:1] soc_A_sum_out;
  input soc_reset, soc_oddeven_enable, soc_carry_in, upf_clk, en_A, en_B, en_C,
         en_D;
  output soc_A_carry_out, soc_B_out, soc_C_out, soc_D_out, soc_equal,
         soc_B1_out, soc_D1_out;
  wire   soc_B2A, soc_C2A, soc_D2A, soc_A2B, soc_A2D, soc_C2B, soc_D2B,
         soc_B2C, soc_B2D, soc_D2C, soc_C2D, net1916, net1917, net1918,
         net1919, net1920, net1921, net1923, net1924, net1925, net1926,
         net1927, net1928, net1929, net1930, net1931, net1932, net1933,
         net1934, net1935, net1936, net1937, net1938, net1939, n1, n2, n3, n5,
         n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20,
         n21, n22, n23, n24, n26, n27, n28, n29;
  wire   [0:1] soc_A2C;
  wire   SYNOPSYS_UNCONNECTED__0;
  assign soc_A_out[0] = 1'b0;

  modA A_inst ( .soc_in1({n1, n24}), .soc_in2({n5, n22}), .soc_carry_in(n20), 
        .soc_B2A(soc_B2A), .soc_C2A(soc_C2A), .soc_D2A(soc_D2A), .upf_clk(
        upf_clk), .soc_reset(n6), .soc_A_carry_out(net1919), .soc_A2B(net1920), 
        .soc_A2D(net1921), .soc_A_out({SYNOPSYS_UNCONNECTED__0, net1923}), 
        .soc_A_sum_out({net1924, net1925}), .soc_A2C({net1926, net1927}) );
  modB B_inst ( .soc_in1({n1, n24}), .soc_in2({n14, n22}), .soc_reset(n13), 
        .upf_clk(upf_clk), .soc_A2B(soc_A2B), .soc_C2B(soc_C2B), .soc_D2B(
        soc_D2B), .soc_B2A(net1916), .soc_B2C(net1930), .soc_B2D(net1931), 
        .soc_B_out(net1932), .soc_equal(net1933), .soc_B1_out(net1934) );
  modC C_inst ( .soc_in2({n5, n22}), .soc_A2C(soc_A2C), .upf_clk(upf_clk), 
        .soc_B2C(soc_B2C), .soc_D2C(soc_D2C), .soc_reset(n7), .soc_C2A(net1917), .soc_C2B(net1928), .soc_C2D(net1936), .soc_C_out(net1937) );
  modD D_inst ( .soc_in1({n11, n24}), .upf_clk(upf_clk), .soc_A_sum_out(
        soc_A_sum_out), .soc_A2D(soc_A2D), .soc_B2D(soc_B2D), .soc_C2D(soc_C2D), .soc_D2A(net1918), .soc_D2B(net1929), .soc_D2C(net1935), .soc_D_out(net1938), 
        .soc_reset(n7), .soc_oddeven_enable(soc_oddeven_enable), .soc_D1_out(
        net1939) );
  ISOLANDX1_HVT snps_pd_modB__iso_B2Top3_snps_soc_B1_out_UPF_ISO ( .D(net1934), 
        .ISO(n15), .Q(soc_B1_out) ); //synopsys isolation_upf iso_B2Top3+pd_modB
  ISOLANDX1_HVT snps_pd_modB__iso_B2Top2_snps_soc_equal_UPF_ISO ( .D(net1933), 
        .ISO(n15), .Q(soc_equal) ); //synopsys isolation_upf iso_B2Top2+pd_modB
  ISOLANDX1_HVT snps_pd_modB__iso_B2Top1_snps_soc_B_out_UPF_ISO ( .D(net1932), 
        .ISO(n15), .Q(soc_B_out) ); //synopsys isolation_upf iso_B2Top1+pd_modB
  ISOLANDX1_HVT snps_pd_modB__iso_B2D_snps_soc_B2D_UPF_ISO ( .D(net1931), 
        .ISO(n27), .Q(soc_B2D) ); //synopsys isolation_upf iso_B2D+pd_modB
  ISOLANDX1_HVT snps_pd_modB__iso_B2C_snps_soc_B2C_UPF_ISO ( .D(net1930), 
        .ISO(n27), .Q(soc_B2C) ); //synopsys isolation_upf iso_B2C+pd_modB
  ISOLANDX1_HVT \snps_pd_modA__iso_A2C_snps_soc_A2C[1]_UPF_ISO  ( .D(net1927), 
        .ISO(n18), .Q(soc_A2C[1]) ); //synopsys isolation_upf iso_A2C+pd_modA
  ISOLANDX1_HVT \snps_pd_modA__iso_A2Top3_snps_soc_A_sum_out[1]_UPF_ISO  ( .D(
        net1925), .ISO(n17), .Q(soc_A_sum_out[1]) ); //synopsys isolation_upf iso_A2Top3+pd_modA
  ISOLANDX1_HVT \snps_pd_modA__iso_A2Top3_snps_soc_A_sum_out[0]_UPF_ISO  ( .D(
        net1924), .ISO(n16), .Q(soc_A_sum_out[0]) ); //synopsys isolation_upf iso_A2Top3+pd_modA
  ISOLANDX1_HVT \snps_pd_modA__iso_A2Top2_snps_soc_A_out[1]_UPF_ISO  ( .D(
        net1923), .ISO(n17), .Q(soc_A_out[1]) ); //synopsys isolation_upf iso_A2Top2+pd_modA
  ISOLANDX1_HVT snps_pd_modA__iso_A2D_snps_soc_A2D_UPF_ISO ( .D(net1921), 
        .ISO(n18), .Q(soc_A2D) ); //synopsys isolation_upf iso_A2D+pd_modA
  ISOLANDX1_HVT snps_pd_modA__iso_A2B_snps_soc_A2B_UPF_ISO ( .D(net1920), 
        .ISO(n18), .Q(soc_A2B) ); //synopsys isolation_upf iso_A2B+pd_modA
  ISOLANDX1_HVT snps_pd_modA__iso_A2Top1_snps_soc_A_carry_out_UPF_ISO ( .D(
        net1919), .ISO(n17), .Q(soc_A_carry_out) ); //synopsys isolation_upf iso_A2Top1+pd_modA
  ISOLANDX1_HVT snps_pd_modB__iso_B2A_snps_soc_B2A_UPF_ISO ( .D(net1916), 
        .ISO(n9), .Q(soc_B2A) ); //synopsys isolation_upf iso_B2A+pd_modB
  LSUPENX8_HVT snps_pd_modD__iso_D2B_snps_soc_D2B_UPF_ISO ( .A(net1929), .EN(
        n8), .Y(soc_D2B) ); //synopsys isolation_upf iso_D2B+pd_modD
  LSUPENX4_HVT snps_pd_modD__iso_D2C_snps_soc_D2C_UPF_ISO ( .A(net1935), .EN(
        n8), .Y(soc_D2C) ); //synopsys isolation_upf iso_D2C+pd_modD
  ISOLANDX1_HVT \snps_pd_modA__iso_A2C_snps_soc_A2C[0]_UPF_ISO  ( .D(net1926), 
        .ISO(n16), .Q(soc_A2C[0]) ); //synopsys isolation_upf iso_A2C+pd_modA
  LSUPENX2_HVT snps_pd_modC__iso_C2D_snps_soc_C2D_UPF_ISO ( .A(net1936), .EN(
        n2), .Y(soc_C2D) ); //synopsys isolation_upf iso_C2D+pd_modC
  LSUPENX1_HVT snps_pd_modD__iso_D2A_snps_soc_D2A_UPF_ISO ( .A(net1918), .EN(
        n12), .Y(soc_D2A) ); //synopsys isolation_upf iso_D2A+pd_modD
  LSUPENX1_HVT snps_pd_modD__iso_D2Top1_snps_soc_D_out_UPF_ISO ( .A(net1938), 
        .EN(n3), .Y(soc_D_out) ); //synopsys isolation_upf iso_D2Top1+pd_modD
  LSUPENX1_HVT snps_pd_modD__iso_D2Top2_snps_soc_D1_out_UPF_ISO ( .A(net1939), 
        .EN(n3), .Y(soc_D1_out) ); //synopsys isolation_upf iso_D2Top2+pd_modD
  LSUPENX1_HVT snps_pd_modC__iso_C2A_snps_soc_C2A_UPF_ISO ( .A(net1917), .EN(
        n10), .Y(soc_C2A) ); //synopsys isolation_upf iso_C2A+pd_modC
  LSUPENX1_HVT snps_pd_modC__iso_C2Top_snps_soc_C_out_UPF_ISO ( .A(net1937), 
        .EN(n10), .Y(soc_C_out) ); //synopsys isolation_upf iso_C2Top+pd_modC
  INVX0_HVT snps_iso_control_inv_3 ( .A(en_A), .Y(n26) );
  LSUPENX4_HVT snps_pd_modC__iso_C2B_snps_soc_C2B_UPF_ISO ( .A(net1928), .EN(
        n2), .Y(soc_C2B) ); //synopsys isolation_upf iso_C2B+pd_modC
  INVX0_HVT snps_iso_control_inv_0 ( .A(en_D), .Y(n29) );
  INVX0_HVT snps_iso_control_inv_2 ( .A(en_B), .Y(n27) );
  INVX0_HVT snps_iso_control_inv_1 ( .A(en_C), .Y(n28) );
  INVX0_HVT U5 ( .A(n21), .Y(n22) );
  INVX0_HVT U6 ( .A(n23), .Y(n24) );
  NBUFFX2_HVT U7 ( .A(soc_carry_in), .Y(n20) );
  NBUFFX2_HVT U8 ( .A(n11), .Y(n1) );
  INVX0_HVT U9 ( .A(soc_in2[1]), .Y(n21) );
  INVX0_HVT U10 ( .A(soc_in1[1]), .Y(n23) );
  NBUFFX2_HVT U11 ( .A(n14), .Y(n5) );
  NBUFFX2_HVT U12 ( .A(n28), .Y(n2) );
  NBUFFX2_HVT U13 ( .A(n12), .Y(n3) );
  NBUFFX2_HVT U14 ( .A(n13), .Y(n6) );
  NBUFFX2_HVT U15 ( .A(n19), .Y(n7) );
  NBUFFX2_HVT U16 ( .A(n29), .Y(n8) );
  NBUFFX2_HVT U17 ( .A(n27), .Y(n9) );
  NBUFFX2_HVT U18 ( .A(n28), .Y(n10) );
  NBUFFX2_HVT U19 ( .A(soc_in1[0]), .Y(n11) );
  NBUFFX2_HVT U20 ( .A(n29), .Y(n12) );
  NBUFFX2_HVT U21 ( .A(n19), .Y(n13) );
  NBUFFX2_HVT U22 ( .A(soc_in2[0]), .Y(n14) );
  NBUFFX2_HVT U23 ( .A(n9), .Y(n15) );
  NBUFFX2_HVT U24 ( .A(n26), .Y(n16) );
  NBUFFX2_HVT U25 ( .A(n16), .Y(n17) );
  NBUFFX2_HVT U26 ( .A(n26), .Y(n18) );
  NBUFFX2_HVT U27 ( .A(soc_reset), .Y(n19) );
endmodule

