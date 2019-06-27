module cla_tb();
reg [15:0] avector;
reg [15:0] bvector;
wire [16:0] c;
reg clock;

cla obj(
.a(avector),
.b(bvector),
.out(c),
.clk(clock)
);

initial begin
$dumpfile("cla_prefix_structural.vcd");
$dumpvars(0,cla_tb);
      clock <= 1'b1;
      avector = 16'b1111111111111111;
      bvector = 16'b1111111111111111;
#12;
      avector <= 38;
      bvector <= 12;
#12;
      avector <= 111;
      bvector <= 121;
#12;
/*      avector <= 92;
      bvector <= 43;
#12;
      avector <= 23;
      bvector <= 52;
#12;
      avector <= 82;
      bvector <= 43;*/
#1000;
      $finish;
end

always @ ( c ) begin
      $display($time,"  :    %d  +  %d  =  %d ",avector,bvector,c);
end

always begin
      #1 clock <= !clock;
end
endmodule
