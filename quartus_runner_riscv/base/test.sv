

module test (
    input  logic         clk,
    input  logic         rst_n,
    input  logic [255:0] data_i,
    output logic [255:0] data_o
);

  scr1_core_top scr1_inst (
    .clk                  ( clk             ),
    .tapc_tck             ( clk             ),
    .rst_n                ( rst_n           ),
    .cpu_rst_n            ( rst_n           ),
    .pwrup_rst_n          ( rst_n           ),
    .tapc_trst_n          ( rst_n           ),
    .test_rst_n           ( rst_n           ),

    .core_irq_mtimer_i    ( data_i[1]       ),
    .core_irq_soft_i      ( data_i[2]       ),
    .dmem2core_req_ack_i  ( data_i[3]       ),
    .imem2core_req_ack_i  ( data_i[4]       ),
    .tapc_tdi             ( data_i[5]       ),
    .tapc_tms             ( data_i[6]       ),
    .test_mode            ( data_i[7]       ),

    .tapc_fuse_idcode_i   ( data_i[255:32]  ),
    .core_mtimer_val_i    ( data_i[255:64]  ),
    .dmem2core_rdata_i    ( data_i[255:96]  ),
    .imem2core_rdata_i    ( data_i[255:128] ),
    .core_fuse_mhartid_i  ( data_i[255:160] ),
    .core_irq_lines_i     ( data_i[255:192] ),
    .dmem2core_resp_i     ( type_scr1_mem_resp_e'(data_i[252:250])  ),
    .imem2core_resp_i     ( type_scr1_mem_resp_e'(data_i[255:253])  ),

    .core2dmem_req_o      ( data_o[0]       ),
    .core2imem_req_o      ( data_o[1]       ),
    .core_rdc_qlfy_o      ( data_o[2]       ),
    .core_rst_n_o         ( data_o[3]       ),
    .sys_rdc_qlfy_o       ( data_o[4]       ),
    .sys_rst_n_o          ( data_o[5]       ),
    .tapc_tdo             ( data_o[6]       ),
    .tapc_tdo_en          ( data_o[7]       ),

    .core2dmem_addr_o     ( data_o[63:32]   ),
    .core2dmem_wdata_o    ( data_o[95:64]   ),
    .core2imem_addr_o     ( data_o[127:96]  ),
    .core2dmem_cmd_o      ( data_o[159:128] ),
    .core2imem_cmd_o      ( data_o[191:160] ),
    .core2dmem_width_o    ( data_o[223:192] )
  );

endmodule

