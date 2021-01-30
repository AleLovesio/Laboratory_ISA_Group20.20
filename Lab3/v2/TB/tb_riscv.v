//`timescale 1ns

module tb_riscv ();

   wire CLK_i;
   wire RSTn_i;
   wire ARSTn_i;
   wire RSTn_RV;
   wire END_SIM_i;
   wire EN_i;
   wire end_code;
   wire end_data;
   wire end_init;
   wire [31:0] add_data;
   wire [31:0] add_code;
   wire [31:0] DIN_data;
   wire [31:0] DOUT_data;
   wire [31:0] DIN_code;
   wire WE_data;
   wire RE_data;
   
   wire [31:0] DOUT_code;
   wire WE_code;
   wire RE_code;
   wire RSTn_mem;
   
	assign RE_code = 1;
	assign EN_i = 1;
	assign ARSTn_i = 1;
	assign RSTn_mem = 1;

	and (end_init, end_code, end_data);
	and (RSTn_RV, RSTn_i, end_init);
	
	clk_gen CG(	.END_SIM(END_SIM_i),
				.RSTn(RSTn_i),
			    .CLK(CLK_i));

	instruction_mem IM(	.Address(add_code),
						//.Data_IN(DOUT_code),
						//.WE(WE_code),
						.RE(RE_code),
						.Ready(end_code),
						.Data_OUT(DIN_code));
	
	data_mem DM(.RSTn(RSTn_mem),
				.Address(add_data),
				.Data_IN(DOUT_data),
				.WE(WE_data),
				.RE(RE_data),
				.Ready(end_data),
				.Data_OUT(DIN_data));
				
	riscv RV(
			.CLK(CLK_i),
			.RSTn(RSTn_RV),
			.ASYNC_RSTn(ARSTn_i),
			.EN(EN_i),
			.ADDR_INSTR(add_code),
			.ADDR_DATA(add_data),
			.MEM_INSTR(DIN_code),
			.MEM_DATA_IN(DIN_data),
			.MEM_DATA_OUT(DOUT_data),
			.MEM_DATA_WRITE(WE_data), 
			.MEM_DATA_READ(RE_data)); 

endmodule

		   
