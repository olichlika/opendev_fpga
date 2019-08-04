module spi_func_module(
   input clk,
   input rst_n,
	input ICall,//发送使能
	input [7:0] IData,//发送的数据
	output reg [7:0] OData,
	output reg [1:0] ODone,
	//spi部分
   input ncs, mosi, sck,
   output reg miso
);

//************异步信号同步和检测时钟跳变************
reg [2:0] sck_edge;
always @(posedge clk or negedge rst_n) begin
   if(!rst_n)
		sck_edge <= 3'b000;
   else
		sck_edge <= {sck_edge[1:0], sck};
end

wire sck_riseedge/*synthesis keep*/;
wire sck_falledge/*synthesis keep*/;

assign sck_riseedge = (sck_edge[2:1] == 2'b01);  //检测到SCK由0变成1，则认为发现上跳沿
assign sck_falledge = (sck_edge[2:1] == 2'b10);  //检测到SCK由1变成0，则认为发现下跳沿

//ncs信号
reg [2:0] ncs_r;
always @(posedge clk or negedge rst_n) begin
   if(!rst_n)
		ncs_r <= 3'b000;
   else
		ncs_r <= {ncs_r[1:0], ncs};
end
wire ncs_t = ncs_r[2];

//mosi信号
reg [2:0] mosi_r;
always @(posedge clk or negedge rst_n) begin
   if(!rst_n)
		mosi_r <= 3'b000;
   else
		mosi_r <= {mosi_r[1:0], mosi};
end

wire mosi_t = mosi_r[2];
//************状态机接收数据************
reg [7:0] rec_status;  //SPI接收部分状态机
reg [7:0] byte_received; //移位寄存器
reg [3:0] bit_received_cnt;//接收位数寄存器

always @(posedge clk or negedge rst_n) begin
   if(!rst_n)
		begin
			rec_status <= 8'd0;
			byte_received <= 8'd0;
			ODone[0] <= 1'b0;
			OData <= 8'd0;
		end
   else
		begin
			if(!ncs_t) //ncs有效
				begin
					case(rec_status)
						8'd0, 8'd1, 8'd2, 8'd3, 8'd4, 8'd5, 8'd6, 8'd7:
							if(sck_riseedge)
								begin
									byte_received <= {byte_received[6:0], mosi_t};
									rec_status <= rec_status + 1'b1;
								end
						8'd8:
							begin
								OData <= byte_received;
								ODone[0] <= 1'b1;
								rec_status <= rec_status + 1'b1;
							end
						8'd9:
							begin
								ODone[0] <= 1'b0;
								rec_status <= 8'd0;
							end
					endcase
				end
			else
				begin
					rec_status <= 8'd0;				
				end
		end
end

//************状态机发送数据************
reg [7:0] send_status;
//reg [7:0] byte_sended;  //发送移位寄存器
always @(posedge clk or negedge rst_n) begin
   if(!rst_n)
		begin
			send_status <= 8'd0;
			ODone[1] <= 1'b0;
			miso <= 1'b0;
		end
   else if(!ncs_t)
		if(ICall)
			case(send_status)
				8'd0, 8'd1, 8'd2, 8'd3, 8'd4, 8'd5, 8'd6, 8'd7:
					if(sck_falledge)
						begin
							miso <= IData[7 - send_status];//发送第7位
							send_status <= send_status + 1'b1;
						end
				8'd8:
					if(sck_falledge)//等最后一次下降沿
						begin
							ODone[1] <= 1'b1;
							send_status <= send_status + 1'b1;
						end
				9'd9:
					begin
						ODone[1] <= 1'b0;
						send_status <= 8'd0;
					end
			endcase
	else
		begin
			send_status <= 8'd0;
			ODone[1] <= 1'b0;
			miso <= 1'b0;
		end
		
end

endmodule
