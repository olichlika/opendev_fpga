module tx_func_module(
   input clk,
   input rst_n,
   input iCall,
   input [7:0] iData,
   output oDone,
   output txd
);

parameter BPS115200 = 9'd434;

reg [3:0] i;
reg [10:0] D1; //寄存发送数据
reg [8:0] C1; //时钟计数器
reg r_txd;
reg r_oDone;
always @(posedge clk or negedge rst_n) begin
   if(!rst_n)
		begin
			i <= 4'd0;
			r_txd <= 1'b0;
			C1 <= 9'd0;
			D1 <= 11'd0;
			r_oDone <= 1'b0;
		end
   else if(iCall)
		case(i)
			0:
				begin
					D1 <= {2'b11, iData, 1'b0};
					i <= i + 1'b1;
				end
			1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11:
				begin
					if(C1 == BPS115200 - 1)
						begin
							C1 <= 9'd0;
							i <= i + 1'b1;
							
						end
					else
						begin
							r_txd <= D1[i - 1];
							C1 <= C1 + 1'b1;
						end
				end
			12:
				begin
					r_oDone <= 1'b1;
					i <= i + 1'b1;
				end
			13:
				begin
					r_oDone <= 1'b0;
					i <= 4'b0;
				end				
		endcase
	else
		i <= 4'd0;
end

assign txd = r_txd;
assign oDone = r_oDone;

endmodule
