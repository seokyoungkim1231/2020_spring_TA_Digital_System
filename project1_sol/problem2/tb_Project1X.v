
`timescale 100ps/1ps

module tb_Project1X;

reg A, B, Cin;
wire S, Cout;

Project1X U0_Project1X(
	.A	(A),
	.B	(B),
	.Cin	(Cin),
	.S	(S),
	.Cout	(Cout)
);

initial begin
	//A,B,Cin 000~111
	//A,B,Cin = (0,0,0)
	A <= 1'b0; B <= 1'b0; Cin <= 1'b0;
	#3
	//A,B,Cin = (0,1,0)
	B <= 1'b1;
	#3
	//A,B,Cin = (1,0,0)
	A <= 1'b1; B <= 1'b0;
	#3
	//A,B,Cin = (1,1,0)
	B <=1'b1;
	#3
	//A,B,Cin = (0,0,1)
	A <= 1'b0; B <= 1'b0; Cin <= 1'b1;
	#3
	//A,B,Cin = (0,1,1)
	B <= 1'b1;
	#3
	//A,B,Cin = (1,0,1)
	A <= 1'b1; B <= 1'b0;
	#3
	//A,B,Cin = (1,1,1)
	B <=1'b1;
end
endmodule
