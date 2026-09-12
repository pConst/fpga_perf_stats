
// shift register w/o rst

module delay #(
    parameter int LENGTH = 8,
    parameter int WIDTH = 32
)(
    input  logic             clk,
    input  logic [WIDTH-1:0] data_i,
    output logic [WIDTH-1:0] data_o
);

  logic [WIDTH-1:0] shift_reg [0:LENGTH-1];

  always_ff @(posedge clk) begin
    shift_reg[0] <= data_i;
    for (int i = 1; i < LENGTH; i++) begin
      shift_reg[i] <= shift_reg[i-1];
    end
  end

  assign data_o = shift_reg[LENGTH-1];

endmodule


module test (
    input  logic         clk,
    input  logic         rst_n,
    input  logic [255:0] data_i,
    output logic [255:0] data_o
);

  delay(
    .clk   ( clk    ),
    .data_i( data_i ),
    .data_o( data_o )
  );

endmodule

