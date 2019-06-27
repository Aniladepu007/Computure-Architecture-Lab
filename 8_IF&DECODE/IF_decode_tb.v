module fetch_sim();
reg clk;
reg reset;
reg readEnable,writeEnable;
reg [3:0] read1,read2,write;
reg [15:0] data;

wire [15:0] readout1,readout2,writeout;

fetch_decode obj(
   .reset(reset),
   .read1(read1),
   .read2(read2),
   .write(write),
   .readEnable(readEnable),
   .writeEnable(writeEnable),
   .clk(clk),
   .readout1(readout1),
   .readout2(readout2),
   .data(data),
   .writeout(writeout)
);

initial begin
      $dumpfile("fetch.vcd");
      $dumpvars(0,fetch_sim);
      $display("                 Time   clk       readout1    readout2    writeout");
      reset = 1;
      clk=0;
      #2 reset = 0;
      read1 = 2;
      read2 = 3;
      write = 6;
      readEnable = 1;
      writeEnable = 0;
      data = 143;
      #5
      writeEnable = 1;
      readEnable = 0;
      #4
      readEnable = 1;
      #3
      writeEnable = 0;
      #5;
       $finish;
end

always @ ( posedge clk ) begin
      $display($time,"     %d       %d       %d       %d",clk,readout1,readout2,writeout);
end

always
#1 clk=~clk;

endmodule
