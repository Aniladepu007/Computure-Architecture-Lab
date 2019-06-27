module ifu(input rst, input clk, output [15:0] o);
reg [9:0] count;
reg [15:0] o;
wire [15:0] m [0:1023];

assign m[0]=16'b1010101010110010;
assign m[1]=16'b1100001000110000;
assign m[2]=16'b0101001100110001;
assign m[3]=16'b1011001010100011;
assign m[4]=16'b1000001000110011;
assign m[5]=16'b1001001100000000;
assign m[6]=16'b0011011110110011;
assign m[7]=16'b1001011100110010;
assign m[8]=16'b0001001100111111;

always @(posedge clk)
begin
	if(rst)
	begin
		count <= 0;
		o<=m[count];
	end
	else
	begin
		count <= count < 8 ? count+10'b0000000001: 0;
		o<=m[count];
	end

end
endmodule
