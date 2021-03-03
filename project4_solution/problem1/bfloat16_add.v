
module bfloat16_add(
    in_A,
    in_B,
    select,

    out_result
    
);

input [15:0]        in_A;
input [15:0]        in_B;
input               select;

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
wire is_sum_zero;

wire is_special;
wire is_ovf_unf;

wire is_A_bigger_B;


//Check special case
assign is_zero        = (A_exp == 8'b0 && A_mant ==8'b1000_0000) || (B_exp == 8'b0 && B_mant == 8'b1000_0000);
assign is_NaN         = (A_exp == 8'b0 && |in_A[6:0]!= 7'b0) || (B_exp == 8'b0 && |in_B[6:0]!= 7'b0);
assign is_inf         = (A_exp == 8'b1111_1111 && A_mant ==8'b1000_0000) || (B_exp == 8'b1111_1111 && B_mant == 8'b1000_0000);
assign is_sum_zero    = (A_sign ^ B_sign) && (A_exp == B_exp) &&(A_mant == B_mant);
assign is_special     = is_zero || is_inf || is_NaN ||is_sum_zero;


assign is_A_bigger_B  = in_A > in_B;


//Compute unnormalized result 
wire add_sign = !select? (is_A_bigger_B? A_sign : B_sign) : (is_A_bigger_B? A_sign : !B_sign);

wire [7:0]  add_exp_unnormalized;
wire [8:0] A_exp_temp = {1'b0,A_exp};
wire [8:0] B_exp_temp = {1'b0,B_exp};
assign add_exp_unnormalized  =is_A_bigger_B? A_exp : B_exp;
wire [8:0] exp_diff = A_exp_temp - B_exp_temp;


reg [8:0] add_mant_unnormalized;
wire [7:0] aligned_A_mant;
wire [7:0] aligned_B_mant;

assign aligned_A_mant = is_A_bigger_B ? A_mant           : A_mant >>exp_diff;
assign aligned_B_mant = is_A_bigger_B ? B_mant>>exp_diff : B_mant;

//assign add_mant_unnormalized = (!select) ? (aligned_A_mant + aligned_B_mant)  : (is_A_bigger_B? aligned_A_mant-aligned_B_mant : aligned_B_mant - aligned_A_mant);

always @(*) begin
	if(!select)           add_mant_unnormalized = aligned_A_mant + aligned_B_mant;
	else  begin    
	   if(is_A_bigger_B)  add_mant_unnormalized = aligned_A_mant-aligned_B_mant;
	   else               add_mant_unnormalized = aligned_B_mant-aligned_A_mant; 
	end

end
//Normalize result & check special
reg [7:0]     out_exp_normalized;
reg [8:0]    out_mant_normalized;

always @(*) begin 
  if(!is_special) begin     
    if(add_mant_unnormalized[8] == 1'b1) begin 
                                                out_exp_normalized   <= add_exp_unnormalized + 8'b0000_0001;
                                                out_mant_normalized  <= add_mant_unnormalized >> 1;
                                             end
    else if(add_mant_unnormalized[7] == 1'b1) begin 
                                                out_exp_normalized   <= add_exp_unnormalized;
                                                out_mant_normalized  <= add_mant_unnormalized;
                                            end 
    else if(add_mant_unnormalized[6] == 1'b1) begin 
                                                out_exp_normalized   <= add_exp_unnormalized - 8'b0000_0001;
                                                out_mant_normalized  <= add_mant_unnormalized << 1;
                                            end                                             
    else if(add_mant_unnormalized[5] == 1'b1) begin 
                                                out_exp_normalized   <= add_exp_unnormalized - 8'b0000_0010;
                                                out_mant_normalized  <= add_mant_unnormalized << 2;
                                             end                                               
    else if(add_mant_unnormalized[4] == 1'b1) begin 
                                                out_exp_normalized   <= add_exp_unnormalized - 8'b0000_0011;
                                                out_mant_normalized  <= add_mant_unnormalized << 3;
                                            end                                             
    else if(add_mant_unnormalized[3] == 1'b1) begin 
                                                out_exp_normalized   <= add_exp_unnormalized - 8'b0000_0100;
                                                out_mant_normalized  <= add_mant_unnormalized << 4;
                                             end 
    else if(add_mant_unnormalized[2] == 1'b1) begin 
                                                out_exp_normalized   <= add_exp_unnormalized - 8'b0000_0101;
                                                out_mant_normalized  <= add_mant_unnormalized << 5;
                                            end 
    else if(add_mant_unnormalized[1] == 1'b1) begin 
                                                out_exp_normalized   <= add_exp_unnormalized - 8'b0000_0110;
                                                out_mant_normalized  <= add_mant_unnormalized << 6;
                                            end                                             
    else if(add_mant_unnormalized[0] == 1'b1) begin 
                                                out_exp_normalized   <= add_exp_unnormalized - 8'b0000_0111;
                                                out_mant_normalized  <= add_mant_unnormalized << 7;
                                             end                                                                                         
    else                                      begin 
                                                out_exp_normalized   <= add_exp_unnormalized - 8'b0000_1000;
                                                out_mant_normalized  <= add_mant_unnormalized << 8;
                                            end
  end
else begin        
    if(is_zero)                              begin                                  
                                                out_exp_normalized   <= 'b0;
                                                out_mant_normalized  <= 'b0;
                                            end
    else if(is_inf)                        begin                                  
                                                out_exp_normalized   <= 8'b1111_1111;
                                                out_mant_normalized  <= 9'b0_0000_0000;
                                            end
    else if(is_NaN)                        begin                                  
                                                out_exp_normalized   <= 8'b1111_1111;
                                                out_mant_normalized  <= 9'b0_0000_0001;
                                            end   
    else if(is_sum_zero)                        begin                                  
                                                out_exp_normalized   <= 8'b0000_0000;
                                                out_mant_normalized  <= 9'b0_0000_0000;
                                            end                                         
end
end

assign out_result  = {add_sign, out_exp_normalized, out_mant_normalized[6:0]};


endmodule