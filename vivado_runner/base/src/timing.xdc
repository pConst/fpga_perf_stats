
# main reference clock, 1000 MHz requested
create_clock -name clk -period 0.500 -waveform {0.000 0.250} [get_ports { clk }]

set_falce_path - to [get_cells {data_i_shift_reg[*]}]
set_falce_path - to [get_cells {rst_n_reg}]

set_falce_path - from [get_cells {data_o_reg_reg[*]}]


