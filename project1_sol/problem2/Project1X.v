
module Project1X(A, B, Cin, S, Cout);
input   A, B, Cin;
output S, Cout;

assign S = A ^ B ^ Cin;
assign Cout = (A&B) | (B&Cin) | (Cin&A);


endmodule
