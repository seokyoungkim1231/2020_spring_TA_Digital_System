
`define NULL 0    
module tb_bfloat16_rf;

reg clk;
reg rst_x;

reg [15:0] in_load_data;
reg        in_load_enable;
reg [4:0]  in_load_addr;

reg        start;

wire  [15:0] out_bfloat16;

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

integer               register_file_descriptor;


reg [15:0] bfloat16_data    [0:ENTRY_SIZE-1];
reg [4:0]  bfloat16_address [0:ENTRY_SIZE-1];
initial begin
  file_decsriptor = $fopen("input.dat", "r");
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
	register_file_descriptor = $fopen ("result_rf.txt", "w");  
     for( k =0; k< ENTRY_SIZE; k=k+1) begin 
	in_load_addr                 = bfloat16_address[k];
	$fwrite(register_file_descriptor,"%x\n",out_bfloat16);
	#10;
      end
end

bfloat16_rf U0_BFLOAT16_RF(
                             .clk(clk),
                             .rst_x(rst_x),
                             .we (in_load_enable),
                             .addr(in_load_addr),
                             .di(in_load_data),

                             .dout(out_bfloat16)
);



endmodule