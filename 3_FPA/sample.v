module bit_reversal(input[63:0]sh, input[32:0]prod, output [9:0]o);
integer i,shift;
//reg[63:0]sh;
reg[9:0]o;

assign      sh = 17;
assign prod = 33'b000000000000000010001001100000000;
initial begin
      shift = sh;
end

always @ ( * ) begin
      $display("%b,%d",sh,shift);

      for(i=shift-1; i>=shift-10; i=i-1) begin
            o[shift-1-i] = prod[i];
      end
end
initial begin
#5;
      $display("%b",o);
end

endmodule // bit_reversal



/*module a();

wire [10:0]w;
reg _x,_y;
assign w = 11'b00100111100;

initial begin
      $display($clog2(w));
      assign {_x,_y} = {1'b1,1'b1};
      $display(_x,_y);
end


endmodule*/
