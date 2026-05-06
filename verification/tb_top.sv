
module tb_top;

  import uvm_pkg::*;
  import int_pkg::*;

  bit ic_clk;

  always #5 ic_clk = ~ic_clk;

  intf vif(ic_clk);

  initial begin
    uvm_config_db#(virtual intf)::set(null, "*", "vif", vif);
    run_test("int_base_test");
  end

  int_top dut (
    .ic_clk                    (ic_clk),
    .ic_rst                    (vif.ic_rst),
    .ic_rst_ack                (vif.ic_rst_ack),

    .ext_int0                  (vif.ext_int[0]),
    .ext_int1                  (vif.ext_int[1]),
    .ext_int2                  (vif.ext_int[2]),
    .ext_int3                  (vif.ext_int[3]),
    .ext_int4                  (vif.ext_int[4]),
    .ext_int5                  (vif.ext_int[5]),
    .ext_int6                  (vif.ext_int[6]),
    .ext_int7                  (vif.ext_int[7]),
    .ext_int8                  (vif.ext_int[8]),
    .ext_int9                  (vif.ext_int[9]),
    .ext_int10                 (vif.ext_int[10]),
    .ext_int11                 (vif.ext_int[11]),
    .ext_int12                 (vif.ext_int[12]),
    .ext_int13                 (vif.ext_int[13]),
    .ext_int14                 (vif.ext_int[14]),
    .ext_int15                 (vif.ext_int[15]),
    .ext_int16                 (vif.ext_int[16]),
    .ext_int17                 (vif.ext_int[17]),
    .ext_int18                 (vif.ext_int[18]),
    .ext_int19                 (vif.ext_int[19]),
    .ext_int20                 (vif.ext_int[20]),
    .ext_int21                 (vif.ext_int[21]),
    .ext_int22                 (vif.ext_int[22]),
    .ext_int23                 (vif.ext_int[23]),
    .ext_int24                 (vif.ext_int[24]),
    .ext_int25                 (vif.ext_int[25]),
    .ext_int26                 (vif.ext_int[26]),
    .ext_int27                 (vif.ext_int[27]),
    .ext_int28                 (vif.ext_int[28]),
    .ext_int29                 (vif.ext_int[29]),
    .ext_int30                 (vif.ext_int[30]),
    .ext_int31                 (vif.ext_int[31]),
    .ext_int32                 (vif.ext_int[32]),
    .ext_int33                 (vif.ext_int[33]),
    .ext_int34                 (vif.ext_int[34]),
    .ext_int35                 (vif.ext_int[35]),
    .ext_int36                 (vif.ext_int[36]),
    .ext_int37                 (vif.ext_int[37]),
    .ext_int38                 (vif.ext_int[38]),
    .ext_int39                 (vif.ext_int[39]),
    .ext_int40                 (vif.ext_int[40]),
    .ext_int41                 (vif.ext_int[41]),
    .ext_int42                 (vif.ext_int[42]),
    .ext_int43                 (vif.ext_int[43]),
    .ext_int44                 (vif.ext_int[44]),
    .ext_int45                 (vif.ext_int[45]),
    .ext_int46                 (vif.ext_int[46]),
    .ext_int47                 (vif.ext_int[47]),

    .threshold                 (vif.threshold),
    .irq_request               (vif.irq_request),
    .interrupt_out             (vif.interrupt_out),

    .zic_mmr_write_en_i        (vif.zic_mmr_write_en_i),
    .zic_mmr_write_addr_i      (vif.zic_mmr_write_addr_i),
    .zic_mmr_write_data_i      (vif.zic_mmr_write_data_i),

    .zic_mmr_read_en_i         (vif.zic_mmr_read_en_i),
    .zic_mmr_read_addr_i       (vif.zic_mmr_read_addr_i),
    .zic_mmr_read_data_o       (vif.zic_mmr_read_data_o),

    .zic_ack_read_valid_en     (vif.zic_ack_read_valid_en),
    .zic_ack_int_id_o          (vif.zic_ack_int_id_o),

    .zic_eoi_valid_i           (vif.zic_eoi_valid_i),
    .zic_eoi_id_i              (vif.zic_eoi_id_i),

    .global_int_enable_bit_i   (vif.global_int_enable_bit_i),
    .global_int_enable_valid_i (vif.global_int_enable_valid_i)
  );


initial begin
$shm_open("wave.shm");
$shm_probe("ACTMF");

end


endmodule
