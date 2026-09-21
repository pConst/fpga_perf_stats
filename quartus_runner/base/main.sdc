
create_clock -period 0.500 -waveform { 0.000 0.250 } [get_ports {clk}]

set_false_path -to [get_cells {data_i_shift*}]
set_false_path -to [get_cells {rst_n_reg}]

set_false_path -from [get_cells {data_o_reg*}]

derive_pll_clocks
derive_clock_uncertainty

