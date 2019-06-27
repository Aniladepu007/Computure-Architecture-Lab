//has no rounding modes involved!
`include "cla_16bit_structural.v"

module fpa(input [15:0] a, input [15:0]b, output [15:0]out);

wire [4:0] shift,shift_sub;
wire [10:0]var1,var2,var3,c3,c4;

wire isSignEqual,isExpEqual;

//for cla adder
wire [15:0] var4, var5;
wire [16:0] cla_out, cla_out1;
wire [11:0] c1,c2;

assign isSignEqual = a[15]==b[15] ? 1 : 0;
assign isExpEqual = a[14:10]==b[14:10] ? 1 : 0;

assign out[15] = (a[14:10]==b[14:10] && isSignEqual==0)? (a[9:0] >= b[9:0]? a[15] : b[15]) : (a[14:10] > b[14:10] ? a[15] : b[15]);

assign shift = a[14:10] > b[14:10] ? a[14:10] - b[14:10] : b[14:10] - a[14:10];

assign var1[9:0] = a[14:10] > b[14:10] ? b[9:0] : a[9:0];
assign var1[10] = 1;
assign var2 = var1>>shift;

assign var3[9:0] = a[14:10] > b[14:10] ? a[9:0] : b[9:0];
assign var3[10] = 1;

flip f1(var2,c1);
flip f2(var3,c2);

assign var4 = !isSignEqual ? (a[15]==1 ? c1 : var2) : var2;
assign var5 = !isSignEqual ? (b[15]==1 ? c2 : var3) : var3;

cla obj(var4,var5,cla_out);

flip_sub f3(cla_out[10:0], c3);

//assign isOutNeg = ( ((a[15]==b[15] ? 0 : 1) ? ( var2 > var3) : ())  ? 1 : 0 ) ? 1 : 0;

assign c4 = (isSignEqual==0 && out[15]==1) ? (c3) : (cla_out[10:0]);

//assign shift_sub = 11-$clog2(c4);

assign shift_sub = c4[10]?0:c4[9]?1:c4[8]?2:c4[7]?3:c4[6]?4:c4[5]?5:c4[4]?6:c4[3]?7:c4[2]?8:c4[1]?9:c4[0]?10:11;

assign out[14:10] = ((isSignEqual==1) ? (cla_out[11] == 1 ? (a[14:10] > b[14:10] ? a[14:10] : b[14:10]) + 1 :
                                          (a[14:10] > b[14:10] ? a[14:10] : b[14:10])) : ( a[14:0]==b[14:0] ? (5'b0) : ((a[14:10] > b[14:10] ? a[14:10] : b[14:10])-shift_sub) ) );

assign cla_out1 = (cla_out[11] == 1 && isSignEqual==1) ? cla_out>>1 : cla_out;
assign out[9:0] = (isSignEqual==0) ? (c4[9:0]<<shift_sub) : (cla_out1[9:0]);

endmodule

//2's complement
module flip(input [10:0]m, output[11:0]comp);
      wire [10:0]t;
      assign t = ~m;
      assign comp = t+1;
endmodule


//reversing 2's complement
module flip_sub(input [10:0]m, output[10:0]comp);
      wire [10:0]t;
      assign t = m-1;
      assign comp = ~t;
endmodule
