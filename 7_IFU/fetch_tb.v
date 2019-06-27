module ifu_tb();
reg rst;
reg clk;
wire [15:0] o;
ifu obj(.rst(rst),.clk(clk),.o(o));

initial begin
	$dumpfile("if.vcd");
	$dumpvars(0,ifu_tb);
	clk<=1;
	rst<=1;
	#2
	rst<=0;
	#20
	$finish;
end

always @ ( o ) begin
	$monitor($time,"\tIns: %b\tPC :%d\t",o,obj.count);
end
always
	#1 clk=~clk;
endmodule
