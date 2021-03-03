

module dec4to16 (A, B, C, D, out);
input A, B, C, D;
output reg [15:0] out;

always@(*) begin
	case({A, B, C, D})
		4'b0000: out <= 16'b0000_0000_0000_0001;
		4'b0001: out <= 16'b0000_0000_0000_0010;
		4'b0010: out <= 16'b0000_0000_0000_0100;
		4'b0011: out <= 16'b0000_0000_0000_1000;
		4'b0100: out <= 16'b0000_0000_0001_0000;
		4'b0101: out <= 16'b0000_0000_0010_0000;
		4'b0110: out <= 16'b0000_0000_0100_0000;
		4'b0111: out <= 16'b0000_0000_1000_0000;
		4'b1000: out <= 16'b0000_0001_0000_0000;
		4'b1001: out <= 16'b0000_0010_0000_0000;
		4'b1010: out <= 16'b0000_0100_0000_0000;
		4'b1011: out <= 16'b0000_1000_0000_0000;
		4'b1100: out <= 16'b0001_0000_0000_0000;
		4'b1101: out <= 16'b0010_0000_0000_0000;
		4'b1110: out <= 16'b0100_0000_0000_0000;
		4'b1111: out <= 16'b1000_0000_0000_0000;
	endcase
end

endmodule

//Make bcd converter by using 4to16 DEC
module bcdto7seg_dec ( bcd_in, seven_seg_out);
 input [3:0] bcd_in;
  
 output [6:0] seven_seg_out;

 wire [15:0] dec_result;

 dec4to16 U0 ( bcd_in[3],
	       bcd_in[2],
               bcd_in[1],
               bcd_in[0], 
               dec_result
 	     );

 wire char_a_out;
 wire char_b_out;
 wire char_c_out;
 wire char_d_out;
 wire char_e_out;
 wire char_f_out; 
 wire char_g_out;

//Decoder's result is minterm
 assign char_a_out = (dec_result[0])|(dec_result[2])|(dec_result[3])|(dec_result[5])|(dec_result[6])|(dec_result[7])|(dec_result[8])|(dec_result[9])
		    |(dec_result[10])|(dec_result[11])|(dec_result[12])|(dec_result[13])|(dec_result[14])|(dec_result[15]);

 assign char_b_out = (dec_result[0])|(dec_result[1])|(dec_result[2])|(dec_result[3])|(dec_result[4])|(dec_result[7])|(dec_result[8])|(dec_result[9]);

 assign char_c_out = (dec_result[0])|(dec_result[1])|(dec_result[3])|(dec_result[4])|(dec_result[5])|(dec_result[6])|(dec_result[7])|(dec_result[8])|(dec_result[9]);

 assign char_d_out = (dec_result[0])|(dec_result[2])|(dec_result[3])|(dec_result[5])|(dec_result[6])|(dec_result[8])|(dec_result[9])
		     | (dec_result[10])|(dec_result[11])|(dec_result[12])|(dec_result[13])|(dec_result[14])|(dec_result[15]);

 assign char_e_out = (dec_result[0])|(dec_result[2])|(dec_result[6])|(dec_result[8])
 		     |(dec_result[10])|(dec_result[11])|(dec_result[12])|(dec_result[13])|(dec_result[14])|(dec_result[15]);

 assign char_f_out = (dec_result[0])|(dec_result[4])|(dec_result[5])|(dec_result[6])|(dec_result[8])|(dec_result[9])
		     |(dec_result[10])|(dec_result[11])|(dec_result[12])|(dec_result[13])|(dec_result[14])|(dec_result[15]);

 assign char_g_out = (dec_result[2])|(dec_result[3])|(dec_result[4])|(dec_result[5])|(dec_result[6])|(dec_result[8])|(dec_result[9])
		     |(dec_result[10])|(dec_result[11])|(dec_result[12])|(dec_result[13])|(dec_result[14])|(dec_result[15]);

assign seven_seg_out = {char_a_out,char_b_out,char_c_out,char_d_out,char_e_out,char_f_out,char_g_out};


endmodule

