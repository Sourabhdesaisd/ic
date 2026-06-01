`timescale 1ns/1ps

interface intf(input logic soc_clk);

  // ============================================================
  // Reset
  // ============================================================
  logic soc_rst;

  // ============================================================
  // MMR write interface from core
  // ============================================================
  logic        soc_mmr_write_en_i;
  logic [15:0] soc_mmr_write_addr_i;
  logic [31:0] soc_mmr_write_data_i;

  // ============================================================
  // MMR read interface from core
  // ============================================================
  logic        soc_mmr_read_en_i;
  logic [15:0] soc_mmr_read_addr_i;
  logic [31:0] soc_mmr_read_data_o;

  // ============================================================
  // ACK interface
  // ============================================================
  logic       soc_ack_read_valid_en;
  logic [7:0] soc_ack_int_id_o;

  // ============================================================
  // EOI interface
  // ============================================================
  logic       soc_eoi_valid_i;
  logic [7:0] soc_eoi_id_i;

  // ============================================================
  // Interrupt priority/status interface
  // ============================================================
  logic [7:0] active_lvl_pr_i;
  logic       interrupt_request_o;
  logic [7:0] highest_pending_lvl_pr_o;

  // ============================================================
  // Global interrupt enable
  // 16 interrupts only
  // ============================================================
  logic [15:0] global_int_enable_bit_i;
  logic        global_int_enable_valid_i;

  // ============================================================
  // External interrupt inputs
  // 16 interrupts only
  // ext_int[0]  -> ext_int0_i
  // ext_int[15] -> ext_int15_i
  // ============================================================
  logic [15:0] ext_int;

  // ============================================================
  // Debug / reset related signals
  // ============================================================
  logic debug_mode_valid_i;
  logic debug_mode_reset_i;
  logic debug_ndm_reset_i;
  logic wdt_reset_o;

endinterface
