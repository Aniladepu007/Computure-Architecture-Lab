module Cachetb();

reg [15:0] PC;
wire [15:0] Inst;
reg [5:0] Ctrl_Sig;
input wire [3:0] Out_Sig;
reg [255:0] Block_Transfer;
reg [255:0] Data_Transfer;
reg [19:0] Write_Word;
Cache c1(.PC(PC), .Inst(Inst), .Ctrl_Sig(Ctrl_Sig), .Out_Sig(Out_Sig), .Block_Transfer(Block_Transfer), .Data_Transfer(Data_Transfer), .Write_Word(Write_Word));


initial begin 
	$dumpfile("Cache.vcd");
    $dumpvars(0,Cachetb);

	#2;
	Ctrl_Sig[0] <= 1'b1;		// Initialization
	
	#2000;
	Ctrl_Sig[0] <= 1'b0;
	Ctrl_Sig[1] <= 1'b1;	 	// Read Instruction
	
			PC <= 16'h1111;
	#10; 	PC <= 16'h1121;
	#10;	PC <= 16'h0002;
	#10;	PC <= 16'h0016;
	#10;	PC <= 16'h0003;
	#10; 	PC <= 16'h1121;
	#10;	PC <= 16'h0002;
	#10;	PC <= 16'haed6;
	#10;	PC <= 16'hfff3;
	#10; 	PC <= 16'h1ab1;
	#10;	PC <= 16'h0112;
	#10;	PC <= 16'h0aa6;
	#10;	PC <= 16'hfcd3;
	#10; 	PC <= 16'h1121;
	#10;	PC <= 16'h0002;
	#10;	PC <= 16'h0016;
	#10;	PC <= 16'h0003;

	#200;
	Ctrl_Sig[0] <= 1'b0;
	Ctrl_Sig[3] <= 1'b1;

			PC <= 16'h1111;
	#20; 	PC <= 16'h1121;
	#20;	PC <= 16'h0002;
	#20;	PC <= 16'h0016;
	#20;	PC <= 16'h0003;
	#20; 	PC <= 16'h1121;
	#20;	PC <= 16'h0002;
	#20;	PC <= 16'haed6;
	#20;	PC <= 16'hfff3;
	#20; 	PC <= 16'h1ab1;
	#20;	PC <= 16'h0112;

	#200;
	Ctrl_Sig[3] <= 1'b0;
	Ctrl_Sig[5] <= 1'b1;

			PC <= 16'hffff;
	#10;	PC <= 16'h0aa6;
	#10;	PC <= 16'hfcd3;
	#10; 	PC <= 16'h1121;
	#10;	PC <= 16'h0002;
	#10;	PC <= 16'h0016;
	#10;	PC <= 16'h0003;
	
	#20;
	$finish;
end


// a142 3586 7097 3bca 7632 1bbd ed4d 2e34
// bdef 4567 8971 acde dde8 1657 ffe4 12ff

always @ (Out_Sig[0]) begin
	c1.Valid_Bit[PC[10:5]] <= 1'b0;
	Ctrl_Sig[2] <= 1'b1;
	Block_Transfer <= 256'ha142358670973bca76321bbded4d2e34bdef45678971acdedde81657ffe412ff;
end 

//always @ (Out_Sig[1])


//initial begin $display("Read\nClk\tReset\tR1\tFV1\tR2\tFV2\n"); end
    
    always @(PC) begin
        $display("(%h)\t(%h)\t(%b)\t(%b)\t(%b)\t(%b)",PC,Inst,c1.Tag[PC[9:4]],c1.PC[15:10],c1.Ins_Hit,c1.Ins_Miss);
    end

    //initial begin  end
    
    always @(Out_Sig) begin
    	$display("(%h)\t(%h)\t(%b)\t(%b)",PC,Inst,c1.Ins_Hit,c1.Ins_Miss);
    end

endmodule