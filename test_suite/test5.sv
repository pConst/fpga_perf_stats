
// 128 bit binary counter with reset and parallel load

module counter_128bit #(
    parameter int WIDTH = 128
)(
    input  logic             clk,
    input  logic             rst_n,
    input  logic             load,
    input  logic [WIDTH-1:0] data,
    output logic [WIDTH-1:0] count
);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      count <= '0;
    end else if (load) begin
      count <= data;
    end else begin
      count <= count + 1'b1;
    end
  end

endmodule


module test (
    input  logic         clk,
    input  logic         rst_n,
    input  logic [255:0] data_i,
    output logic [255:0] data_o
);

  counter_128bit(
    .clk   ( clk           ),
    .rst_n ( rst_n         ),
    .load  ( data_i[128]   ),
    .data  ( data_i[127:0] ),
    .count ( data_o[127:0] )
  );

endmodule

