
module mux_8to1 (A0, A1, A2, A3, A4, A5, A6, A7, sel, mux_out);
input  A0, A1, A2, A3, A4, A5, A6, A7;
input [2:0] sel;
output reg mux_out;

always@(*) begin
	case(sel) 
		3'b000: mux_out <= A0;
		3'b001: mux_out <= A1;
		3'b010: mux_out <= A2;
		3'b011: mux_out <= A3;
		3'b100: mux_out <= A4;
		3'b101: mux_out <= A5;
		3'b110: mux_out <= A6;
		3'b111: mux_out <= A7;
	endcase
end


endmodule