
`timescale 100ps/1ps

module tb_basic;

reg inp1, inp2;
wire out_AND, out_OR, out_NAND, out_NOR, out_XOR;

basic U0_basic (
	.A (inp1),
	.B (inp2),
	.out_AND(out_AND),
	.out_OR(out_OR),
	.out_NAND(out_NAND),
	.out_NOR(out_NOR),
	.out_XOR(out_XOR)
);

initial begin

	inp1 <= 1'b0;
	inp2 <= 1'b0;
	#3
	inp1 <= 1'b1;
	#3
	inp1 <= 1'b0;
	inp2 <= 1'b1;
	#3
	inp1 <= 1'b1;
	#3
	inp1 <= 1'b0;
	inp2 <= 1'b0;
end


endmodule