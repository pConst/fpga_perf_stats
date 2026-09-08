
// typical SPI transmitter

module spi_transmitter #(
  parameter int DATA_WIDTH = 64
)(
  input  logic                    clk,
  input  logic                    rst_n,

  input  logic [DATA_WIDTH-1:0]   tx_data,
  input  logic                    tx_valid,
  output logic                    tx_ready,

  output logic                    spi_sclk,
  output logic                    spi_mosi,
  output logic                    spi_ss_n
);

  typedef enum logic [1:0] {
    IDLE  = 2'b00,
    START = 2'b01,
    SHIFT = 2'b10,
    STOP  = 2'b11
  } state_t;

  state_t current_state, next_state;

  logic [DATA_WIDTH-1:0] shift_reg;
  logic [$clog2(DATA_WIDTH)-1:0] bit_cnt;
  logic sclk_enable;

  assign tx_ready = (current_state == IDLE);
  assign spi_sclk = sclk_enable ? clk : 1'b0;
  assign spi_mosi = shift_reg[DATA_WIDTH-1];

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end

  always_comb begin
    next_state = current_state;
    case (current_state)
      IDLE: begin
        if (tx_valid) begin
          next_state = START;
        end
      end
      START: begin
        next_state = SHIFT;
      end
      SHIFT: begin
        if (bit_cnt == DATA_WIDTH - 1) begin
          next_state = STOP;
        end
      end
      STOP: begin
        next_state = IDLE;
      end
      default: next_state = IDLE;
    endcase
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      shift_reg   <= '0;
      bit_cnt     <= '0;
      spi_ss_n    <= 1'b1;
      sclk_enable <= 1'b0;
    end else begin
      case (current_state)
        IDLE: begin
          spi_ss_n    <= 1'b1;
          sclk_enable <= 1'b0;
          bit_cnt     <= '0;
          if (tx_valid) begin
            shift_reg <= tx_data;
          end
        end

        START: begin
          spi_ss_n    <= 1'b0;
          sclk_enable <= 1'b1;
        end

        SHIFT: begin
          shift_reg <= {shift_reg[DATA_WIDTH-2:0], 1'b0};
          bit_cnt   <= bit_cnt + 1'b1;
        end

        STOP: begin
          sclk_enable <= 1'b0;
          spi_ss_n    <= 1'b1;
        end
      endcase
    end
  end

endmodule


module dut (
    input  logic         clk,
    input  logic         rst_n,
    input  logic [255:0] data_i,
    output logic [255:0] data_o
);

  spi_transmitter(
    .clk      ( clk          ),
    .rst_n    ( rst_n        ),
    .tx_data  ( data_i[63:0] ),
    .tx_valid ( data_i[64]   ),
    .tx_ready ( data_o[0]    ),
    .spi_sclk ( data_o[1]    ),
    .spi_mosi ( data_o[2]    ),
    .spi_ss_n ( data_o[3]    )
  );

endmodule

