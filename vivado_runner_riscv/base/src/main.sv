
`define WIDTH 256

module main (
  input logic clk,
  input logic rst_n,
  
  input  logic data_i,
  output logic data_o
);


// input shifter
(* DONT_TOUCH = "TRUE" *) logic rst_n_reg;
(* DONT_TOUCH = "TRUE" *) logic [`WIDTH-1:0] data_i_shift;
always_ff @(posedge clk) begin
  rst_n_reg <= rst_n;
  data_i_shift[`WIDTH-1:0] <= {data_i_shift[`WIDTH-1-1:0], data_i};
end

logic [`WIDTH-1:0] data_o_wire;

test test_inst (
  .clk   ( clk          ),
  .rst_n ( rst_n_reg    ),
  .data_i( data_i_shift ),
  .data_o( data_o_wire  )
);

// output shifter
(* DONT_TOUCH = "TRUE" *) logic [`WIDTH-1:0] data_o_reg;
always_ff @(posedge clk) begin
  data_o_reg[`WIDTH-1:0] <= data_o_wire[`WIDTH-1:0];
end

assign data_o = ^data_o_reg[`WIDTH-1:0];

endmodule

