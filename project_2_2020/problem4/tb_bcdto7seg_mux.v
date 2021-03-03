


`timescale 100ps/100ps

module tb_bcdto7seg_mux;
reg  [3:0] bcd_in;
wire [6:0] seven_seg_out;

bcdto7seg_mux UUT( 
	      .bcd_in       (bcd_in), 
              .seven_seg_out(seven_seg_out)
                  );

initial begin

	bcd_in <= 4'b0000;
	#3;
	bcd_in <= 4'b0001;
	#3;
	bcd_in <= 4'b0010;
	#3;
	bcd_in <= 4'b0011;
	#3;
	bcd_in <= 4'b0100;
	#3;
	bcd_in <= 4'b0101;
	#3;
	bcd_in <= 4'b0110;
	#3;
	bcd_in <= 4'b0111;
	#3;
	bcd_in <= 4'b1000;
	#3;
	bcd_in <= 4'b1001;
	#3;
	bcd_in <= 4'b1010;
	#3;
	bcd_in <= 4'b1011;
	#3;
	bcd_in <= 4'b1100;
	#3;
	bcd_in <= 4'b1101;
	#3;
	bcd_in <= 4'b1110;
	#3;
	bcd_in <= 4'b1111;
	#3;

	
end


endmodule