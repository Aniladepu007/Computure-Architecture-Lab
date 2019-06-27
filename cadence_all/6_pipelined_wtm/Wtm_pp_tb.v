module wallace_tb();
reg [15:0] avector;
reg [15:0] bvector;
wire [32:0] c;

reg Clock;

//integer i;
wallace_mul obj(.a(avector), .b(bvector), .out(c), .clk(Clock));

initial begin
      $dumpfile("wallace.vcd");
      $dumpvars(0,wallace_tb);
//      avector = 16'b0000000011011011;
//      bvector = 16'b0000000001100110;
      Clock <= 1'b1;
      avector <= 6;
      bvector <= 65;
      #3;
      avector <= 36;
      bvector <= 11;
      #2;
      avector <= 6;
      bvector <= 6;
      #2;
      avector <= 16;
      bvector <= 16;
      #1000;
      $finish;
end


always @ ( c ) begin
//      $display("%b",obj.m15_1);
//      $display("%b",obj.u[13]);
      $display($time,"  %d   %d   %d",avector,bvector,c);
end

always
      #1 Clock <= !Clock;
endmodule
