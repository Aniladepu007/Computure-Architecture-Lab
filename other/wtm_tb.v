module mul_tb();

    reg [15:0] InputA, InputB;
    wire [31:0] Output;
    reg Clock;
    wallace_mul obj (
          .A(InputA),
          .B(InputB),
          .C(Output),
          .clk(Clock)
    );
    initial begin
            $dumpfile("wtm.vcd");
            $dumpvars(0,mul_tb);
    Clock<=1'b0;
    InputA<=12;
    InputB<=3;
    #2;
    InputA<=34;
    InputB<=11;
    #2;
    InputA<=34;
    InputB<=11;
    #1000;
    $finish;
    end
    always@(InputA|Output)
        $display($time,"%d   %d  =  %d    %b",InputA,InputB,Output,Clock);

    always begin
    #1 Clock <= !Clock;
    end

endmodule
