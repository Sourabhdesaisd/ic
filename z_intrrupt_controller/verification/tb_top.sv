
module tb_top;

  import uvm_pkg::*;
  import int_pkg::*;

  bit zic_clk;

  always #5 zic_clk = ~zic_clk;

  intf vif(zic_clk);

  initial begin
    uvm_config_db#(virtual intf)::set(null, "*", "vif", vif);
    run_test("int_base_test");
  end

  zilla_interrupt_control dut (
    .zic_clk                  (zic_clk),
    .zic_rst                  (vif.zic_rst),

    .zic_mmr_write_en_i       (vif.zic_mmr_write_en_i),
    .zic_mmr_write_addr_i     (vif.zic_mmr_write_addr_i),
    .zic_mmr_write_data_i     (vif.zic_mmr_write_data_i),

    .zic_mmr_read_en_i        (vif.zic_mmr_read_en_i),
    .zic_mmr_read_addr_i      (vif.zic_mmr_read_addr_i),
    .zic_mmr_read_data_o      (vif.zic_mmr_read_data_o),

    .zic_ack_read_valid_en    (vif.zic_ack_read_valid_en),
    .zic_ack_int_id_o         (vif.zic_ack_int_id_o),

    .zic_eoi_valid_i          (vif.zic_eoi_valid_i),
    .zic_eoi_id_i             (vif.zic_eoi_id_i),

    .active_lvl_pr_i          (vif.active_lvl_pr_i),
    .interrupt_request_o      (vif.interrupt_request_o),

    .global_int_enable_bit_i  (vif.global_int_enable_bit_i),
    .global_int_enable_valid_i(vif.global_int_enable_valid_i),

    .highest_pending_lvl_pr_o (vif.highest_pending_lvl_pr_o),

    .ext_int0_i               (vif.ext_int[0]),
    .ext_int1_i               (vif.ext_int[1]),
    .ext_int2_i               (vif.ext_int[2]),
    .ext_int3_i               (vif.ext_int[3]),
    .ext_int4_i               (vif.ext_int[4]),
    .ext_int5_i               (vif.ext_int[5]),
    .ext_int6_i               (vif.ext_int[6]),
    .ext_int7_i               (vif.ext_int[7]),
    .ext_int8_i               (vif.ext_int[8]),
    .ext_int9_i               (vif.ext_int[9]),
    .ext_int10_i              (vif.ext_int[10]),
    .ext_int11_i              (vif.ext_int[11]),
    .ext_int12_i              (vif.ext_int[12]),
    .ext_int13_i              (vif.ext_int[13]),
    .ext_int14_i              (vif.ext_int[14]),
    .ext_int15_i              (vif.ext_int[15]),
    .ext_int16_i              (vif.ext_int[16]),
    .ext_int17_i              (vif.ext_int[17]),
    .ext_int18_i              (vif.ext_int[18]),
    .ext_int19_i              (vif.ext_int[19]),
    .ext_int20_i              (vif.ext_int[20]),
    .ext_int21_i              (vif.ext_int[21]),
    .ext_int22_i              (vif.ext_int[22]),
    .ext_int23_i              (vif.ext_int[23]),
    .ext_int24_i              (vif.ext_int[24]),
    .ext_int25_i              (vif.ext_int[25]),
    .ext_int26_i              (vif.ext_int[26]),
    .ext_int27_i              (vif.ext_int[27]),
    .ext_int28_i              (vif.ext_int[28]),
    .ext_int29_i              (vif.ext_int[29]),
    .ext_int30_i              (vif.ext_int[30]),
    .ext_int31_i              (vif.ext_int[31]),
    .ext_int32_i              (vif.ext_int[32]),
    .ext_int33_i              (vif.ext_int[33]),
    .ext_int34_i              (vif.ext_int[34]),
    .ext_int35_i              (vif.ext_int[35]),
    .ext_int36_i              (vif.ext_int[36]),
    .ext_int37_i              (vif.ext_int[37]),
    .ext_int38_i              (vif.ext_int[38]),
    .ext_int39_i              (vif.ext_int[39]),
    .ext_int40_i              (vif.ext_int[40]),
    .ext_int41_i              (vif.ext_int[41]),
    .ext_int42_i              (vif.ext_int[42]),
    .ext_int43_i              (vif.ext_int[43]),
    .ext_int44_i              (vif.ext_int[44]),
    .ext_int45_i              (vif.ext_int[45]),
    .ext_int46_i              (vif.ext_int[46]),
    

    .debug_mode_valid_i       (vif.debug_mode_valid_i),
    .debug_mode_reset_i       (vif.debug_mode_reset_i),
    .debug_ndm_reset_i        (vif.debug_ndm_reset_i),
    .wdt_reset_o              (vif.wdt_reset_o)
  );

assign vif.zic_ack_int_id_w =   dut.zic_ack_int_id_w;
 
 initial begin
    $shm_open("wave.shm");
    $shm_probe("ACTMF");
  end

endmodule
