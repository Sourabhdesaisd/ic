class int_coverage extends uvm_subscriber #(int_seq_item);

  `uvm_component_utils(int_coverage)

  int_seq_item tr;

  bit        cov_reset;
  bit        cov_irq_req;
  bit        cov_ack_valid;
  bit        cov_ack_output_valid;
  bit        cov_eoi_valid;

  bit [7:0]  cov_ack_id;
  bit [7:0]  cov_exp_ack_id;
  bit [47:0] cov_ext_int;
  bit [47:0] cov_int_en;
  bit [7:0]  cov_highest_lvl_pr;
  bit [7:0]  cov_active_lvl_pr;

  int        cov_active_irq_count;
  int        cov_ack_irq_num;
  int        cov_exp_ack_irq_num;

  bit        cov_wr_en;
  bit        cov_rd_en;
  bit [15:0] cov_wr_addr;
  bit [15:0] cov_rd_addr;
  bit [31:0] cov_wr_data;
  bit [7:0]  cov_eoi_id;
  bit        cov_global_en_valid;

  covergroup zic_cg;

    option.per_instance = 1;

    // Active-low reset:
    // 0 = reset active
    // 1 = reset inactive / normal operation
    cp_reset : coverpoint cov_reset {
      bins reset_active   = {0};
      bins reset_inactive = {1};
    }

    cp_irq_req : coverpoint cov_irq_req {
      bins irq_low  = {0};
      bins irq_high = {1};
    }

    cp_ack_valid : coverpoint cov_ack_valid {
      bins no_ack_compare = {0};
      bins ack_compare    = {1};
    }

    cp_ack_output_valid : coverpoint cov_ack_output_valid {
      bins ack_output_zero    = {0};
      bins ack_output_nonzero = {1};
    }

    cp_ack_irq_num : coverpoint cov_ack_irq_num iff (cov_ack_output_valid) {
      bins irq_0_7    = {[0:7]};
      bins irq_8_15   = {[8:15]};
      bins irq_16_23  = {[16:23]};
      bins irq_24_31  = {[24:31]};
      bins irq_32_39  = {[32:39]};
      bins irq_40_47  = {[40:47]};
    }

    cp_exp_ack_irq_num : coverpoint cov_exp_ack_irq_num iff (cov_ack_valid) {
      bins exp_irq_0_7    = {[0:7]};
      bins exp_irq_8_15   = {[8:15]};
      bins exp_irq_16_23  = {[16:23]};
      bins exp_irq_24_31  = {[24:31]};
      bins exp_irq_32_39  = {[32:39]};
      bins exp_irq_40_47  = {[40:47]};
    }

    cp_ack_id_raw : coverpoint cov_ack_id iff (cov_ack_output_valid) {
      bins ack_10_17 = {[8'h10:8'h17]};
      bins ack_18_1f = {[8'h18:8'h1F]};
      bins ack_20_27 = {[8'h20:8'h27]};
      bins ack_28_2f = {[8'h28:8'h2F]};
      bins ack_30_37 = {[8'h30:8'h37]};
      bins ack_38_3f = {[8'h38:8'h3F]};
    }

    cp_exp_ack_id_raw : coverpoint cov_exp_ack_id iff (cov_ack_valid) {
      bins exp_ack_10_17 = {[8'h10:8'h17]};
      bins exp_ack_18_1f = {[8'h18:8'h1F]};
      bins exp_ack_20_27 = {[8'h20:8'h27]};
      bins exp_ack_28_2f = {[8'h28:8'h2F]};
      bins exp_ack_30_37 = {[8'h30:8'h37]};
      bins exp_ack_38_3f = {[8'h38:8'h3F]};
    }

    cp_active_irq_count : coverpoint cov_active_irq_count {
      bins no_irq     = {0};
      bins single_irq = {1};
      bins two_irq    = {2};
      bins few_irq    = {[3:5]};
      bins many_irq   = {[6:15]};
      bins stress_irq = {[16:48]};
    }

    cp_highest_lvl_pr : coverpoint cov_highest_lvl_pr {
      bins zero_range = {8'h00};
      bins low_range  = {[8'h01:8'h3F]};
      bins mid_range  = {[8'h40:8'h9F]};
      bins high_range = {[8'hA0:8'hFF]};
    }

    cp_active_lvl_pr : coverpoint cov_active_lvl_pr {
      bins zero_level = {8'h00};
      bins low_level  = {[8'h01:8'h3F]};
      bins mid_level  = {[8'h40:8'h9F]};
      bins high_level = {[8'hA0:8'hFF]};
    }

    cp_eoi_valid : coverpoint cov_eoi_valid {
      bins no_eoi   = {0};
      bins eoi_seen = {1};
    }

    cp_wr_en : coverpoint cov_wr_en {
      bins wr_low  = {0};
      bins wr_high = {1};
    }

    cp_rd_en : coverpoint cov_rd_en {
      bins rd_low  = {0};
      bins rd_high = {1};
    }

    cp_wr_addr : coverpoint cov_wr_addr iff (cov_wr_en) {
      bins cfg_ctl_low  = {[16'h1003:16'h103F]};
      bins cfg_ctl_mid  = {[16'h1043:16'h107F]};
      bins cfg_ctl_high = {[16'h1083:16'h10BF]};
    }

    cp_rd_addr : coverpoint cov_rd_addr iff (cov_rd_en) {
      bins rd_ctl_low  = {[16'h1003:16'h103F]};
      bins rd_ctl_mid  = {[16'h1043:16'h107F]};
      bins rd_ctl_high = {[16'h1083:16'h10BF]};
    }

    cp_wr_data : coverpoint cov_wr_data[7:0] iff (cov_wr_en) {
      bins zero_val = {8'h00};
      bins low_val  = {[8'h01:8'h3F]};
      bins mid_val  = {[8'h40:8'h9F]};
      bins high_val = {[8'hA0:8'hFF]};
    }

    cp_ext_int_present : coverpoint (cov_ext_int != 48'h0) {
      bins no_ext_int = {0};
      bins ext_int_on = {1};
    }

    cp_global_enable_present : coverpoint (cov_int_en != 48'h0) {
      bins no_global_enable = {0};
      bins global_enable_on = {1};
    }

    cp_global_en_valid : coverpoint cov_global_en_valid {
      bins invalid = {0};
      bins valid   = {1};
    }

    cp_eoi_id : coverpoint cov_eoi_id iff (cov_eoi_valid) {
      bins eoi_10_17 = {[8'h10:8'h17]};
      bins eoi_18_1f = {[8'h18:8'h1F]};
      bins eoi_20_27 = {[8'h20:8'h27]};
      bins eoi_28_2f = {[8'h28:8'h2F]};
      bins eoi_30_37 = {[8'h30:8'h37]};
      bins eoi_38_3f = {[8'h38:8'h3F]};
    }

    cross_wr_addr_data  : cross cp_wr_addr, cp_wr_data;
    cross_ext_enable    : cross cp_ext_int_present, cp_global_enable_present;
    cross_irq_count_req : cross cp_active_irq_count, cp_irq_req;
    cross_irq_ack       : cross cp_irq_req, cp_ack_valid;
    cross_ack_pr        : cross cp_exp_ack_irq_num, cp_highest_lvl_pr;
    cross_ack_eoi       : cross cp_ack_valid, cp_eoi_valid;
    cross_threshold_irq : cross cp_active_lvl_pr, cp_irq_req;

  endgroup

  function new(string name = "int_coverage", uvm_component parent = null);
    super.new(name, parent);
    zic_cg = new();
  endfunction

  function void write(int_seq_item t);

    tr = t;

    cov_reset             = tr.zic_rst;
    cov_irq_req           = tr.interrupt_request_o;
    cov_ack_valid         = tr.exp_valid;
    cov_ack_output_valid  = (tr.zic_ack_int_id_o != 8'h00);

    cov_ack_id            = tr.zic_ack_int_id_o;
    cov_exp_ack_id        = tr.exp_ack_id;

    cov_ext_int           = tr.ext_int;
    cov_int_en            = tr.global_int_enable_bit_i;

    cov_highest_lvl_pr    = tr.highest_pending_lvl_pr_o;
    cov_active_lvl_pr     = tr.active_lvl_pr_i;

    cov_eoi_valid         = tr.zic_eoi_valid_i;

    cov_active_irq_count  = count_active_interrupts(cov_ext_int, cov_int_en);
    cov_ack_irq_num       = ack_to_irq_num(cov_ack_id);
    cov_exp_ack_irq_num   = ack_to_irq_num(cov_exp_ack_id);

    cov_wr_en             = tr.zic_mmr_write_en_i;
    cov_rd_en             = tr.zic_mmr_read_en_i;
    cov_wr_addr           = tr.zic_mmr_write_addr_i;
    cov_rd_addr           = tr.zic_mmr_read_addr_i;
    cov_wr_data           = tr.zic_mmr_write_data_i;
    cov_eoi_id            = tr.zic_eoi_id_i;
    cov_global_en_valid   = tr.global_int_enable_valid_i;

    `uvm_info("COV_SAMPLE",
      $sformatf("rst=%0b irq_req=%0b ack_valid=%0b ack_o=%0h exp_ack=%0h wr_en=%0b rd_en=%0b",
      cov_reset,
      cov_irq_req,
      cov_ack_valid,
      cov_ack_id,
      cov_exp_ack_id,
      cov_wr_en,
      cov_rd_en),
      UVM_LOW)

    zic_cg.sample();

  endfunction

  function int count_active_interrupts(bit [47:0] ext_int,
                                       bit [47:0] int_en);
    int count;

    count = 0;

    for (int i = 0; i < 48; i++) begin
      if (ext_int[i] && int_en[i]) begin
        count++;
      end
    end

    return count;
  endfunction

  function int ack_to_irq_num(bit [7:0] ack_id);

    if ((ack_id >= 8'h10) && (ack_id <= 8'h3F)) begin
      return int'(ack_id - 8'h10);
    end
    else begin
      return -1;
    end

  endfunction

endclass
