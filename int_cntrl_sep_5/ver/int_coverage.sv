class int_coverage extends uvm_subscriber #(int_seq_item);

  `uvm_component_utils(int_coverage)


  // ============================================================
  // Configuration
  // ============================================================

  localparam int NUM_IRQ = 16;

  int_seq_item tr;


  // ============================================================
  // Coverage variables
  // ============================================================

  bit        cov_reset;

  bit        cov_irq_req;

  bit        cov_irq_output_valid;

  bit        cov_eoi_valid;

  bit [7:0]  cov_irq_id;

  bit [15:0] cov_ext_int;

  bit [15:0] cov_int_en;

  bit [7:0]  cov_highest_lvl_pr;

  bit [7:0]  cov_active_lvl_pr;

  int        cov_active_irq_count;

  bit        cov_wr_en;

  bit        cov_rd_en;

  bit [15:0] cov_wr_addr;

  bit [15:0] cov_rd_addr;

  bit [7:0]  cov_wr_data;

  bit [7:0]  cov_eoi_id;

  bit        cov_global_en_valid;


  // ============================================================
  // Coverage group
  // ============================================================

  covergroup zic_cg;

    option.per_instance = 1;


    // ------------------------------------------------------------
    // Reset
    // ------------------------------------------------------------

    cp_reset : coverpoint cov_reset {

      bins reset_active   = {0};
      bins reset_inactive = {1};

    }


    // ------------------------------------------------------------
    // Interrupt request
    // ------------------------------------------------------------

    cp_irq_req : coverpoint cov_irq_req {

      bins irq_low  = {0};
      bins irq_high = {1};

    }


    // ------------------------------------------------------------
    // Interrupt output valid
    // current_int_id_o != 0
    // ------------------------------------------------------------

    cp_irq_output_valid : coverpoint cov_irq_output_valid {

      bins irq_output_zero    = {0};
      bins irq_output_nonzero = {1};

    }


    // ------------------------------------------------------------
    // Current interrupt ID
    //
    // ACK ID encoding:
    // IRQ0  -> 10h
    // IRQ1  -> 11h
    // ...
    // IRQ15 -> 1Fh
    // ------------------------------------------------------------

    cp_irq_id : coverpoint cov_irq_id
      iff (cov_irq_output_valid) {

      bins irq_0_7[]  = {[8'h10:8'h17]};
      bins irq_8_15[] = {[8'h18:8'h1F]};

    }


    // ------------------------------------------------------------
    // Active IRQ count
    // ------------------------------------------------------------

    cp_active_irq_count : coverpoint cov_active_irq_count {

      bins no_irq     = {0};
      bins single_irq = {1};
      bins two_irq    = {2};
      bins few_irq[]  = {[3:5]};
      bins many_irq[] = {[6:15]};
      bins all_irq    = {16};

    }


    // ------------------------------------------------------------
    // Highest priority
    // ------------------------------------------------------------

    cp_highest_lvl_pr : coverpoint cov_highest_lvl_pr {

      bins low_range[]  = {[8'h00:8'h3F]};
      bins mid_range[]  = {[8'h40:8'h9F]};
      bins high_range[] = {[8'hA0:8'hFF]};

    }


    // ------------------------------------------------------------
    // Active priority
    // ------------------------------------------------------------

    cp_active_lvl_pr : coverpoint cov_active_lvl_pr {

      bins zero_level = {8'h00};

      bins low_level[] = {
        [8'h01:8'h3F]
      };

      bins mid_level[] = {
        [8'h40:8'h9F]
      };

      bins high_level[] = {
        [8'hA0:8'hFF]
      };

    }


    // ------------------------------------------------------------
    // EOI
    // ------------------------------------------------------------

    cp_eoi_valid : coverpoint cov_eoi_valid {

      bins no_eoi   = {0};
      bins eoi_seen = {1};

    }


    // ------------------------------------------------------------
    // EOI ID
    // ------------------------------------------------------------

    cp_eoi_id : coverpoint cov_eoi_id
      iff (cov_eoi_valid) {

      bins eoi_10_17[] = {[8'h10:8'h17]};
      bins eoi_18_1f[] = {[8'h18:8'h1F]};

    }


    // ------------------------------------------------------------
    // MMR write
    // ------------------------------------------------------------

    cp_wr_en : coverpoint cov_wr_en {

      bins wr_low  = {0};
      bins wr_high = {1};

    }


    // ------------------------------------------------------------
    // MMR read
    // ------------------------------------------------------------

    cp_rd_en : coverpoint cov_rd_en {

      bins rd_low  = {0};
      bins rd_high = {1};

    }


    // ------------------------------------------------------------
    // CTL write address
    //
    // CTL0  = 9020
    // CTL1  = 9030
    // ...
    // CTL15 = 9110
    //
    // CTL0-9 are RO according to the register map,
    // so writable CTL coverage is mainly IRQ10-15.
    // ------------------------------------------------------------

    cp_wr_addr : coverpoint cov_wr_addr
      iff (cov_wr_en) {

      bins irq_ctl_10 = {16'h90C0};
      bins irq_ctl_11 = {16'h90D0};
      bins irq_ctl_12 = {16'h90E0};
      bins irq_ctl_13 = {16'h90F0};
      bins irq_ctl_14 = {16'h9100};
      bins irq_ctl_15 = {16'h9110};

    }


    // ------------------------------------------------------------
    // CTL read address
    // ------------------------------------------------------------

    cp_rd_addr : coverpoint cov_rd_addr
      iff (cov_rd_en) {

      bins rd_irq_ctl_0  = {16'h9020};
      bins rd_irq_ctl_1  = {16'h9030};
      bins rd_irq_ctl_2  = {16'h9040};
      bins rd_irq_ctl_3  = {16'h9050};
      bins rd_irq_ctl_4  = {16'h9060};
      bins rd_irq_ctl_5  = {16'h9070};
      bins rd_irq_ctl_6  = {16'h9080};
      bins rd_irq_ctl_7  = {16'h9090};
      bins rd_irq_ctl_8  = {16'h90A0};
      bins rd_irq_ctl_9  = {16'h90B0};
      bins rd_irq_ctl_10 = {16'h90C0};
      bins rd_irq_ctl_11 = {16'h90D0};
      bins rd_irq_ctl_12 = {16'h90E0};
      bins rd_irq_ctl_13 = {16'h90F0};
      bins rd_irq_ctl_14 = {16'h9100};
      bins rd_irq_ctl_15 = {16'h9110};

    }


    // ------------------------------------------------------------
    // CTL write data
    // ------------------------------------------------------------

    cp_wr_data : coverpoint cov_wr_data {

      bins low_val[]  = {[8'h00:8'h3F]};
      bins mid_val[]  = {[8'h40:8'h9F]};
      bins high_val[] = {[8'hA0:8'hFF]};

    }


    // ------------------------------------------------------------
    // External interrupt present
    // ------------------------------------------------------------

    cp_ext_int_present :
      coverpoint (cov_ext_int != 16'h0000) {

      bins no_ext_int = {0};
      bins ext_int_on = {1};

    }


    // ------------------------------------------------------------
    // Global enable present
    // ------------------------------------------------------------

    cp_global_enable_present :
      coverpoint (cov_int_en != 16'h0000) {

      bins global_enable_on = {1};

    }


    // ------------------------------------------------------------
    // Global enable valid
    // ------------------------------------------------------------

    cp_global_en_valid : coverpoint cov_global_en_valid {

      bins invalid = {0};
      bins valid   = {1};

    }


    // ------------------------------------------------------------
    // Cross coverage
    // ------------------------------------------------------------

    cross_wr_addr_data :
      cross cp_wr_addr, cp_wr_data;

    cross_ext_enable :
      cross cp_ext_int_present,
            cp_global_enable_present;

    cross_irq_count_req :
      cross cp_active_irq_count,
            cp_irq_req;

    cross_threshold_irq :
      cross cp_active_lvl_pr,
            cp_irq_req;

    cross_irq_output :
      cross cp_irq_req,
            cp_irq_output_valid;

    cross_eoi_irq :
      cross cp_eoi_valid,
            cp_irq_output_valid;

  endgroup


  // ============================================================
  // Constructor
  // ============================================================

  function new(
    string name = "int_coverage",
    uvm_component parent = null
  );

    super.new(name, parent);

    zic_cg = new();

  endfunction


  // ============================================================
  // Analysis write
  // ============================================================

  function void write(int_seq_item t);

    tr = t;


    // ------------------------------------------------------------
    // Basic signals
    // ------------------------------------------------------------

    cov_reset =
        tr.soc_rst;

    cov_irq_req =
        tr.interrupt_request_o;


    // ------------------------------------------------------------
    // Current interrupt output
    // ------------------------------------------------------------

    cov_irq_output_valid =
        (tr.current_int_id_o != 8'h00);

    cov_irq_id =
        tr.current_int_id_o;


    // ------------------------------------------------------------
    // Interrupt inputs
    // ------------------------------------------------------------

    cov_ext_int =
        tr.ext_int[15:0];

    cov_int_en =
        tr.global_int_enable_bit_i[15:0];


    // ------------------------------------------------------------
    // Priority
    // ------------------------------------------------------------

    cov_highest_lvl_pr =
        tr.highest_pending_lvl_pr_o;

    cov_active_lvl_pr =
        tr.active_lvl_pr_i;


    // ------------------------------------------------------------
    // Active interrupt count
    // ------------------------------------------------------------

    cov_active_irq_count =
        count_active_interrupts(
          cov_ext_int,
          cov_int_en
        );


    // ------------------------------------------------------------
    // MMR
    // ------------------------------------------------------------

    cov_wr_en =
        tr.soc_mmr_write_en_i;

    cov_rd_en =
        tr.soc_mmr_read_en_i;

    cov_wr_addr =
        tr.soc_mmr_write_addr_i;

    cov_rd_addr =
        tr.soc_mmr_read_addr_i;

    cov_wr_data =
        tr.soc_mmr_write_data_i;


    // ------------------------------------------------------------
    // EOI
    // ------------------------------------------------------------

    cov_eoi_valid =
        tr.soc_eoi_valid_i;

    cov_eoi_id =
        tr.soc_eoi_id_i;


    // ------------------------------------------------------------
    // Global enable
    // ------------------------------------------------------------

    cov_global_en_valid =
        tr.global_int_enable_valid_i;


    `uvm_info("COV_SAMPLE",
      $sformatf(
        "rst=%0b irq_req=%0b current_id=%02h wr_en=%0b rd_en=%0b ext=%04h en=%04h eoi=%0b eoi_id=%02h",
        cov_reset,
        cov_irq_req,
        cov_irq_id,
        cov_wr_en,
        cov_rd_en,
        cov_ext_int,
        cov_int_en,
        cov_eoi_valid,
        cov_eoi_id
      ),
      UVM_LOW);


    zic_cg.sample();

  endfunction


  // ============================================================
  // Count active interrupts
  // ============================================================

  function int count_active_interrupts(
    bit [15:0] ext_int,
    bit [15:0] int_en
  );

    int count;

    count = 0;

    for (int i = 0; i < NUM_IRQ; i++) begin

      if (ext_int[i] &&
          int_en[i]) begin

        count++;

      end

    end

    return count;

  endfunction

endclass
