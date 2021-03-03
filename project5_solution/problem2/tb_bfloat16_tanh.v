

`define NULL 0    
module tb_bfloat16_tanh;

reg clk;
reg rst_x;

reg [15:0]   in_load_data;
reg          in_load_enable;
reg [4:0]    in_load_addr;

reg          start;

reg   [15:0] input_x;
wire  [15:0] output_y;

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
   rst_x = 1'b1;
   repeat (1) @(posedge clk); 
end
//------------------------------------------------
//Input Address & Data 
//------------------------------------------------
parameter ENTRY_SIZE = 32;

integer               file_decsriptor; // file handler
integer               file_io; // file handler
integer               i,j,k;

reg [15:0] bfloat16_data    [0:ENTRY_SIZE-1];
reg [4:0]  bfloat16_address [0:ENTRY_SIZE-1];


reg [15:0]test_input_x;
wire[15:0]test_output_y;

initial begin
  file_decsriptor = $fopen("LUT_entry.dat", "r");
  if (file_decsriptor == `NULL) begin
    $display("file_decsriptor was NULL");
    $finish;
  end
  for( i =0; i< ENTRY_SIZE; i=i+1) begin
    file_io = $fscanf(file_decsriptor,"%d,%x\n", bfloat16_address[i], bfloat16_data[i]); 
  end
    $display ("File Read Done!");
end

//------------------------------------------------
//Test Logic
//------------------------------------------------
	// Insert register file//
 initial begin 
   j       = 0;
   start   = 0;
   $display ("Register file enqueue start!");
      for( j =0; j< ENTRY_SIZE; j=j+1) begin 
	in_load_data   <= bfloat16_data[j];
	in_load_addr   <= bfloat16_address[j];
	in_load_enable <=1;
	#10;
      end
	in_load_enable =0;
	#10;

       test_input_x  = 16'h 3f81;
	#10;
       test_input_x  = 16'h 4001;
	#10;


end
bfloat16_tanh U0_BFLOAT16_TANH(
                             .clk(clk),
                             .rst_x(rst_x),
                             .in_load_enable (in_load_enable),
                             .in_load_addr   (in_load_addr),
                             .in_load_data   (in_load_data),

                             .input_x        (test_input_x),
                             .output_y       (test_output_y)
);



endmodule