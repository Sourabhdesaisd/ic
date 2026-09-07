`timescale 1ns/1ps

interface intf(input logic soc_clk);

  // ============================================================
  // RESET
  // ============================================================
  logic soc_rst;

  // ============================================================
  // MMR WRITE
  // ============================================================
  logic        soc_mmr_write_en_i;
  logic [15:0] soc_mmr_write_addr_i;
  logic [7:0]  soc_mmr_write_data_i;

  // ============================================================
  // MMR READ
  // ============================================================
  logic        soc_mmr_read_en_i;
  logic [15:0] soc_mmr_read_addr_i;

  logic [7:0]  soc_mmr_read_data_o;

  // New read response signal
  logic        soc_read_rsp_o;

  // ============================================================
  // EOI
  // ============================================================
  logic       soc_eoi_valid_i;
  logic [7:0] soc_eoi_id_i;

  // ============================================================
  // INTERRUPT PRIORITY
  // ============================================================
  logic [7:0] active_lvl_pr_i;

  logic       interrupt_request_o;

  logic [7:0] highest_pending_lvl_pr_o;

  // ============================================================
  // GLOBAL INTERRUPT ENABLE
  // ============================================================
  logic [15:0] global_int_enable_bit_i;
  logic        global_int_enable_valid_i;

  // ============================================================
  // EXTERNAL INTERRUPTS
  // ============================================================
  logic [15:0] ext_int;

  // ============================================================
  // DEBUG
  // ============================================================
  logic debug_mode_valid_i;


  // ============================================================
  // ASSERTIONS
  // ============================================================

  // ------------------------------------------------------------
  // Reset outputs
  // ------------------------------------------------------------
  property p_reset_outputs_zero;

    @(posedge soc_clk)

    !soc_rst

    |->

    (
      interrupt_request_o      == 1'b0 &&
      highest_pending_lvl_pr_o == 8'h00 &&
      soc_mmr_read_data_o      == 8'h00
    );

  endproperty

  a_reset_outputs_zero:
    assert property(p_reset_outputs_zero)
    else
      $error("[ASSERT_FAIL] Reset outputs are not zero");


  // ------------------------------------------------------------
  // No X on outputs after reset
  // ------------------------------------------------------------
  property p_no_x_on_outputs;

    @(posedge soc_clk)

    disable iff (!soc_rst)

    !$isunknown({
      interrupt_request_o,
      highest_pending_lvl_pr_o,
      soc_mmr_read_data_o,
      soc_read_rsp_o
    });

  endproperty

  a_no_x_on_outputs:
    assert property(p_no_x_on_outputs)
    else
      $error("[ASSERT_FAIL] X/Z detected on DUT outputs");


  // ------------------------------------------------------------
  // All interrupts disabled => no IRQ
  // ------------------------------------------------------------
  property p_no_irq_when_all_disabled;

    @(posedge soc_clk)

    disable iff (!soc_rst)

    (global_int_enable_bit_i == 16'h0000)

    |->

    !interrupt_request_o;

  endproperty

  a_no_irq_when_all_disabled:
    assert property(p_no_irq_when_all_disabled)
    else
      $error("[ASSERT_FAIL] IRQ asserted when all interrupts disabled");


  // ------------------------------------------------------------
  // MMR write address legal
  // ------------------------------------------------------------
  property p_mmr_write_ctl_addr_legal;

    @(posedge soc_clk)

    disable iff (!soc_rst)

    soc_mmr_write_en_i

    |->

    (
      (soc_mmr_write_addr_i >= 16'h1003) &&
      (soc_mmr_write_addr_i <= 16'h103F) &&
      (((soc_mmr_write_addr_i - 16'h1003) % 4) == 0)
    );

  endproperty

  a_mmr_write_ctl_addr_legal:
    assert property(p_mmr_write_ctl_addr_legal)
    else
      $error(
        "[ASSERT_FAIL] Illegal MMR write address: 0x%04h",
        soc_mmr_write_addr_i
      );


  // ------------------------------------------------------------
  // MMR read address legal
  // ------------------------------------------------------------
  property p_mmr_read_ctl_addr_legal;

    @(posedge soc_clk)

    disable iff (!soc_rst)

    soc_mmr_read_en_i

    |->

    (
      (soc_mmr_read_addr_i >= 16'h1003) &&
      (soc_mmr_read_addr_i <= 16'h103F) &&
      (((soc_mmr_read_addr_i - 16'h1003) % 4) == 0)
    );

  endproperty

  a_mmr_read_ctl_addr_legal:
    assert property(p_mmr_read_ctl_addr_legal)
    else
      $error(
        "[ASSERT_FAIL] Illegal MMR read address: 0x%04h",
        soc_mmr_read_addr_i
      );


  // ------------------------------------------------------------
  // Read response must not be X
  // ------------------------------------------------------------
  property p_read_response_not_x;

    @(posedge soc_clk)

    disable iff (!soc_rst)

    soc_read_rsp_o

    |->

    !$isunknown(soc_mmr_read_data_o);

  endproperty

  a_read_response_not_x:
    assert property(p_read_response_not_x)
    else
      $error("[ASSERT_FAIL] MMR read response data is X/Z");


  // ------------------------------------------------------------
  // Read response should not occur without read request
  //
  // This assertion assumes one outstanding read at a time.
  // If RTL has pipelined/multiple outstanding reads, modify this.
  // ------------------------------------------------------------
  property p_read_response_requires_read;

    @(posedge soc_clk)

    disable iff (!soc_rst)

    soc_read_rsp_o

    |->

    $past(soc_mmr_read_en_i, 1);

  endproperty

  a_read_response_requires_read:
    assert property(p_read_response_requires_read)
    else
      $error("[ASSERT_FAIL] Read response without previous read request");


  // ------------------------------------------------------------
  // EOI is one-cycle pulse
  // ------------------------------------------------------------
  property p_eoi_one_cycle;

    @(posedge soc_clk)

    disable iff (!soc_rst)

    soc_eoi_valid_i

    |->

    ##1 !soc_eoi_valid_i;

  endproperty

  a_eoi_one_cycle:
    assert property(p_eoi_one_cycle)
    else
      $error("[ASSERT_FAIL] EOI is not one-cycle pulse");


  // ============================================================
  // ASSERTION COVER
  // ============================================================

  c_reset_outputs_zero:
    cover property(p_reset_outputs_zero);

  c_no_x_on_outputs:
    cover property(p_no_x_on_outputs);

  c_no_irq_when_all_disabled:
    cover property(p_no_irq_when_all_disabled);

  c_mmr_write_ctl_addr_legal:
    cover property(p_mmr_write_ctl_addr_legal);

  c_mmr_read_ctl_addr_legal:
    cover property(p_mmr_read_ctl_addr_legal);

  c_read_response_not_x:
    cover property(p_read_response_not_x);

  c_read_response_requires_read:
    cover property(p_read_response_requires_read);

  c_eoi_one_cycle:
    cover property(p_eoi_one_cycle);

endinterface
