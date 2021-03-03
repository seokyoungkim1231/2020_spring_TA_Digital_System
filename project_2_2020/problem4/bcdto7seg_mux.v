
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


// Make bcd converter by using 16to1 Mux
module bcdto7seg_mux ( bcd_in, seven_seg_out);
 input [3:0] bcd_in;
 output [6:0] seven_seg_out;
 
 //Use BCD input as 16to1 MUX's select bit
 wire char_a_out;
 wire char_b_out;
 wire char_c_out;
 wire char_d_out;
 wire char_e_out;
 wire char_f_out;
 wire char_g_out;

//  'a' = ~D,1,D,1,1,1,1,1
//  'b' = 1,1,~D,D,1,0,0,0
//  'c' = 1,D,1,1,1,0,0,0
//  'd' = ~D,1,D,~D,1,1,1,1
//  'e' = ~D,~D,0,~D,~D,1,1,1
//  'f' = ~D,0,1,~D,1,1,1,1
//  'g' = 0,1,1,~D,1,1,1,1

 mux_8to1 U0_a_out (  ~bcd_in[0],
		      1'b1,
		      bcd_in[0],
                      1'b1, 
		      1'b1,
		      1'b1,
		      1'b1,
		      1'b1 ,
		      bcd_in[3:1],char_a_out
	   	    );
 mux_8to1 U0_b_out ( 1'b1,1'b1,~bcd_in[0],bcd_in[0],1'b1,1'b0,1'b0,1'b0 ,bcd_in[3:1], char_b_out);
 mux_8to1 U0_c_out ( 1'b1, bcd_in[0],1'b1,1'b1,1'b1,1'b0,1'b0,1'b0 ,bcd_in[3:1], char_c_out);
 mux_8to1 U0_d_out ( ~bcd_in[0],1'b1,bcd_in[0],~bcd_in[0],1'b1,1'b1,1'b1,1'b1 ,bcd_in[3:1], char_d_out);
 mux_8to1 U0_e_out ( ~bcd_in[0],~bcd_in[0],1'b0,~bcd_in[0],~bcd_in[0],1'b1,1'b1,1'b1 ,bcd_in[3:1], char_e_out);
 mux_8to1 U0_f_out ( ~bcd_in[0],1'b0,1'b1,~bcd_in[0],1'b1,1'b1,1'b1,1'b1 ,bcd_in[3:1], char_f_out);
 mux_8to1 U0_g_out ( 1'b0,1'b1,1'b1,~bcd_in[0],1'b1,1'b1,1'b1,1'b1 ,bcd_in[3:1], char_g_out);

 assign seven_seg_out = {char_a_out,char_b_out,char_c_out,char_d_out,char_e_out,char_f_out,char_g_out};

endmodule


