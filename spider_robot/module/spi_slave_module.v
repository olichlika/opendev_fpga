module spi_slave_module(
	input clk,
	input rst_n,
	//spi部分
	input ncs, mosi, sck,
	output miso,
	
	output [2:0] oLED_Sig,
	
	output PWM_Top_Left_Coxa_Sig,
	output PWM_Top_Left_Femur_Sig,
	output PWM_Top_Left_Tibia_Sig,

	output PWM_Top_Right_Coxa_Sig,
	output PWM_Top_Right_Femur_Sig,
	output PWM_Top_Right_Tibia_Sig,
	
	output PWM_Back_Left_Coxa_Sig,
	output PWM_Back_Left_Femur_Sig,
	output PWM_Back_Left_Tibia_Sig,

	output PWM_Back_Right_Coxa_Sig,
	output PWM_Back_Right_Femur_Sig,
	output PWM_Back_Right_Tibia_Sig		
);

wire [1:0] DoneU1/*synthesis keep*/;
wire [7:0] DataU1/*synthesis keep*/;

spi_func_module U1(
	.clk (clk),
	.rst_n (rst_n),
	.ICall (CallU2),
	.IData (DataU2),
	.OData (DataU1),
	.ODone (DoneU1),
	.ncs (ncs),
	.mosi (mosi),
	.sck (sck),
	.miso (miso)
);

wire CallU2;
wire [7:0] DataU2;

wire [7:0] PWM_Top_Left_Coxa_Control_Sig;
wire [7:0] PWM_Top_Left_Femur_Control_Sig;
wire [7:0] PWM_Top_Left_Tibia_Control_Sig;

wire [7:0] PWM_Top_Right_Coxa_Control_Sig;
wire [7:0] PWM_Top_Right_Femur_Control_Sig;
wire [7:0] PWM_Top_Right_Tibia_Control_Sig;
	
wire [7:0] PWM_Back_Left_Coxa_Control_Sig;
wire [7:0] PWM_Back_Left_Femur_Control_Sig;
wire [7:0] PWM_Back_Left_Tibia_Control_Sig;

wire [7:0] PWM_Back_Right_Coxa_Control_Sig;
wire [7:0] PWM_Back_Right_Femur_Control_Sig;
wire [7:0] PWM_Back_Right_Tibia_Control_Sig;

spi_control_module U2(
	.clk (clk),
	.rst_n (rst_n),
	.ncs (ncs),
	.iDone (DoneU1),
	.iData (DataU1),
	.oCall (CallU2),
	.oData (DataU2),
	.oLED_Sig (oLED_Sig),
	
	.oPWM_Top_Left_Coxa_Control_Sig (PWM_Top_Left_Coxa_Control_Sig),
	.oPWM_Top_Left_Femur_Control_Sig (PWM_Top_Left_Femur_Control_Sig),
	.oPWM_Top_Left_Tibia_Control_Sig (PWM_Top_Left_Tibia_Control_Sig),
	
	.oPWM_Top_Right_Coxa_Control_Sig (PWM_Top_Right_Coxa_Control_Sig),
	.oPWM_Top_Right_Femur_Control_Sig (PWM_Top_Right_Femur_Control_Sig),
	.oPWM_Top_Right_Tibia_Control_Sig (PWM_Top_Right_Tibia_Control_Sig),
	
	.oPWM_Back_Left_Coxa_Control_Sig (PWM_Back_Left_Coxa_Control_Sig),
	.oPWM_Back_Left_Femur_Control_Sig (PWM_Back_Left_Femur_Control_Sig),
	.oPWM_Back_Left_Tibia_Control_Sig (PWM_Back_Left_Tibia_Control_Sig),
	
	.oPWM_Back_Right_Coxa_Control_Sig (PWM_Back_Right_Coxa_Control_Sig),
	.oPWM_Back_Right_Femur_Control_Sig (PWM_Back_Right_Femur_Control_Sig),
	.oPWM_Back_Right_Tibia_Control_Sig (PWM_Back_Right_Tibia_Control_Sig)
);
//左前脚
pwm PWM_Top_Left_Coxa_Module(
	.clk (clk),
	.rst_n (rst_n),
	.iPWM_Control_Sig (PWM_Top_Left_Coxa_Control_Sig),
	.oPWM_Output_Sig (PWM_Top_Left_Coxa_Sig),
);

pwm PWM_Top_Left_Femur_Module(
	.clk (clk),
	.rst_n (rst_n),
	.iPWM_Control_Sig (PWM_Top_Left_Femur_Control_Sig),
	.oPWM_Output_Sig (PWM_Top_Left_Femur_Sig),
);

pwm PWM_Top_Left_Tibia_Module(
	.clk (clk),
	.rst_n (rst_n),
	.iPWM_Control_Sig (PWM_Top_Left_Tibia_Control_Sig),
	.oPWM_Output_Sig (PWM_Top_Left_Tibia_Sig),
);	
//右前脚
pwm PWM_Top_Right_Coxa_Module(
	.clk (clk),
	.rst_n (rst_n),
	.iPWM_Control_Sig (PWM_Top_Right_Coxa_Control_Sig),
	.oPWM_Output_Sig (PWM_Top_Right_Coxa_Sig),
);

pwm PWM_Top_Right_Femur_Module(
	.clk (clk),
	.rst_n (rst_n),
	.iPWM_Control_Sig (PWM_Top_Right_Femur_Control_Sig),
	.oPWM_Output_Sig (PWM_Top_Right_Femur_Sig),
);

pwm PWM_Top_Right_Tibia_Module(
	.clk (clk),
	.rst_n (rst_n),
	.iPWM_Control_Sig (PWM_Top_Right_Tibia_Control_Sig),
	.oPWM_Output_Sig (PWM_Top_Right_Tibia_Sig),
);
//左后脚
pwm PWM_Back_Left_Coxa_Module(
	.clk (clk),
	.rst_n (rst_n),
	.iPWM_Control_Sig (PWM_Back_Left_Coxa_Control_Sig),
	.oPWM_Output_Sig (PWM_Back_Left_Coxa_Sig),
);

pwm PWM_Back_Left_Femur_Module(
	.clk (clk),
	.rst_n (rst_n),
	.iPWM_Control_Sig (PWM_Back_Left_Femur_Control_Sig),
	.oPWM_Output_Sig (PWM_Back_Left_Femur_Sig),
);

pwm PWM_Back_Left_Tibia_Module(
	.clk (clk),
	.rst_n (rst_n),
	.iPWM_Control_Sig (PWM_Back_Left_Tibia_Control_Sig),
	.oPWM_Output_Sig (PWM_Back_Left_Tibia_Sig),
);	
//右后脚
pwm PWM_Back_Right_Coxa_Module(
	.clk (clk),
	.rst_n (rst_n),
	.iPWM_Control_Sig (PWM_Back_Right_Coxa_Control_Sig),
	.oPWM_Output_Sig (PWM_Back_Right_Coxa_Sig),
);

pwm PWM_Back_Right_Femur_Module(
	.clk (clk),
	.rst_n (rst_n),
	.iPWM_Control_Sig (PWM_Back_Right_Femur_Control_Sig),
	.oPWM_Output_Sig (PWM_Back_Right_Femur_Sig),
);

pwm PWM_Back_Right_Tibia_Module(
	.clk (clk),
	.rst_n (rst_n),
	.iPWM_Control_Sig (PWM_Back_Right_Tibia_Control_Sig),
	.oPWM_Output_Sig (PWM_Back_Right_Tibia_Sig),
);	
endmodule
