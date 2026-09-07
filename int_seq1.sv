// ============================================================
// COMMON BASE FOR reset_basic_seq / mmr_basic_seq
// single_irq_seq / multi_irq_seq
// 16 INTERRUPT VERSION
// ============================================================
class zic_comman_base_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(zic_comman_base_seq)

  localparam int NUM_IRQ = 16;
  localparam bit [15:0] VALID_IRQ_MASK = 16'hFFFF;

  function new(string name = "zic_comman_base_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int id);
    return 16'h9020 + (id * 16'h0010);
  endfunction

  task send_tr(
    string name,
    bit soc_rst,
    bit [15:0] ext_int,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [7:0] wr_data,
    bit rd_en,
    bit [15:0] rd_addr,
    bit eoi_valid,
    bit [7:0] eoi_id,
    bit [15:0] enable_bits,
    bit enable_valid,
    bit [7:0] active_lvl,
    bit debug_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);

    start_item(tr);

    tr.soc_rst = soc_rst;
    tr.ext_int = ext_int;

    tr.soc_mmr_write_en_i   = wr_en;
    tr.soc_mmr_write_addr_i = wr_addr;
    tr.soc_mmr_write_data_i = wr_data;

    tr.soc_mmr_read_en_i   = rd_en;
    tr.soc_mmr_read_addr_i = rd_addr;

    tr.soc_eoi_valid_i = eoi_valid;
    tr.soc_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = debug_valid;

    finish_item(tr);

  endtask


  task idle(
    int n,
    bit [15:0] ext = 16'h0000,
    bit [15:0] en  = VALID_IRQ_MASK
  );

    repeat (n) begin

      send_tr(
        "idle",
        1'b1,
        ext,

        1'b0,
        16'h0000,
        8'h00,

        1'b0,
        16'h0000,

        1'b0,
        8'h00,

        en,
        1'b0,

        8'h00,
        1'b0
      );

    end

  endtask


  task write_ctl(
    int irq,
    bit [7:0] data
  );

    send_tr(
      $sformatf("write_irq%0d_ctl", irq),

      1'b1,
      16'h0000,

      1'b1,
      ctl_addr(irq),
      data,

      1'b0,
      16'h0000,

      1'b0,
      8'h00,

      VALID_IRQ_MASK,
      1'b0,

      8'h00,
      1'b0
    );

  endtask


  task read_ctl(int irq);

    send_tr(
      $sformatf("read_ctl_irq%0d", irq),

      1'b1,
      16'h0000,

      1'b0,
      16'h0000,
      8'h00,

      1'b1,
      ctl_addr(irq),

      1'b0,
      8'h00,

      VALID_IRQ_MASK,
      1'b0,

      8'h00,
      1'b0
    );

  endtask

endclass



