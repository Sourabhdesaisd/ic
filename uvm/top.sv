`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ic_if.sv"


`include "transaction.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "virtual_sequencer.sv"
`include "env.sv"
`include "test.sv"


module top;

  //=========================================
  // Clock & Reset
  //=========================================
  logic ic_clk;
  logic ic_rst;

  //=========================================
  // DUT Inputs (vector form for interface)
  //=========================================
  logic [47:0] ext_int;
  logic [7:0]  threshold;

  //=========================================
  // MMR signals (tie-off)
  //=========================================
  logic        zic_mmr_write_en_i;
  logic [15:0] zic_mmr_write_addr_i;
  logic [31:0] zic_mmr_write_data_i;

  logic        zic_mmr_read_en_i;
  logic [15:0] zic_mmr_read_addr_i;

  logic        zic_ack_read_valid_en;
  logic        zic_eoi_valid_i;
  logic [7:0]  zic_eoi_id_i;

  logic [47:0] global_int_enable_bit_i;
  logic        global_int_enable_valid_i;

  //=========================================
  // DUT Outputs
  //=========================================
  logic irq_request;
  logic [7:0] interrupt_out;
  logic [31:0] zic_mmr_read_data_o;
  logic [7:0] zic_ack_int_id_o;

  //=========================================
  // Interface Instance
  //=========================================
  ic_if vif();

  //=========================================
  // Connect interface to TB signals
  //=========================================
  assign vif.ic_clk    = ic_clk;
  assign vif.ic_rst    = ic_rst;
  assign vif.ext_int   = ext_int;
  assign vif.threshold = threshold;

  assign vif.irq_request   = irq_request;
  assign vif.interrupt_out = interrupt_out;

  //=========================================
  // Clock Generation
  //=========================================
  initial begin
    ic_clk = 0;
    forever #5 ic_clk = ~ic_clk;
  end

  //=========================================
  // Reset Generation
  //=========================================
  initial begin
    ic_rst = 1;
    #20;
    ic_rst = 0;
  end

  //=========================================
  // Default Stimulus (safe values)
  //=========================================
  initial begin
    ext_int = 0;
    threshold = 8'd10;

    zic_mmr_write_en_i = 0;
    zic_mmr_write_addr_i = 0;
    zic_mmr_write_data_i = 0;

    zic_mmr_read_en_i = 0;
    zic_mmr_read_addr_i = 0;

    zic_ack_read_valid_en = 0;
    zic_eoi_valid_i = 0;
    zic_eoi_id_i = 0;

    global_int_enable_bit_i = 0;
    global_int_enable_valid_i = 0;
  end

  //=========================================
  // DUT INST (IMPORTANT FIX: VECTOR ? SCALAR)
  //=========================================
  int_top dut (

    .ic_clk(ic_clk),
    .ic_rst(ic_rst),
    .ic_rst_ack(1'b0),

    // 48 interrupt mapping
    .ext_int0(ext_int[0]),
    .ext_int1(ext_int[1]),
    .ext_int2(ext_int[2]),
    .ext_int3(ext_int[3]),
    .ext_int4(ext_int[4]),
    .ext_int5(ext_int[5]),
    .ext_int6(ext_int[6]),
    .ext_int7(ext_int[7]),
    .ext_int8(ext_int[8]),
    .ext_int9(ext_int[9]),
    .ext_int10(ext_int[10]),
    .ext_int11(ext_int[11]),
    .ext_int12(ext_int[12]),
    .ext_int13(ext_int[13]),
    .ext_int14(ext_int[14]),
    .ext_int15(ext_int[15]),
    .ext_int16(ext_int[16]),
    .ext_int17(ext_int[17]),
    .ext_int18(ext_int[18]),
    .ext_int19(ext_int[19]),
    .ext_int20(ext_int[20]),
    .ext_int21(ext_int[21]),
    .ext_int22(ext_int[22]),
    .ext_int23(ext_int[23]),
    .ext_int24(ext_int[24]),
    .ext_int25(ext_int[25]),
    .ext_int26(ext_int[26]),
    .ext_int27(ext_int[27]),
    .ext_int28(ext_int[28]),
    .ext_int29(ext_int[29]),
    .ext_int30(ext_int[30]),
    .ext_int31(ext_int[31]),
    .ext_int32(ext_int[32]),
    .ext_int33(ext_int[33]),
    .ext_int34(ext_int[34]),
    .ext_int35(ext_int[35]),
    .ext_int36(ext_int[36]),
    .ext_int37(ext_int[37]),
    .ext_int38(ext_int[38]),
    .ext_int39(ext_int[39]),
    .ext_int40(ext_int[40]),
    .ext_int41(ext_int[41]),
    .ext_int42(ext_int[42]),
    .ext_int43(ext_int[43]),
    .ext_int44(ext_int[44]),
    .ext_int45(ext_int[45]),
    .ext_int46(ext_int[46]),
    .ext_int47(ext_int[47]),

    .threshold(threshold),

    .irq_request(irq_request),
    .interrupt_out(interrupt_out),

    .zic_mmr_write_en_i(zic_mmr_write_en_i),
    .zic_mmr_write_addr_i(zic_mmr_write_addr_i),
    .zic_mmr_write_data_i(zic_mmr_write_data_i),

    .zic_mmr_read_en_i(zic_mmr_read_en_i),
    .zic_mmr_read_addr_i(zic_mmr_read_addr_i),
    .zic_mmr_read_data_o(zic_mmr_read_data_o),

    .zic_ack_read_valid_en(zic_ack_read_valid_en),
    .zic_ack_int_id_o(zic_ack_int_id_o),

    .zic_eoi_valid_i(zic_eoi_valid_i),
    .zic_eoi_id_i(zic_eoi_id_i),

    .global_int_enable_bit_i(global_int_enable_bit_i),
    .global_int_enable_valid_i(global_int_enable_valid_i)
  );

  //=========================================
  // UVM START
  //=========================================
  initial begin
    uvm_config_db#(virtual ic_if)::set(null, "*", "vif", vif);
    run_test("ic_test");
  end

endmodule
