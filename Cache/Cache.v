module Cache(input wire [15:0] PC, output reg [15:0] Inst, input wire [5:0] Ctrl_Sig,output reg [3:0] Out_Sig,input wire [255:0] Block_Transfer,
	input wire [255:0] Data_Transfer,input wire [19:0] Write_Word);

reg[15:0] Data_Cache[0:63][0:15], Cache_Mem[0:63][0:15], Main_Mem[0:4096][0:15];
reg[5:0] Tag[0:63];
reg Valid_Bit[0:63];
reg Ins_Hit, Ins_Miss;

reg[5:0] DTag[0:63];
reg DValid_Bit[0:63];
reg Dirty_Bit[0:63];
reg Data_Hit, Data_Miss;
genvar i,j;

generate for(i=0;i<64;i=i+1) begin
		for(j=0;j<16;j=j+1) begin
			always @ (Ctrl_Sig[0]) begin
					Cache_Mem[i][j] <= 16'h1111;
					Tag[i] <= Cache_Mem[i][j][15:10];
					Valid_Bit[i] <= 1'b0;
			end
		end
	   end
endgenerate

generate for(i=0;i<64;i=i+1) begin
		for(j=0;j<16;j=j+1) begin
			always @ (Ctrl_Sig[0]) begin
					Data_Cache[i][j] <= 16'h9999;
					DTag[i] <= Cache_Mem[i][j][15:10];
					DValid_Bit[i] <= 1'b0;
					Dirty_Bit[i] <= 1'b0;
			end
		end
	   end
endgenerate
		always @ (Ctrl_Sig[1]) begin
			Valid_Bit[PC[9:5]] <= ~(|(Tag[PC[9:4]] ^ PC[15:10])) ? 1'b1 : 1'b0;
			// Checking Instruction Hit's and Miss's
			Ins_Hit <= Valid_Bit[PC[9:4]];
			Ins_Miss <= ~Ins_Hit;
			// Reading from the Address in PC when Control Signal is Read_Inst enabled
			Inst <= (Ctrl_Sig[1] & Ins_Hit) ? Cache_Mem[PC[9:4]][PC[3:0]] : 16'hxxxx;
			// Miss Replacement Strategy
			Out_Sig[0] <= Ins_Miss ? 1'b1 : 1'b0;
		end
		generate
			for(i=15;i>=0;i=i-1) begin
				always @ (Ctrl_Sig[2]) begin
					Cache_Mem[PC[9:4]][i] <= Block_Transfer[(16*(i+1)-1):(16*(i))];
					Valid_Bit[PC[9:4]] <= 1'b1;
				end

				end
		endgenerate
// Data

		always @ (Ctrl_Sig[3]) begin
			DValid_Bit[PC[9:4]] <= (~|(DTag[PC[9:4]] ^ PC[15:10])) ? 1'b1 : 1'b0;
			// Checking Data Hit's and Miss's
			Data_Hit <= DValid_Bit[PC[9:4]];
			Data_Miss <= ~Data_Miss;
			// Reading from the Given Data from the assigned PC
			Inst <= (Ctrl_Sig[3] & Data_Hit) ? Data_Cache[PC[9:4]][PC[3:0]] :16'hxxxx;
			// Replacement when Data Miss occurs and Dirty Bit is Set
			Out_Sig[1] <= (Dirty_Bit[PC[9:4]] ^ Data_Miss) ? 1'b1 : 1'b0;
		end

		always @ (Ctrl_Sig[5]) begin
			DValid_Bit[PC[9:4]] <= (~|(DTag[PC[9:4]] ^ PC[15:10])) ? 1'b1 : 1'b0;
			// Checking Data Hit's and Miss's
			Data_Hit <= DValid_Bit[PC[9:4]];
			Data_Miss <= ~Data_Miss;
		end

		always @ (Ctrl_Sig[5] & Data_Hit) begin
			Data_Cache[PC[9:4]][Write_Word[19:16]] <= Write_Word[15:0];
			Dirty_Bit[PC[9:4]] <= 1'b1;
		end

		generate
			for(i=15;i>=0;i=i-1) begin
				always @ (Ctrl_Sig[4]) begin
					Data_Cache[PC[9:4]][i] <= Data_Transfer[(16*(i+1)-1):(16*(i))];
					DValid_Bit[PC[9:4]] <= 1'b1;
					Dirty_Bit[PC[9:4]] <= 1'b0;
				end
			end
			for(i=15;i>=0;i=i-1) begin
				always @ (Ctrl_Sig[5] | Data_Miss) begin
					Data_Cache[PC[9:4]][i] <= Data_Transfer[(16*(i+1)-1):(16*(i))];
					DValid_Bit[PC[9:4]] <= 1'b1;
					Dirty_Bit[PC[9:4]] <= 1'b0;
				end
			end
		endgenerate
endmodule
