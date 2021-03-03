module bfloat16_rf # (
    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 16
)(
  rst_x,
  clk, 
  we, 
  addr, 
  di, 
  dout
);

input rst_x;
input clk; 
input we;

input  [ADDR_WIDTH-1:0] addr; 
input  [DATA_WIDTH-1:0] di; 
output [DATA_WIDTH-1:0] dout;

reg [DATA_WIDTH-1:0] register_bfloat16 [(1<<ADDR_WIDTH)-1:0];
reg [DATA_WIDTH-1:0] dout;

always @(posedge clk) begin
    if (we)                 register_bfloat16[addr] <= di;
    else                    dout <= register_bfloat16[addr];
  end
endmodule



