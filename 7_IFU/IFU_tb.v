module IFU_tb();
reg [15:0] Input, Output;
wire [15:0] Instruction;
reg Clock, Reset;
IFU obj(
      Input,
      Clock,
      Reset,
      Instruction
);

initial begin
      $dumpfile("Fetcher.vcd");
      $dumpvars(0,IFU_tb);
      Clock <= 1'b0;
      Input <= 16'h0003;
      Reset <= 1'b1;
      #5;
      Reset <= 1'b0;
      #100;
      $finish;
end

always begin
      #1 Clock <= 1'b1;
      Output <= Instruction;
      #1 Clock <= 1'b0;
end

initial begin
      $display("INPUT   OUT    CLK    RESET");
end

always @(Output|Reset)
      $display("%h   %h     %b     %b",Input,Output,Clock,Reset);

endmodule
