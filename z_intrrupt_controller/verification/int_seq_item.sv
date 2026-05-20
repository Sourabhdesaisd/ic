class int_seq_item extends uvm_sequence_item;

  //============================================================
  // DUT OUTPUTS SAMPLED BY MONITOR
  //============================================================
  logic [31:0] zic_mmr_read_data_o;
  logic [7:0]  zic_ack_int_id_o;
  logic        interrupt_request_o;
  logic [7:0]  highest_pending_lvl_pr_o;

  //============================================================
  // DUT INPUTS / DRIVER FIELDS
  //============================================================
  rand logic        zic_rst;

  rand logic        zic_mmr_write_en_i;
  rand logic [15:0] zic_mmr_write_addr_i;
  rand logic [31:0] zic_mmr_write_data_i;

  rand logic        zic_mmr_read_en_i;
  rand logic [15:0] zic_mmr_read_addr_i;

  rand logic        zic_ack_read_valid_en;

  rand logic        zic_eoi_valid_i;
  rand logic [7:0]  zic_eoi_id_i;

  rand logic [7:0]  active_lvl_pr_i;

  rand logic [47:0] global_int_enable_bit_i;
  rand logic        global_int_enable_valid_i;


  //============================================================
  // EXTERNAL INTERRUPTS
  // Your top has ext_int0_i to ext_int46_i.
  // ext_int47 is internally wdt_irq_w in top.
  //============================================================
  rand logic ext_int0_i;
  rand logic ext_int1_i;
  rand logic ext_int2_i;
  rand logic ext_int3_i;
  rand logic ext_int4_i;
  rand logic ext_int5_i;
  rand logic ext_int6_i;
  rand logic ext_int7_i;
  rand logic ext_int8_i;
  rand logic ext_int9_i;
  rand logic ext_int10_i;
  rand logic ext_int11_i;
  rand logic ext_int12_i;
  rand logic ext_int13_i;
  rand logic ext_int14_i;
  rand logic ext_int15_i;
  rand logic ext_int16_i;
  rand logic ext_int17_i;
  rand logic ext_int18_i;
  rand logic ext_int19_i;
  rand logic ext_int20_i;
  rand logic ext_int21_i;
  rand logic ext_int22_i;
  rand logic ext_int23_i;
  rand logic ext_int24_i;
  rand logic ext_int25_i;
  rand logic ext_int26_i;
  rand logic ext_int27_i;
  rand logic ext_int28_i;
  rand logic ext_int29_i;
  rand logic ext_int30_i;
  rand logic ext_int31_i;
  rand logic ext_int32_i;
  rand logic ext_int33_i;
  rand logic ext_int34_i;
  rand logic ext_int35_i;
  rand logic ext_int36_i;
  rand logic ext_int37_i;
  rand logic ext_int38_i;
  rand logic ext_int39_i;
  rand logic ext_int40_i;
  rand logic ext_int41_i;
  rand logic ext_int42_i;
  rand logic ext_int43_i;
  rand logic ext_int44_i;
  rand logic ext_int45_i;
  rand logic ext_int46_i;

  // Packed vector used only by monitor/scoreboard for simple loops
  logic [47:0] ext_int;


  //============================================================
  // DEBUG INPUTS
  //============================================================
  rand logic debug_mode_valid_i;
  rand logic debug_mode_reset_i;
  rand logic debug_ndm_reset_i;


  //============================================================
  // EXPECTED VALUES CALCULATED BY MONITOR
  //============================================================
  logic        exp_valid;
  logic        exp_irq_req;
  logic [7:0]  exp_ack_id;
  logic [7:0]  exp_highest_lvl_pr;


  //============================================================
  // HELPER FUNCTION
  // Call this in monitor after sampling individual ext_int pins,
  // or in driver before driving if required.
  //============================================================
  function void pack_ext_int();

    ext_int[0]  = ext_int0_i;
    ext_int[1]  = ext_int1_i;
    ext_int[2]  = ext_int2_i;
    ext_int[3]  = ext_int3_i;
    ext_int[4]  = ext_int4_i;
    ext_int[5]  = ext_int5_i;
    ext_int[6]  = ext_int6_i;
    ext_int[7]  = ext_int7_i;
    ext_int[8]  = ext_int8_i;
    ext_int[9]  = ext_int9_i;
    ext_int[10] = ext_int10_i;
    ext_int[11] = ext_int11_i;
    ext_int[12] = ext_int12_i;
    ext_int[13] = ext_int13_i;
    ext_int[14] = ext_int14_i;
    ext_int[15] = ext_int15_i;
    ext_int[16] = ext_int16_i;
    ext_int[17] = ext_int17_i;
    ext_int[18] = ext_int18_i;
    ext_int[19] = ext_int19_i;
    ext_int[20] = ext_int20_i;
    ext_int[21] = ext_int21_i;
    ext_int[22] = ext_int22_i;
    ext_int[23] = ext_int23_i;
    ext_int[24] = ext_int24_i;
    ext_int[25] = ext_int25_i;
    ext_int[26] = ext_int26_i;
    ext_int[27] = ext_int27_i;
    ext_int[28] = ext_int28_i;
    ext_int[29] = ext_int29_i;
    ext_int[30] = ext_int30_i;
    ext_int[31] = ext_int31_i;
    ext_int[32] = ext_int32_i;
    ext_int[33] = ext_int33_i;
    ext_int[34] = ext_int34_i;
    ext_int[35] = ext_int35_i;
    ext_int[36] = ext_int36_i;
    ext_int[37] = ext_int37_i;
    ext_int[38] = ext_int38_i;
    ext_int[39] = ext_int39_i;
    ext_int[40] = ext_int40_i;
    ext_int[41] = ext_int41_i;
    ext_int[42] = ext_int42_i;
    ext_int[43] = ext_int43_i;
    ext_int[44] = ext_int44_i;
    ext_int[45] = ext_int45_i;
    ext_int[46] = ext_int46_i;
    ext_int[47] = 1'b0; // top connects IRQ47 to WDT, not external TB pin

  endfunction


  //============================================================
  // FACTORY REGISTRATION
  //============================================================
  `uvm_object_utils_begin(int_seq_item)

    `uvm_field_int(zic_mmr_read_data_o,       UVM_ALL_ON)
    `uvm_field_int(zic_ack_int_id_o,          UVM_ALL_ON)
    `uvm_field_int(interrupt_request_o,       UVM_ALL_ON)
    `uvm_field_int(highest_pending_lvl_pr_o,  UVM_ALL_ON)

    `uvm_field_int(zic_rst,                   UVM_ALL_ON)

    `uvm_field_int(zic_mmr_write_en_i,        UVM_ALL_ON)
    `uvm_field_int(zic_mmr_write_addr_i,      UVM_ALL_ON)
    `uvm_field_int(zic_mmr_write_data_i,      UVM_ALL_ON)

    `uvm_field_int(zic_mmr_read_en_i,         UVM_ALL_ON)
    `uvm_field_int(zic_mmr_read_addr_i,       UVM_ALL_ON)

    `uvm_field_int(zic_ack_read_valid_en,     UVM_ALL_ON)

    `uvm_field_int(zic_eoi_valid_i,           UVM_ALL_ON)
    `uvm_field_int(zic_eoi_id_i,              UVM_ALL_ON)

    `uvm_field_int(active_lvl_pr_i,           UVM_ALL_ON)

    `uvm_field_int(global_int_enable_bit_i,   UVM_ALL_ON)
    `uvm_field_int(global_int_enable_valid_i, UVM_ALL_ON)

    `uvm_field_int(ext_int0_i,                UVM_ALL_ON)
    `uvm_field_int(ext_int1_i,                UVM_ALL_ON)
    `uvm_field_int(ext_int2_i,                UVM_ALL_ON)
    `uvm_field_int(ext_int3_i,                UVM_ALL_ON)
    `uvm_field_int(ext_int4_i,                UVM_ALL_ON)
    `uvm_field_int(ext_int5_i,                UVM_ALL_ON)
    `uvm_field_int(ext_int6_i,                UVM_ALL_ON)
    `uvm_field_int(ext_int7_i,                UVM_ALL_ON)
    `uvm_field_int(ext_int8_i,                UVM_ALL_ON)
    `uvm_field_int(ext_int9_i,                UVM_ALL_ON)
    `uvm_field_int(ext_int10_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int11_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int12_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int13_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int14_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int15_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int16_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int17_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int18_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int19_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int20_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int21_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int22_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int23_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int24_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int25_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int26_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int27_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int28_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int29_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int30_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int31_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int32_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int33_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int34_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int35_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int36_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int37_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int38_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int39_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int40_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int41_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int42_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int43_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int44_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int45_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int46_i,               UVM_ALL_ON)

    `uvm_field_int(ext_int,                   UVM_ALL_ON)

    `uvm_field_int(debug_mode_valid_i,        UVM_ALL_ON)
    `uvm_field_int(debug_mode_reset_i,        UVM_ALL_ON)
    `uvm_field_int(debug_ndm_reset_i,         UVM_ALL_ON)

    `uvm_field_int(exp_valid,                 UVM_ALL_ON)
    `uvm_field_int(exp_irq_req,               UVM_ALL_ON)
    `uvm_field_int(exp_ack_id,                UVM_ALL_ON)
    `uvm_field_int(exp_highest_lvl_pr,        UVM_ALL_ON)

  `uvm_object_utils_end


  function new(string name = "int_seq_item");
    super.new(name);
  endfunction

endclass
