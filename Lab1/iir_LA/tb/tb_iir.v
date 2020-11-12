//`timescale 1ns

module tb_iir ();

   wire CLK_i;
   wire RST_n_i;
   wire [13:0] DIN_i;
   wire VIN_i;
   wire [13:0] E2_i;
   wire [13:0] E3_i;
   wire [13:0] F0_i;
   wire [13:0] F1_i;
   wire [13:0] F2_i;
   wire [13:0] F3_i;
   wire [13:0] DOUT_i;
   wire VOUT_i;
   wire END_SIM_i;

   clk_gen CG(.END_SIM(END_SIM_i),
  	      .CLK(CLK_i),
	      .RST_n(RST_n_i));

   data_maker SM(.CLK(CLK_i),
	         .RST_n(RST_n_i),
		 .VOUT(VIN_i),
		 .DOUT(DIN_i),
		 .E2(E2_i),
		 .E3(E3_i),
		 .F0(F0_i),
		 .F1(F1_i),
		 .F2(F2_i),
		 .F3(F3_i),
		 .END_SIM(END_SIM_i));

   myiir_adv UUT(.CLK(CLK_i),
	     .RST_n(RST_n_i),
	     .DIN(DIN_i),
             .VIN(VIN_i),
	     .E2(E2_i),
		 .E3(E3_i),
		 .F0(F0_i),
		 .F1(F1_i),
		 .F2(F2_i),
		 .F3(F3_i),
             .DOUT(DOUT_i),
             .VOUT(VOUT_i));

   data_sink DS(.CLK(CLK_i),
		.RST_n(RST_n_i),
		.VIN(VOUT_i),
		.DIN(DOUT_i));   

endmodule

		   
