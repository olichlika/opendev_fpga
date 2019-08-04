module spi_module(
   input clk,
   input rst_n,
   input I_tx_en, // 读使能信号
	input [7:0] I_data_in, // 要发送的数据
   output reg O_tx_done, // 发送一个字节完毕标志位
    // 四线标准SPI信号定义
	input I_spi_miso, // SPI串行输入，用来接收从机的数据
   output reg O_spi_sck, // SPI时钟
   output reg O_spi_cs, // SPI片选信号
   output reg O_spi_mosi // SPI输出，用来给从机发送数据       
);

reg [3:0] R_tx_state; 

always @(posedge clk or negedge rst_n) begin
   if(!rst_n)
		begin
			R_tx_state <= 4'd0;
			O_spi_cs <= 1'b1;
			O_spi_sck <= 1'b0;
			O_spi_mosi <= 1'b0;
			O_tx_done <= 1'b0;
		end
   else if(I_tx_en)
		begin
			O_spi_cs <= 1'b0;
			case(R_tx_state)
				4'd1, 4'd3 , 4'd5 , 4'd7, 
            4'd9, 4'd11, 4'd13, 4'd15 : //整合奇数状态
					begin
						O_spi_sck <= 1'b1;
                  R_tx_state <= R_tx_state + 1'b1;//15是最大的数 跳回0
                  O_tx_done <= 1'b0;
               end
            4'd0: // 发送第7位
					begin
						O_spi_mosi <= I_data_in[7];
                  O_spi_sck <= 1'b0;
                  R_tx_state <= R_tx_state + 1'b1;
                  O_tx_done <= 1'b0;
               end
            4'd2: // 发送第6位
					begin
						O_spi_mosi <= I_data_in[6];
                  O_spi_sck <= 1'b0;
                  R_tx_state <= R_tx_state + 1'b1;
                  O_tx_done <= 1'b0;
               end
            4'd4: // 发送第5位
					begin
						O_spi_mosi <= I_data_in[5];
                  O_spi_sck <= 1'b0;
                  R_tx_state <= R_tx_state + 1'b1;
                  O_tx_done <= 1'b0;
               end
            4'd6: // 发送第4位
					begin
						O_spi_mosi <= I_data_in[4];
                  O_spi_sck <= 1'b0;
                  R_tx_state <= R_tx_state + 1'b1;
                  O_tx_done <= 1'b0;
               end
            4'd8: // 发送第3位
					begin
						O_spi_mosi <= I_data_in[3];
                  O_spi_sck <= 1'b0;
                  R_tx_state <= R_tx_state + 1'b1;
                  O_tx_done <= 1'b0;
               end
            4'd10: // 发送第2位
					begin
						O_spi_mosi <= I_data_in[2];
                  O_spi_sck <= 1'b0;
                  R_tx_state <= R_tx_state + 1'b1;
                  O_tx_done <= 1'b0;
               end
            4'd12: // 发送第1位
					begin
						O_spi_mosi <= I_data_in[1];
                  O_spi_sck <= 1'b0;
                  R_tx_state <= R_tx_state + 1'b1;
                  O_tx_done <= 1'b0;
               end
            4'd14: // 发送第7位
					begin
						O_spi_mosi <= I_data_in[0];
                  O_spi_sck <= 1'b0;
                  R_tx_state <= R_tx_state + 1'b1;
                  O_tx_done <= 1'b1;
               end
				default: R_tx_state  <=  4'd0;
			endcase
		end
end


endmodule
