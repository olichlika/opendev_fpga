module spi_control_module(
	input clk,
	input rst_n,
	input ncs, //spi ncs信号
	input [1:0] iDone,//iDone[0]接收1字节完成 iDone[1]发送1字节完成
	input [7:0] iData,//spi接收到的数据
	output reg oCall,
	output reg [7:0] oData, //spi发送数据
	
	output reg [2:0] oLED_Sig,
	
	output reg [7:0] oPWM_Top_Left_Coxa_Control_Sig
);

//************同步异步信号************
reg [2:0] ncs_r;
always @(posedge clk or negedge rst_n) begin
   if(!rst_n)
		ncs_r <= 3'b000;
   else
		ncs_r <= {ncs_r[1:0], ncs};
end
wire ncs_t = ncs_r[2];


//************控制部分************
parameter LED_CONTROL = 8'd3;

parameter TOP_LEFT_COXA_CONTROL = 8'd4;

reg [7:0] i;

always @(posedge clk or negedge rst_n) begin
   if(!rst_n)
		begin
			i <= 8'd0;
			oCall <= 1'b0;
			oData <= 8'd0;
			
			oLED_Sig <= 3'b000;
			
			oPWM_Top_Left_Coxa_Control_Sig <= 8'd0;
		end
   else
		if(!ncs_t)
			case(i)
				0:
					if(iDone[0])
						i <= i + 1'b1;
					else
						i <= 8'd0;
				1: //spi第1个字节信号
					if(iData == 8'h06)//处理0x06命令
						begin
							i <= 8'd2;
						end
					else if(iData == 8'hA1)
						begin
							i <= LED_CONTROL;
						end
					else if(iData == 8'hA3)
						begin
							i <= TOP_LEFT_COXA_CONTROL;
						end								
					else
						i <= 8'd0;
				2:
					if(iDone[1])
						begin
							oCall <= 1'b0;
							i <= 8'd0;
							oData <= 8'd0;
						end
					else
						begin
							oData <= 8'hd4;
							oCall <= 1'b1;
						end
				LED_CONTROL:
					if(iDone[1])
						begin
							oCall <= 1'b0;
							i <= 8'd0;
							oLED_Sig <= iData;
						end
					else
						oCall <= 1'b1;
				TOP_LEFT_COXA_CONTROL:
					if(iDone[1])
						begin
							oCall <= 1'b0;
							i <= 8'd0;
							oPWM_Top_Left_Coxa_Control_Sig <= iData;
						end
					else
						oCall <= 1'b1;					
			endcase
		else
			begin
				i <= 8'd0;//cs为高 状态机清零
				oCall <= 1'b0;
			end
end

endmodule
