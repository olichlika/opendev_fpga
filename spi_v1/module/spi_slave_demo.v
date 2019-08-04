module spi_slave_demo(
   input clk,
   input rst_n,
	output txd,
	//spi部分
   input ncs, mosi, sck,
   output miso
);

wire [1:0] DoneU1/*synthesis keep*/;
wire [7:0] DataU1/*synthesis keep*/;

spi_slave_module U1(
	.clk (clk),
	.rst_n (rst_n),
	.OData (DataU1),
	.ODone (DoneU1),
	.ncs (ncs),
	.mosi (mosi),
	.sck (sck),
	.miso (miso)
);

wire [1:0] TagU2;
wire [7:0] DataU2;

//IP核 FIFO 校验位Even
fifo U2(
	.clock (clk),
	.wrreq (DoneU1[0]),
	.rdreq (isRead),
	.data (DataU1), //写入数据
	.empty (TagU2[0]), //读空信号
	.full (TagU2[1]), //写满信号
	.q (DataU2) //fifo读出数据
);

//wire DoneU3;
//
//tx_func_module U3(
//	.clk (clk),
//	.rst_n (rst_n),
//	.iCall (isTX),
//	.iData (DataU2),
//	.oDone (DoneU3),
//	.txd (txd)
//);

//************发送部分************
//reg isTX;
//reg isRead;
//reg [3:0] i;
//
//always @(posedge clk or negedge rst_n) begin
//   if(!rst_n)
//		begin
//			i <= 4'd0;
//			isRead <= 1'b0;
//			isTX <= 1'b0;
//		end
//	else
//		case(i)
//			0:
//				if(!TagU2[0]) //读fifo不为空
//					begin
//						isRead <= 1'b1;//读1个数据
//						i <= i + 1'b1;
//					end
//			1:
//				begin
//					isRead <= 1'b0;
//					i <= i + 1'b1;
//				end
//			2:
//				if(DoneU3)
//					begin
//						isTX <= 1'b0;
//						i <= 4'd0;
//					end
//				else
//					begin
//						isTX <= 1'b1;
//					end					
//		endcase
//end
//************控制部分************
reg [3:0] i;
reg isRead;
reg [7:0] SPIData/*synthesis noprune*/;
always @(posedge clk or negedge rst_n) begin
   if(!rst_n)
		begin
			i <= 4'd0;
			isRead <= 1'b0;
			SPIData <= 8'd0;
		end
   else
		case(i)
			0:
				if(!TagU2[0]) //读fifo不为空
					begin
						isRead <= 1'b1;//读1个数据
						i <= i + 1'b1;
					end
			1:
				begin
					isRead <= 1'b0;
					i <= i + 1'b1;
					SPIData <= DataU2;
				end
			2:
				i <= 4'd0;
		endcase
end

endmodule
