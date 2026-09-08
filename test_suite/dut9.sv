
// typical UART receiver

module dut #(
    input  logic         clk,
    input  logic         rst_n,
    input  logic [255:0] data_i,
    output logic [255:0] data_o
);

  uart_rx(
    .clk          ( clk         ),
    .rst_n        ( rst_n       ),
    .rx           ( data_i[7:0] ),
    .rx_data      ( data_o[7:0] ),
    .rx_valid     ( data_o[8]   )
  );

endmodule


module uart_rx #(
  parameter CLK_FREQ_HZ = 50_000_000,
  parameter BAUD_RATE   = 115_200
)(
  input  logic        clk,
  input  logic        rst_n,
  input  logic        rx,
  output logic [7:0]  rx_data,
  output logic        rx_valid
);

  localparam int CLKS_PER_BIT_16X = CLK_FREQ_HZ / (BAUD_RATE * 16);
  localparam int DIV_WIDTH        = $clog2(CLKS_PER_BIT_16X);

  typedef enum logic [1:0] {
    IDLE  = 2'b00,
    START = 2'b01,
    DATA  = 2'b10,
    STOP  = 2'b11
  } state_t;

  state_t state;

  logic [DIV_WIDTH-1:0] clk_cnt;
  logic                 sample_tick;

  logic [3:0]           sample_cnt;
  logic [2:0]           bit_cnt;
  logic [7:0]           shift_reg;

  logic rx_sync_0, rx_sync;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rx_sync_0 <= 1'b1;
      rx_sync   <= 1'b1;
    end else begin
      rx_sync_0 <= rx;
      rx_sync   <= rx_sync_0;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      clk_cnt     <= '0;
      sample_tick <= 1'b0;
    end else if (clk_cnt == CLKS_PER_BIT_16X - 1) begin
      clk_cnt     <= '0;
      sample_tick <= 1'b1;
    end else begin
      clk_cnt     <= clk_cnt + 1'b1;
      sample_tick <= 1'b0;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state       <= IDLE;
      sample_cnt  <= '0;
      bit_cnt     <= '0;
      shift_reg   <= '0;
      rx_data     <= '0;
      rx_valid    <= 1'b0;
    end else begin
      rx_valid <= 1'b0;

      if (sample_tick) begin
        case (state)

          IDLE: begin
            if (rx_sync == 1'b0) begin
              state      <= START;
              sample_cnt <= '0;
            end
          end

          START: begin
            if (sample_cnt == 4'd7) begin
              if (rx_sync == 1'b0) begin
                state      <= DATA;
                sample_cnt <= '0;
                bit_cnt    <= '0;
              end else begin
                state      <= IDLE;
              end
            end else begin
              sample_cnt <= sample_cnt + 1'b1;
            end
          end

          DATA: begin
            if (sample_cnt == 4'd15) begin
              sample_cnt <= '0;
              shift_reg  <= {rx_sync, shift_reg[7:1]};

              if (bit_cnt == 3'd7) begin
                state <= STOP;
              end else begin
                bit_cnt <= bit_cnt + 1'b1;
              end
            end else begin
              sample_cnt <= sample_cnt + 1'b1;
            end
          end

          STOP: begin
            if (sample_cnt == 4'd15) begin
              if (rx_sync == 1'b1) begin
                rx_data  <= shift_reg;
                rx_valid <= 1'b1;
              end
              state <= IDLE;
            end else begin
              sample_cnt <= sample_cnt + 1'b1;
            end
          end

          default: state <= IDLE;
        endcase
      end
    end
  end

endmodule

