
`timescale 100ps/1ps

module tb_dec4to16;
reg A, B, C, D;
wire [15:0] out;


dec4to16 UUT (
	.A(A),
	.B(B),
	.C(C),
	.D(D),
	.out(out)
);

integer h, i, j, k;

initial begin
  for(h=0;h<2;h=h+1) begin
	for(i=0;i<2;i=i+1) begin
		for(j=0;j<2;j=j+1) begin
			for(k=0;k<2;k=k+1) begin
				A <= h;
				B <= i;
				C <= j;
				D <= k;
				#3;
			end
		end
	end
  end
end


endmodule
