class int_seq_item extends uvm_sequence_item;

  // ============================================================
  // DUT OUTPUTS
  // ============================================================

  logic [7:0]  soc_mmr_read_data_o;
  logic        soc_read_rsp_o;

  logic        interrupt_request_o;
  logic [7:0]  highest_pending_lvl_pr_o;

  logic [7:0]  current_int_id_o;

  logic [31:0] trace_data_int_o;
  logic [7:0]  trace_event_int_o;


  // ============================================================
  // DUT INPUTS
  // ============================================================

  rand logic soc_rst;

  rand logic        soc_mmr_write_en_i;
  rand logic [15:0] soc_mmr_write_addr_i;
  rand logic [7:0]  soc_mmr_write_data_i;

  rand logic        soc_mmr_read_en_i;
  rand logic [15:0] soc_mmr_read_addr_i;

  rand logic       soc_eoi_valid_i;
  rand logic [7:0] soc_eoi_id_i;

  rand logic [7:0] active_lvl_pr_i;

  rand logic [15:0] global_int_enable_bit_i;
  rand logic        global_int_enable_valid_i;


  // ============================================================
  // EXTERNAL INTERRUPTS
  // ============================================================

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

  logic [15:0] ext_int;


  // ============================================================
  // DEBUG
  // ============================================================

  rand logic debug_mode_valid_i;


  // ============================================================
  // EXPECTED VALUES
  // ============================================================

  logic        exp_valid;
  logic        exp_irq_req;
  logic [7:0]  exp_highest_lvl_pr;
  logic [7:0]  exp_ack_id;

  logic        exp_read_rsp;
  logic [7:0]  exp_mmr_read_data;
  bit          exp_mmr_read_valid;


  // ============================================================
  // GLOBAL ENABLE MODEL
  // ============================================================

  logic [15:0] global_enable_actual;
  logic [15:0] exp_global_enable;

  bit exp_global_enable_valid;


  longint unsigned mon_cycle;


  // ============================================================
  // PACK EXTERNAL INTERRUPTS
  // ============================================================

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

  endfunction


  // ============================================================
  // UVM FACTORY
  // ============================================================

  `uvm_object_utils_begin(int_seq_item)

    `uvm_field_int(soc_mmr_read_data_o,      UVM_ALL_ON)
    `uvm_field_int(soc_read_rsp_o,            UVM_ALL_ON)
    `uvm_field_int(interrupt_request_o,       UVM_ALL_ON)
    `uvm_field_int(highest_pending_lvl_pr_o,  UVM_ALL_ON)

    `uvm_field_int(current_int_id_o,          UVM_ALL_ON)
    `uvm_field_int(trace_data_int_o,           UVM_ALL_ON)
    `uvm_field_int(trace_event_int_o,          UVM_ALL_ON)

    `uvm_field_int(soc_rst,                   UVM_ALL_ON)

    `uvm_field_int(soc_mmr_write_en_i,        UVM_ALL_ON)
    `uvm_field_int(soc_mmr_write_addr_i,      UVM_ALL_ON)
    `uvm_field_int(soc_mmr_write_data_i,      UVM_ALL_ON)

    `uvm_field_int(soc_mmr_read_en_i,         UVM_ALL_ON)
    `uvm_field_int(soc_mmr_read_addr_i,       UVM_ALL_ON)

    `uvm_field_int(soc_eoi_valid_i,           UVM_ALL_ON)
    `uvm_field_int(soc_eoi_id_i,              UVM_ALL_ON)

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

    `uvm_field_int(ext_int,                   UVM_ALL_ON)

    `uvm_field_int(debug_mode_valid_i,        UVM_ALL_ON)

    `uvm_field_int(exp_valid,                 UVM_ALL_ON)
    `uvm_field_int(exp_irq_req,               UVM_ALL_ON)
    `uvm_field_int(exp_highest_lvl_pr,        UVM_ALL_ON)
    `uvm_field_int(exp_ack_id,                UVM_ALL_ON)

    `uvm_field_int(exp_read_rsp,              UVM_ALL_ON)
    `uvm_field_int(exp_mmr_read_data,         UVM_ALL_ON)
    `uvm_field_int(exp_mmr_read_valid,        UVM_ALL_ON)

    `uvm_field_int(mon_cycle,                 UVM_ALL_ON)

    `uvm_field_int(global_enable_actual,      UVM_ALL_ON)
    `uvm_field_int(exp_global_enable,         UVM_ALL_ON)
    `uvm_field_int(exp_global_enable_valid,   UVM_ALL_ON)

  `uvm_object_utils_end


  function new(string name = "int_seq_item");
    super.new(name);
  endfunction

endclass
