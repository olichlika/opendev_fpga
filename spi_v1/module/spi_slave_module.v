module spi_slave_module(
   input clk,
   input rst_n,
	//spi部分
   input ncs, mosi, sck,
   output miso,
	//测试信号
	output tncs, tmosi, tsck,
   output tmiso
);
assign tsck = sck;
assign tncs = ncs;
assign tmosi = mosi;
assign tmiso = miso;

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

spi_control_module U2(
	.clk (clk),
	.rst_n (rst_n),
	.iDone (DoneU1),
	.iData (DataU1),
	.oCall (CallU2),
	.oData (DataU2)
);
endmodule
