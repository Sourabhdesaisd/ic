`timescale 1ns/1ps

interface intf(input logic soc_clk);

  // ============================================================
  // Reset
  // ============================================================
  logic soc_rst;

  
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
  
endinterface

