
`timescale 100ps/100ps

module tb_bcdto7seg;
reg  A0, A1, A2, A3, A4, A5, A6, A7;
reg [2:0] sel;
wire mux_out;


mux_8to1 U1 (
	.A0	(A0),
	.A1	(A1),
	.A2	(A2),
	.A3	(A3),
	.A4	(A4),
	.A5	(A5),
	.A6	(A6),
	.A7	(A7),
	.sel(sel),

	.mux_out(mux_out)
);

initial begin
	A0 <= 1'b1;
	A1 <= 1'b0;
	A2 <= 1'b1;
	A3 <= 1'b0;
	A4 <= 1'b0;
	A5 <= 1'b1;
	A6 <= 1'b1;
	A7 <= 1'b1;

	sel <= 3'b000;
	#3;
	sel <= 3'b001;
	#3;
	sel <= 3'b010;
	#3;
	sel <= 3'b011;
	#3;
	sel <= 3'b100;
	#3;
	sel <= 3'b101;
	#3;
	sel <= 3'b110;
	#3;
	sel <= 3'b111;
end


endmodule

