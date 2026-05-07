package zic_mem_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "../UVME/ZIC_MEM_SEQUENCES/zic_mem_seq_item.sv"
  `include "../UVME/ZIC_MEM_SEQUENCES/zic_mem_sequence.sv"
  `include "../UVME/ZIC_MEM_SEQUENCES/zic_memseq.sv"
  `include "../UVME/ZIC_MEM_SEQUENCES/zic_mem_rand_seq.sv"
  `include "../UVME/ZIC_MEM_SEQUENCES/zic_mem_ack_block223_seq.sv"
  `include "../UVME/ZIC_MEM_SEQUENCES/zic_mem_block214_seq.sv"
  `include "../UVME/ZIC_MEM_SEQUENCES/zic_mem_uncovered_seq.sv"
  `include "../UVME/ZIC_MEM_SEQUENCES/zic_mem_sequencer.sv"
  `include "../UVME/ZIC_MEM_AGENTS/zic_mem_driver.sv"
  `include "../UVME/ZIC_MEM_AGENTS/zic_mem_monitor.sv"
  `include "../UVME/ZIC_MEM_AGENTS/zic_mem_agent.sv"
  `include "../UVME/ZIC_MEM_ENVIRONMENT/zic_mem_scb.sv"
  `include "../UVME/ZIC_MEM_ENVIRONMENT/zic_mem_env.sv"
  `include "../UVME/ZIC_MEM_TESTS/zic_mem_test.sv"
  `include "../UVME/ZIC_MEM_TESTS/zic_memtest.sv"
  `include "../UVME/ZIC_MEM_TESTS/zic_mem_rand_test.sv"
  `include "../UVME/ZIC_MEM_TESTS/zic_mem_ack_block223_test.sv"
  `include "../UVME/ZIC_MEM_TESTS/zic_mem_block214_test.sv"
  `include "../UVME/ZIC_MEM_TESTS/zic_mem_uncovered_test.sv"

endpackage
