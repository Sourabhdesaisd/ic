class int_coverage extends uvm_subscriber #(int_seq_item);

  `uvm_component_utils(int_coverage)

  int_seq_item tr;

  // Sample variables
  bit        cov_reset;
  bit        cov_irq_req;
  bit        cov_ack_valid;
  bit        cov_eoi_valid;
  bit [7:0]  cov_ack_id;
  bit [7:0]  cov_exp_ack_id;
  bit [47:0] cov_ext_int;
  bit [47:0] cov_int_en;
  bit [7:0]  cov_highest_lvl_pr;
  int        cov_active_irq_count;

  // ------------------------------------------------------------
  // Covergroup
  // ------------------------------------------------------------
  covergroup zic_cg;

    option.per_instance = 1;

    // -------------------------
    // Reset coverage
    // -------------------------
    cp_reset : coverpoint cov_reset {
      bins reset_asserted   = {1};
      bins reset_deasserted = {0};
    }

    // -------------------------
    // IRQ request coverage
    // -------------------------
    cp_irq_req : coverpoint cov_irq_req {
      bins irq_low  = {0};
      bins irq_high = {1};
    }

    // -------------------------
    // ACK valid coverage
    // -------------------------
    cp_ack_valid : coverpoint cov_ack_valid {
      bins no_ack  = {0};
      bins ack_seen = {1};
    }

    // -------------------------
    // ACK ID coverage
    // -------------------------
    cp_ack_id : coverpoint cov_ack_id iff (cov_ack_valid) {
      bins irq_0_7    = {[0:7]};
      bins irq_8_15   = {[8:15]};
      bins irq_16_23  = {[16:23]};
      bins irq_24_31  = {[24:31]};
      bins irq_32_39  = {[32:39]};
      bins irq_40_47  = {[40:47]};
    }

    // -------------------------
    // Expected ACK ID coverage
    // -------------------------
    cp_exp_ack_id : coverpoint cov_exp_ack_id iff (cov_ack_valid) {
      bins exp_irq_0_7    = {[0:7]};
      bins exp_irq_8_15   = {[8:15]};
      bins exp_irq_16_23  = {[16:23]};
      bins exp_irq_24_31  = {[24:31]};
      bins exp_irq_32_39  = {[32:39]};
      bins exp_irq_40_47  = {[40:47]};
    }

    // -------------------------
    // Active interrupt count coverage
    // -------------------------
    cp_active_irq_count : coverpoint cov_active_irq_count {
      bins no_irq        = {0};
      bins single_irq    = {1};
      bins two_irq       = {2};
      bins few_irq       = {[3:5]};
      bins many_irq      = {[6:15]};
      bins stress_irq    = {[16:48]};
    }

    // -------------------------
    // Highest pending level/priority output coverage
    // -------------------------
    cp_highest_lvl_pr : coverpoint cov_highest_lvl_pr {
      bins low_range  = {[0:63]};
      bins mid_range  = {[64:127]};
      bins high_range = {[128:255]};
    }

    // -------------------------
    // EOI coverage
    // -------------------------
    cp_eoi_valid : coverpoint cov_eoi_valid {
      bins no_eoi  = {0};
      bins eoi_seen = {1};
    }

    // -------------------------
    // Important crosses
    // -------------------------

    // IRQ request should happen for active interrupts
    cross_irq_count_req : cross cp_active_irq_count, cp_irq_req;

    // ACK should happen when IRQ request is active
    cross_irq_ack : cross cp_irq_req, cp_ack_valid;

    // ACK ID range with highest level/priority
    cross_ack_pr : cross cp_ack_id, cp_highest_lvl_pr;

    // EOI after ACK scenario
    cross_ack_eoi : cross cp_ack_valid, cp_eoi_valid;

  endgroup

  // ------------------------------------------------------------
  // Constructor
  // ------------------------------------------------------------
  function new(string name = "int_coverage", uvm_component parent = null);
    super.new(name, parent);
    zic_cg = new();
  endfunction

  // ------------------------------------------------------------
  // Write method receives transaction from monitor
  // ------------------------------------------------------------

function void write(int_seq_item t);

  tr = t;

  cov_reset          = tr.zic_rst;
  cov_irq_req        = tr.interrupt_request_o;
  cov_ack_valid      = tr.exp_valid;
  cov_ack_id         = tr.zic_ack_int_id_o;
  cov_exp_ack_id     = tr.exp_ack_id;
  cov_ext_int        = tr.ext_int;
  cov_int_en         = tr.global_int_enable_bit_i;
  cov_highest_lvl_pr = tr.highest_pending_lvl_pr_o;
  cov_eoi_valid      = tr.zic_eoi_valid_i;

  cov_active_irq_count = count_active_interrupts(cov_ext_int, cov_int_en);

  zic_cg.sample();



  endfunction

  // ------------------------------------------------------------
  // Count enabled + active interrupts
  // ------------------------------------------------------------
  function int count_active_interrupts(bit [47:0] ext_int, bit [47:0] int_en);
    int count;
    count = 0;

    for (int i = 0; i < 48; i++) begin
      if (ext_int[i] && int_en[i])
        count++;
    end

    return count;
  endfunction

endclass
