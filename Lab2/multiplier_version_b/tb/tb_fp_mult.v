//`timescale 1ns

module tb_fp_mult ();

   wire CLK_i;
   wire [31:0] FP_A_i;
   wire [31:0] FP_B_i;
   wire [31:0] FP_Z_i;
   wire END_SIM_i;
   wire maker_end;

   clk_gen CG(.END_SIM(END_SIM_i),
  	      .CLK(CLK_i));

   data_maker SM(.CLK(CLK_i),
	         	.FP_A(FP_A_i),
         		.FP_B(FP_B_i),
		 		.END_SIM(END_SIM_i),
				.maker_end(maker_end));

   FPmul UUT(.clk(CLK_i),
	     .FP_A(FP_A_i),
         .FP_B(FP_B_i),
             .FP_Z(FP_Z_i));

   data_sink DS(.CLK(CLK_i),
		.FP_Z(FP_Z_i),
		.maker_end(maker_end));   

endmodule

		   
