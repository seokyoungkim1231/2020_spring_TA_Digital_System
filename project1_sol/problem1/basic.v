
module basic(A, B, out_AND, out_OR, out_NAND, out_NOR, out_XOR);

input A, B;
output out_AND, out_OR, out_NAND, out_NOR, out_XOR;

//and  and0	(out_AND , A, B);
//or   or0	(out_OR  , A, B);
//nand nand0	(out_NAND, A, B);
//nor  nor0	(out_NOR , A, B);
//xor  xor0	(out_XOR , A, B);

assign out_AND = A & B;
assign out_OR = A | B;
assign out_NAND = ~(A & B);
assign out_NOR = ~(A | B);
assign out_XOR = A ^ B;


endmodule