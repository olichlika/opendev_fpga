module spi_control_module(
	input clk,
	input rst_n,
	input ncs, //spi ncs信号
	input [1:0] iDone,//iDone[0]接收1字节完成 iDone[1]发送1字节完成
	input [7:0] iData,//spi接收到的数据
	output reg oCall,
	output reg [7:0] oData, //spi发送数据
	
	output reg [2:0] oLED_Sig,
	
	output reg [7:0] oPWM_Top_Left_Coxa_Control_Sig,
	output reg [7:0] oPWM_Top_Left_Femur_Control_Sig,
	output reg [7:0] oPWM_Top_Left_Tibia_Control_Sig,

	output reg [7:0] oPWM_Top_Right_Coxa_Control_Sig,
	output reg [7:0] oPWM_Top_Right_Femur_Control_Sig,
	output reg [7:0] oPWM_Top_Right_Tibia_Control_Sig,

	output reg [7:0] oPWM_Back_Left_Coxa_Control_Sig,
	output reg [7:0] oPWM_Back_Left_Femur_Control_Sig,
	output reg [7:0] oPWM_Back_Left_Tibia_Control_Sig,

	output reg [7:0] oPWM_Back_Right_Coxa_Control_Sig,
	output reg [7:0] oPWM_Back_Right_Femur_Control_Sig,
	output reg [7:0] oPWM_Back_Right_Tibia_Control_Sig
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
parameter TOP_LEFT_FEMUR_CONTROL = 8'd5;
parameter TOP_LEFT_TIBIA_CONTROL = 8'd6;

parameter TOP_RIGHT_COXA_CONTROL = 8'd7;
parameter TOP_RIGHT_FEMUR_CONTROL = 8'd8;
parameter TOP_RIGHT_TIBIA_CONTROL = 8'd9;

parameter BACK_LEFT_COXA_CONTROL = 8'd10;
parameter BACK_LEFT_FEMUR_CONTROL = 8'd11;
parameter BACK_LEFT_TIBIA_CONTROL = 8'd12;

parameter BACK_RIGHT_COXA_CONTROL = 8'd13;
parameter BACK_RIGHT_FEMUR_CONTROL = 8'd14;
parameter BACK_RIGHT_TIBIA_CONTROL = 8'd15;

reg [7:0] i;

always @(posedge clk or negedge rst_n) begin
   if(!rst_n)
		begin
			i <= 8'd0;
			oCall <= 1'b0;
			oData <= 8'd0;
			
			oLED_Sig <= 3'b000;
			
			oPWM_Top_Left_Coxa_Control_Sig <= 8'd0;
			oPWM_Top_Left_Femur_Control_Sig <= 8'd0;
			oPWM_Top_Left_Tibia_Control_Sig <= 8'd0;

			oPWM_Top_Right_Coxa_Control_Sig <= 8'd0;
			oPWM_Top_Right_Femur_Control_Sig <= 8'd0;
			oPWM_Top_Right_Tibia_Control_Sig <= 8'd0;

			oPWM_Back_Left_Coxa_Control_Sig <= 8'd0;
			oPWM_Back_Left_Femur_Control_Sig <= 8'd0;
			oPWM_Back_Left_Tibia_Control_Sig <= 8'd0;

			oPWM_Back_Right_Coxa_Control_Sig <= 8'd0;
			oPWM_Back_Right_Femur_Control_Sig <= 8'd0;
			oPWM_Back_Right_Tibia_Control_Sig <= 8'd0;			
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
					else if(iData == 8'hA4)
						begin
							i <= TOP_LEFT_FEMUR_CONTROL;
						end
					else if(iData == 8'hA5)
						begin
							i <= TOP_LEFT_TIBIA_CONTROL;
						end			
					else if(iData == 8'hA6)
						begin
							i <= TOP_RIGHT_COXA_CONTROL;
						end
					else if(iData == 8'hA7)
						begin
							i <= TOP_RIGHT_FEMUR_CONTROL;
						end
					else if(iData == 8'hA8)
						begin
							i <= TOP_RIGHT_TIBIA_CONTROL;
						end
					else if(iData == 8'hA9)
						begin
							i <= BACK_LEFT_COXA_CONTROL;
						end
					else if(iData == 8'hAA)
						begin
							i <= BACK_LEFT_FEMUR_CONTROL;
						end
					else if(iData == 8'hAB)
						begin
							i <= BACK_LEFT_TIBIA_CONTROL;
						end			
					else if(iData == 8'hAC)
						begin
							i <= BACK_RIGHT_COXA_CONTROL;
						end
					else if(iData == 8'hAD)
						begin
							i <= BACK_RIGHT_FEMUR_CONTROL;
						end
					else if(iData == 8'hAE)
						begin
							i <= BACK_RIGHT_TIBIA_CONTROL;
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
				TOP_LEFT_FEMUR_CONTROL:
					if(iDone[1])
						begin
							oCall <= 1'b0;
							i <= 8'd0;
							oPWM_Top_Left_Femur_Control_Sig <= iData;
						end
					else
						oCall <= 1'b1;
				TOP_LEFT_TIBIA_CONTROL:
					if(iDone[1])
						begin
							oCall <= 1'b0;
							i <= 8'd0;
							oPWM_Top_Left_Tibia_Control_Sig <= iData;
						end
					else
						oCall <= 1'b1;	

				TOP_RIGHT_COXA_CONTROL:
					if(iDone[1])
						begin
							oCall <= 1'b0;
							i <= 8'd0;
							oPWM_Top_Right_Coxa_Control_Sig <= iData;
						end
					else
						oCall <= 1'b1;
				TOP_RIGHT_FEMUR_CONTROL:
					if(iDone[1])
						begin
							oCall <= 1'b0;
							i <= 8'd0;
							oPWM_Top_Right_Femur_Control_Sig <= iData;
						end
					else
						oCall <= 1'b1;
				TOP_RIGHT_TIBIA_CONTROL:
					if(iDone[1])
						begin
							oCall <= 1'b0;
							i <= 8'd0;
							oPWM_Top_Right_Tibia_Control_Sig <= iData;
						end
					else
						oCall <= 1'b1;	
				//-----后腿-----
				BACK_LEFT_COXA_CONTROL:
					if(iDone[1])
						begin
							oCall <= 1'b0;
							i <= 8'd0;
							oPWM_Back_Left_Coxa_Control_Sig <= iData;
						end
					else
						oCall <= 1'b1;				
				BACK_LEFT_FEMUR_CONTROL:
					if(iDone[1])
						begin
							oCall <= 1'b0;
							i <= 8'd0;
							oPWM_Back_Left_Femur_Control_Sig <= iData;
						end
					else
						oCall <= 1'b1;
				BACK_LEFT_TIBIA_CONTROL:
					if(iDone[1])
						begin
							oCall <= 1'b0;
							i <= 8'd0;
							oPWM_Back_Left_Tibia_Control_Sig <= iData;
						end
					else
						oCall <= 1'b1;	

				BACK_RIGHT_COXA_CONTROL:
					if(iDone[1])
						begin
							oCall <= 1'b0;
							i <= 8'd0;
							oPWM_Back_Right_Coxa_Control_Sig <= iData;
						end
					else
						oCall <= 1'b1;
				BACK_RIGHT_FEMUR_CONTROL:
					if(iDone[1])
						begin
							oCall <= 1'b0;
							i <= 8'd0;
							oPWM_Back_Right_Femur_Control_Sig <= iData;
						end
					else
						oCall <= 1'b1;
				BACK_RIGHT_TIBIA_CONTROL:
					if(iDone[1])
						begin
							oCall <= 1'b0;
							i <= 8'd0;
							oPWM_Back_Right_Tibia_Control_Sig <= iData;
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
