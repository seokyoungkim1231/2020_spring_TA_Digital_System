


module bfloat16_range_decoder (

                 input_x,
                 output_index
);

input [15:0] input_x;
output [4:0] output_index; 

reg  [4:0]    output_index_temp;


wire           input_x_sign;
wire [7:0]     input_x_exp;
wire [6:0]     input_x_mant;

assign input_x_sign = input_x[15];
assign input_x_exp  = input_x[14:7];
assign input_x_mant = input_x[6:0];
/*Range list X
0.125

0.25
0.375

0.5
0.625
0.75
0.875

1
1.125
1.25
1.375
1.5
1.625
1.75
1.875

2
2.125
2.25
2.375
2.5
2.625
2.75
2.875
3
3.125
3.25
3.375
3.5
3.625
3.75
3.875

4
*/


//exp_range0 = x < 0.125
//exp_range1 = 0.125<x  < 0.25
//exp_range2 = 0.25 <x  < 0.5
//exp_range3 = 0.5  < x < 1
//exp_range4 = 1    < x < 2
//exp_range5 = 2    < x < 4
//exp_range6 = x > 4
wire exp_range0;
wire exp_range1;
wire exp_range2;
wire exp_range3;
wire exp_range4;
wire exp_range5;


assign exp_range0 = (input_x_exp < 8'b 01111100);
assign exp_range1 = (input_x_exp >= 8'b 01111100) && (input_x_exp <8'b01111101);
assign exp_range2 = (input_x_exp >= 8'b 01111101) && (input_x_exp <8'b01111110);
assign exp_range3 = (input_x_exp >= 8'b 01111110) && (input_x_exp <8'b01111111);
assign exp_range4 = (input_x_exp >= 8'b 01111111) && (input_x_exp <8'b10000000);
assign exp_range5 = (input_x_exp >= 8'b 10000000) && (input_x_exp <8'b10000001);
assign exp_range6 = (input_x_exp >= 8'b 10000001);

always @( * ) begin
  if      (exp_range0)                                                                  output_index_temp   <= 5'b00000;
  else if (exp_range1)                                                                  output_index_temp   <= 5'b00001;
  else if (exp_range2) begin 
                                if     (input_x_mant[6])                                output_index_temp   <= 5'b00011;
                                else                                                    output_index_temp   <= 5'b00010;
                       end

  else if (exp_range3) begin 
                                if     (input_x_mant[6] && input_x_mant[5])             output_index_temp   <= 5'b 00111;
                                else if(input_x_mant[6] && !input_x_mant[5])            output_index_temp   <= 5'b 00110;
                                else if(!input_x_mant[6] && input_x_mant[5])            output_index_temp   <= 5'b 00101;
                                else                                                    output_index_temp   <= 5'b 00100;
                       end

  else if (exp_range4) begin 
                                if     (input_x_mant[6] && input_x_mant[5]  && input_x_mant[4])            output_index_temp   <= 5'b 01111;
                                else if(input_x_mant[6] && input_x_mant[5]  && !input_x_mant[4])           output_index_temp   <= 5'b 01110;
                                else if(input_x_mant[6] && !input_x_mant[5] && input_x_mant[4])            output_index_temp   <= 5'b 01101;
                                else if(input_x_mant[6] && !input_x_mant[5] &&!input_x_mant[4])            output_index_temp   <= 5'b 01100;
                                else if(!input_x_mant[6] && input_x_mant[5] &&input_x_mant[4])             output_index_temp   <= 5'b 01011;
                                else if(!input_x_mant[6] && input_x_mant[5] &&!input_x_mant[4])            output_index_temp   <= 5'b 01010;
                                else if(!input_x_mant[6] && !input_x_mant[5] &&input_x_mant[4])            output_index_temp   <= 5'b 01001;
                                else                                                                       output_index_temp   <= 5'b 01000;
                       end

  else if (exp_range5) begin 
                                if     (input_x_mant[6] && input_x_mant[5]  && input_x_mant[4] && input_x_mant[3])            output_index_temp   <= 5'b 11111;
                                else if(input_x_mant[6] && input_x_mant[5]  && input_x_mant[4] && !input_x_mant[3])           output_index_temp   <= 5'b 11110;
                                else if(input_x_mant[6] && input_x_mant[5]  &&!input_x_mant[4] && input_x_mant[3])            output_index_temp   <= 5'b 11101;
                                else if(input_x_mant[6] && input_x_mant[5]  &&!input_x_mant[4] && !input_x_mant[3])           output_index_temp   <= 5'b 11100;

                                else if(input_x_mant[6] && !input_x_mant[5] &&input_x_mant[4]  && input_x_mant[3])            output_index_temp   <= 5'b 11011;
                                else if(input_x_mant[6] && !input_x_mant[5] &&input_x_mant[4]  && !input_x_mant[3])           output_index_temp   <= 5'b 11010;
                                else if(input_x_mant[6] && !input_x_mant[5] &&!input_x_mant[4] && input_x_mant[3])            output_index_temp   <= 5'b 11001;
                                else if(input_x_mant[6] && !input_x_mant[5] &&!input_x_mant[4]&& !input_x_mant[3])            output_index_temp   <= 5'b 11000;
                                
                                else if(!input_x_mant[6] && input_x_mant[5] && input_x_mant[4] && input_x_mant[3])            output_index_temp   <= 5'b 10111;
                                else if(!input_x_mant[6] && input_x_mant[5] && input_x_mant[4]  && !input_x_mant[3])          output_index_temp   <= 5'b 10110;
                                else if(!input_x_mant[6] && input_x_mant[5] &&!input_x_mant[4] && input_x_mant[3])            output_index_temp   <= 5'b 10101;
                                else if(!input_x_mant[6] && input_x_mant[5] &&!input_x_mant[4] && !input_x_mant[3])           output_index_temp   <= 5'b 10100;
                                
                                else if(!input_x_mant[6] && !input_x_mant[5] &&input_x_mant[4] && input_x_mant[3])            output_index_temp   <= 5'b 10011;
                                else if(!input_x_mant[6] && !input_x_mant[5]  && input_x_mant[4]&& !input_x_mant[3])          output_index_temp   <= 5'b 10010;
                                else if(!input_x_mant[6] && !input_x_mant[5] && !input_x_mant[4] && input_x_mant[3])          output_index_temp   <= 5'b 10001;
                                else                                                                                          output_index_temp   <= 5'b 10000;
                       end
end
assign output_index = output_index_temp;
endmodule

