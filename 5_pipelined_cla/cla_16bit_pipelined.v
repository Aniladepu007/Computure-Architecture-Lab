module cla(input [15:0]a, input [15:0]b,output [16:0]out, input clk);
//reg [16:0]out;
wire [16:0]out;
wire [1:0]w[0:16];

reg [1:0] ws[0:16], S1[0:15], S2[0:15], S3[0:15], S4[0:15];
//final carry values
reg [15:0]L5;
genvar q;

generate    for(q=0; q<=15; q=q+1) begin
                  assign { w[q+1][0], w[q+1][1] } = {a[q] || b[q] , a[q] && b[q]};
            end
endgenerate

generate
      for(q=1; q<=16; q=q+1) begin
            always @ ( posedge clk ) begin
                  ws[q] <= w[q];
            end
      end
      always @ ( posedge clk )
            ws[0] <= 1'b0;
/*************** LEVEL1 *****************/
      for(q=0;q<=14;q=q+1) begin
            always @ ( posedge clk ) begin
                  S1[q][1] <= (ws[15-q][1] & ws[15-q][0] & !ws[14-q][1]) | (ws[15-q][0] & ws[14-q][1] & ws[14-q][0]);
                  S1[q][0] <= (ws[15-q][1] & ws[15-q][0] & !ws[14-q][1] & !ws[14-q][0]) | (ws[14-q][0] & ws[15-q][0]);
            end
      end
      always @ ( posedge clk ) begin
            S1[15] <= 1'b0;
            S2[14] <= S1[14];
      end
/*************** LEVEL2 *****************/
      for(q=0;q<=13;q=q+1) begin
            always @ ( posedge clk ) begin
                  S2[q][1] <= (S1[q][1] & S1[q][0] & !S1[q+2][1]) | (S1[q][0] & S1[q+2][1] & S1[q+2][0]);
                  S2[q][0] <= (S1[q][1] & S1[q][0] & !S1[q+2][1] & !S1[q+2][0]) | (S1[q+2][0] & S1[q][0]);
            end
      end
      always @ ( posedge clk )
            S2[15] <= S1[15];
/*************** LEVEL3 *****************/
      for(q=0;q<=11;q=q+1) begin
            always @ ( posedge clk ) begin
                  S3[q][1] <= (S2[q][1] & S2[q][0] & !S2[q+4][1]) | (S2[q][0] & S2[q+4][1] & S2[q+4][0]);
                  S3[q][0] <= (S2[q][1] & S2[q][0] & !S2[q+4][1] & !S2[q+4][0]) | (S2[q+4][0] & S2[q][0]);
            end
      end
      always @ ( posedge clk )
            {S3[12], S3[13], S3[14], S3[15]} <= {S2[12], S2[13], S2[14], S2[15]};
/*************** LEVEL4 *****************/
      for(q=0;q<=7;q=q+1) begin
            always @ ( posedge clk ) begin
                  S4[15-q][1] <= (S3[q][1] & S3[q][0] & !S3[q+8][1]) | (S3[q][0] & S3[q+8][1] & S3[q+8][0]);
                  S4[15-q][0] <= (S3[q][1] & S3[q][0] & !S3[q+8][1] & !S3[q+8][0]) | (S3[q+8][0] & S3[q][0]);
            end
      end
      for(q=8;q<=15;q=q+1) begin
            always @ ( posedge clk )
                  S4[15-q] <= S3[q];
      end
endgenerate

/*************** FINAL XOR-ing *****************/
generate      for(q=0;q<=15;q=q+1) begin
//            always @ ( posedge clk ) begin
                  assign      out[q] = a[q] ^ b[q] ^ S4[q][0];
                  assign out[16] = (a==16'b1111111111111111) ? (b == 16'b0 ? 0 : 1) : 0;
//            end
      end
endgenerate
endmodule
