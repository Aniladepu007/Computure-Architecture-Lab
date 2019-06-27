module fetch_decode(input [3:0]read1, input [3:0]read2, input [3:0]write,
      input [15:0]data, input readEnable, input writeEnable, input clk,
      output [15:0]readout1, output [15:0]writeout, output [15:0]readout2, input reset);

reg [15:0] readout1,readout2,writeout;

reg [15:0] reg_file [15:0] ;
//register file

always @(posedge clk) begin
      if(reset) begin
            reg_file[0] <= 16'b0000000000000001;
            reg_file[1] <= 16'b0000000000000010;
            reg_file[2] <= 16'b0000000000000011;
            reg_file[3] <= 16'b0000000000000100;
            reg_file[4] <= 16'b0000000000000101;
            reg_file[5] <= 16'b0000000000000110;
            reg_file[6] <= 16'b0000000000000111;
            reg_file[7] <= 16'b0000000000001000;
            reg_file[8] <= 16'b0000000000001001;
            reg_file[9] <= 16'b0000000000001010;
            reg_file[10] <= 16'b0000000000001011;
            reg_file[11] <= 16'b0000000000001100;
            reg_file[12] <= 16'b0000000000001101;
            reg_file[13] <= 16'b0000000000001110;
            reg_file[14] <= 16'b0000000000001111;
            reg_file[15] <= 16'b0000000000010000;
      end
      else begin
            if(readEnable == 1 && writeEnable == 1) begin
                  readout1 <= 16'bxxxxxxxxxxxxxxxx;
                  readout2 <= 16'bxxxxxxxxxxxxxxxx;
            end

            else begin
                  readout1 <= readEnable ? reg_file[read1] : 16'bzzzzzzzzzzzzzzzz;
                  readout2 <= readEnable ? reg_file[read2] : 16'bzzzzzzzzzzzzzzzz;
                  reg_file[write] <= writeEnable ? data : reg_file[write];
                  writeout <= writeEnable ? data : reg_file[write];
            end
      end
end
endmodule
