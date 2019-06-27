module a();

b b1();

endmodule

module b();
initial begin
$display("%d",1);
end
endmodule

module c();
initial begin
$display("%d",2);
end
endmodule
