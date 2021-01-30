//`timescale 1ns

module tb_sfu ();

   wire CLK_i;
   wire [31:0] IN_A_i;
   wire [31:0] IN_B_i;
   wire [31:0] OUTPUT_i;
   wire END_SIM_i;
   wire SFUOP_i;
   wire ZERO_i;

   clk_gen CG(.END_SIM(END_SIM_i),
  	      .CLK(CLK_i));

   data_maker SM(.CLK(CLK_i),
	         	.IN_A(IN_A_i),
         		.IN_B(IN_B_i),
				.SFUOP(SFUOP_i),
		 		.END_SIM(END_SIM_i));

   sfu UUT(.IN_A(IN_A_i),
         .IN_B(IN_B_i),
		 .SFUOP(SFUOP_i),
             .ZERO(ZERO_i),
             .OUTPUT(OUTPUT_i));

   data_sink DS(.CLK(CLK_i),
		.OUTPUT(OUTPUT_i));   

endmodule

		   
