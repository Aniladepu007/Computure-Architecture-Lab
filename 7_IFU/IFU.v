module IFU(InitVal, Clk, Reset, instr);
input [15:0]InitVal;
input Clk;
input Reset;
output [15:0] instr;

wire [15:0] InitVal, instr;
wire Clk, Reset;

reg [15:0] PC;
reg [15:0] ins_buffer[0:1023];

always @(Reset) begin
    PC = InitVal;

    ins_buffer[0] = 16'h0001;
    ins_buffer[1] = 16'h0002;
    ins_buffer[2] = 16'h0003;
    ins_buffer[3] = 16'h0004;
    ins_buffer[4] = 16'h0005;
    ins_buffer[5] = 16'h0000;

end
always @(posedge Clk & ~Reset) begin
    PC <= PC + 1'b1;
end
    assign instr = ins_buffer[PC & 10'h3ff];

endmodule
