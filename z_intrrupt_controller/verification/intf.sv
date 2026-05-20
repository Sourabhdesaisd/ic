`timescale 1ns/1ps



interface intf(input logic zic_clk);

  logic zic_rst;
//logic [7:0] zic_ack_int_id_w;
  logic zic_mmr_write_en_i;
  logic [15:0] zic_mmr_write_addr_i;
  logic [31:0] zic_mmr_write_data_i;

  logic zic_mmr_read_en_i;
  logic [15:0] zic_mmr_read_addr_i;
  logic [31:0] zic_mmr_read_data_o;

  logic zic_ack_read_valid_en;
  logic [7:0] zic_ack_int_id_o;

  logic zic_eoi_valid_i;
  logic [7:0] zic_eoi_id_i;

  logic [7:0] active_lvl_pr_i;
  logic interrupt_request_o;

  logic [47:0] global_int_enable_bit_i;
  logic global_int_enable_valid_i;

  logic [7:0] highest_pending_lvl_pr_o;
    
      // Internal DUT observation signals for monitor/checker
  logic [47:0] zic_int_en_w;
  logic        zic_ack_w;
  logic [7:0]  zic_ack_int_id_i;
  
  logic [46:0] ext_int;

  logic debug_mode_valid_i;
  logic debug_mode_reset_i;
  logic debug_ndm_reset_i;
  logic wdt_reset_o;

endinterface
