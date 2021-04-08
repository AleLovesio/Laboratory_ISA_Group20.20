module DUT(dut_if.port_in in_inter, dut_if.port_out out_inter, output enum logic [2:0] {INITIAL,WAIT_0,WAIT_1,ALIGN,SEND} state);
    
    FPmul fpmpy_under_test(.FP_A(in_inter.A),.FP_B(in_inter.B),.clk(in_inter.clk),.FP_Z(out_inter.data));

	integer cnt = 0;
	logic [31:0] A1,B1;

    always_ff @(posedge in_inter.clk)
    begin
        if(in_inter.rst) begin
            in_inter.ready <= 0;
            out_inter.data <= 'x;
            out_inter.valid <= 0;
            state <= INITIAL;
			cnt = 0;
        end
        else case(state)
                INITIAL: begin
					in_inter.ready <= 1;
    	            state <= WAIT_0;
					cnt=0;
                end

				WAIT_0: begin
					if(in_inter.valid) begin
						in_inter.ready <= 0;
						A1 = in_inter.A;
						B1 = in_inter.B;
					end
					out_inter.valid <= 0;
					state <= ALIGN;
				end		

				ALIGN: begin
					in_inter.ready <= 0;
					out_inter.valid <= 0;
					if(cnt<4) begin
						cnt = cnt + 1;
						state <= ALIGN;
					end
					else begin
						state <= WAIT_1;
					end
				end				
                
                WAIT_1: begin
                    in_inter.ready <= 0;
					out_inter.valid <= 1;
					$display("FP mul: input A = %e, input B = %e, output OUT = %e",$bitstoshortreal(A1), $bitstoshortreal(B1),$bitstoshortreal(out_inter.data));
					$display("FP mul: input A = %b, input B = %b, output OUT = %b", A1, B1, out_inter.data);
                    state <= SEND;
                end
                
                SEND: begin
                    if(out_inter.ready) begin
                        out_inter.valid <= 0;
                        in_inter.ready <= 1;
                        state <= WAIT_0;
						cnt=0;
                    end
                end
        endcase
    end
endmodule: DUT
