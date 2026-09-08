
// dynamic delay = 128 tap delay + output demultiplexer

module dynamic_delay_128 #(
  parameter int LENGTH = 128,
  parameter int WIDTH  = 32,
  parameter int ADDR_W = $clog2(LENGTH)
)(
  input  logic                clk,
  input  logic                rst_n,
  input  logic [ADDR_W-1:0]   delay_select,
  input  logic [WIDTH-1:0]    data_i,
  output logic [WIDTH-1:0]    data_o
);

  logic [WIDTH-1:0] shift_reg [0:LENGTH-1];

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (int i = 0; i < LENGTH; i++) begin
        shift_reg[i] <= '0;
      end
    end else begin
      shift_reg[0] <= data_i;
      for (int i = 1; i < LENGTH; i++) begin
        shift_reg[i] <= shift_reg[i-1];
      end
    end
  end

  assign data_o = shift_reg[delay_select];

endmodule


module dut (
    input  logic         clk,
    input  logic         rst_n,
    input  logic [255:0] data_i,
    output logic [255:0] data_o
);

  dynamic_delay_128(
    .clk          ( clk           ),
    .rst_n        ( rst_n         ),
    .delay_select ( data_i[63:32] ),
    .data_i       ( data_i[31:0]  ),
    .data_o       ( data_o[31:0]  )
  );

endmodule

