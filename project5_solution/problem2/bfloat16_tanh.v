
module bfloat16_tanh(
            rst_x,
	    clk,
                 
            in_load_data,
            in_load_addr,
            in_load_enable,

            input_x,
            output_y
);

input rst_x;
input clk;

input [15:0] in_load_data;
input [4:0]  in_load_addr;
input        in_load_enable;

input [15:0] input_x;

output[15:0] output_y;

wire [4:0] index_decoder_result;
wire [4:0] addr_temp;
wire [15:0] out_bfloat16;
assign addr_temp = in_load_enable? in_load_addr: index_decoder_result;


bfloat16_rf U0_BFLOAT16_RF(
                             .clk(clk),
                             .rst_x(rst_x),
                             .we (in_load_enable),
                             .addr(addr_temp),
                             .di(in_load_data),

                             .dout(out_bfloat16)
);

bfloat16_range_decoder U1_BFLOAT16_RANGE_DECODER (
                              .input_x(input_x),
                              .output_index(index_decoder_result)
);


assign output_y = out_bfloat16;


endmodule 

