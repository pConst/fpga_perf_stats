
`define WIDTH 256

module main (
  input logic clk,
  input logic rst_n,
  
  input  logic [`WIDTH-1:0] data_i,
  output logic [`WIDTH-1:0] data_o
);

//registering all outputs
logic [`WIDTH-1:0] data_i_reg;
always_ff @(posedge clk) begin
  data_i_reg [`WIDTH-1:0] <= data_i[`WIDTH-1:0];
end

logic [`WIDTH-1:0] data_o_reg;

dut dut_inst (
  .clk  ( clk ),
  .rst_n( rst_n ),
  .data_i( data_i_reg ),
  .data_o( data_o_reg )
);

//registering all outputs
always_ff @(posedge clk) begin
  data_o [`WIDTH-1:0] <= data_o_reg [`WIDTH-1:0];
end

endmodule

