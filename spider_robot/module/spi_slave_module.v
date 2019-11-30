module spi_slave_module(
	input clk,
	input rst_n,
	//spi部分
	input ncs, mosi, sck,
	output miso,
	
	output [2:0] oLED_Sig,
	
	output PWM_Top_Left_Coxa_Sig
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

spi_control_module U2(
	.clk (clk),
	.rst_n (rst_n),
	.ncs (ncs),
	.iDone (DoneU1),
	.iData (DataU1),
	.oCall (CallU2),
	.oData (DataU2),
	.oLED_Sig (oLED_Sig),
	
	.oPWM_Top_Left_Coxa_Control_Sig (PWM_Top_Left_Coxa_Control_Sig)
);

pwm PWM_Coxa_Module(
	.clk (clk),
	.rst_n (rst_n),
	.iPWM_Control_Sig (PWM_Top_Left_Coxa_Control_Sig),
	.oPWM_Output_Sig (PWM_Top_Left_Coxa_Sig)
);

endmodule
