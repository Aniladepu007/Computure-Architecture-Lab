module cachetb;
reg clk;
reg [15:0]write1,read1,writedata;
reg r1e,w1e;
wire readHit;
wire [15:0]readout1;
always
  #1 clk=!clk;
cache obj(
  .read1(read1),
  .write1(write1),
  .writedata(writedata),
  .r1e(r1e),
  .w1e(w1e),
  .clk(clk),
  .readHit(readHit),
  .readout1(readout1)
  );
initial begin
  clk=0;
  r1e=1;read1=0;
  #4;
  r1e=1;read1=1;
  #4;
  r1e=0;w1e=1;
  write1=1;writedata=343;
  #4;
  w1e=0;r1e=1;
  #4;
  read1=16;
  #4;
  read1=128;
  #4;
  read1=1;
  #20 $finish;
end

initial begin
  $dumpfile("cachetb.vcd");
  $dumpvars(0,cachetb);
  $monitor(" %d  %d  %d",read1,readout1,readHit);
end



endmodule
