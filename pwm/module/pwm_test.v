module pwm_test(
	input clk,
	input rst_n,
	output PWM_Output_Sig
);

//1s = 49999999
parameter T1S = 27'd49999999;

reg [26:0] C1;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		C1 <= 27'd0;
	else if(C1 == T1S)
		C1 <= 27'd0;
	else
		C1 <= C1 + 1'b1;
end

reg [7:0] i;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		i <= 8'd0;
	else if((C1 == T1S) && (i < 8))
		i <= i + 1'b1;
	else if((C1 == T1S) && (i == 8))
		i <= 8'd0;
	else
		i <= i;
end

reg [7:0] PWM_Control_Sig;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		PWM_Control_Sig <= 8'd0;
	else
		case(i)
			8'd0:
				PWM_Control_Sig <= 8'd0;
			8'd1:
				PWM_Control_Sig <= 8'd1;
			8'd2:
				PWM_Control_Sig <= 8'd2;
			8'd3:
				PWM_Control_Sig <= 8'd3;
			8'd4:
				PWM_Control_Sig <= 8'd4;
			8'd5:
				PWM_Control_Sig <= 8'd5;
			8'd6:
				PWM_Control_Sig <= 8'd6;
			8'd7:
				PWM_Control_Sig <= 8'd7;
			8'd8:
				PWM_Control_Sig <= 8'd8;		
		endcase
end


pwm U0(
	.clk (clk),
	.rst_n (rst_n),
	.iPWM_Control_Sig (PWM_Control_Sig),
	.oPWM_Output_Sig (PWM_Output_Sig)
);
endmodule
