

`timescale 100ps/1ps

module tb_bcdto7seg_dec;

 reg[3:0] bcd_in;
 wire [6:0] seven_seg_out;


bcdto7seg_dec UUT (
	      .bcd_in       (bcd_in), 
              .seven_seg_out(seven_seg_out)
                  );


integer  i;

initial begin
	for(i=0;i<16;i=i+1) begin
			   bcd_in <= i;
			   #3;
	                 end
end


endmodule