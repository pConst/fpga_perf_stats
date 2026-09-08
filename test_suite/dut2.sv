
// LSFR with reset
// polynamial x^8 + x^6 + x^5 + x^4 + 1

module dut #(
    input  logic         clk,
    input  logic         rst_n,
    input  logic [255:0] data_i,
    output logic [255:0] data_o
);

  lsfr(
    .clk   ( clk    ),
    .rst_n ( rst_n  ),
    .data_o( data_o )
  );

endmodule


module lsfr #(
    parameter int WIDTH = 8,
    parameter bit [WIDTH-1:0] POLYNOMIAL = 8'b10110001,
    parameter bit [WIDTH-1:0] SEED       = 8'h01
)(
    input  logic             clk,
    input  logic             rst_n,
    output logic [WIDTH-1:0] data_o
);

    logic [WIDTH-1:0] lfsr_reg = SEED;

    always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        lfsr_reg <= SEED;
      end else begin
        if (lfsr_reg[0]) begin
            lfsr_reg <= (lfsr_reg >> 1) ^ POLYNOMIAL;
        end else begin
            lfsr_reg <= (lfsr_reg >> 1);
        end
      end
    end

    // Выходное значение
    assign data_o = lfsr_reg;

endmodule

