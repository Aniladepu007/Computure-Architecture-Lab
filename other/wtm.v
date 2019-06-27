module wallace_mul(input [15:0] A,input [15:0] B, output [31:0] C, input clk);

wire [15:0] A,B;
wire [31:0] C;
wire [31:0] m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,m13,m14,m15,m16;
reg [31:0] s1,s2,s3,s4,s5,s55,s6,s7,s8,s9,s10,s11,s12,s13,s14,m161,m162,m163;
reg [31:0] c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c51,c52,c131;
wire [31:0] s15,c15;

assign m1 = B[0]?{16'b0,A}:32'b0;
assign m2 = B[1]?{15'b0,A,1'b0}:32'b0;
assign m3 = B[2]?{14'b0,A,2'b0}:32'b0;
assign m4 = B[3]?{13'b0,A,3'b0}:32'b0;
assign m5 = B[4]?{12'b0,A,4'b0}:32'b0;
assign m6 = B[5]?{11'b0,A,5'b0}:32'b0;
assign m7 = B[6]?{10'b0,A,6'b0}:32'b0;
assign m8 = B[7]?{9'b0,A,7'b0}:32'b0;
assign m9 = B[8]?{8'b0,A,8'b0}:32'b0;
assign m10 = B[9]?{7'b0,A,9'b0}:32'b0;
assign m11 = B[10]?{6'b0,A,10'b0}:32'b0;
assign m12 = B[11]?{5'b0,A,11'b0}:32'b0;
assign m13 = B[12]?{4'b0,A,12'b0}:32'b0;
assign m14 = B[13]?{3'b0,A,13'b0}:32'b0;
assign m15 = B[14]?{2'b0,A,14'b0}:32'b0;
assign m16 = B[15]?{1'b0,A,15'b0}:32'b0;

always @(posedge clk) begin
s1<=m1^m2^m3;
c1<={((m1&m2)+(m3&(m1^m2))),1'b0};

s2<=m6^m4^m5;
c2<={((m6&m4)+(m5&(m6^m4))),1'b0};

s3<=m7^m8^m9;
c3<={((m8&m7)+(m9&(m7^m8))),1'b0};

s4<=m10^m11^m12;
c4<={((m10&m11)+(m12&(m10^m11))),1'b0};

s5<=m13^m14^m15;
c5<={((m13&m14)+(m15&(m13^m14))),1'b0};

m161<=m16;
/*****************LEVEL1***********************/

s6<=s2^s1^c1;
c6<={((s1&c1)+(s2&(s1^c1))),1'b0};

s7<=c3^c2^s3;
c7<={((c3&c2)+(s3&(c3^c2))),1'b0};

s8<=s5^c4^s4;
c8<={((s5&c4)+(s4&(s5^c4))),1'b0};

c51<=c5;
m162<=m161;
/*****************LEVEL2**********************/

s10<=c6^s6^s7;
c10<={((c6&s6)+(s7&(c6^s6))),1'b0};

s11<=s8^c8^c7;
c11<={((s8&c8)+(c7&(s8^c8))),1'b0};

c52<=c51;
m163<=m162;
/****************LEVEL3************************/

s12<=s10^c10^s11;
c12<={((s10&c10)+(s11&(s10^c10))),1'b0};

s13<=c11^m163^c52;
c13<={((c11&m163)+(c52&(c11^m163))),1'b0};
/*****************LEVEL4**********************/

s14<=c12^s12^s13;
c14<={((c12&s12)+(s13&(c12^s12))),1'b0};

c131<=c13;
/****************LEVEL4**********************/
end
assign s15=s14^c14^c131;
assign c15={((c14&s14)+(c131&(s14^c14))),1'b0};

//CarryLookAhead Adder Ahead:
reg [31:0] g1,g2,g3,g4,g5,p1,p2,p3,p4,XorOut1,XorOut2,XorOut3,XorOut4,XorOut5;  //P for XOR And G for AND

    reg [32:0] G,P; //C for Output
    always @(posedge clk) begin
    P<={s15^c15,1'b0};
    G<={s15&c15,1'b0};
    end
    genvar i;
    generate
    for(i=1;i<32;i=i+1) begin:FirstStage //s=naya g+ naya p*purana g
        always @(posedge clk) begin
        g1[i]<=(G[i-1]&P[i])+G[i];
        p1[i]<=P[i]&P[i-1];

        XorOut1<=P[32:1];
        end
    end
    for(i=2;i<32;i=i+1) begin:SecondStage //s=naya g+ naya p*purana g
        always @(posedge clk) begin
        g2[i]<=(g1[i-2]&p1[i])+g1[i];
        p2[i]<=p1[i]&p1[i-2];

        XorOut2<=XorOut1;
        end
    end
    for(i=4;i<32;i=i+1) begin:ThirdStage //s=naya g+ naya p*purana g
        always @(posedge clk) begin
        g3[i]<=(g2[i-4]&p2[i])+g2[i];
        p3[i]<=p2[i]&p2[i-4];

        XorOut3<=XorOut2;
        end
    end
    for(i=8;i<32;i=i+1) begin:FourthStage //s=naya g+ naya p*purana g
        always @(posedge clk) begin
        g4[i]<=(g3[i-8]&p3[i])+g3[i];
        p4[i]<=p3[i]&p3[i-8];

        XorOut4<=XorOut3;
        end
    end
    for(i=16;i<32;i=i+1) begin:FifthStage
    	always @(posedge clk) begin
        g5[i]<=(g4[i-16]&p4[i])+g4[i];

        XorOut5<=XorOut4;
        end
    end
    always@(posedge clk) begin
    g1[0]<=G[0];

    g2[0]<=g1[0];
    g2[1]<=g1[1];
    end

    for(i=0;i<4;i=i+1)
        always @(posedge clk) g3[i]<=g2[i];

    for(i=0;i<8;i=i+1)
        always @(posedge clk) g4[i]<=g3[i];

    for(i=0;i<16;i=i+1)
    	always @(posedge clk) g5[i]<=g4[i];

    endgenerate

    assign C=XorOut5^g5;


endmodule
