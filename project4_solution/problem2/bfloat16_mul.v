
module bfloat16_mul(
    in_A,
    in_B,

    out_result
    
);

input [15:0]        in_A;
input [15:0]        in_B;

output[15:0]        out_result;

wire        A_sign          = in_A[15];
wire [7:0]  A_exp           = in_A[14:7];
wire [7:0]  A_mant          = {1'b1, in_A[6:0]};

wire        B_sign          = in_B[15];
wire [7:0]  B_exp           = in_B[14:7];
wire [7:0]  B_mant          = {1'b1, in_B[6:0]};

wire is_zero;
wire is_inf;
wire is_NaN;

wire is_special;
wire is_ovf_unf;

//Check special case
assign is_zero     = (A_exp == 8'b0 && A_mant ==8'b1000_0000) || (B_exp == 8'b0 && B_mant == 8'b1000_0000);
assign is_NaN      = (A_exp == 8'b0 && |in_A[6:0]!= 7'b0) || (B_exp == 8'b0 && |in_B[6:0]!= 7'b0);
assign is_inf      = (A_exp == 8'b1111_1111 && A_mant ==8'b1000_0000) || (B_exp == 8'b1111_1111 && B_mant == 8'b1000_0000);
assign is_special  = is_zero || is_inf || is_NaN;

//Compute unnormalized result 
wire mul_sign = (is_zero) ? 1'b0 : A_sign ^ B_sign;

wire [7:0]  mul_exp_unnormalized;
assign mul_exp_unnormalized  = (is_zero) ? 8'b00000000 : A_exp + B_exp - 127;

wire [15:0] mul_mant_unnormalized;
assign mul_mant_unnormalized = (is_zero) ? 16'b0  : A_mant * B_mant;

//Normalize result & check special
reg [7:0]     out_exp_normalized;
reg [15:0]    out_mant_normalized;

always @(*) begin 
  if(!is_special) begin     
    if(mul_mant_unnormalized[15] == 1'b1) begin 
                                                out_exp_normalized   <= mul_exp_unnormalized + 8'b000_0001;
                                                out_mant_normalized  <= mul_mant_unnormalized >> 1;
                                             end
    else if(mul_mant_unnormalized[14] == 1'b1) begin 
                                                out_exp_normalized   <= mul_exp_unnormalized;
                                                out_mant_normalized  <= mul_mant_unnormalized;
                                            end 
    else if(mul_mant_unnormalized[13] == 1'b1) begin 
                                                out_exp_normalized   <= mul_exp_unnormalized - 8'b000_0001;
                                                out_mant_normalized  <= mul_mant_unnormalized << 1;
                                            end                                             
    else if(mul_mant_unnormalized[12] == 1'b1) begin 
                                                out_exp_normalized   <= mul_exp_unnormalized - 8'b000_0010;
                                                out_mant_normalized  <= mul_mant_unnormalized << 2;
                                             end                                               
    else if(mul_mant_unnormalized[11] == 1'b1) begin 
                                                out_exp_normalized   <= mul_exp_unnormalized - 8'b000_0011;
                                                out_mant_normalized  <= mul_mant_unnormalized << 3;
                                            end                                             
    else if(mul_mant_unnormalized[10] == 1'b1) begin 
                                                out_exp_normalized   <= mul_exp_unnormalized - 8'b000_0100;
                                                out_mant_normalized  <= mul_mant_unnormalized << 4;
                                             end 
    else if(mul_mant_unnormalized[9] == 1'b1) begin 
                                                out_exp_normalized   <= mul_exp_unnormalized - 8'b000_0101;
                                                out_mant_normalized  <= mul_mant_unnormalized << 5;
                                            end 
    else if(mul_mant_unnormalized[8] == 1'b1) begin 
                                                out_exp_normalized   <= mul_exp_unnormalized - 8'b000_0110;
                                                out_mant_normalized  <= mul_mant_unnormalized << 6;
                                            end                                             
    else if(mul_mant_unnormalized[7] == 1'b1) begin 
                                                out_exp_normalized   <= mul_exp_unnormalized - 8'b000_0111;
                                                out_mant_normalized  <= mul_mant_unnormalized << 7;
                                             end                                               
    else if(mul_mant_unnormalized[6] == 1'b1) begin 
                                                out_exp_normalized   <= mul_exp_unnormalized - 8'b000_1000;
                                                out_mant_normalized  <= mul_mant_unnormalized << 8;
                                            end                                             
    else if(mul_mant_unnormalized[5] == 1'b1) begin 
                                                out_exp_normalized   <= mul_exp_unnormalized - 8'b000_1001;
                                                out_mant_normalized  <= mul_mant_unnormalized << 9;
                                            end
    else if(mul_mant_unnormalized[4] == 1'b1) begin 
                                                out_exp_normalized   <= mul_exp_unnormalized - 8'b000_1010;
                                                out_mant_normalized  <= mul_mant_unnormalized << 10;
                                            end                                             
    else if(mul_mant_unnormalized[3] == 1'b1) begin 
                                                out_exp_normalized   <= mul_exp_unnormalized - 8'b000_1100;
                                                out_mant_normalized  <= mul_mant_unnormalized << 11;
                                             end                                               
    else if(mul_mant_unnormalized[2] == 1'b1) begin 
                                                out_exp_normalized   <= mul_exp_unnormalized - 8'b000_1101;
                                                out_mant_normalized  <= mul_mant_unnormalized << 12;
                                            end                                             
    else if(mul_mant_unnormalized[1] == 1'b1) begin 
                                                out_exp_normalized   <= mul_exp_unnormalized - 8'b000_1110;
                                                out_mant_normalized  <= mul_mant_unnormalized << 13;
                                             end                                             
    else                                      begin 
                                                out_exp_normalized   <= mul_exp_unnormalized - 8'b000_1111;
                                                out_mant_normalized  <= mul_mant_unnormalized << 14;
                                            end
  end
else begin        
    if(is_zero)                              begin                                  
                                                out_exp_normalized   <= 'b0;
                                                out_mant_normalized  <= 'b0;
                                            end
    else if(is_inf)                        begin                                  
                                                out_exp_normalized   <= 8'b1111_1111;
                                                out_mant_normalized  <= 16'h0000;
                                            end
    else if(is_NaN)                        begin                                  
                                                out_exp_normalized   <= 8'b1111_1111;
                                                out_mant_normalized  <= 16'h0001;
                                            end                                            
  end
end


assign out_result  = {mul_sign, out_exp_normalized, out_mant_normalized[13:7]};



endmodule