// ============================================================
// RANDOM INTERRUPT STORM SEQUENCE
// 16 INTERRUPT VERSION
// ============================================================
class random_interrupt_storm_seq extends zic_comman_base_seq;

  `uvm_object_utils(random_interrupt_storm_seq)

  localparam int NUM_IRQ = 16;
  localparam bit [15:0] VALID_IRQ_MASK = 16'hFFFF;

  rand bit [7:0] irq_ctl [NUM_IRQ];

  rand int unsigned irq_count;
  rand int unsigned irq_group;
  rand int unsigned prio_group;

  int unsigned storm_cycles = 1000;


  constraint ctl_c {
    foreach (irq_ctl[i])
      irq_ctl[i] inside {[8'h01:8'hFF]};
  }

  constraint cov_bias_c {

    irq_count dist {
      1       := 35,
      2       := 35,
      [3:5]   := 20,
      [6:10]  := 10,
      [11:16] := 10
    };

    irq_group dist {
      0 := 35,
      1 := 35,
      2 := 25,
      3 := 25
    };

    prio_group dist {
      0 := 35,
      1 := 35,
      2 := 30
    };

  }


  function new(string name = "random_interrupt_storm_seq");
    super.new(name);
  endfunction


  function automatic bit [15:0] ctl_addr(int id);
    return 16'h9020 + (id * 16'h0010);
  endfunction


  function automatic int rand_irq_from_group(int group_id);

    case (group_id)

      0: return $urandom_range(0, 3);
      1: return $urandom_range(4, 7);
      2: return $urandom_range(8, 11);
      3: return $urandom_range(12, 15);

      default:
        return $urandom_range(0, 15);

    endcase

  endfunction


  function automatic bit [7:0] rand_ctl_from_group(int group_id);

    case (group_id)

      0: return $urandom_range(8'h01, 8'h3F);
      1: return $urandom_range(8'h40, 8'h9F);
      2: return $urandom_range(8'hA0, 8'hFF);

      default:
        return $urandom_range(8'h01, 8'hFF);

    endcase

  endfunction


  function automatic bit higher_priority(
    bit [7:0] cur_ctl,
    int       cur_id,
    bit [7:0] best_ctl,
    int       best_id
  );

    if (cur_ctl[7:5] > best_ctl[7:5])
      return 1'b1;

    if ((cur_ctl[7:5] == best_ctl[7:5]) &&
        (cur_ctl[4:2] > best_ctl[4:2]))
      return 1'b1;

    if ((cur_ctl[7:5] == best_ctl[7:5]) &&
        (cur_ctl[4:2] == best_ctl[4:2]) &&
        (cur_id > best_id))
      return 1'b1;

    return 1'b0;

  endfunction


  function automatic int find_best_id(bit [15:0] mask);

    int best_id;
    bit best_found;
    bit [7:0] best_ctl;

    best_id    = -1;
    best_found = 1'b0;
    best_ctl   = 8'h00;

    for (int i = 0; i < NUM_IRQ; i++) begin

      if (mask[i]) begin

        if (!best_found) begin

          best_found = 1'b1;
          best_id    = i;
          best_ctl   = irq_ctl[i];

        end
        else if (higher_priority(
                   irq_ctl[i],
                   i,
                   best_ctl,
                   best_id
                 )) begin

          best_id  = i;
          best_ctl = irq_ctl[i];

        end

      end

    end

    return best_id;

  endfunction


  task body();

    bit [15:0] ext_mask;
    bit [15:0] en_mask;
    bit [15:0] eligible_mask;

    int best_id;
    int wait_cycles;

    bit [7:0] active_lvl_rand;


    if (!this.randomize()) begin

      `uvm_fatal(
        "RAND_STORM_SEQ",
        "Initial randomization failed"
      )

    end


    `uvm_info(
      "RAND_STORM_SEQ",
      $sformatf(
        "Starting 16-interrupt random storm, cycles=%0d",
        storm_cycles
      ),
      UVM_LOW
    )


    // --------------------------------------------------------
    // RESET
    // --------------------------------------------------------

    send_tr(
      "reset",

      1'b0,
      16'h0000,

      1'b0,
      16'h0000,
      8'h00,

      1'b0,
      16'h0000,

      1'b0,
      8'h00,

      16'h0000,
      1'b0,

      8'h00,
      1'b0
    );


    repeat (3) begin

      send_tr(
        "post_reset_idle",

        1'b1,
        16'h0000,

        1'b0,
        16'h0000,
        8'h00,

        1'b0,
        16'h0000,

        1'b0,
        8'h00,

        16'h0000,
        1'b0,

        8'h00,
        1'b0
      );

    end


    // --------------------------------------------------------
    // INITIAL CTL PROGRAMMING
    // --------------------------------------------------------

    for (int i = 0; i < NUM_IRQ; i++) begin

      irq_ctl[i] = $urandom_range(
        8'h20,
        8'hFF
      );

      // CTL0-CTL9 are read-only in the register map.
      // CTL10-CTL15 are writable.

      if (i >= 10) begin

        send_tr(
          $sformatf(
            "mmr_write_irq%0d_ctl",
            i
          ),

          1'b1,
          16'h0000,

          1'b1,
          ctl_addr(i),
          irq_ctl[i],

          1'b0,
          16'h0000,

          1'b0,
          8'h00,

          16'h0000,
          1'b0,

          8'h00,
          1'b0
        );

      end
      else begin

        send_tr(
          $sformatf(
            "mmr_read_irq%0d_ctl",
            i
          ),

          1'b1,
          16'h0000,

          1'b0,
          16'h0000,
          8'h00,

          1'b1,
          ctl_addr(i),

          1'b0,
          8'h00,

          16'h0000,
          1'b0,

          8'h00,
          1'b0
        );

      end

    end


    repeat (5) begin

      send_tr(
        "initial_ctl_settle",

        1'b1,
        16'h0000,

        1'b0,
        16'h0000,
        8'h00,

        1'b0,
        16'h0000,

        1'b0,
        8'h00,

        16'h0000,
        1'b0,

        8'h00,
        1'b0
      );

    end


    // --------------------------------------------------------
    // ENABLE ALL INTERRUPTS
    // --------------------------------------------------------

    send_tr(
      "enable_irq_0_to_15",

      1'b1,
      16'h0000,

      1'b0,
      16'h0000,
      8'h00,

      1'b0,
      16'h0000,

      1'b0,
      8'h00,

      VALID_IRQ_MASK,
      1'b1,

      8'h00,
      1'b0
    );


    repeat (5) begin

      send_tr(
        "settle_after_enable",

        1'b1,
        16'h0000,

        1'b0,
        16'h0000,
        8'h00,

        1'b0,
        16'h0000,

        1'b0,
        8'h00,

        VALID_IRQ_MASK,
        1'b0,

        8'h00,
        1'b0
      );

    end


    // --------------------------------------------------------
    // RANDOM INTERRUPT STORM
    // --------------------------------------------------------

    repeat (storm_cycles) begin

      if (!this.randomize()) begin

        `uvm_fatal(
          "RAND_STORM_SEQ",
          "Loop randomization failed"
        )

      end


      ext_mask = 16'h0000;
      en_mask  = 16'h0000;


      // ------------------------------------------------------
      // Re-program writable CTL registers
      // ------------------------------------------------------

      for (int i = 10; i < NUM_IRQ; i++) begin

        irq_ctl[i] = rand_ctl_from_group(prio_group);

        send_tr(
          $sformatf(
            "cov_mmr_write_irq%0d_ctl",
            i
          ),

          1'b1,
          16'h0000,

          1'b1,
          ctl_addr(i),
          irq_ctl[i],

          1'b0,
          16'h0000,

          1'b0,
          8'h00,

          16'h0000,
          1'b0,

          8'h00,
          1'b0
        );

      end


      repeat (8) begin

        send_tr(
          "settle_after_ctl_programming",

          1'b1,
          16'h0000,

          1'b0,
          16'h0000,
          8'h00,

          1'b0,
          16'h0000,

          1'b0,
          8'h00,

          16'h0000,
          1'b0,

          8'h00,
          1'b0
        );

      end


      // ------------------------------------------------------
      // Generate active and enabled interrupts
      // ------------------------------------------------------

      repeat (irq_count) begin

        int irq;

        irq = rand_irq_from_group(
          irq_group
        );

        ext_mask[irq] = 1'b1;
        en_mask[irq]  = 1'b1;

      end


      if ((ext_mask & en_mask) == 16'h0000) begin

        int irq;

        irq = rand_irq_from_group(
          irq_group
        );

        ext_mask[irq] = 1'b1;
        en_mask[irq]  = 1'b1;

      end


      eligible_mask = ext_mask & en_mask;

      best_id = find_best_id(
        eligible_mask
      );

      wait_cycles = $urandom_range(
        6,
        10
      );

      active_lvl_rand = 8'h00;


      `uvm_info(
        "RAND_STORM_SEQ",
        $sformatf(
          "ext=0x%0h en=0x%0h best_id=%0d ctl=0x%0h level=0x%0h pri=0x%0h",
          ext_mask,
          en_mask,
          best_id,
          irq_ctl[best_id],
          irq_ctl[best_id][7:5],
          irq_ctl[best_id][4:2]
        ),
        UVM_LOW
      )


      // ------------------------------------------------------
      // Drive external interrupt and global enable
      // ------------------------------------------------------

      send_tr(
        "drive_ext_irq_and_global_enable",

        1'b1,
        ext_mask,

        1'b0,
        16'h0000,
        8'h00,

        1'b0,
        16'h0000,

        1'b0,
        8'h00,

        en_mask,
        1'b1,

        active_lvl_rand,
        1'b0
      );


      // ------------------------------------------------------
      // Wait for priority resolution
      // ------------------------------------------------------

      repeat (wait_cycles) begin

        send_tr(
          "wait_priority_resolve",

          1'b1,
          ext_mask,

          1'b0,
          16'h0000,
          8'h00,

          1'b0,
          16'h0000,

          1'b0,
          8'h00,

          en_mask,
          1'b0,

          active_lvl_rand,
          1'b0
        );

      end


      // ------------------------------------------------------
      // Optional MMR read
      // ------------------------------------------------------

      if ($urandom_range(0, 3) == 0) begin

        int rd_irq;

        rd_irq = $urandom_range(
          0,
          15
        );


        send_tr(
          "mmr_read_random_ctl",

          1'b1,
          ext_mask,

          1'b0,
          16'h0000,
          8'h00,

          1'b1,
          ctl_addr(rd_irq),

          1'b0,
          8'h00,

          en_mask,
          1'b0,

          active_lvl_rand,
          1'b0
        );


        repeat (3) begin

          send_tr(
            "settle_after_mmr_read",

            1'b1,
            ext_mask,

            1'b0,
            16'h0000,
            8'h00,

            1'b0,
            16'h0000,

            1'b0,
            8'h00,

            en_mask,
            1'b0,

            active_lvl_rand,
            1'b0
          );

        end

      end


      // ------------------------------------------------------
      // Clear external interrupt
      // ------------------------------------------------------

      send_tr(
        "clear_ext_before_eoi",

        1'b1,
        16'h0000,

        1'b0,
        16'h0000,
        8'h00,

        1'b0,
        16'h0000,

        1'b0,
        8'h00,

        en_mask,
        1'b0,

        active_lvl_rand,
        1'b0
      );


      // ------------------------------------------------------
      // EOI
      // ------------------------------------------------------

      if (best_id >= 0) begin

        send_tr(
          "eoi_served_irq",

          1'b1,
          16'h0000,

          1'b0,
          16'h0000,
          8'h00,

          1'b0,
          16'h0000,

          1'b1,
          8'h10 + best_id[7:0],

          en_mask,
          1'b0,

          active_lvl_rand,
          1'b0
        );

      end


      // ------------------------------------------------------
      // Idle
      // ------------------------------------------------------

      repeat (3) begin

        send_tr(
          "clear_irq_idle",

          1'b1,
          16'h0000,

          1'b0,
          16'h0000,
          8'h00,

          1'b0,
          16'h0000,

          1'b0,
          8'h00,

          en_mask,
          1'b0,

          8'h00,
          1'b0
        );

      end

    end

  endtask

endclass



// ============================================================
// RANDOM STORM SEQUENCE - 16 INTERRUPT VERSION
// ============================================================
class rand_storm_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(rand_storm_seq)

  localparam int NUM_IRQ = 16;
  localparam bit [15:0] VALID_IRQ_MASK = 16'hFFFF;

  int_seq_item tr;

  bit [7:0] irq_ctl [NUM_IRQ];

  int unsigned storm_cycles = 1000;


  function new(string name = "rand_storm_seq");
    super.new(name);
  endfunction


  function automatic bit [15:0] ctl_addr(int id);
    return 16'h9020 + (id * 16'h0010);
  endfunction


  function automatic int find_best_id(bit [15:0] mask);

    int best_id;
    bit found;

    bit [2:0] best_lvl;
    bit [2:0] best_pri;
    bit [2:0] cur_lvl;
    bit [2:0] cur_pri;

    best_id  = -1;
    found    = 1'b0;
    best_lvl = 3'h0;
    best_pri = 3'h0;


    for (int i = 0; i < NUM_IRQ; i++) begin

      if (mask[i]) begin

        cur_lvl = irq_ctl[i][7:5];
        cur_pri = irq_ctl[i][4:2];


        if (!found) begin

          found    = 1'b1;
          best_id  = i;
          best_lvl = cur_lvl;
          best_pri = cur_pri;

        end
        else if (cur_lvl > best_lvl) begin

          best_id  = i;
          best_lvl = cur_lvl;
          best_pri = cur_pri;

        end
        else if ((cur_lvl == best_lvl) &&
                 (cur_pri > best_pri)) begin

          best_id  = i;
          best_lvl = cur_lvl;
          best_pri = cur_pri;

        end
        else if ((cur_lvl == best_lvl) &&
                 (cur_pri == best_pri) &&
                 (i > best_id)) begin

          best_id  = i;
          best_lvl = cur_lvl;
          best_pri = cur_pri;

        end

      end

    end

    return best_id;

  endfunction


  task send_tr(
    string name,
    bit soc_rst,
    bit [15:0] ext_mask,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [7:0] wr_data,
    bit rd_en,
    bit [15:0] rd_addr,
    bit eoi_valid,
    bit [7:0] eoi_id,
    bit [15:0] en_mask,
    bit en_valid
  );

    tr = int_seq_item::type_id::create(name);

    start_item(tr);

    tr.soc_rst = soc_rst;
    tr.ext_int = ext_mask;

    tr.soc_mmr_write_en_i   = wr_en;
    tr.soc_mmr_write_addr_i = wr_addr;
    tr.soc_mmr_write_data_i = wr_data;

    tr.soc_mmr_read_en_i   = rd_en;
    tr.soc_mmr_read_addr_i = rd_addr;

    tr.soc_eoi_valid_i = eoi_valid;
    tr.soc_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = 8'h00;

    tr.global_int_enable_bit_i   = en_mask;
    tr.global_int_enable_valid_i = en_valid;

    tr.debug_mode_valid_i = 1'b0;

    finish_item(tr);

  endtask


  task body();

    int i;
    int n;
    int irq;
    int best_id;

    bit [15:0] rand_ext;
    bit [15:0] active_mask;


    // --------------------------------------------------------
    // RESET
    // --------------------------------------------------------

    send_tr(
      "reset",
      1'b0,
      16'h0000,

      1'b0,
      16'h0000,
      8'h00,

      1'b0,
      16'h0000,

      1'b0,
      8'h00,

      16'h0000,
      1'b0
    );


    repeat (3) begin

      send_tr(
        "post_reset_idle",
        1'b1,
        16'h0000,

        1'b0,
        16'h0000,
        8'h00,

        1'b0,
        16'h0000,

        1'b0,
        8'h00,

        16'h0000,
        1'b0
      );

    end


    // --------------------------------------------------------
    // Configure writable CTL10 to CTL15
    // --------------------------------------------------------

    for (i = 10; i < NUM_IRQ; i++) begin

      irq_ctl[i] = $urandom_range(
        8'h20,
        8'hFF
      );


      send_tr(
        $sformatf(
          "cfg_irq_%0d",
          i
        ),

        1'b1,
        16'h0000,

        1'b1,
        ctl_addr(i),
        irq_ctl[i],

        1'b0,
        16'h0000,

        1'b0,
        8'h00,

        16'h0000,
        1'b0
      );

    end


    // --------------------------------------------------------
    // Enable IRQ0 to IRQ15
    // --------------------------------------------------------

    send_tr(
      "enable_irq_0_to_15",

      1'b1,
      16'h0000,

      1'b0,
      16'h0000,
      8'h00,

      1'b0,
      16'h0000,

      1'b0,
      8'h00,

      VALID_IRQ_MASK,
      1'b1
    );


    repeat (5) begin

      send_tr(
        "settle_after_enable",

        1'b1,
        16'h0000,

        1'b0,
        16'h0000,
        8'h00,

        1'b0,
        16'h0000,

        1'b0,
        8'h00,

        VALID_IRQ_MASK,
        1'b0
      );

    end


    // --------------------------------------------------------
    // RANDOM INTERRUPT STORM
    // --------------------------------------------------------

    repeat (storm_cycles) begin

      rand_ext = 16'h0000;

      n = $urandom_range(
        1,
        5
      );


      for (i = 0; i < n; i++) begin

        irq = $urandom_range(
          0,
          15
        );

        rand_ext[irq] = 1'b1;

      end


      active_mask = rand_ext & VALID_IRQ_MASK;

      best_id = find_best_id(
        active_mask
      );


      `uvm_info(
        "RAND_STORM_SEQ",

        $sformatf(
          "rand_ext=0x%0h best_id=%0d ctl=0x%0h level=0x%0h pri=0x%0h",
          rand_ext,
          best_id,
          irq_ctl[best_id],
          irq_ctl[best_id][7:5],
          irq_ctl[best_id][4:2]
        ),

        UVM_LOW
      )


      // ------------------------------------------------------
      // Assert random interrupts
      // ------------------------------------------------------

      send_tr(
        "rand_irq_assert",

        1'b1,
        rand_ext,

        1'b0,
        16'h0000,
        8'h00,

        1'b0,
        16'h0000,

        1'b0,
        8'h00,

        VALID_IRQ_MASK,
        1'b0
      );


      // ------------------------------------------------------
      // Wait
      // ------------------------------------------------------

      repeat (4) begin

        send_tr(
          "wait_priority_resolve",

          1'b1,
          rand_ext,

          1'b0,
          16'h0000,
          8'h00,

          1'b0,
          16'h0000,

          1'b0,
          8'h00,

          VALID_IRQ_MASK,
          1'b0
        );

      end


      // ------------------------------------------------------
      // Clear external interrupt
      // ------------------------------------------------------

      send_tr(
        "clear_ext_before_eoi",

        1'b1,
        16'h0000,

        1'b0,
        16'h0000,
        8'h00,

        1'b0,
        16'h0000,

        1'b0,
        8'h00,

        VALID_IRQ_MASK,
        1'b0
      );


      // ------------------------------------------------------
      // EOI
      // ------------------------------------------------------

      if (best_id >= 0) begin

        send_tr(
          "eoi_served_irq",

          1'b1,
          16'h0000,

          1'b0,
          16'h0000,
          8'h00,

          1'b0,
          16'h0000,

          1'b1,
          8'h10 + best_id[7:0],

          VALID_IRQ_MASK,
          1'b0
        );

      end


      repeat (3) begin

        send_tr(
          "clear_irq_idle",

          1'b1,
          16'h0000,

          1'b0,
          16'h0000,
          8'h00,

          1'b0,
          16'h0000,

          1'b0,
          8'h00,

          VALID_IRQ_MASK,
          1'b0
        );

      end

    end

  endtask

endclass

// ============================================================
// DYNAMIC PRIORITY OVERRIDE SEQUENCE - 16 INTERRUPT VERSION
// ============================================================
class dynamic_priority_override_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(dynamic_priority_override_seq)

  rand int low_irq;
  rand int high_irq;

  constraint irq_c {
    low_irq  inside {[10:12]};
    high_irq inside {[13:15]};
    low_irq != high_irq;
  }

  function new(string name = "dynamic_priority_override_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int id);
    return 16'h9020 + (id * 16'h0010);
  endfunction

  task body();

    bit [15:0] enable_mask;
    bit [15:0] low_mask;
    bit [15:0] both_mask;

    if (!this.randomize()) begin
      `uvm_fatal("DYN_PRIO_SEQ", "Randomization failed")
    end

    enable_mask = 16'h0000;
    low_mask    = 16'h0000;
    both_mask   = 16'h0000;

    enable_mask[low_irq]  = 1'b1;
    enable_mask[high_irq] = 1'b1;

    low_mask[low_irq] = 1'b1;

    both_mask[low_irq]  = 1'b1;
    both_mask[high_irq] = 1'b1;

    `uvm_info("DYN_PRIO_SEQ",
      $sformatf("LOW_IRQ=%0d PRIO=0x20 | HIGH_IRQ=%0d PRIO=0xE0",
                low_irq, high_irq),
      UVM_LOW)

   send_tr("reset", 1'b0, 16'h0000,
        1'b0, 16'h0000, 8'h00,
        1'b0, 16'h0000,
        1'b0, 16'h0000,
        1'b0, 8'h00,
        8'h00, 1'b0);

    repeat (3) begin
    
      send_tr("post_reset_idle", 1'b1, 16'h0000,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0000,
              1'b0, 8'h00,
              8'h00, 1'b0);
    
    end
    write_ctl($sformatf("write_low_irq%0d_ctl", low_irq),
              ctl_addr(low_irq),
              8'h20);

    write_ctl($sformatf("write_high_irq%0d_ctl", high_irq),
              ctl_addr(high_irq),
              8'hE0);

    send_tr("assert_low_irq_only", 1'b1, low_mask,
        1'b0, 16'h0000, 8'h00,
        1'b0, 16'h0000,
        1'b0, enable_mask,
        1'b0, 8'h00,
        8'h00, 1'b0);

    
    repeat (5) begin
      send_tr("wait_low_irq_resolve", 1'b1, low_mask,
        1'b0, 16'h0000, 8'h00,
        1'b0, 16'h0000,
        1'b0, enable_mask,
        1'b0, 8'h00,
        8'h00, 1'b0);
      
      end

    repeat (2) begin
      send_tr("wait_after_low_ack", 1'b1, low_mask,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, enable_mask,
              1'b0, 8'h00,
              8'h00, 
              1'b0);
    end

    send_tr("high_irq_arrives", 1'b1, both_mask,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, enable_mask,
            1'b0, 8'h00,
            8'h00, 
            1'b0);

    repeat (5) begin
      send_tr("wait_high_override", 1'b1, both_mask,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, enable_mask,
              1'b0, 8'h00,
              8'h00, 
              1'b0);
    end

    send_tr("eoi_high_irq", 1'b1, both_mask,
            1'b0, 16'h0000, 8'h00,
            1'b1, (8'h10 + high_irq),
            1'b0, enable_mask,
            1'b0, 8'h00,
            8'h00, 
            1'b0);

    repeat (3) begin
      send_tr("idle_after_high_eoi", 1'b1, both_mask,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, enable_mask,
              1'b0, 8'h00,
              8'h00, 
              1'b0);
    end

    send_tr("eoi_low_irq", 1'b1, both_mask,
            1'b0, 16'h0000, 8'h00,
            1'b1, (8'h10 + low_irq),
            1'b0, enable_mask,
            1'b0, 8'h00,
            8'h00, 
            1'b0);

    repeat (3) begin
      send_tr("idle_after_low_eoi", 1'b1, both_mask,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, enable_mask,
              1'b0, 8'h00,
              8'h00, 
              1'b0);
    end

  endtask

  task write_ctl(string name, bit [15:0] addr, bit [7:0] data);

    send_tr(name, 1'b1, 16'h0000,
            1'b1, addr, data,
            1'b0, 16'h0000,
            1'b0, 16'h0000,
            1'b0, 8'h00,
            8'h00, 
            1'b0);

  endtask

  task send_tr(
    string name,
    bit soc_rst,
    bit [15:0] ext_mask,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [7:0] wr_data,
    bit rd_en,
    bit [15:0] rd_addr,
    bit eoi_valid,
    bit [15:0] enable_bits,
    bit enable_valid,
    bit [7:0] eoi_id,
    bit [7:0] active_lvl,
    bit debug_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);
    start_item(tr);

    tr.soc_rst = soc_rst;
    tr.ext_int = ext_mask;

    tr.soc_mmr_write_en_i   = wr_en;
    tr.soc_mmr_write_addr_i = wr_addr;
    tr.soc_mmr_write_data_i = wr_data;

    tr.soc_mmr_read_en_i   = rd_en;
    tr.soc_mmr_read_addr_i = rd_addr;

    tr.soc_eoi_valid_i = eoi_valid;
    tr.soc_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = debug_valid;

    finish_item(tr);

  endtask

endclass


// ============================================================
// RANDOM TIE BREAK + EOI SEQUENCE - 16 IRQ
// ============================================================
class random_tie_break_eoi_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(random_tie_break_eoi_seq)

  rand bit [15:0] active_mask;
  rand bit [15:0] enable_mask;
  rand bit [7:0]  shared_prio;

  constraint valid_c {
    active_mask[9:0] == 10'h000;
    enable_mask[9:0] == 10'h000;

    active_mask[15:10] != 6'h00;
    enable_mask[15:10] != 6'h00;

    (active_mask & enable_mask) != 16'h0000;
    $countones(active_mask & enable_mask) >= 3;

    shared_prio inside {[8'h01:8'hFF]};
  }

  function new(string name = "random_tie_break_eoi_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int id);
    return 16'h9020 + (id * 16'h0010);
  endfunction

  function automatic int find_highest_id(bit [15:0] mask);

    int best_id = -1;

    for (int i = 10; i < 16; i++) begin
      if (mask[i] && (i > best_id))
        best_id = i;
    end

    return best_id;

  endfunction

  task body();

    bit [15:0] work_mask;
    int winner;

    if (!this.randomize())
      `uvm_fatal("RAND_TIE_EOI_SEQ", "Randomization failed")

    work_mask = active_mask & enable_mask;

    send_tr("reset", 1'b0, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, 16'h0000,
            1'b0, 8'h00,
            8'h00, 
            1'b0);

    repeat (3) begin
      send_tr("post_reset_idle", 1'b1, 16'h0000,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0000,
              1'b0, 8'h00,
              8'h00, 
              1'b0);
    end

    for (int i = 10; i < 16; i++) begin
      write_ctl($sformatf("write_irq%0d_ctl", i),
                ctl_addr(i),
                shared_prio);
    end

    send_tr("assert_tie_break_irqs", 1'b1, active_mask,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, enable_mask,
            1'b1, 8'h00,
            8'h00, 
            1'b0);

    repeat (5) begin
      send_tr("wait_initial_resolve", 1'b1, active_mask,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, enable_mask,
              1'b0, 8'h00,
              8'h00, 
              1'b0);
    end

    repeat (3) begin

      winner = find_highest_id(work_mask);

      if (winner < 10) begin
        `uvm_fatal("RAND_TIE_EOI_SEQ", "Invalid winner")
      end

      repeat (2) begin
        send_tr("wait_before_eoi", 1'b1, work_mask,
                1'b0, 16'h0000, 8'h00,
                1'b0, 16'h0000,
                1'b0, enable_mask,
                1'b0, 8'h00,
                8'h00, 
                1'b0);
      end

      work_mask[winner] = 1'b0;

      send_tr("eoi_highest_id_winner", 1'b1, work_mask,
              1'b0, 16'h0000, 8'h00,
              1'b1, 16'h0000,
              1'b1, enable_mask,
              1'b0, (8'h10 + winner),
              8'h00,
              1'b0);

      repeat (4) begin
        send_tr("wait_next_tie_resolve", 1'b1, work_mask,
                1'b0, 16'h0000, 8'h00,
                1'b0, 16'h0000,
                1'b0, enable_mask,
                1'b0, 8'h00,
                8'h00, 
                1'b0);
      end

    end

  endtask

  task write_ctl(string name, bit [15:0] addr, bit [7:0] data);

    send_tr(name, 1'b1, 16'h0000,
            1'b1, addr, data,
            1'b0, 16'h0000,
            1'b0, 16'h0000,
            1'b0, 8'h00,
            8'h00, 
            1'b0);

  endtask

  task send_tr(
    string name,
    bit soc_rst,
    bit [15:0] ext_mask,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [7:0] wr_data,
    bit rd_en,
    bit [15:0] rd_addr,
    bit eoi_valid,
    bit [15:0] enable_bits,
    bit enable_valid,
    bit [7:0] eoi_id,
    bit [7:0] active_lvl,
    bit debug_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);
    start_item(tr);

    tr.soc_rst = soc_rst;
    tr.ext_int = ext_mask;

    tr.soc_mmr_write_en_i   = wr_en;
    tr.soc_mmr_write_addr_i = wr_addr;
    tr.soc_mmr_write_data_i = wr_data;

    tr.soc_mmr_read_en_i   = rd_en;
    tr.soc_mmr_read_addr_i = rd_addr;

    tr.soc_eoi_valid_i = eoi_valid;
    tr.soc_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = debug_valid;

    finish_item(tr);

  endtask

endclass


// ============================================================
// RANDOM EOI PROGRESSION SEQUENCE - 16 IRQ
// ============================================================
class random_eoi_progression_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(random_eoi_progression_seq)

  rand bit [7:0]  irq_ctl [16];
  rand bit [15:0] active_mask;
  rand bit [15:0] enable_mask;

  constraint valid_c {

    active_mask[9:0] == 10'h000;
    enable_mask[9:0] == 10'h000;

    active_mask[15:10] != 6'h00;
    enable_mask[15:10] != 6'h00;

    (active_mask & enable_mask) != 16'h0000;
    $countones(active_mask & enable_mask) >= 3;

    foreach (irq_ctl[i]) {
      irq_ctl[i] inside {[8'h01:8'hFF]};
    }
  }

  function new(string name = "random_eoi_progression_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int id);
    return 16'h9020 + (id * 16'h0010);
  endfunction

  function automatic int find_best_id(bit [15:0] mask);

    int best_id;
    bit [7:0] best_prio;

    best_id   = -1;
    best_prio = 8'h00;

    for (int i = 10; i < 16; i++) begin
      if (mask[i]) begin
        if ((best_id == -1) ||
            (irq_ctl[i] > best_prio) ||
            ((irq_ctl[i] == best_prio) && (i > best_id))) begin

          best_id   = i;
          best_prio = irq_ctl[i];

        end
      end
    end

    return best_id;

  endfunction

  task body();

    bit [15:0] work_mask;
    int winner;

    if (!this.randomize())
      `uvm_fatal("RAND_EOI_PROG_SEQ", "Randomization failed")

    work_mask = active_mask & enable_mask;

    send_tr("reset", 1'b0, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, 16'h0000,
            1'b0, 8'h00,
            8'h00, 
            1'b0);

    repeat (3) begin
      send_tr("post_reset_idle", 1'b1, 16'h0000,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0000,
              1'b0, 8'h00,
              8'h00, 
              1'b0);
    end

    for (int i = 10; i < 16; i++) begin
      write_ctl($sformatf("write_irq%0d_ctl", i),
                ctl_addr(i),
                irq_ctl[i]);
    end

    send_tr("assert_initial_irqs", 1'b1, active_mask,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, enable_mask,
            1'b1, 8'h00,
            8'h00, 
            1'b0);

    repeat (5) begin
      send_tr("wait_initial_resolve", 1'b1, active_mask,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, enable_mask,
              1'b0, 8'h00,
              8'h00, 
              1'b0);
    end

    repeat (3) begin

      winner = find_best_id(work_mask);

      if (winner < 10) begin
        `uvm_fatal("RAND_EOI_PROG_SEQ", "Invalid winner")
      end

      repeat (2) begin
        send_tr("wait_before_eoi", 1'b1, work_mask,
                1'b0, 16'h0000, 8'h00,
                1'b0, 16'h0000,
                1'b0, enable_mask,
                1'b0, 8'h00,
                8'h00, 
                1'b0);
      end

      work_mask[winner] = 1'b0;

      send_tr("eoi_current_winner", 1'b1, work_mask,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b1, enable_mask,
              1'b0, (8'h10 + winner),
              8'h00, 
              1'b0);

      repeat (4) begin
        send_tr("wait_next_resolve", 1'b1, work_mask,
                1'b0, 16'h0000, 8'h00,
                1'b0, 16'h0000,
                1'b0, enable_mask,
                1'b0, 8'h00,
                8'h00, 
                1'b0);
      end

    end

  endtask

  task write_ctl(string name, bit [15:0] addr, bit [7:0] data);

    send_tr(name, 1'b1, 16'h0000,
            1'b1, addr, data,
            1'b0, 16'h0000,
            1'b0, 16'h0000,
            1'b0, 8'h00,
            8'h00, 
            1'b0);

  endtask

  task send_tr(
    string name,
    bit soc_rst,
    bit [15:0] ext_mask,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [7:0] wr_data,
    bit rd_en,
    bit [15:0] rd_addr,
    bit eoi_valid,
    bit [15:0] enable_bits,
    bit enable_valid,
    bit [7:0] eoi_id,
    bit [7:0] active_lvl,
    bit debug_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);
    start_item(tr);

    tr.soc_rst = soc_rst;
    tr.ext_int = ext_mask;

    tr.soc_mmr_write_en_i   = wr_en;
    tr.soc_mmr_write_addr_i = wr_addr;
    tr.soc_mmr_write_data_i = wr_data;

    tr.soc_mmr_read_en_i   = rd_en;
    tr.soc_mmr_read_addr_i = rd_addr;

    tr.soc_eoi_valid_i = eoi_valid;
    tr.soc_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = debug_valid;

    finish_item(tr);

  endtask

endclass


// ============================================================
// RANDOM EOI LATENCY SEQUENCE - 16 IRQ
// ============================================================
class random_ack_latency_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(random_ack_latency_seq)

  rand bit [7:0]  irq_ctl [16];
  rand bit [15:0] active_mask;
  rand bit [15:0] enable_mask;
  rand int unsigned eoi_delay;

  constraint valid_c {

    active_mask[9:0] == 10'h000;
    enable_mask[9:0] == 10'h000;

    active_mask[15:10] != 6'h00;
    enable_mask[15:10] != 6'h00;

    (active_mask & enable_mask) != 16'h0000;

    eoi_delay inside {[1:25]};

    foreach (irq_ctl[i]) {
      irq_ctl[i] inside {[8'h01:8'hFF]};
    }
  }

  function new(string name = "random_ack_latency_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int id);
    return 16'h9020 + (id * 16'h0010);
  endfunction

  function automatic int find_best_id(bit [15:0] mask);

    int best_id;
    bit [7:0] best_prio;

    best_id   = -1;
    best_prio = 8'h00;

    for (int i = 10; i < 16; i++) begin

      if (mask[i]) begin

        if ((best_id == -1) ||
            (irq_ctl[i] > best_prio) ||
            ((irq_ctl[i] == best_prio) && (i > best_id))) begin

          best_id   = i;
          best_prio = irq_ctl[i];

        end

      end

    end

    return best_id;

  endfunction

  task body();

    int best_id;

    if (!this.randomize())
      `uvm_fatal("RAND_ACK_LAT_SEQ", "Randomization failed")

    best_id = find_best_id(active_mask & enable_mask);

    if (best_id < 10)
      `uvm_fatal("RAND_ACK_LAT_SEQ", "Invalid interrupt winner")

    send_tr("reset", 1'b0, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, 16'h0000,
            1'b0, 8'h00,
            8'h00, 
            1'b0);

    repeat (3) begin
      send_tr("post_reset_idle", 1'b1, 16'h0000,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0000,
              1'b0, 8'h00,
              8'h00, 
              1'b0);
    end

    for (int i = 10; i < 16; i++) begin
      write_ctl($sformatf("write_irq%0d_ctl", i),
                ctl_addr(i),
                irq_ctl[i]);
    end

    send_tr("assert_irqs", 1'b1, active_mask,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, enable_mask,
            1'b1, 8'h00,
            8'h00, 
            1'b0);

    repeat (5) begin
      send_tr("wait_interrupt_resolve", 1'b1, active_mask,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, enable_mask,
              1'b0, 8'h00,
              8'h00, 
              1'b0);
    end

    repeat (eoi_delay) begin
      send_tr("wait_before_eoi_random_delay", 1'b1, active_mask,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, enable_mask,
              1'b0, 8'h00,
              8'h00, 
              1'b0);
    end

    send_tr("eoi_after_random_delay", 1'b1, active_mask,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b1, enable_mask,
            1'b0, (8'h10 + best_id),
            8'h00, 
            1'b0);

    repeat (2) begin
      send_tr("idle_after_eoi", 1'b1, 16'h0000,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, enable_mask,
              1'b0, 8'h00,
              8'h00, 
              1'b0);
    end

  endtask

  task write_ctl(string name, bit [15:0] addr, bit [7:0] data);

    send_tr(name, 1'b1, 16'h0000,
            1'b1, addr, data,
            1'b0, 16'h0000,
            1'b0, 16'h0000,
            1'b0, 8'h00,
            8'h00,
            1'b0);

  endtask

  task send_tr(
    string name,
    bit soc_rst,
    bit [15:0] ext_mask,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [7:0] wr_data,
    bit rd_en,
    bit [15:0] rd_addr,
    bit eoi_valid,
    bit [15:0] enable_bits,
    bit enable_valid,
    bit [7:0] eoi_id,
    bit [7:0] active_lvl,
    bit debug_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);
    start_item(tr);

    tr.soc_rst = soc_rst;
    tr.ext_int = ext_mask;

    tr.soc_mmr_write_en_i   = wr_en;
    tr.soc_mmr_write_addr_i = wr_addr;
    tr.soc_mmr_write_data_i = wr_data;

    tr.soc_mmr_read_en_i   = rd_en;
    tr.soc_mmr_read_addr_i = rd_addr;

    tr.soc_eoi_valid_i = eoi_valid;
    tr.soc_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = debug_valid;

    finish_item(tr);

  endtask

endclass


// ============================================================
// RANDOM EQUAL PRIORITY SEQUENCE - 16 IRQ
// ============================================================
class random_equal_priority_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(random_equal_priority_seq)

  rand bit [15:0] active_mask;
  rand bit [15:0] enable_mask;
  rand bit [7:0]  shared_prio;

  bit [7:0] irq_ctl [16];

 constraint valid_c {
  active_mask[9:0]  == 10'h000;
  enable_mask[9:0]  == 10'h000;

  active_mask[15:10] != 6'b000000;
  enable_mask[15:10] != 6'b000000;

  (active_mask & enable_mask) != 16'h0000;

  $countones(active_mask & enable_mask) >= 3;

  shared_prio inside {[8'h01:8'hFF]};
}


  function new(string name = "random_equal_priority_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int id);
    return 16'h9020 + (id * 16'h0010);
  endfunction

  task body();

    int winner_id;

    if (!this.randomize())
      `uvm_fatal("RAND_EQUAL_PRIO_SEQ", "Randomization failed")

    foreach (irq_ctl[i]) begin
      irq_ctl[i] = shared_prio;
    end

    winner_id = -1;

    for (int i = 10; i < 16; i++) begin
      if (active_mask[i] && enable_mask[i]) begin
        if (i > winner_id)
          winner_id = i;
      end
    end

    `uvm_info("RAND_EQUAL_PRIO_SEQ",
      $sformatf("Shared priority=0x%02h Expected highest ID=%0d",
                shared_prio, winner_id),
      UVM_LOW)

    send_tr("reset",
            1'b0,
            16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, 16'h0000,
            1'b0, 8'h00,
            8'h00,
            1'b0);

    repeat (3) begin
      send_tr("post_reset_idle",
              1'b1,
              16'h0000,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0000,
              1'b0, 8'h00,
              8'h00,
              1'b0);
    end

    for (int i = 10; i < 16; i++) begin
      if (active_mask[i] || enable_mask[i]) begin
        write_ctl($sformatf("write_irq%0d_ctl", i),
                  ctl_addr(i),
                  irq_ctl[i]);
      end
    end

    send_tr("assert_equal_priority_irqs",
            1'b1,
            active_mask,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, enable_mask,
            1'b1, 8'h00,
            8'h00,
            1'b0);

    repeat (5) begin
      send_tr("wait_resolve",
              1'b1,
              active_mask,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, enable_mask,
              1'b0, 8'h00,
              8'h00,
              1'b0);
    end

    send_tr("eoi_winner",
            1'b1,
            active_mask,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b1, enable_mask,
            1'b0, (8'h10 + winner_id),
            8'h00,
            1'b0);

    repeat (3) begin
      send_tr("idle_after_eoi",
              1'b1,
              active_mask,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, enable_mask,
              1'b0, 8'h00,
              8'h00,
              1'b0);
    end

  endtask

  task write_ctl(
    string name,
    bit [15:0] addr,
    bit [7:0] data
  );

    send_tr(name,
            1'b1,
            16'h0000,
            1'b1, addr, data,
            1'b0, 16'h0000,
            1'b0, 16'h0000,
            1'b0, 8'h00,
            8'h00,
            1'b0);

  endtask

  task send_tr(
    string name,
    bit soc_rst,
    bit [15:0] ext_mask,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [7:0] wr_data,
    bit rd_en,
    bit [15:0] rd_addr,
    bit eoi_valid,
    bit [15:0] enable_bits,
    bit enable_valid,
    bit [7:0] eoi_id,
    bit [7:0] active_lvl,
    bit debug_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);

    start_item(tr);

    tr.soc_rst = soc_rst;
    tr.ext_int = ext_mask;

    tr.soc_mmr_write_en_i   = wr_en;
    tr.soc_mmr_write_addr_i = wr_addr;
    tr.soc_mmr_write_data_i = wr_data;

    tr.soc_mmr_read_en_i   = rd_en;
    tr.soc_mmr_read_addr_i = rd_addr;

    tr.soc_eoi_valid_i = eoi_valid;
    tr.soc_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = debug_valid;

    finish_item(tr);

  endtask

endclass


// ============================================================
// RANDOM ACTIVE LEVEL PRIORITY SEQUENCE - 16 IRQ
// ============================================================
class random_active_level_priority_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(random_active_level_priority_seq)

  rand int unsigned irq_count;
  rand bit [7:0] active_lvl;

  constraint c_valid {
    irq_count inside {[1:6]};
  }

  function new(string name = "random_active_level_priority_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int irq);
    return 16'h9020 + (irq * 16'h0010);
  endfunction

  task body();

    int irq;
    bit [15:0] ext_mask;
    bit [15:0] en_mask;
    bit [7:0] ctl_val;
    bit [15:0] selected_mask;

    if (!this.randomize())
      `uvm_fatal("RAND_ACT_LVL", "Randomization failed")

    ext_mask      = 16'h0000;
    en_mask       = 16'h0000;
    selected_mask = 16'h0000;

    send_tr("reset",
            1'b0,
            16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, 16'h0000,
            1'b0, 8'h00,
            8'h00,
            1'b0);

    repeat (3) begin
      send_tr("post_reset_idle",
              1'b1,
              16'h0000,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0000,
              1'b0, 8'h00,
              8'h00,
              1'b0);
    end

    repeat (irq_count) begin

      do begin
        irq = $urandom_range(10, 15);
      end while (selected_mask[irq]);

      selected_mask[irq] = 1'b1;

      ctl_val = $urandom_range(8'h01, 8'hFF);

      write_ctl($sformatf("irq_%0d_ctl", irq),
                ctl_addr(irq),
                ctl_val);

      ext_mask[irq] = 1'b1;
      en_mask[irq]  = 1'b1;

    end

    `uvm_info("RAND_ACT_LVL",
      $sformatf("IRQ count=%0d ACTIVE_LEVEL=0x%02h EXT_MASK=0x%04h ENABLE_MASK=0x%04h",
                irq_count, active_lvl, ext_mask, en_mask),
      UVM_LOW)

    send_tr("assert_random_irqs",
            1'b1,
            ext_mask,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, en_mask,
            1'b1, 8'h00,
            active_lvl,
            1'b0);

    repeat ($urandom_range(2, 8)) begin
      send_tr("wait_irq",
              1'b1,
              ext_mask,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, en_mask,
              1'b0, 8'h00,
              active_lvl,
              1'b0);
    end

    repeat (2) begin
      send_tr("wait_before_eoi",
              1'b1,
              ext_mask,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, en_mask,
              1'b0, 8'h00,
              active_lvl,
              1'b0);
    end

    send_tr("eoi_current_interrupt",
            1'b1,
            ext_mask,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b1, en_mask,
            1'b0, 8'h10,
            active_lvl,
            1'b0);

    repeat ($urandom_range(1, 5)) begin
      send_tr("idle",
              1'b1,
              16'h0000,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, en_mask,
              1'b0, 8'h00,
              active_lvl,
              1'b0);
    end

  endtask

  task write_ctl(
    string name,
    bit [15:0] addr,
    bit [7:0] data
  );

    send_tr(name,
            1'b1,
            16'h0000,
            1'b1,
            addr,
            data,
            1'b0,
            16'h0000,
            1'b0,
            16'h0000,
            1'b0,
            8'h00,
            8'h00,
            1'b0);

  endtask

  task send_tr(
    string name,
    bit soc_rst,
    bit [15:0] ext_mask,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [7:0] wr_data,
    bit rd_en,
    bit [15:0] rd_addr,
    bit eoi_valid,
    bit [15:0] enable_bits,
    bit enable_valid,
    bit [7:0] eoi_id,
    bit [7:0] active_lvl_pr,
    bit debug_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);

    start_item(tr);

    tr.soc_rst = soc_rst;
    tr.ext_int = ext_mask;

    tr.soc_mmr_write_en_i   = wr_en;
    tr.soc_mmr_write_addr_i = wr_addr;
    tr.soc_mmr_write_data_i = wr_data;

    tr.soc_mmr_read_en_i   = rd_en;
    tr.soc_mmr_read_addr_i = rd_addr;

    tr.soc_eoi_valid_i = eoi_valid;
    tr.soc_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl_pr;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = debug_valid;

    finish_item(tr);

  endtask

endclass


// ============================================================
// RANDOM ENABLE MASK SEQUENCE - 16 IRQ
// ============================================================
class random_enable_mask_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(random_enable_mask_seq)

  rand bit [7:0]  irq_ctl [16];
  rand bit [15:0] ext_mask;
  rand bit [15:0] en_mask;

    constraint valid_c {
    
      ext_mask[9:0] == 10'h000;
      en_mask[9:0]  == 10'h000;
    
      ext_mask[15:10] != 6'b000000;
      en_mask[15:10]  != 6'b000000;
    
      (ext_mask & en_mask) != 16'h0000;
    
      foreach (irq_ctl[i]) {
        irq_ctl[i] inside {[8'h01:8'hFF]};
      }
    } 
    
  function new(string name = "random_enable_mask_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int id);
    return 16'h9020 + (id * 16'h0010);
  endfunction

  function automatic int find_best_id(bit [15:0] mask);

    int best_id;
    bit [7:0] best_prio;

    best_id   = -1;
    best_prio = 8'h00;

    for (int i = 10; i < 16; i++) begin

      if (mask[i]) begin

        if ((best_id == -1) ||
            (irq_ctl[i] > best_prio) ||
            ((irq_ctl[i] == best_prio) && (i > best_id))) begin

          best_id   = i;
          best_prio = irq_ctl[i];

        end

      end

    end

    return best_id;

  endfunction

  task body();

    int best_id;

    if (!this.randomize())
      `uvm_fatal("RAND_EN_MASK_SEQ", "Randomization failed")

    best_id = find_best_id(ext_mask & en_mask);

    if (best_id < 10)
      `uvm_fatal("RAND_EN_MASK_SEQ", "Invalid interrupt winner")

    send_tr("reset",
            1'b0,
            16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, 16'h0000,
            1'b0, 8'h00,
            8'h00,
            1'b0);

    repeat (3) begin
      send_tr("post_reset_idle",
              1'b1,
              16'h0000,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0000,
              1'b0, 8'h00,
              8'h00,
              1'b0);
    end

    for (int i = 10; i < 16; i++) begin
      if (ext_mask[i]) begin
        write_ctl($sformatf("write_irq%0d_ctl", i),
                  ctl_addr(i),
                  irq_ctl[i]);
      end
    end

    send_tr("assert_random_enable_mask",
            1'b1,
            ext_mask,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, en_mask,
            1'b1, 8'h00,
            8'h00,
            1'b0);

    repeat (5) begin
      send_tr("wait_resolve",
              1'b1,
              ext_mask,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, en_mask,
              1'b0, 8'h00,
              8'h00,
              1'b0);
    end

    send_tr("eoi_enabled_winner",
            1'b1,
            ext_mask,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b1, en_mask,
            1'b0, (8'h10 + best_id),
            8'h00,
            1'b0);

    repeat (3) begin
      send_tr("idle_after_eoi",
              1'b1,
              ext_mask,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, en_mask,
              1'b0, 8'h00,
              8'h00,
              1'b0);
    end

  endtask

  task write_ctl(
    string name,
    bit [15:0] addr,
    bit [7:0] data
  );

    send_tr(name,
            1'b1,
            16'h0000,
            1'b1,
            addr,
            data,
            1'b0,
            16'h0000,
            1'b0,
            16'h0000,
            1'b0,
            8'h00,
            8'h00,
            1'b0);

  endtask

  task send_tr(
    string name,
    bit soc_rst,
    bit [15:0] ext_mask,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [7:0] wr_data,
    bit rd_en,
    bit [15:0] rd_addr,
    bit eoi_valid,
    bit [15:0] enable_bits,
    bit enable_valid,
    bit [7:0] eoi_id,
    bit [7:0] active_lvl,
    bit debug_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);

    start_item(tr);

    tr.soc_rst = soc_rst;
    tr.ext_int = ext_mask;

    tr.soc_mmr_write_en_i   = wr_en;
    tr.soc_mmr_write_addr_i = wr_addr;
    tr.soc_mmr_write_data_i = wr_data;

    tr.soc_mmr_read_en_i   = rd_en;
    tr.soc_mmr_read_addr_i = rd_addr;

    tr.soc_eoi_valid_i = eoi_valid;
    tr.soc_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = debug_valid;

    finish_item(tr);

  endtask

endclass


// ============================================================
// SAME PRIORITY RANDOM SEQUENCE - 16 IRQ
// ============================================================
class same_priority_random_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(same_priority_random_seq)

  rand int irq_id[5];
  rand bit [7:0] common_prio;

  constraint irq_c {

    foreach (irq_id[i]) {
      irq_id[i] inside {[10:15]};
    }

    foreach (irq_id[i]) {
      foreach (irq_id[j]) {
        if (i != j)
          irq_id[i] != irq_id[j];
      }
    }

    common_prio inside {[8'h01:8'hFF]};
  }

  function new(string name = "same_priority_random_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int id);
    return 16'h9020 + (id * 16'h0010);
  endfunction

  task body();

    bit [15:0] irq_mask;
    int expected_id;

    if (!this.randomize())
      `uvm_fatal("SAME_PRIO_SEQ", "Randomization failed")

    irq_mask    = 16'h0000;
    expected_id = irq_id[0];

    foreach (irq_id[i]) begin

      irq_mask[irq_id[i]] = 1'b1;

      if (irq_id[i] > expected_id)
        expected_id = irq_id[i];

    end

    `uvm_info("SAME_PRIO_SEQ",
      $sformatf("COMMON_PRIO=0x%02h EXPECTED_HIGHEST_ID=%0d IRQ_MASK=0x%04h",
                common_prio, expected_id, irq_mask),
      UVM_LOW)

    send_tr("reset",
            1'b0,
            16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, 16'h0000,
            1'b0, 8'h00,
            8'h00,
            1'b0);

    repeat (3) begin
      send_tr("post_reset_idle",
              1'b1,
              16'h0000,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0000,
              1'b0, 8'h00,
              8'h00,
              1'b0);
    end

    foreach (irq_id[i]) begin

      write_ctl($sformatf("write_irq%0d_ctl", irq_id[i]),
                ctl_addr(irq_id[i]),
                common_prio);

    end

    send_tr("assert_same_priority_irqs",
            1'b1,
            irq_mask,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, irq_mask,
            1'b1, 8'h00,
            8'h00,
            1'b0);

    repeat (5) begin
      send_tr("wait_resolve",
              1'b1,
              irq_mask,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, irq_mask,
              1'b0, 8'h00,
              8'h00,
              1'b0);
    end

    send_tr("eoi_highest_id",
            1'b1,
            irq_mask,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b1, irq_mask,
            1'b0, (8'h10 + expected_id),
            8'h00,
            1'b0);

    repeat (3) begin
      send_tr("idle_after_eoi",
              1'b1,
              irq_mask,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, irq_mask,
              1'b0, 8'h00,
              8'h00,
              1'b0);
    end

  endtask

  task write_ctl(
    string name,
    bit [15:0] addr,
    bit [7:0] data
  );

    send_tr(name,
            1'b1,
            16'h0000,
            1'b1,
            addr,
            data,
            1'b0,
            16'h0000,
            1'b0,
            16'h0000,
            1'b0,
            8'h00,
            8'h00,
            1'b0);

  endtask

  task send_tr(
    string name,
    bit soc_rst,
    bit [15:0] ext_mask,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [7:0] wr_data,
    bit rd_en,
    bit [15:0] rd_addr,
    bit eoi_valid,
    bit [15:0] enable_bits,
    bit enable_valid,
    bit [7:0] eoi_id,
    bit [7:0] active_lvl,
    bit debug_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);

    start_item(tr);

    tr.soc_rst = soc_rst;
    tr.ext_int = ext_mask;

    tr.soc_mmr_write_en_i   = wr_en;
    tr.soc_mmr_write_addr_i = wr_addr;
    tr.soc_mmr_write_data_i = wr_data;

    tr.soc_mmr_read_en_i   = rd_en;
    tr.soc_mmr_read_addr_i = rd_addr;

    tr.soc_eoi_valid_i = eoi_valid;
    tr.soc_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = debug_valid;

    finish_item(tr);

  endtask

endclass

// ============================================================
// RANDOM ALL 16 IRQ SEQUENCE
// ============================================================
class random_all_16_irq_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(random_all_16_irq_seq)

  rand bit [7:0] irq_ctl [6];
  rand bit [15:0] irq_mask;

  constraint valid_c {
    irq_mask != 16'h0000;

    foreach (irq_ctl[i]) {
      irq_ctl[i] inside {[8'h01:8'hFF]};
    }
  }

  function new(string name = "random_all_16_irq_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int irq_id);
    return 16'h9020 + (irq_id * 16'h0010);
  endfunction

  task body();

    bit [15:0] prog_mask;
    int best_id;

    if (!this.randomize())
      `uvm_fatal("RAND16_SEQ", "randomization failed")

    // All 16 IRQs are asserted
    irq_mask = 16'hFFFF;

    // Only IRQ10-15 CTLs are programmable
    prog_mask = 16'hFC00;

    send_tr("post_reset_idle",
        1'b1, 16'h0000,
        1'b0, 16'h0000, 8'h00,
        1'b0, 16'h0000,
        1'b0, 16'h0000,
        1'b0, 8'h00,
        8'h00,
        1'b0);
    
    repeat (3) begin
      send_tr("post_reset_idle",
        1'b1, 16'h0000,
        1'b0, 16'h0000, 8'h00,
        1'b0, 16'h0000,
        1'b0, 16'h0000,
        1'b0, 8'h00,
        8'h00,
        1'b0);
    end

    for (int i = 0; i < 6; i++) begin
      write_ctl($sformatf("write_irq%0d_ctl", i + 10),
                ctl_addr(i + 10),
                irq_ctl[i]);
    end

  send_tr("enable_all_assert_random_mask", 1'b1, irq_mask,
        1'b0, 16'h0000, 8'h00,
        1'b0, 16'h0000,
        1'b0, 16'hFFFF,
        1'b0, 8'h00,
        8'h00,
        1'b0);


    repeat (5) begin
      send_tr("wait_priority_resolve", 1'b1, irq_mask,
        1'b0, 16'h0000, 8'h00,
        1'b0, 16'h0000,
        1'b0, 16'hFFFF,
        1'b0, 8'h00,
        8'h00,
        1'b0);
    end

    // Remove IRQs 0-9 from expected programmable-priority
    // winner calculation. Programmable priority is tested on
    // IRQ10-15.
    best_id = 10;

    for (int i = 11; i < 16; i++) begin
      if ((irq_ctl[i-10] > irq_ctl[best_id-10]) ||
          ((irq_ctl[i-10] == irq_ctl[best_id-10]) &&
           (i > best_id))) begin
        best_id = i;
      end
    end

   send_tr("idle_before_eoi", 1'b1, irq_mask,
        1'b0, 16'h0000, 8'h00,
        1'b0, 16'h0000,
        1'b0, 16'hFFFF,
        1'b0, 8'h00,
        8'h00,
        1'b0);

    // EOI selected programmable IRQ
    irq_mask[best_id] = 1'b0;

    send_tr("eoi_first_winner", 1'b1, irq_mask,
        1'b0, 16'h0000, 8'h00,
        1'b0, 16'h0000,
        1'b1, 16'hFFFF,
        1'b0, 8'h00,
        (8'h10 + best_id),
        1'b0);

    repeat (3) begin
      send_tr("wait_next_pending", 1'b1, irq_mask,
        1'b0, 16'h0000, 8'h00,
        1'b0, 16'h0000,
        1'b0, 16'hFFFF,
        1'b0, 8'h00,
        8'h00,
        1'b0);
      end

    if (irq_mask != 16'h0000) begin
    send_tr("wait_next_pending", 1'b1, irq_mask,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, 16'hFFFF,
            1'b0, 8'h00,
            8'h00,
            1'b0);
    end

    repeat (3) begin
      send_tr("idle_before_eoi", 1'b1, irq_mask,
        1'b0, 16'h0000, 8'h00,
        1'b0, 16'h0000,
        1'b0, 16'hFFFF,
        1'b0, 8'h00,
        8'h00,
        1'b0);
      end

  endtask

     task write_ctl(
        string name,
        bit [15:0] addr,
        bit [7:0] data
    );
    
        send_tr(name, 1'b1, 16'h0000,
                1'b1, addr, data,
                1'b0, 16'h0000,
                1'b0, 16'h0000,
                1'b0, 8'h00,
                8'h00,
                1'b0);
    endtask
  task send_tr(
    string name,
    bit soc_rst,
    bit [15:0] ext_mask,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [7:0] wr_data,
    bit rd_en,
    bit [15:0] rd_addr,
    bit eoi_valid,
    bit [15:0] enable_bits,
    bit enable_valid,
    bit [7:0] eoi_id,
    bit [7:0] active_lvl,
    bit debug_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);

    start_item(tr);

    tr.soc_rst = soc_rst;
    tr.ext_int = ext_mask;

    tr.soc_mmr_write_en_i   = wr_en;
    tr.soc_mmr_write_addr_i = wr_addr;
    tr.soc_mmr_write_data_i = wr_data;

    tr.soc_mmr_read_en_i   = rd_en;
    tr.soc_mmr_read_addr_i = rd_addr;

    tr.soc_eoi_valid_i = eoi_valid;
    tr.soc_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = debug_valid;

    finish_item(tr);

  endtask

endclass

// ============================================================
// ENABLE / DISABLE MASKING SEQUENCE - 16 IRQ
// ============================================================
class enable_disable_masking_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(enable_disable_masking_seq)

  function new(string name = "enable_disable_masking_seq");
    super.new(name);
  endfunction

  task body();

    send_tr("reset", 1'b0, 16'h0000,
        1'b0, 16'h0000, 8'h00,
        1'b0, 16'h0000,
        1'b0, 16'h0000,
        1'b0, 8'h00,
        1'b0,
        1'b0);

    repeat (3)
      send_tr("post_reset_idle", 1'b1, 16'h0000,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0000,
              1'b0, 8'h00,
              1'b0);

    // IRQ10 CTL = 0x9020 + 10*0x10 = 0x90C0
    write_ctl("irq10_ctl", 16'h90C0, 8'hE0);

    // IRQ10 active, but disabled
    send_tr("irq10_active_disabled", 1'b1, 16'h0400,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b1, 16'h0000,
            1'b0, 8'h00,
            1'b0);

    repeat (5)
      send_tr("wait_disabled", 1'b1, 16'h0400,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0000,
              1'b0, 8'h00,
              1'b0);

    // Enable IRQ10 while still active
    send_tr("enable_irq10", 1'b1, 16'h0400,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, 16'h0400,
            1'b1, 8'h00,
            1'b0);

    repeat (3)
      send_tr("wait_enabled_irq10", 1'b1, 16'h0400,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0400,
              1'b0, 8'h00,
              1'b0);

    // IRQ10 EOI ID = 0x10 + 10 = 0x1A
    send_tr("eoi_irq10", 1'b1, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b1, 8'h1A,
            1'b0, 16'h0400,
            1'b0, 8'h00,
            1'b0);

    repeat (2)
      send_tr("idle_after_eoi", 1'b1, 16'h0400,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0400,
              1'b0, 8'h00,
              1'b0);

    // Disable IRQ10 again
    send_tr("disable_irq10_again", 1'b1, 16'h0400,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, 16'h0000,
            1'b1, 8'h00,
            1'b0);

    repeat (5)
      send_tr("wait_after_disable_again", 1'b1, 16'h0400,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0000,
              1'b0, 8'h00,
              1'b0);

  endtask

  task write_ctl(
    string name,
    bit [15:0] addr,
    bit [7:0] data
  );

    send_tr(name, 1'b1, 16'h0000,
            1'b1, addr, data,
            1'b0, 16'h0000,
            1'b0, 16'h0000,
            1'b0, 8'h00,
            1'b0);

  endtask

  task send_tr(
    string name,
    bit soc_rst,
    bit [15:0] ext_mask,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [7:0] wr_data,
    bit rd_en,
    bit [15:0] rd_addr,
    bit eoi_valid,
    bit [15:0] enable_bits,
    bit enable_valid,
    bit [7:0] eoi_id,
    bit [7:0] active_lvl,
    bit debug_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);

    start_item(tr);

    tr.soc_rst = soc_rst;
    tr.ext_int = ext_mask;

    tr.soc_mmr_write_en_i   = wr_en;
    tr.soc_mmr_write_addr_i = wr_addr;
    tr.soc_mmr_write_data_i = wr_data;

    tr.soc_mmr_read_en_i   = rd_en;
    tr.soc_mmr_read_addr_i = rd_addr;

    tr.soc_eoi_valid_i = eoi_valid;
    tr.soc_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = debug_valid;

    finish_item(tr);

  endtask

endclass


// ============================================================
// SIMULTANEOUS NEW IRQ DURING EOI SEQUENCE - 16 IRQ
// ============================================================
class simultaneous_new_irq_during_eoi_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(simultaneous_new_irq_during_eoi_seq)

  function new(string name = "simultaneous_new_irq_during_eoi_seq");
    super.new(name);
  endfunction

  task body();

    send_tr("reset", 1'b0, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, 16'h0000,
            1'b0, 8'h00,
            1'b0);

    repeat (3)
      send_tr("post_reset_idle", 1'b1, 16'h0000,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0000,
              1'b0, 8'h00,
              1'b0);

    // IRQ10 CTL = 0x90C0
    // IRQ11 CTL = 0x90D0
    write_ctl("irq10_ctl", 16'h90C0, 8'h20);
    write_ctl("irq11_ctl", 16'h90D0, 8'hE0);

    // Assert IRQ10 only, enable IRQ10 and IRQ11
    send_tr("assert_irq10", 1'b1, 16'h0400,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, 16'h0C00,
            1'b1, 8'h00,
            1'b0);

    repeat (3)
      send_tr("wait_irq10", 1'b1, 16'h0400,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0C00,
              1'b0, 8'h00,
              1'b0);

    // ACK is generated internally.
    // Wait until interrupt is accepted by the DUT.

    repeat (2)
      send_tr("wait_after_internal_ack10", 1'b1, 16'h0400,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0C00,
              1'b0, 8'h00,
              1'b0);

    // Same transaction:
    // EOI IRQ10 + new IRQ11 assertion
    send_tr("eoi_irq10_new_irq11", 1'b1, 16'h0800,
            1'b0, 16'h0000, 8'h00,
            1'b1, 8'h1A,
            1'b0, 16'h0C00,
            1'b0, 8'h00,
            1'b0);

    repeat (3)
      send_tr("wait_irq11", 1'b1, 16'h0800,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0C00,
              1'b0, 8'h00,
              1'b0);

    // IRQ11 EOI ID = 0x10 + 11 = 0x1B
    send_tr("eoi_irq11", 1'b1, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b1, 8'h1B,
            1'b0, 16'h0C00,
            1'b0, 8'h00,
            1'b0);

    repeat (3)
      send_tr("idle", 1'b1, 16'h0000,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0C00,
              1'b0, 8'h00,
              1'b0);

  endtask

  task write_ctl(
    string name,
    bit [15:0] addr,
    bit [7:0] data
  );

    send_tr(name, 1'b1, 16'h0000,
            1'b1, addr, data,
            1'b0, 16'h0000,
            1'b0, 16'h0000,
            1'b0, 8'h00,
            1'b0);

  endtask

  task send_tr(
    string name,
    bit soc_rst,
    bit [15:0] ext_mask,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [7:0] wr_data,
    bit rd_en,
    bit [15:0] rd_addr,
    bit eoi_valid,
    bit [15:0] enable_bits,
    bit enable_valid,
    bit [7:0] eoi_id,
    bit [7:0] active_lvl,
    bit debug_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);

    start_item(tr);

    tr.soc_rst = soc_rst;
    tr.ext_int = ext_mask;

    tr.soc_mmr_write_en_i   = wr_en;
    tr.soc_mmr_write_addr_i = wr_addr;
    tr.soc_mmr_write_data_i = wr_data;

    tr.soc_mmr_read_en_i   = rd_en;
    tr.soc_mmr_read_addr_i = rd_addr;

    tr.soc_eoi_valid_i = eoi_valid;
    tr.soc_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = debug_valid;

    finish_item(tr);

  endtask

endclass

// ============================================================
// RANDOM MULTI IRQ SEQUENCE - 16 IRQ
// ============================================================
class random_multi_irq_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(random_multi_irq_seq)

  rand int irq_a;
  rand int irq_b;
  rand int irq_c;

  rand bit [7:0] prio_a;
  rand bit [7:0] prio_b;
  rand bit [7:0] prio_c;

  constraint valid_irq_c {
    irq_a inside {[10:15]};
    irq_b inside {[10:15]};
    irq_c inside {[10:15]};

    irq_a != irq_b;
    irq_b != irq_c;
    irq_a != irq_c;

    prio_a inside {[8'h01:8'hFF]};
    prio_b inside {[8'h01:8'hFF]};
    prio_c inside {[8'h01:8'hFF]};
  }

  function new(string name = "random_multi_irq_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int irq_id);
    return 16'h9020 + (irq_id * 16'h0010);
  endfunction

  function automatic int find_best_id(
    bit [15:0] mask
  );

    int best_id;
    bit [7:0] best_prio;

    best_id   = -1;
    best_prio = 8'h00;

    for (int i = 10; i < 16; i++) begin

      if (mask[i]) begin

        if ((best_id == -1) ||
            ((i == irq_a) && (prio_a > best_prio)) ||
            ((i == irq_b) && (prio_b > best_prio)) ||
            ((i == irq_c) && (prio_c > best_prio))) begin

          best_id = i;

          if (i == irq_a)
            best_prio = prio_a;
          else if (i == irq_b)
            best_prio = prio_b;
          else
            best_prio = prio_c;

        end
        else if ((i == best_id)) begin
          // Keep current winner
        end

      end

    end

    return best_id;

  endfunction

  task body();

    bit [15:0] irq_mask;
    int best_id;

    if (!this.randomize())
      `uvm_fatal("RAND_MULTI_SEQ", "randomization failed")

    irq_mask = 16'h0000;

    irq_mask[irq_a] = 1'b1;
    irq_mask[irq_b] = 1'b1;
    irq_mask[irq_c] = 1'b1;

    send_tr("reset", 1'b0, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, 16'h0000,
            1'b0, 8'h00,
            1'b0);

    repeat (3)
      send_tr("post_reset_idle", 1'b1, 16'h0000,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0000,
              1'b0, 8'h00,
              1'b0);

    write_ctl("write_irq_a_ctl",
              ctl_addr(irq_a),
              prio_a);

    write_ctl("write_irq_b_ctl",
              ctl_addr(irq_b),
              prio_b);

    write_ctl("write_irq_c_ctl",
              ctl_addr(irq_c),
              prio_c);

    send_tr("assert_random_irqs", 1'b1, irq_mask,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, irq_mask,
            1'b1, 8'h00,
            1'b0);

    repeat (3)
      send_tr("wait_random_irqs", 1'b1, irq_mask,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, irq_mask,
              1'b0, 8'h00,
              1'b0);

    best_id = find_best_id(irq_mask);

    if (best_id < 10)
      `uvm_fatal("RAND_MULTI_SEQ",
                 "Invalid programmable IRQ winner")

    // Remove winner before EOI
    irq_mask[best_id] = 1'b0;

    send_tr("eoi_random_winner", 1'b1, irq_mask,
            1'b0, 16'h0000, 8'h00,
            1'b1, (8'h10 + best_id),
            1'b0, 16'h0FC0,
            1'b0, 8'h00,
            1'b0);

    repeat (3)
      send_tr("wait_next_pending", 1'b1, irq_mask,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0FC0,
              1'b0, 8'h00,
              1'b0);

  endtask

  task write_ctl(
    string name,
    bit [15:0] addr,
    bit [7:0] data
  );

    send_tr(name, 1'b1, 16'h0000,
            1'b1, addr, data,
            1'b0, 16'h0000,
            1'b0, 16'h0000,
            1'b0, 8'h00,
            1'b0);

  endtask

  task send_tr(
    string name,
    bit soc_rst,
    bit [15:0] ext_mask,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [7:0] wr_data,
    bit rd_en,
    bit [15:0] rd_addr,
    bit eoi_valid,
    bit [15:0] enable_bits,
    bit enable_valid,
    bit [7:0] eoi_id,
    bit [7:0] active_lvl,
    bit debug_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);

    start_item(tr);

    tr.soc_rst = soc_rst;
    tr.ext_int = ext_mask;

    tr.soc_mmr_write_en_i   = wr_en;
    tr.soc_mmr_write_addr_i = wr_addr;
    tr.soc_mmr_write_data_i = wr_data;

    tr.soc_mmr_read_en_i   = rd_en;
    tr.soc_mmr_read_addr_i = rd_addr;

    tr.soc_eoi_valid_i = eoi_valid;
    tr.soc_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = debug_valid;

    finish_item(tr);

  endtask

endclass

// ============================================================
// EOI FLOW SEQUENCE - 16 IRQ
// ============================================================
class eoi_flow_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(eoi_flow_seq)

  function new(string name = "eoi_flow_seq");
    super.new(name);
  endfunction

  task body();

    // IRQ10 = 0x0400
    // IRQ11 = 0x0800

    // Reset
    send_tr("reset", 1'b0, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, 16'h0000, 1'b0,
            8'h00, 8'h00,
            1'b0);

    repeat (3)
      send_tr("post_reset_idle", 1'b1, 16'h0000,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0000, 1'b0,
              8'h00, 8'h00,
              1'b0);

    // IRQ10 CTL = 0x90C0
    // IRQ11 CTL = 0x90D0
    write_ctl("prog_irq10_ctl", 16'h90C0, 8'h20);
    write_ctl("prog_irq11_ctl", 16'h90D0, 8'hE0);

    // Assert IRQ10 and IRQ11
    // Both enabled
    send_tr("assert_irq10_irq11", 1'b1, 16'h0C00,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, 16'h0C00, 1'b1,
            8'h00, 8'h00,
            1'b0);

    repeat (3)
      send_tr("wait_first_irq", 1'b1, 16'h0C00,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0C00, 1'b0,
              8'h00, 8'h00,
              1'b0);

    // IRQ11 has higher priority
    // ACK is generated internally by DUT
    repeat (2)
      send_tr("wait_after_internal_ack11", 1'b1, 16'h0C00,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0C00, 1'b0,
              8'h00, 8'h00,
              1'b0);

    // EOI IRQ11
    send_tr("eoi_irq11", 1'b1, 16'h0400,
            1'b0, 16'h0000, 8'h00,
            1'b1, 16'h0000,
            1'b1, 16'h0C00, 1'b0,
            8'h00, 8'h1B,
            1'b0);

    repeat (3)
      send_tr("wait_next_irq10", 1'b1, 16'h0400,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0C00, 1'b0,
              8'h00, 8'h00,
              1'b0);

    // EOI IRQ10
    send_tr("eoi_irq10", 1'b1, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b1, 16'h0000,
            1'b1, 16'h0C00, 1'b0,
            8'h00, 8'h1A,
            1'b0);

    repeat (3)
      send_tr("idle_after_eoi", 1'b1, 16'h0000,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0C00, 1'b0,
              8'h00, 8'h00,
              1'b0);

  endtask

  task write_ctl(
    string name,
    bit [15:0] addr,
    bit [7:0] data
  );

    send_tr(name, 1'b1, 16'h0000,
            1'b1, addr, data,
            1'b0, 16'h0000,
            1'b0, 16'h0000, 1'b0,
            8'h00, 8'h00,
            1'b0);

  endtask

  task send_tr(
    string name,
    bit soc_rst,
    bit [15:0] ext_mask,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [7:0] wr_data,
    bit rd_en,
    bit [15:0] rd_addr,
    bit eoi_valid,
    bit [15:0] enable_bits,
    bit enable_valid,
    bit [7:0] eoi_id,
    bit [7:0] active_lvl,
    bit debug_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);

    start_item(tr);

    tr.soc_rst = soc_rst;
    tr.ext_int = ext_mask;

    tr.soc_mmr_write_en_i   = wr_en;
    tr.soc_mmr_write_addr_i = wr_addr;
    tr.soc_mmr_write_data_i = wr_data;

    tr.soc_mmr_read_en_i   = rd_en;
    tr.soc_mmr_read_addr_i = rd_addr;

    tr.soc_eoi_valid_i = eoi_valid;
    tr.soc_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = debug_valid;

    finish_item(tr);

  endtask

endclass

// ============================================================
// RESET BASIC SEQUENCE
// ============================================================
class reset_basic_seq extends zic_comman_base_seq;

  `uvm_object_utils(reset_basic_seq)

  rand int unsigned rst_cycles;
  rand int unsigned post_idle_cycles;

  constraint c {
    rst_cycles       inside {[1:10]};
    post_idle_cycles inside {[1:10]};
  }

  function new(string name = "reset_basic_seq");
    super.new(name);
  endfunction

  task body();

    if (!this.randomize())
      `uvm_fatal("RESET_SEQ", "Randomization failed")

    repeat (rst_cycles) begin

      send_tr("random_reset",
              1'b0, 16'h0000,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'h0000, 1'b0,
              8'h00, 8'h00,
              1'b0);

    end

    idle(post_idle_cycles);

  endtask

endclass


// ============================================================
// MMR BASIC SEQUENCE
// ============================================================
class mmr_basic_seq extends zic_comman_base_seq;

  `uvm_object_utils(mmr_basic_seq)

  rand int unsigned num_ops;

  constraint c {
    num_ops inside {[20:50]};
  }

  function new(string name = "mmr_basic_seq");
    super.new(name);
  endfunction

  task body();

    int irq;
    bit [7:0] ctl_data;
    bit [15:0] rd_addr;

    if (!this.randomize())
      `uvm_fatal("MMR_SEQ", "Randomization failed")

    // ============================================================
    // READ ALL IRQ CTL ADDRESSES
    // IRQ0-9 are RO
    // IRQ10-15 are RW
    // ============================================================
    for (int i = 0; i < 16; i++) begin

      if (i >= 10) begin
        ctl_data = $urandom_range(8'h01, 8'hFF);
        write_ctl(i, ctl_data);
      end

      send_tr($sformatf("read_irq%0d_ctl", i),
              1'b1, 16'h0000,
              1'b0, 16'h0000, 8'h00,
              1'b1, ctl_addr(i),
              1'b0, 16'h0000, 1'b0,
              8'h00, 8'h00,
              1'b0);

      idle(1);

    end

    // ============================================================
    // HIT DATA VALUE 0x00
    // ============================================================
    write_ctl(10, 8'h00);

    send_tr("read_zero_data_irq10",
            1'b1, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b1, ctl_addr(10),
            1'b0, 16'h0000, 1'b0,
            8'h00, 8'h00,
            1'b0);

    idle(1);

    // ============================================================
    // HIT DATA VALUE 0xFF
    // ============================================================
    write_ctl(15, 8'hFF);

    send_tr("read_ff_data_irq15",
            1'b1, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b1, ctl_addr(15),
            1'b0, 16'h0000, 1'b0,
            8'h00, 8'h00,
            1'b0);

    idle(1);

    // ============================================================
    // HIT ALL 8-BIT DATA VALUES
    // Only writable CTL10-15
    // ============================================================
    for (int d = 0; d < 256; d++) begin

      irq = 10 + (d % 6);

      write_ctl(irq, d[7:0]);

      idle(1);

    end

    // ============================================================
    // RANDOM MMR STRESS
    // ============================================================
    repeat (num_ops) begin

      irq      = $urandom_range(10, 15);
      ctl_data = $urandom_range(8'h00, 8'hFF);
      rd_addr  = ctl_addr(irq);

      write_ctl(irq, ctl_data);

      send_tr("random_mmr_read",
              1'b1, 16'h0000,
              1'b0, 16'h0000, 8'h00,
              1'b1, rd_addr,
              1'b0, 16'h0000, 1'b0,
              8'h00, 8'h00,
              1'b0);

      idle($urandom_range(1, 3));

    end

  endtask

  function automatic bit [15:0] ctl_addr(int irq_id);

    return 16'h9020 + (irq_id * 16'h0010);

  endfunction

  task write_ctl(
    int irq_id,
    bit [7:0] data
  );

    send_tr($sformatf("write_irq%0d_ctl", irq_id),
            1'b1, 16'h0000,
            1'b1, ctl_addr(irq_id), data,
            1'b0, 16'h0000,
            1'b0, 16'h0000, 1'b0,
            8'h00, 8'h00,
            1'b0);

  endtask

endclass


// ============================================================
// SINGLE IRQ SEQUENCE
// ============================================================
class single_irq_seq extends zic_comman_base_seq;

  `uvm_object_utils(single_irq_seq)

  rand int irq;
  rand bit [7:0] irq_ctl;
  rand int unsigned eoi_delay;

  constraint c {
    irq       inside {[10:15]};
    irq_ctl   inside {[8'h01:8'hFF]};
    eoi_delay inside {[1:5]};
  }

  function new(string name = "single_irq_seq");
    super.new(name);
  endfunction

  task body();

    bit [15:0] ext;
    bit [15:0] en;

    if (!this.randomize())
      `uvm_fatal("SINGLE_IRQ_SEQ", "Randomization failed")

    ext = 16'h0000;
    en  = 16'hFC00;

    ext[irq] = 1'b1;

    write_ctl(irq, irq_ctl);

    send_tr("single_irq_assert",
            1'b1, ext,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, en, 1'b1,
            8'h00, 8'h00,
            1'b0);

    // Wait for internal ACK / interrupt acceptance
    idle(5, ext, en);

    // Keep IRQ active
    idle(eoi_delay, ext, en);

    // Clear external interrupt and send EOI
    send_tr("single_irq_clear",
            1'b1, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, en, 1'b0,
            8'h00, 8'h00,
            1'b0);

    send_tr("single_irq_eoi",
            1'b1, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b1, en, 1'b0,
            8'h00, (8'h10 + irq),
            1'b0);

    idle(3);

  endtask

endclass

// ============================================================
// MULTI IRQ SEQUENCE
// ============================================================
class multi_irq_seq extends zic_comman_base_seq;

  `uvm_object_utils(multi_irq_seq)

  rand bit [7:0] irq_ctl [6];
  rand int unsigned irq_count;
  rand int unsigned eoi_delay;

  constraint c {
    irq_count inside {[2:6]};
    eoi_delay inside {[3:10]};

    foreach (irq_ctl[i]) {
      irq_ctl[i] inside {[8'h01:8'hFF]};
    }
  }

  function new(string name = "multi_irq_seq");
    super.new(name);
  endfunction

  function automatic bit higher_priority(
    bit [7:0] cur_ctl,
    int cur_id,
    bit [7:0] best_ctl,
    int best_id
  );

    if (cur_ctl[7:5] > best_ctl[7:5])
      return 1'b1;

    if ((cur_ctl[7:5] == best_ctl[7:5]) &&
        (cur_ctl[4:2] > best_ctl[4:2]))
      return 1'b1;

    if ((cur_ctl[7:5] == best_ctl[7:5]) &&
        (cur_ctl[4:2] == best_ctl[4:2]) &&
        (cur_id > best_id))
      return 1'b1;

    return 1'b0;

  endfunction

  function automatic int find_best_id(bit [15:0] mask);

    int best_id;
    bit found;
    bit [7:0] best_ctl;

    best_id  = 10;
    found    = 1'b0;
    best_ctl = 8'h00;

    for (int i = 10; i < 16; i++) begin

      if (mask[i]) begin

        if (!found) begin
          found    = 1'b1;
          best_id  = i;
          best_ctl = irq_ctl[i-10];
        end
        else if (higher_priority(
                   irq_ctl[i-10],
                   i,
                   best_ctl,
                   best_id)) begin

          best_id  = i;
          best_ctl = irq_ctl[i-10];

        end

      end

    end

    return best_id;

  endfunction

  task body();

    bit [15:0] ext;
    bit [15:0] en;
    int irq;
    int best_id;

    if (!this.randomize())
      `uvm_fatal("MULTI_IRQ_SEQ", "Randomization failed")

    ext = 16'h0000;
    en  = 16'hFC00;

    // Program IRQ10-15
    for (int i = 10; i < 16; i++) begin
      write_ctl(i, irq_ctl[i-10]);
    end

    // Generate random number of unique active IRQs
    repeat (irq_count) begin
      irq = $urandom_range(10, 15);
      ext[irq] = 1'b1;
    end

    // Make sure at least two IRQs are active
    if ($countones(ext) < 2) begin
      ext[10] = 1'b1;
      ext[11] = 1'b1;
    end

    best_id = find_best_id(ext);

    send_tr("multi_irq_assert",
            1'b1, ext,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, en, 1'b1,
            8'h00, 8'h00,
            1'b0);

    // Wait for internal ACK
    idle(eoi_delay, ext, en);

    // Clear current external requests
    send_tr("multi_irq_clear",
            1'b1, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, en, 1'b0,
            8'h00, 8'h00,
            1'b0);

    // EOI selected winner
    send_tr("multi_irq_eoi",
            1'b1, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b1, en, 1'b0,
            8'h00, (8'h10 + best_id),
            1'b0);

    idle(3);

  endtask

endclass

// ============================================================
// PRIORITY RANGE STRESS SEQUENCE - 16 IRQ
// ============================================================
class priority_range_stress_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(priority_range_stress_seq)

  function new(string name = "priority_range_stress_seq");
    super.new(name);
  endfunction

  task body();

    bit [15:0] ext;
    bit [7:0] ctl_val;

    for (int grp = 0; grp < 4; grp++) begin

      ext = 16'h0000;

      for (int irq = 10; irq < 16; irq++) begin

        case (grp)
          0: ctl_val = 8'h10;
          1: ctl_val = 8'h40;
          2: ctl_val = 8'hA0;
          3: ctl_val = 8'hFF;
          default: ctl_val = 8'h10;
        endcase

        send_tr("cfg_priority_range",
                1'b1, 16'h0000,
                1'b1,
                16'h9020 + (irq * 16'h0010),
                ctl_val,
                1'b0, 16'h0000,
                1'b0, 16'h0000, 1'b0,
                8'h00, 8'h00,
                1'b0);

        ext[irq] = 1'b1;

      end

      send_tr("drive_priority_range",
              1'b1, ext,
              1'b0, 16'h0000, 8'h00,
              1'b0, 16'h0000,
              1'b0, 16'hFC00, 1'b1,
              8'h00, 8'h00,
              1'b0);

      repeat (3)
        send_tr("wait_priority_range",
                1'b1, ext,
                1'b0, 16'h0000, 8'h00,
                1'b0, 16'h0000,
                1'b0, 16'hFC00, 1'b0,
                8'h00, 8'h00,
                1'b0);

    end

  endtask

  task send_tr(
    string name,
    bit soc_rst,
    bit [15:0] ext_mask,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [7:0] wr_data,
    bit rd_en,
    bit [15:0] rd_addr,
    bit eoi_valid,
    bit [15:0] enable_bits,
    bit enable_valid,
    bit [7:0] eoi_id,
    bit [7:0] active_lvl,
    bit debug_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);

    start_item(tr);

    tr.soc_rst = soc_rst;
    tr.ext_int = ext_mask;

    tr.soc_mmr_write_en_i   = wr_en;
    tr.soc_mmr_write_addr_i = wr_addr;
    tr.soc_mmr_write_data_i = wr_data;

    tr.soc_mmr_read_en_i   = rd_en;
    tr.soc_mmr_read_addr_i = rd_addr;

    tr.soc_eoi_valid_i = eoi_valid;
    tr.soc_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = debug_valid;

    finish_item(tr);

  endtask

endclass


// ============================================================
// EOI WITHOUT ACK SEQUENCE - 16 IRQ
// ============================================================
class illegal_eoi_seq extends zic_comman_base_seq;

  `uvm_object_utils(illegal_eoi_seq)

  function new(string name = "illegal_eoi_seq");
    super.new(name);
  endfunction

  task body();

    // IRQ10
    // ext mask = 0x0400
    // enable   = 0x0400
    // EOI ID   = 0x1A

    // Reset
    send_tr("reset",
            1'b0, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, 16'h0000, 1'b0,
            8'h00, 8'h00,
            1'b0);

    idle(3);

    // Program IRQ10 CTL
    write_ctl(10, 8'hE0);

    // Assert IRQ10 and enable IRQ10
    send_tr("assert_irq10_no_ack",
            1'b1, 16'h0400,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, 16'h0400, 1'b1,
            8'h00, 8'h00,
            1'b0);

    // Do not wait for normal interrupt acceptance.
    // Immediately issue EOI.
    send_tr("eoi_without_ack_irq10",
            1'b1, 16'h0400,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b1, 16'h0400, 1'b0,
            8'h00, 8'h1A,
            1'b0);

    idle(5, 16'h0400, 16'h0400);

    // IRQ10 remains asserted.
    // The monitor/scoreboard should determine whether the DUT
    // correctly rejects/ignores the illegal EOI.
    send_tr("check_irq10_after_illegal_eoi",
            1'b1, 16'h0400,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, 16'h0400, 1'b0,
            8'h00, 8'h00,
            1'b0);

    idle(3, 16'h0400, 16'h0400);

  endtask

endclass


// ============================================================
// SAME IRQ REASSERT SEQUENCE - 16 IRQ / soc_*
// IRQ10 assert -> internal ACK -> clear -> EOI
// IRQ10 assert again -> internal ACK -> clear -> EOI
// ============================================================
class irq_reassert_seq extends zic_comman_base_seq;

  `uvm_object_utils(irq_reassert_seq)

  function new(string name = "irq_reassert_seq");
    super.new(name);
  endfunction

  task body();

    bit [15:0] ext;
    bit [15:0] en;

    // IRQ10
    ext = 16'h0400;
    en  = 16'h0400;

    // --------------------------------------------------------
    // RESET
    // --------------------------------------------------------
    send_tr("reset",
            1'b0, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, 16'h0000,
            1'b0,
            8'h00,
            8'h00,
            1'b0);

    idle(3);

    // --------------------------------------------------------
    // Program IRQ10 high priority
    // CTL10 = 0x90C0
    // --------------------------------------------------------
    write_ctl(10, 8'hE0);

    // ========================================================
    // FIRST IRQ10 SERVICE
    // ========================================================
    send_tr("irq10_assert_first",
            1'b1, ext,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, en,
            1'b1,
            8'h00,
            8'h00,
            1'b0);

    // Allow interrupt resolver/internal ACK to occur
    idle(5, ext, en);

    // ACK is generated internally.
    // No ack_valid transaction is required.
    send_tr("irq10_wait_after_ack_first",
            1'b1, ext,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, en,
            1'b0,
            8'h00,
            8'h00,
            1'b0);

    idle(2, ext, en);

    // --------------------------------------------------------
    // Clear external interrupt before EOI
    // --------------------------------------------------------
    send_tr("irq10_clear_first",
            1'b1, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, en,
            1'b0,
            8'h00,
            8'h00,
            1'b0);

    idle(2, 16'h0000, en);

    // --------------------------------------------------------
    // EOI IRQ10
    // EOI ID = 8'h1A
    // --------------------------------------------------------
    send_tr("irq10_eoi_first",
            1'b1, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b1, en,
            1'b0,
            8'h1A,
            8'h00,
            1'b0);

    idle(4, 16'h0000, en);

    // ========================================================
    // REASSERT SAME IRQ10
    // ========================================================
    send_tr("irq10_reassert_second",
            1'b1, ext,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, en,
            1'b1,
            8'h00,
            8'h00,
            1'b0);

    idle(5, ext, en);

    // Internal ACK
    send_tr("irq10_wait_after_ack_second",
            1'b1, ext,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, en,
            1'b0,
            8'h00,
            8'h00,
            1'b0);

    idle(2, ext, en);

    // --------------------------------------------------------
    // Clear external interrupt
    // --------------------------------------------------------
    send_tr("irq10_clear_second",
            1'b1, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, en,
            1'b0,
            8'h00,
            8'h00,
            1'b0);

    idle(2, 16'h0000, en);

    // --------------------------------------------------------
    // EOI IRQ10
    // --------------------------------------------------------
    send_tr("irq10_eoi_second",
            1'b1, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b1, en,
            1'b0,
            8'h1A,
            8'h00,
            1'b0);

    idle(5);

  endtask

endclass


// ============================================================
// ALL INTERRUPTS HIGH SEQUENCE - 16 IRQ
//
// Assert IRQ0-IRQ15 together
// Enable IRQ0-IRQ15 together
//
// CTL0-CTL9 are RO, so only CTL10-CTL15 are programmed.
//
// Highest programmed priority:
// IRQ15 = 0xFF
// Expected highest programmable interrupt = IRQ15
// Expected interrupt ID = 8'h1F
// ============================================================
class all_interrupts_high_seq extends zic_comman_base_seq;

  `uvm_object_utils(all_interrupts_high_seq)

  function new(string name = "all_interrupts_high_seq");
    super.new(name);
  endfunction

  task body();

    bit [15:0] ext;
    bit [15:0] en;

    ext = 16'hFFFF;
    en  = 16'hFFFF;

    // --------------------------------------------------------
    // RESET
    // --------------------------------------------------------
    send_tr("reset",
            1'b0, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, 16'h0000,
            1'b0,
            8'h00,
            8'h00,
            1'b0);

    idle(3);

    // --------------------------------------------------------
    // Program only writable CTL registers: IRQ10-IRQ15
    // --------------------------------------------------------
    for (int i = 10; i < 16; i++) begin
      write_ctl(i, 8'h10 + ((i - 10) * 8'h20));
    end

    // Explicitly make IRQ15 highest priority
    write_ctl(15, 8'hFF);

    // --------------------------------------------------------
    // Assert all interrupts and enable all
    // --------------------------------------------------------
    send_tr("assert_all_interrupts_high",
            1'b1, ext,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, en,
            1'b1,
            8'h00,
            8'h00,
            1'b0);

    // Wait for internal priority resolver / ACK
    idle(5, ext, en);

    // --------------------------------------------------------
    // ACK is internal.
    // Wait for monitor/checker to observe IRQ15.
    // --------------------------------------------------------
    send_tr("wait_after_internal_ack",
            1'b1, ext,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, en,
            1'b0,
            8'h00,
            8'h00,
            1'b0);

    idle(3, ext, en);

    // --------------------------------------------------------
    // Clear all external interrupts
    // --------------------------------------------------------
    send_tr("clear_all_interrupts",
            1'b1, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b0, en,
            1'b0,
            8'h00,
            8'h00,
            1'b0);

    // --------------------------------------------------------
    // EOI IRQ15
    // ID = 8'h1F
    // --------------------------------------------------------
    send_tr("eoi_irq15",
            1'b1, 16'h0000,
            1'b0, 16'h0000, 8'h00,
            1'b0, 16'h0000,
            1'b1, en,
            1'b0,
            8'h1F,
            8'h00,
            1'b0);

    idle(5);

  endtask

endclass


// ============================================================
// FULL REGRESSION SEQUENCE - 16 IRQ
// ============================================================
class zic_full_regression_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(zic_full_regression_seq)

  reset_basic_seq                  reset_seq;
  mmr_basic_seq                    mmr_seq;
  single_irq_seq                   single_seq;
  multi_irq_seq                    multi_seq;
  random_enable_mask_seq           enable_seq;
  random_equal_priority_seq        equal_seq;
  same_priority_random_seq         same_pri_seq;
  dynamic_priority_override_seq    dyn_pri_seq;
  random_eoi_progression_seq       eoi_seq;
  random_all_16_irq_seq             all_irq_seq;
  random_interrupt_storm_seq        storm_seq;
  rand_storm_seq                    rand_storm;
  priority_range_stress_seq         pri_seq;
  random_active_level_priority_seq  active_lvl_seq;
  illegal_eoi_seq                   illegal_eoi_s;
  irq_reassert_seq                  reassert_seq;
  all_interrupts_high_seq            all_high_seq;

  function new(string name = "zic_full_regression_seq");
    super.new(name);
  endfunction

  task body();

    `uvm_info("ZIC_REG_SEQ",
              "FULL ZIC 16-IRQ RANDOM REGRESSION STARTED",
              UVM_LOW)

    // --------------------------------------------------------
    // RESET
    // --------------------------------------------------------
    repeat (10) begin
      reset_seq = reset_basic_seq::type_id::create("reset_seq");
      reset_seq.start(m_sequencer);
    end

    // --------------------------------------------------------
    // MMR
    // --------------------------------------------------------
    repeat (20) begin
      mmr_seq = mmr_basic_seq::type_id::create("mmr_seq");
      mmr_seq.start(m_sequencer);
    end

    // --------------------------------------------------------
    // SINGLE IRQ
    // --------------------------------------------------------
    repeat (30) begin
      single_seq = single_irq_seq::type_id::create("single_seq");
      single_seq.start(m_sequencer);
    end

    // --------------------------------------------------------
    // MULTI IRQ
    // --------------------------------------------------------
    repeat (30) begin
      multi_seq = multi_irq_seq::type_id::create("multi_seq");
      multi_seq.start(m_sequencer);
    end

    // --------------------------------------------------------
    // RANDOM ENABLE MASK
    // --------------------------------------------------------
    repeat (30) begin
      enable_seq =
        random_enable_mask_seq::type_id::create("enable_seq");
      enable_seq.start(m_sequencer);
    end

    // --------------------------------------------------------
    // EQUAL PRIORITY
    // --------------------------------------------------------
    repeat (30) begin
      equal_seq =
        random_equal_priority_seq::type_id::create("equal_seq");
      equal_seq.start(m_sequencer);
    end

    // --------------------------------------------------------
    // SAME PRIORITY RANDOM
    // --------------------------------------------------------
    repeat (30) begin
      same_pri_seq =
        same_priority_random_seq::type_id::create("same_pri_seq");
      same_pri_seq.start(m_sequencer);
    end

    // --------------------------------------------------------
    // DYNAMIC PRIORITY
    // --------------------------------------------------------
    repeat (30) begin
      dyn_pri_seq =
        dynamic_priority_override_seq::type_id::create("dyn_pri_seq");
      dyn_pri_seq.start(m_sequencer);
    end

    // --------------------------------------------------------
    // EOI
    // --------------------------------------------------------
    repeat (30) begin
      eoi_seq =
        random_eoi_progression_seq::type_id::create("eoi_seq");
      eoi_seq.start(m_sequencer);
    end

    // --------------------------------------------------------
    // ALL 16 IRQ
    // --------------------------------------------------------
    repeat (10) begin
      all_irq_seq =
        random_all_16_irq_seq::type_id::create("all_irq_seq");
      all_irq_seq.start(m_sequencer);
    end

    // --------------------------------------------------------
    // PRIORITY RANGE
    // --------------------------------------------------------
    repeat (20) begin
      pri_seq =
        priority_range_stress_seq::type_id::create("pri_seq");
      pri_seq.start(m_sequencer);
    end

    // --------------------------------------------------------
    // ACTIVE LEVEL PRIORITY
    // --------------------------------------------------------
    repeat (50) begin
      active_lvl_seq =
        random_active_level_priority_seq::type_id::create(
          "active_lvl_seq");

      active_lvl_seq.start(m_sequencer);
    end

    // --------------------------------------------------------
    // ILLEGAL EOI
    // --------------------------------------------------------
    repeat (20) begin
      illegal_eoi_s =
        illegal_eoi_seq::type_id::create("illegal_eoi_s");
      illegal_eoi_s.start(m_sequencer);
    end

    // --------------------------------------------------------
    // SAME IRQ REASSERT
    // --------------------------------------------------------
    repeat (20) begin
      reassert_seq =
        irq_reassert_seq::type_id::create("reassert_seq");
      reassert_seq.start(m_sequencer);
    end

    // --------------------------------------------------------
    // ALL INTERRUPTS HIGH
    // --------------------------------------------------------
    repeat (20) begin
      all_high_seq =
        all_interrupts_high_seq::type_id::create("all_high_seq");
      all_high_seq.start(m_sequencer);
    end

    // --------------------------------------------------------
    // RANDOM INTERRUPT STORM
    // --------------------------------------------------------
    storm_seq =
      random_interrupt_storm_seq::type_id::create("storm_seq");

    storm_seq.storm_cycles = 500;
    storm_seq.start(m_sequencer);

    // --------------------------------------------------------
    // RANDOM STORM
    // --------------------------------------------------------
    rand_storm =
      rand_storm_seq::type_id::create("rand_storm");

    rand_storm.storm_cycles = 1000;
    rand_storm.start(m_sequencer);

    `uvm_info("ZIC_REG_SEQ",
              "FULL ZIC 16-IRQ RANDOM REGRESSION COMPLETED",
              UVM_LOW)

  endtask

endclass
