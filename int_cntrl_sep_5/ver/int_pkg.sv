`timescale 1ns/1ps



package int_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "int_seq_item.sv"

//  `include "int_seq1.sv"
  `include "tests/tc001_mmr_single_rw_seq.sv"
  `include "tests/tc002_mmr_multiple_rw_seq.sv"
  `include "tests/tc003_mmr_random_rw_seq.sv"
  `include "tests/tc004_mmr_random_stress_rw_seq.sv"
  `include "tests/tc005_global_enable_single_seq.sv"
  `include "tests/tc006_global_enable_multiple_seq.sv"
  `include "tests/tc007_global_enable_all_bits_seq.sv"
  `include "tests/tc008_global_enable_random_seq.sv"
  `include "tests/tc009_global_enable_random_stress_seq.sv"
  `include "tests/tc010_single_interrupt_seq.sv"
  `include "tests/tc011_multiple_interrupt_seq.sv"
  `include "tests/tc012_priority_arbitration_seq.sv"
  `include "tests/tc013_same_priority_tie_break_seq.sv"
  `include "tests/tc014_global_enable_masking_seq.sv"
  `include "tests/tc015_ack_verification_seq.sv"
  `include "tests/tc016_multiple_ack_seq.sv"
  `include "tests/tc017_ack_priority_seq.sv"
  `include "tests/tc010_interrupt_ack_latency_seq.sv"
  `include "tests/tc018_back_to_back_ack_seq.sv"
  `include "tests/tc019_same_priority_tie_break_seq.sv"
  `include "tests/tc020_random_interrupt_seq.sv"
  `include "tests/tc021_random_interrupt_stress_seq.sv"
  `include "tests/tc022_basic_full_system_seq.sv"
  `include "tests/tc010_debug_single_interrupt_seq.sv"
  `include "tests/tc023_invalid_eoi_seq.sv"
  `include "tests/tc024_retrigger_after_eoi_seq.sv"
  `include "tests/tc025_global_enable_toggle_pending_seq.sv"
  `include "tests/tc026_higher_priority_preempt_seq.sv"
  //`include "tests/tc029_random_mixed_seq.sv"
  
  
  

    

  
  
  
  
  
  `include "int_sequencer.sv"

  `include "int_driver.sv"
  `include "int_monitor.sv"

  // Subscribers
  `include "int_scoreboard.sv"
  `include "int_coverage.sv"

  // Higher-level TB
  `include "int_agent.sv"
  `include "int_env.sv"

  // Tests
  `include "int_test.sv"

endpackage
