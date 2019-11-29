module pwm(
	input clk,
	input rst_n,
	input [7:0] iPWM_Control_Sig,
	output oPWM_Output_Sig
);

//20MS = 20_000_000ns
parameter T20MS = 20'd999_999;
//1个时钟是20ns 500_000ns 需要25000个时钟
parameter T0_5MS = 20'd25000-1;
parameter T0_75MS = 20'd37500-1;
parameter T1_00MS = 20'd50000-1;
parameter T1_25MS = 20'd62500-1;
parameter T1_50MS = 20'd75000-1;
parameter T1_75MS = 20'd87500-1;
parameter T2_00MS = 20'd100000-1;
parameter T2_25MS = 20'd112500-1;
parameter T2_50MS = 20'd125000-1;

reg [19:0] C1;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		C1 <= 20'd0;
	else if(C1 == T20MS)
		C1 <= 20'd0;
	else
		C1 <= C1 + 1'b1;
end

reg r_PWM_Output_Sig;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r_PWM_Output_Sig <= 1'b0;
	else
		case(iPWM_Control_Sig)
			8'd0:
				if(C1 <= T0_5MS)
					r_PWM_Output_Sig <= 1'b0;
				else
					r_PWM_Output_Sig <= 1'b1;
			8'd1:
				if(C1 <= T0_75MS)
					r_PWM_Output_Sig <= 1'b0;
				else
					r_PWM_Output_Sig <= 1'b1;
			8'd2:
				if(C1 <= T1_00MS)
					r_PWM_Output_Sig <= 1'b0;
				else
					r_PWM_Output_Sig <= 1'b1;
			8'd3:
				if(C1 <= T1_25MS)
					r_PWM_Output_Sig <= 1'b0;
				else
					r_PWM_Output_Sig <= 1'b1;
			8'd4:
				if(C1 <= T1_50MS)
					r_PWM_Output_Sig <= 1'b0;
				else
					r_PWM_Output_Sig <= 1'b1;
			8'd5:
				if(C1 <= T1_75MS)
					r_PWM_Output_Sig <= 1'b0;
				else
					r_PWM_Output_Sig <= 1'b1;
			8'd6:
				if(C1 <= T2_00MS)
					r_PWM_Output_Sig <= 1'b0;
				else
					r_PWM_Output_Sig <= 1'b1;
			8'd7:
				if(C1 <= T2_25MS)
					r_PWM_Output_Sig <= 1'b0;
				else
					r_PWM_Output_Sig <= 1'b1;
			8'd8:
				if(C1 <= T2_50MS)
					r_PWM_Output_Sig <= 1'b0;
				else
					r_PWM_Output_Sig <= 1'b1;
			default:
				if(C1 <= T0_5MS)
					r_PWM_Output_Sig <= 1'b0;
				else
					r_PWM_Output_Sig <= 1'b1;				
		endcase
end	

assign oPWM_Output_Sig = r_PWM_Output_Sig;	
		
		
endmodule
