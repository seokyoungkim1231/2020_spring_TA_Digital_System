

`define NULL 0    
module tb_bfloat16;

reg clk;
reg rst_x;
reg [15:0] bfloat16_A;
reg [15:0] bfloat16_B;
reg select;
//------------------------------------------------
//Clock & Reset
//------------------------------------------------

parameter FREQ   = 100;
parameter CKP    = 1000.0/FREQ;
initial  forever #(CKP/2)    clk  = ~clk;
initial  begin 
   clk = 1'b1;
end
initial begin
   rst_x = 1'b0;
   repeat (5) @(posedge clk);
   #(CKP/2) rst_x = 1'b1;
   $display ("Reset disable... Simulation Start !!! ");    
end
task wait_clocks;
   input integer num_clocks;
   integer cnt_clocks;
   for(cnt_clocks = 0; cnt_clocks < num_clocks; cnt_clocks = cnt_clocks + 1) begin
     @ (posedge clk);
   end
endtask 


//------------------------------------------------
//Test Input Trace
//------------------------------------------------
parameter TRACE_SIZE = 50;

integer               file_decsriptor; // file handler
integer               file_io; // file handler
integer               i,j;
integer               start;
integer               mul_result_file_descriptor;
integer               add_result_file_descriptor;

reg bfloat16_A_sign[0:TRACE_SIZE-1];
reg [7:0] bfloat16_A_exp[0:TRACE_SIZE-1];
reg [6:0] bfloat16_A_mant[0:TRACE_SIZE-1];

reg bfloat16_B_sign[0:TRACE_SIZE-1];
reg [7:0] bfloat16_B_exp[0:TRACE_SIZE-1];
reg [6:0] bfloat16_B_mant[0:TRACE_SIZE-1];

initial begin
  file_decsriptor = $fopen("input.dat", "r");
  if (file_decsriptor == `NULL) begin
    $display("file_decsriptor was NULL");
    $finish;
  end
  for( i =0; i< TRACE_SIZE; i=i+1) begin
  file_io = $fscanf(file_decsriptor,"%d,%d,%d,%d,%d,%d\n", bfloat16_A_sign[i], bfloat16_A_exp[i], bfloat16_A_mant[i], bfloat16_B_sign[i], bfloat16_B_exp[i], bfloat16_B_mant[i]); 
  end
   $display ("File Read Done!");
end

//------------------------------------------------
//Test Logic
//------------------------------------------------

wire [15:0] mul_result;
wire [15:0] add_result;


bfloat16_add U0_ADD(
	.in_A (bfloat16_A),
	.in_B (bfloat16_B),
	.select (select),
        .out_result(add_result)
);

bfloat16_mul U1_MUL(
	.in_A (bfloat16_A),
	.in_B (bfloat16_B),
        .out_result(mul_result)
);


 initial begin
   mul_result_file_descriptor = $fopen ("mul_result.txt", "w");   
   add_result_file_descriptor = $fopen ("add_result.txt", "w");   
   j       = 0;
   start   = 0;
   $display ("Request enqueue start!");
   start   = 1;
   for( j =0; j< TRACE_SIZE; j=j+1) begin 
	//$display ("A => Sign: %b Exponent:%b Mantissa:%b \n",bfloat16_A_sign[j], bfloat16_A_exp[j], bfloat16_A_mant[j]);
	//$display ("B => Sign: %b Exponent:%b Mantissa:%b \n",bfloat16_B_sign[j], bfloat16_B_exp[j], bfloat16_B_mant[j]);	
	bfloat16_A = {bfloat16_A_sign[j], bfloat16_A_exp[j], bfloat16_A_mant[j]};
	bfloat16_B = {bfloat16_B_sign[j], bfloat16_B_exp[j], bfloat16_B_mant[j]}; 
	
	select =0;
	$fwrite(add_result_file_descriptor,"%x\n",add_result);
	wait_clocks(30);
	
	select =1;
	$fwrite(add_result_file_descriptor,"%x\n",add_result);
	wait_clocks(30);
	
	$fwrite(mul_result_file_descriptor,"%x\n",mul_result);
        	wait_clocks(30);
 	$display ("Request enqueue end!");
  end
end





endmodule