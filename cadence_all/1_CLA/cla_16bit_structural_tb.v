module cla_tb();
reg [15:0] avector;
reg [15:0] bvector;
wire [16:0] c;

cla obj(
.a(avector),
.b(bvector),
.out(c)
);

initial begin
//      avector = 16'b0000000011011011;
//      bvector = 16'b0000000001100110;
avector = 16'b1111111111111111;
bvector = 16'b1000000000000001;
#4;
      avector = 138;
      bvector = 100;
      #1;
      avector = 12;
      bvector = 13;
end

initial

begin
$dumpfile("cla_prefix_structural.vcd");
$dumpvars(0,cla_tb);
$monitor($time,"%b  %b  %b",avector,bvector,c);
end

endmodule
