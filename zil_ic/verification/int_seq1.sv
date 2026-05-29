


// ============================================================
// COMMON BASE FOR ONLY reset_basic_seq
//mmr_basic_seq
//single_irq_seq
//multi_irq_seq
// ============================================================
class zic_comman_base_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(zic_comman_base_seq)

  localparam bit [47:0] VALID_IRQ_MASK = 48'h0000_7FFF_FFFF_FFFE;

  function new(string name = "zic_comman_base_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int id);
    return 16'h1003 + (id * 4);
  endfunction

  task send_tr(
    string name,
    bit zic_rst,
    bit [47:0] ext_int,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [31:0] wr_data,
    bit rd_en,
    bit [15:0] rd_addr,
    bit eoi_valid,
    bit [7:0] eoi_id,
    bit [47:0] enable_bits,
    bit enable_valid,
    bit [7:0] active_lvl,
    bit ack_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);
    start_item(tr);

    tr.zic_rst = zic_rst;
    tr.ext_int = ext_int;

    tr.zic_mmr_write_en_i   = wr_en;
    tr.zic_mmr_write_addr_i = wr_addr;
    tr.zic_mmr_write_data_i = wr_data;

    tr.zic_mmr_read_en_i   = rd_en;
    tr.zic_mmr_read_addr_i = rd_addr;

    tr.zic_ack_read_valid_en = ack_valid;

    tr.zic_eoi_valid_i = eoi_valid;
    tr.zic_eoi_id_i    = eoi_id;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.active_lvl_pr_i = active_lvl;

    tr.debug_mode_valid_i = 1'b0;
    tr.debug_mode_reset_i = 1'b0;
    tr.debug_ndm_reset_i  = 1'b0;

    finish_item(tr);

  endtask

  task idle(
    int n,
    bit [47:0] ext = 48'h0,
    bit [47:0] en  = VALID_IRQ_MASK
  );
    repeat (n) begin
      send_tr("idle",
              0, ext,
              0, 16'h0, 32'h0,
              0, 16'h0,
              0, 8'h00,
              en, 0,
              8'h00,
              0);
    end
  endtask

  task write_ctl(int irq, bit [7:0] ctl);
    send_tr($sformatf("write_ctl_irq%0d", irq),
            0, 48'h0,
            1, ctl_addr(irq), {24'h0, ctl},
            0, 16'h0,
            0, 8'h00,
            VALID_IRQ_MASK, 0,
            8'h00,
            0);
  endtask

endclass


class random_interrupt_storm_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(random_interrupt_storm_seq)

  rand bit [7:0] irq_ctl [48];

  rand int unsigned irq_count;
  rand int unsigned irq_group;
  rand int unsigned prio_group;

  int unsigned storm_cycles = 1000;

  localparam bit [47:0] VALID_IRQ_MASK = 48'h0000_7FFF_FFFF_FFFE;

  constraint ctl_c {
    foreach (irq_ctl[i]) irq_ctl[i] inside {[8'h01:8'hFF]};
  }

  constraint cov_bias_c {

    irq_count dist {
      1       := 35,
      2       := 35,
      [3:5]   := 15,
      [6:15]  := 10,
      [16:46] := 15
    };

    irq_group dist {
      0 := 40,
      1 := 40,
      2 := 25,
      3 := 25,
      4 := 25,
      5 := 25
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
    return 16'h1003 + (id * 4);
  endfunction

  function automatic bit [3:0] get_level(bit [7:0] ctl);
    return ctl[7:4];
  endfunction

  function automatic int rand_irq_from_group(int group_id);
    case (group_id)
      0: return $urandom_range(1, 7);
      1: return $urandom_range(8, 15);
      2: return $urandom_range(16, 23);
      3: return $urandom_range(24, 31);
      4: return $urandom_range(32, 39);
      5: return $urandom_range(40, 46);
      default: return $urandom_range(1, 46);
    endcase
  endfunction

  function automatic bit [7:0] rand_ctl_from_group(int group_id);
    case (group_id)
      0: return $urandom_range(8'h01, 8'h3F);
      1: return $urandom_range(8'h40, 8'h9F);
      2: return $urandom_range(8'hA0, 8'hFF);
      default: return $urandom_range(8'h01, 8'hFF);
    endcase
  endfunction

  function automatic int find_best_id(bit [47:0] mask);

    int best_id;
    bit best_found;
    bit [3:0] best_level;
    bit [3:0] cur_level;

    best_id    = 0;
    best_found = 1'b0;
    best_level = 4'h0;

    for (int i = 1; i <= 46; i++) begin
      if (mask[i]) begin
        cur_level = get_level(irq_ctl[i]);

        if (!best_found) begin
          best_found = 1'b1;
          best_id    = i;
          best_level = cur_level;
        end
        else if (cur_level > best_level) begin
          best_id    = i;
          best_level = cur_level;
        end
        else if ((cur_level == best_level) && (i > best_id)) begin
          best_id    = i;
          best_level = cur_level;
        end
      end
    end

    if (!best_found)
      return -1;

    return best_id;

  endfunction

  task body();

    bit [47:0] ext_mask;
    bit [47:0] en_mask;
    bit [47:0] eligible_mask;

    int best_id;
    int wait_cycles;
    bit [7:0] active_lvl_rand;

    if (!this.randomize())
      `uvm_fatal("RAND_STORM_SEQ", "Initial randomization failed")

    `uvm_info("RAND_STORM_SEQ",
      $sformatf("Starting random interrupt storm, cycles=%0d", storm_cycles),
      UVM_LOW)

    // ------------------------------------------------------------
    // Reset - keep same as your old passing style
    // ------------------------------------------------------------
    send_tr("reset",
            1, 48'h0,
            0, 16'h0, 32'h0,
            0, 16'h0,
            0, 8'h00,
            48'h0, 0,
            8'h00,
            0,
            0, 0, 0);

    irq_ctl[0]  = 8'h00;
    irq_ctl[47] = 8'h00;

    // ------------------------------------------------------------
    // Initial CTL programming
    // ------------------------------------------------------------
    for (int i = 1; i <= 46; i++) begin
      send_tr($sformatf("mmr_write_irq%0d_ctl", i),
              0, 48'h0,
              1, ctl_addr(i), {24'h0, irq_ctl[i]},
              0, 16'h0,
              0, 8'h00,
              48'h0, 0,
              8'h00,
              0,
              0, 0, 0);
    end

    // ------------------------------------------------------------
    // Initial settle after first programming
    // ------------------------------------------------------------
    repeat (5) begin
      send_tr("initial_ctl_settle",
              0, 48'h0,
              0, 16'h0, 32'h0,
              0, 16'h0,
              0, 8'h00,
              48'h0, 0,
              8'h00,
              0,
              0, 0, 0);
    end

    // ------------------------------------------------------------
    // Main storm loop
    // ------------------------------------------------------------
    repeat (storm_cycles) begin

      if (!this.randomize())
        `uvm_fatal("RAND_STORM_SEQ", "Loop randomization failed")

      ext_mask = 48'h0;
      en_mask  = 48'h0;

      // ----------------------------------------------------------
      // Re-program CTL values
      // ----------------------------------------------------------
      for (int i = 1; i <= 46; i++) begin

        irq_ctl[i] = rand_ctl_from_group(prio_group);

        send_tr($sformatf("cov_mmr_write_irq%0d_ctl", i),
                0, 48'h0,
                1, ctl_addr(i), {24'h0, irq_ctl[i]},
                0, 16'h0,
                0, 8'h00,
                48'h0, 0,
                8'h00,
                0,
                0, 0, 0);
      end

      // ----------------------------------------------------------
      // IMPORTANT FIX:
      // Settle after CTL programming before driving IRQ.
      // This prevents highest_pending and ack_read_valid_en
      // from occurring in the same initial timing window.
      // ----------------------------------------------------------
      repeat (8) begin
        send_tr("settle_after_ctl_programming",
                0, 48'h0,
                0, 16'h0, 32'h0,
                0, 16'h0,
                0, 8'h00,
                48'h0, 0,
                8'h00,
                0,
                0, 0, 0);
      end

      // ----------------------------------------------------------
      // Generate active/enabled IRQs
      // ----------------------------------------------------------
      repeat (irq_count) begin
        int irq;
        irq = rand_irq_from_group(irq_group);
        ext_mask[irq] = 1'b1;
        en_mask[irq]  = 1'b1;
      end

      if ((ext_mask & en_mask) == 48'h0) begin
        int irq;
        irq = rand_irq_from_group(irq_group);
        ext_mask[irq] = 1'b1;
        en_mask[irq]  = 1'b1;
      end

      eligible_mask = ext_mask & en_mask;
      best_id       = find_best_id(eligible_mask);

      wait_cycles     = $urandom_range(6, 10);
      active_lvl_rand = 8'h00;

      `uvm_info("RAND_STORM_SEQ",
        $sformatf("ext=0x%0h en=0x%0h best_id=%0d exp_ack=0x%0h ctl=0x%0h level=0x%0h",
                  ext_mask,
                  en_mask,
                  best_id,
                  8'h10 + best_id[7:0],
                  irq_ctl[best_id],
                  get_level(irq_ctl[best_id])),
        UVM_LOW)

      // ----------------------------------------------------------
      // Drive interrupt + enable
      // ----------------------------------------------------------
      send_tr("drive_ext_irq_and_global_enable",
              0, ext_mask,
              0, 16'h0, 32'h0,
              0, 16'h0,
              0, 8'h00,
              en_mask, 1,
              active_lvl_rand,
              0,
              0, 0, 0);

      // ----------------------------------------------------------
      // Wait for highest_pending/interrupt_request to become stable
      // ----------------------------------------------------------
      repeat (wait_cycles) begin
        send_tr("wait_priority_resolve",
                0, ext_mask,
                0, 16'h0, 32'h0,
                0, 16'h0,
                0, 8'h00,
                en_mask, 0,
                active_lvl_rand,
                0,
                0, 0, 0);
      end

      // ----------------------------------------------------------
      // Optional MMR read, then settle before ACK
      // ----------------------------------------------------------
      if ($urandom_range(0, 3) == 0) begin
        int rd_irq;
        rd_irq = $urandom_range(1, 46);

        send_tr("mmr_read_random_ctl",
                0, ext_mask,
                0, 16'h0, 32'h0,
                1, ctl_addr(rd_irq),
                0, 8'h00,
                en_mask, 0,
                active_lvl_rand,
                0,
                0, 0, 0);

        repeat (3) begin
          send_tr("settle_after_mmr_read",
                  0, ext_mask,
                  0, 16'h0, 32'h0,
                  0, 16'h0,
                  0, 8'h00,
                  en_mask, 0,
                  active_lvl_rand,
                  0,
                  0, 0, 0);
        end
      end

      // ----------------------------------------------------------
      // ACK read valid after stable priority output
      // ----------------------------------------------------------
      send_tr("ack_current_irq",
              0, ext_mask,
              0, 16'h0, 32'h0,
              0, 16'h0,
              0, 8'h00,
              en_mask, 0,
              active_lvl_rand,
              1,
              0, 0, 0);

      // ----------------------------------------------------------
      // Hold after ACK
      // ----------------------------------------------------------
      repeat (3) begin
        send_tr("idle_after_ack",
                0, ext_mask,
                0, 16'h0, 32'h0,
                0, 16'h0,
                0, 8'h00,
                en_mask, 0,
                active_lvl_rand,
                0,
                0, 0, 0);
      end

      // ----------------------------------------------------------
      // Clear external IRQ before EOI
      // ----------------------------------------------------------
      send_tr("clear_ext_before_eoi",
              0, 48'h0,
              0, 16'h0, 32'h0,
              0, 16'h0,
              0, 8'h00,
              en_mask, 0,
              active_lvl_rand,
              0,
              0, 0, 0);

      // ----------------------------------------------------------
      // EOI served interrupt
      // ----------------------------------------------------------
      if (best_id >= 1) begin
        send_tr("eoi_served_irq",
                0, 48'h0,
                0, 16'h0, 32'h0,
                0, 16'h0,
                1, 8'h10 + best_id[7:0],
                en_mask, 0,
                active_lvl_rand,
                0,
                0, 0, 0);
      end

      repeat (3) begin
        send_tr("clear_irq_idle",
                0, 48'h0,
                0, 16'h0, 32'h0,
                0, 16'h0,
                0, 8'h00,
                en_mask, 0,
                8'h00,
                0,
                0, 0, 0);
      end

    end

  endtask

  task send_tr(
    string name,
    bit do_reset,
    bit [47:0] ext_int,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [31:0] wr_data,
    bit rd_en,
    bit [15:0] rd_addr,
    bit eoi_valid,
    bit [7:0] eoi_id,
    bit [47:0] enable_bits,
    bit enable_valid,
    bit [7:0] active_lvl,
    bit ack_valid,
    bit debug_valid,
    bit debug_reset,
    bit debug_ndm_reset
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);
    start_item(tr);

    tr.zic_rst = do_reset;
    tr.ext_int = ext_int;

    tr.zic_mmr_write_en_i   = wr_en;
    tr.zic_mmr_write_addr_i = wr_addr;
    tr.zic_mmr_write_data_i = wr_data;

    tr.zic_mmr_read_en_i    = rd_en;
    tr.zic_mmr_read_addr_i  = rd_addr;

    tr.zic_ack_read_valid_en = ack_valid;

    tr.zic_eoi_valid_i = eoi_valid;
    tr.zic_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = debug_valid;
    tr.debug_mode_reset_i = debug_reset;
    tr.debug_ndm_reset_i  = debug_ndm_reset;

    finish_item(tr);

  endtask

endclass

class rand_storm_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(rand_storm_seq)

  int_seq_item tr;

  bit [7:0] irq_ctl [48];

  int unsigned storm_cycles = 1000;

  localparam bit [47:0] VALID_IRQ_MASK = 48'h0000_7FFF_FFFF_FFFE;

  function new(string name = "rand_storm_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int id);
    return 16'h1003 + (id * 4);
  endfunction

  // 1. Higher level    = ctl[7:5]
  // 2. Higher priority = ctl[4:2]
  // 3. Tie             = higher IRQ ID
  function automatic int find_best_id(bit [47:0] mask);

    int best_id;
    bit found;

    bit [2:0] best_lvl;
    bit [2:0] best_pri;
    bit [2:0] cur_lvl;
    bit [2:0] cur_pri;

    best_id  = 0;
    found    = 0;
    best_lvl = 0;
    best_pri = 0;

    for (int i = 1; i <= 46; i++) begin

      if (mask[i]) begin

        cur_lvl = irq_ctl[i][7:5];
        cur_pri = irq_ctl[i][4:2];

        if (!found) begin
          found    = 1;
          best_id  = i;
          best_lvl = cur_lvl;
          best_pri = cur_pri;
        end
        else if (cur_lvl > best_lvl) begin
          best_id  = i;
          best_lvl = cur_lvl;
          best_pri = cur_pri;
        end
        else if ((cur_lvl == best_lvl) && (cur_pri > best_pri)) begin
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
    bit do_reset,
    bit [47:0] ext_mask,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [31:0] wr_data,
    bit ack_valid,
    bit eoi_valid,
    bit [7:0] eoi_id,
    bit [47:0] en_mask,
    bit en_valid
  );

    tr = int_seq_item::type_id::create(name);
    start_item(tr);

    tr.zic_rst = do_reset;

    tr.ext_int = ext_mask;

    tr.zic_mmr_write_en_i   = wr_en;
    tr.zic_mmr_write_addr_i = wr_addr;
    tr.zic_mmr_write_data_i = wr_data;

    tr.zic_mmr_read_en_i    = 1'b0;
    tr.zic_mmr_read_addr_i  = 16'h0;

    tr.zic_ack_read_valid_en = ack_valid;

    tr.zic_eoi_valid_i = eoi_valid;
    tr.zic_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = 8'h00;

    tr.global_int_enable_bit_i   = en_mask;
    tr.global_int_enable_valid_i = en_valid;

    tr.debug_mode_valid_i = 1'b0;
    tr.debug_mode_reset_i = 1'b0;
    tr.debug_ndm_reset_i  = 1'b0;

    finish_item(tr);

  endtask

  task body();

    int i;
    int n;
    int irq;
    int best_id;

    bit [47:0] rand_ext;
    bit [47:0] active_mask;

    // ------------------------------------------------------------
    // 1. Reset
    // ------------------------------------------------------------
    send_tr("reset",
            1'b1,
            48'h0,
            1'b0, 16'h0, 32'h0,
            1'b0,
            1'b0, 8'h00,
            48'h0,
            1'b0);

    // ------------------------------------------------------------
    // 2. Configure IRQ1 to IRQ46
    // ------------------------------------------------------------
    irq_ctl[0]  = 8'h00;
    irq_ctl[47] = 8'h00;

    for (i = 1; i <= 46; i++) begin

      irq_ctl[i] = $urandom_range(8'h20, 8'hFF);

      send_tr($sformatf("cfg_irq_%0d", i),
              1'b0,
              48'h0,
              1'b1,
              ctl_addr(i),
              {24'h0, irq_ctl[i]},
              1'b0,
              1'b0, 8'h00,
              48'h0,
              1'b0);
    end

    // ------------------------------------------------------------
    // 3. Enable IRQ1 to IRQ46 once
    // ------------------------------------------------------------
    send_tr("enable_irq_1_to_46",
            1'b0,
            48'h0,
            1'b0, 16'h0, 32'h0,
            1'b0,
            1'b0, 8'h00,
            VALID_IRQ_MASK,
            1'b1);

    // ------------------------------------------------------------
    // 4. Random interrupt storm
    // ------------------------------------------------------------
    repeat (storm_cycles) begin

      rand_ext = 48'h0;

      n = $urandom_range(1, 5);

      for (i = 0; i < n; i++) begin
        irq = $urandom_range(1, 46);
        rand_ext[irq] = 1'b1;
      end

      active_mask = rand_ext & VALID_IRQ_MASK;
      best_id     = find_best_id(active_mask);

      `uvm_info("RAND_STORM_SEQ",
        $sformatf("rand_ext=0x%0h best_id=%0d exp_ack=0x%0h ctl=0x%0h level=0x%0h pri=0x%0h",
                  rand_ext,
                  best_id,
                  8'h10 + best_id[7:0],
                  irq_ctl[best_id],
                  irq_ctl[best_id][7:5],
                  irq_ctl[best_id][4:2]),
        UVM_LOW)

      // A. Assert random interrupt lines
      send_tr("rand_irq_assert",
              1'b0,
              rand_ext,
              1'b0, 16'h0, 32'h0,
              1'b0,
              1'b0, 8'h00,
              VALID_IRQ_MASK,
              1'b0);

      // B. Wait for priority resolver
      repeat (4) begin
        send_tr("wait_priority_resolve",
                1'b0,
                rand_ext,
                1'b0, 16'h0, 32'h0,
                1'b0,
                1'b0, 8'h00,
                VALID_IRQ_MASK,
                1'b0);
      end

      // C. ACK read
      send_tr("rand_irq_ack",
              1'b0,
              rand_ext,
              1'b0, 16'h0, 32'h0,
              1'b1,
              1'b0, 8'h00,
              VALID_IRQ_MASK,
              1'b0);

      // D. Hold one cycle after ACK
      send_tr("idle_after_ack",
              1'b0,
              rand_ext,
              1'b0, 16'h0, 32'h0,
              1'b0,
              1'b0, 8'h00,
              VALID_IRQ_MASK,
              1'b0);

      // E. Clear external interrupt before EOI
      send_tr("clear_ext_before_eoi",
              1'b0,
              48'h0,
              1'b0, 16'h0, 32'h0,
              1'b0,
              1'b0, 8'h00,
              VALID_IRQ_MASK,
              1'b0);

      // F. EOI for served interrupt
      send_tr("eoi_served_irq",
              1'b0,
              48'h0,
              1'b0, 16'h0, 32'h0,
              1'b0,
              1'b1, 8'h10 + best_id[7:0],
              VALID_IRQ_MASK,
              1'b0);

      // G. Idle after EOI
      repeat (3) begin
        send_tr("clear_irq_idle",
                1'b0,
                48'h0,
                1'b0, 16'h0, 32'h0,
                1'b0,
                1'b0, 8'h00,
                VALID_IRQ_MASK,
                1'b0);
      end

    end

  endtask

endclass


class dynamic_priority_override_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(dynamic_priority_override_seq)

  rand int low_irq;
  rand int high_irq;

  constraint irq_c {
    low_irq  inside {[0:23]};
    high_irq inside {[24:47]};
    low_irq != high_irq;
  }

  function new(string name = "dynamic_priority_override_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int id);
    return 16'h1003 + (id * 4);
  endfunction

  task body();

    bit [47:0] enable_mask;
    bit [47:0] low_mask;
    bit [47:0] both_mask;

    if (!this.randomize()) begin
      `uvm_fatal("DYN_PRIO_SEQ", "Randomization failed")
    end

    enable_mask = 48'h0;
    low_mask    = 48'h0;
    both_mask   = 48'h0;

    enable_mask[low_irq]  = 1'b1;
    enable_mask[high_irq] = 1'b1;

    low_mask[low_irq] = 1'b1;

    both_mask[low_irq]  = 1'b1;
    both_mask[high_irq] = 1'b1;

    `uvm_info("DYN_PRIO_SEQ",
      $sformatf("LOW_IRQ=%0d LOW_ACK=0x%0h PRIO=0x20 | HIGH_IRQ=%0d HIGH_ACK=0x%0h PRIO=0xE0",
                low_irq,  8'h10 + low_irq[7:0],
                high_irq, 8'h10 + high_irq[7:0]),
      UVM_LOW)

    // RESET
    send_tr("reset", 1, 48'h0,
            0, 16'h0, 32'h0,
            0, 8'h0,
            48'h0, 0,
            8'h00, 0);

    // Program low IRQ = 0x20
    write_ctl($sformatf("write_low_irq%0d_ctl", low_irq),
              ctl_addr(low_irq),
              8'h20);

    // Program high IRQ = 0xE0
    write_ctl($sformatf("write_high_irq%0d_ctl", high_irq),
              ctl_addr(high_irq),
              8'hE0);

    // Assert only low IRQ first
    send_tr("assert_low_irq_only", 0, low_mask,
            0, 16'h0, 32'h0,
            0, 8'h0,
            enable_mask, 1,
            8'h00, 0);

    repeat (5) begin
      send_tr("wait_low_irq_resolve", 0, low_mask,
              0, 16'h0, 32'h0,
              0, 8'h0,
              enable_mask, 0,
              8'h00, 0);
    end

    // ACK low IRQ first
    send_tr("ack_low_irq", 0, low_mask,
            0, 16'h0, 32'h0,
            0, 8'h0,
            enable_mask, 0,
            8'h00, 1);

    repeat (2) begin
      send_tr("idle_after_low_ack", 0, low_mask,
              0, 16'h0, 32'h0,
              0, 8'h0,
              enable_mask, 0,
              8'h00, 0);
    end

    // Now high-priority IRQ arrives while low IRQ is still active
    send_tr("high_irq_arrives", 0, both_mask,
            0, 16'h0, 32'h0,
            0, 8'h0,
            enable_mask, 0,
            8'h00, 0);

    repeat (5) begin
      send_tr("wait_high_override", 0, both_mask,
              0, 16'h0, 32'h0,
              0, 8'h0,
              enable_mask, 0,
              8'h00, 0);
    end

    // ACK should now be high IRQ
    send_tr("ack_high_irq_override", 0, both_mask,
            0, 16'h0, 32'h0,
            0, 8'h0,
            enable_mask, 0,
            8'h00, 1);

    repeat (3) begin
      send_tr("idle_after_high_ack", 0, both_mask,
              0, 16'h0, 32'h0,
              0, 8'h0,
              enable_mask, 0,
              8'h00, 0);
    end

  endtask


  task write_ctl(string name, bit [15:0] addr, bit [7:0] data);

    send_tr(name, 0, 48'h0,
            1, addr, {24'h0, data},
            0, 8'h0,
            48'h0, 0,
            8'h00, 0);

  endtask


  task send_tr(
    string name,
    bit zic_rst,
    bit [47:0] ext_int,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [31:0] wr_data,
    bit eoi_valid,
    bit [7:0] eoi_id,
    bit [47:0] enable_bits,
    bit enable_valid,
    bit [7:0] active_lvl,
    bit ack_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);
    start_item(tr);

    tr.zic_rst = zic_rst;
    tr.ext_int  = ext_int;

    tr.zic_mmr_write_en_i   = wr_en;
    tr.zic_mmr_write_addr_i = wr_addr;
    tr.zic_mmr_write_data_i = wr_data;

    tr.zic_mmr_read_en_i   = 0;
    tr.zic_mmr_read_addr_i = 0;

    tr.zic_ack_read_valid_en = ack_valid;

    tr.zic_eoi_valid_i = eoi_valid;
    tr.zic_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i  = 0;

    finish_item(tr);

  endtask

endclass


class random_tie_break_eoi_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(random_tie_break_eoi_seq)

  rand bit [47:0] active_mask;
  rand bit [47:0] enable_mask;
  rand bit [7:0]  shared_prio;

  constraint valid_c {
    active_mask != 48'h0;
    enable_mask != 48'h0;
    (active_mask & enable_mask) != 48'h0;

    // Need at least 3 eligible IRQs for 3 ACK/EOI checks
    $countones(active_mask & enable_mask) >= 3;

    shared_prio inside {[8'h01:8'hFF]};
  }

  function new(string name = "random_tie_break_eoi_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int id);
    return 16'h1003 + (id * 4);
  endfunction

  function automatic int find_highest_id(bit [47:0] mask);
    int best_id;
    best_id = -1;

    for (int i = 0; i < 48; i++) begin
      if (mask[i]) begin
        if (i > best_id)
          best_id = i;
      end
    end

    return best_id;
  endfunction

  task body();

    bit [47:0] work_mask;
    int winner;

    if (!this.randomize()) begin
      `uvm_fatal("RAND_TIE_EOI_SEQ", "Randomization failed")
    end

    work_mask = active_mask & enable_mask;

    `uvm_info("RAND_TIE_EOI_SEQ",
      $sformatf("shared_prio=0x%0h active=0x%0h enable=0x%0h eligible=0x%0h",
                shared_prio, active_mask, enable_mask, work_mask),
      UVM_LOW)

    // RESET
    send_tr("reset", 1, 48'h0,
            0, 16'h0, 32'h0,
            0, 8'h0,
            48'h0, 0,
            8'h00, 0);

    // Program ALL 48 IRQs with same priority
    for (int i = 0; i < 48; i++) begin
      write_ctl($sformatf("write_irq%0d_ctl", i),
                ctl_addr(i),
                shared_prio);
    end

    // Assert active mask and enable mask
    send_tr("assert_tie_break_irqs", 0, active_mask,
            0, 16'h0, 32'h0,
            0, 8'h0,
            enable_mask, 1,
            8'h00, 0);

    repeat (5) begin
      send_tr("wait_initial_resolve", 0, active_mask,
              0, 16'h0, 32'h0,
              0, 8'h0,
              enable_mask, 0,
              8'h00, 0);
    end

    // Do 3 tie-break ACK/EOI progressions
    repeat (3) begin

      winner = find_highest_id(work_mask);

      `uvm_info("RAND_TIE_EOI_SEQ",
        $sformatf("Expected tie winner IRQ%0d ACK=0x%0h PRIO=0x%0h work_mask=0x%0h",
                  winner,
                  8'h10 + winner[7:0],
                  shared_prio,
                  work_mask),
        UVM_LOW)

      // ACK current highest ID
      send_tr("ack_highest_id_winner", 0, work_mask,
              0, 16'h0, 32'h0,
              0, 8'h0,
              enable_mask, 0,
              8'h00, 1);

      repeat (2) begin
        send_tr("idle_after_ack", 0, work_mask,
                0, 16'h0, 32'h0,
                0, 8'h0,
                enable_mask, 0,
                8'h00, 0);
      end

      // Remove current winner for next tie-break winner
      work_mask[winner] = 1'b0;

      // EOI current winner
      send_tr("eoi_highest_id_winner", 0, work_mask,
              0, 16'h0, 32'h0,
              1, (8'h10 + winner[7:0]),
              enable_mask, 0,
              8'h00, 0);

      repeat (4) begin
        send_tr("wait_next_tie_resolve", 0, work_mask,
                0, 16'h0, 32'h0,
                0, 8'h0,
                enable_mask, 0,
                8'h00, 0);
      end

    end

  endtask


  task write_ctl(string name, bit [15:0] addr, bit [7:0] data);
    send_tr(name, 0, 48'h0,
            1, addr, {24'h0, data},
            0, 8'h0,
            48'h0, 0,
            8'h00, 0);
  endtask


  task send_tr(
    string name,
    bit zic_rst,
    bit [47:0] ext_int,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [31:0] wr_data,
    bit eoi_valid,
    bit [7:0] eoi_id,
    bit [47:0] enable_bits,
    bit enable_valid,
    bit [7:0] active_lvl,
    bit ack_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);
    start_item(tr);

    tr.zic_rst = zic_rst;
    tr.ext_int  = ext_int;

    tr.zic_mmr_write_en_i   = wr_en;
    tr.zic_mmr_write_addr_i = wr_addr;
    tr.zic_mmr_write_data_i = wr_data;

    tr.zic_mmr_read_en_i   = 0;
    tr.zic_mmr_read_addr_i = 0;

    tr.zic_ack_read_valid_en = ack_valid;

    tr.zic_eoi_valid_i = eoi_valid;
    tr.zic_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i  = 0;

    finish_item(tr);

  endtask

endclass

class random_eoi_progression_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(random_eoi_progression_seq)

  rand bit [7:0]  irq_ctl [48];
  rand bit [47:0] active_mask;
  rand bit [47:0] enable_mask;

  constraint valid_c {
    active_mask != 48'h0;
    enable_mask != 48'h0;
    (active_mask & enable_mask) != 48'h0;

    // Make sure enough active+enabled IRQs exist for 3 ACKs
    $countones(active_mask & enable_mask) >= 3;

    foreach (irq_ctl[i]) {
      irq_ctl[i] inside {[8'h01:8'hFF]};
    }
  }

  function new(string name = "random_eoi_progression_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int id);
    return 16'h1003 + (id * 4);
  endfunction

  function automatic int find_best_id(bit [47:0] mask);
    int best_id;
    bit [7:0] best_prio;

    best_id   = -1;
    best_prio = 8'h00;

    for (int i = 0; i < 48; i++) begin
      if (mask[i]) begin
        if (best_id == -1) begin
          best_id   = i;
          best_prio = irq_ctl[i];
        end
        else if (irq_ctl[i] > best_prio) begin
          best_id   = i;
          best_prio = irq_ctl[i];
        end
        else if ((irq_ctl[i] == best_prio) && (i > best_id)) begin
          best_id   = i;
          best_prio = irq_ctl[i];
        end
      end
    end

    return best_id;
  endfunction

  task body();

    bit [47:0] work_mask;
    int winner;

    if (!this.randomize()) begin
      `uvm_fatal("RAND_EOI_PROG_SEQ", "Randomization failed")
    end

    work_mask = active_mask & enable_mask;

    `uvm_info("RAND_EOI_PROG_SEQ",
      $sformatf("active=0x%0h enable=0x%0h eligible_start=0x%0h",
                active_mask, enable_mask, work_mask),
      UVM_LOW)

    send_tr("reset", 1, 48'h0,
            0, 16'h0, 32'h0,
            0, 8'h0,
            48'h0, 0,
            8'h00, 0);

    for (int i = 0; i < 48; i++) begin
      write_ctl($sformatf("write_irq%0d_ctl", i),
                ctl_addr(i),
                irq_ctl[i]);
    end

    // Initial assertion
    send_tr("assert_initial_irqs", 0, active_mask,
            0, 16'h0, 32'h0,
            0, 8'h0,
            enable_mask, 1,
            8'h00, 0);

    repeat (5) begin
      send_tr("wait_initial_resolve", 0, active_mask,
              0, 16'h0, 32'h0,
              0, 8'h0,
              enable_mask, 0,
              8'h00, 0);
    end

    // Do 3 ACK/EOI progressions
    repeat (3) begin

      winner = find_best_id(work_mask);

      `uvm_info("RAND_EOI_PROG_SEQ",
        $sformatf("Expected winner=%0d ack=0x%0h prio=0x%0h work_mask=0x%0h",
                  winner,
                  8'h10 + winner[7:0],
                  irq_ctl[winner],
                  work_mask),
        UVM_LOW)

      // ACK current winner
      send_tr("ack_current_winner", 0, work_mask,
              0, 16'h0, 32'h0,
              0, 8'h0,
              enable_mask, 0,
              8'h00, 1);

      repeat (2) begin
        send_tr("idle_after_ack", 0, work_mask,
                0, 16'h0, 32'h0,
                0, 8'h0,
                enable_mask, 0,
                8'h00, 0);
      end

      // Remove winner from active mask for clean next winner
      work_mask[winner] = 1'b0;

      // EOI served winner
      send_tr("eoi_current_winner", 0, work_mask,
              0, 16'h0, 32'h0,
              1, (8'h10 + winner[7:0]),
              enable_mask, 0,
              8'h00, 0);

      repeat (4) begin
        send_tr("wait_next_resolve", 0, work_mask,
                0, 16'h0, 32'h0,
                0, 8'h0,
                enable_mask, 0,
                8'h00, 0);
      end

    end

  endtask


  task write_ctl(string name, bit [15:0] addr, bit [7:0] data);
    send_tr(name, 0, 48'h0,
            1, addr, {24'h0, data},
            0, 8'h0,
            48'h0, 0,
            8'h00, 0);
  endtask


  task send_tr(
    string name,
    bit zic_rst,
    bit [47:0] ext_int,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [31:0] wr_data,
    bit eoi_valid,
    bit [7:0] eoi_id,
    bit [47:0] enable_bits,
    bit enable_valid,
    bit [7:0] active_lvl,
    bit ack_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);
    start_item(tr);

    tr.zic_rst = zic_rst;
    tr.ext_int  = ext_int;

    tr.zic_mmr_write_en_i   = wr_en;
    tr.zic_mmr_write_addr_i = wr_addr;
    tr.zic_mmr_write_data_i = wr_data;

    tr.zic_mmr_read_en_i   = 0;
    tr.zic_mmr_read_addr_i = 0;

    tr.zic_ack_read_valid_en = ack_valid;

    tr.zic_eoi_valid_i = eoi_valid;
    tr.zic_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i  = 0;

    finish_item(tr);

  endtask

endclass

class random_ack_latency_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(random_ack_latency_seq)

  rand bit [7:0]  irq_ctl [48];
  rand bit [47:0] active_mask;
  rand bit [47:0] enable_mask;
  rand int unsigned ack_delay;

  constraint valid_c {
    active_mask != 48'h0;
    enable_mask != 48'h0;
    (active_mask & enable_mask) != 48'h0;

    ack_delay inside {[1:25]};

    foreach (irq_ctl[i]) {
      irq_ctl[i] inside {[8'h01:8'hFF]};
    }
  }

  function new(string name = "random_ack_latency_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int id);
    return 16'h1003 + (id * 4);
  endfunction

  task body();

    int best_id;
    bit [7:0] best_prio;

    if (!this.randomize()) begin
      `uvm_fatal("RAND_ACK_LAT_SEQ", "Randomization failed")
    end

    best_id   = -1;
    best_prio = 8'h00;

    for (int i = 0; i < 48; i++) begin
      if (active_mask[i] && enable_mask[i]) begin
        if (best_id == -1) begin
          best_id   = i;
          best_prio = irq_ctl[i];
        end
        else if (irq_ctl[i] > best_prio) begin
          best_id   = i;
          best_prio = irq_ctl[i];
        end
        else if ((irq_ctl[i] == best_prio) && (i > best_id)) begin
          best_id   = i;
          best_prio = irq_ctl[i];
        end
      end
    end

    `uvm_info("RAND_ACK_LAT_SEQ",
      $sformatf("active=0x%0h enable=0x%0h ack_delay=%0d expected_irq=%0d expected_ack=0x%0h expected_prio=0x%0h",
                active_mask,
                enable_mask,
                ack_delay,
                best_id,
                8'h10 + best_id[7:0],
                best_prio),
      UVM_LOW)

    // ------------------------------------------------------------
    // RESET
    // ------------------------------------------------------------
    send_tr("reset", 1, 48'h0,
            0, 16'h0, 32'h0,
            0, 8'h0,
            48'h0, 0,
            8'h00, 0);

    // ------------------------------------------------------------
    // Program random control values
    // ------------------------------------------------------------
    for (int i = 0; i < 48; i++) begin
      write_ctl($sformatf("write_irq%0d_ctl", i),
                ctl_addr(i),
                irq_ctl[i]);
    end

    // ------------------------------------------------------------
    // Assert random active/enabled interrupts
    // ------------------------------------------------------------
    send_tr("assert_irqs", 0, active_mask,
            0, 16'h0, 32'h0,
            0, 8'h0,
            enable_mask, 1,
            8'h00, 0);

    // ------------------------------------------------------------
    // Random wait before ACK
    // ------------------------------------------------------------
    repeat (ack_delay) begin
      send_tr("wait_before_ack_random_delay", 0, active_mask,
              0, 16'h0, 32'h0,
              0, 8'h0,
              enable_mask, 0,
              8'h00, 0);
    end

    // ------------------------------------------------------------
    // ACK held for 2 cycles
    // This avoids compare while zic_ack_int_id_o is still 0.
    // ------------------------------------------------------------
    repeat (2) begin
      send_tr("ack_after_random_delay", 0, active_mask,
              0, 16'h0, 32'h0,
              0, 8'h0,
              enable_mask, 0,
              8'h00, 1);
    end

    // ------------------------------------------------------------
    // Hold inputs stable after ACK for monitor/scoreboard sampling
    // ------------------------------------------------------------
    repeat (2) begin
      send_tr("idle_after_ack_sample", 0, active_mask,
              0, 16'h0, 32'h0,
              0, 8'h0,
              enable_mask, 0,
              8'h00, 0);
    end

    // ------------------------------------------------------------
    // Clear external interrupts before leaving sequence
    // ------------------------------------------------------------
    send_tr("clear_irqs_after_ack", 0, 48'h0,
            0, 16'h0, 32'h0,
            0, 8'h0,
            enable_mask, 0,
            8'h00, 0);

    repeat (3) begin
      send_tr("final_idle", 0, 48'h0,
              0, 16'h0, 32'h0,
              0, 8'h0,
              enable_mask, 0,
              8'h00, 0);
    end

  endtask


  task write_ctl(string name, bit [15:0] addr, bit [7:0] data);
    send_tr(name, 0, 48'h0,
            1, addr, {24'h0, data},
            0, 8'h0,
            48'h0, 0,
            8'h00, 0);
  endtask


  task send_tr(
    string name,
    bit zic_rst,
    bit [47:0] ext_int,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [31:0] wr_data,
    bit eoi_valid,
    bit [7:0] eoi_id,
    bit [47:0] enable_bits,
    bit enable_valid,
    bit [7:0] active_lvl,
    bit ack_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);
    start_item(tr);

    tr.zic_rst = zic_rst;
    tr.ext_int  = ext_int;

    tr.zic_mmr_write_en_i   = wr_en;
    tr.zic_mmr_write_addr_i = wr_addr;
    tr.zic_mmr_write_data_i = wr_data;

    tr.zic_mmr_read_en_i   = 0;
    tr.zic_mmr_read_addr_i = 0;

    tr.zic_ack_read_valid_en = ack_valid;

    tr.zic_eoi_valid_i = eoi_valid;
    tr.zic_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i  = 0;

    finish_item(tr);

  endtask

endclass


class random_equal_priority_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(random_equal_priority_seq)

  rand bit [47:0] active_mask;
  rand bit [47:0] enable_mask;
  rand bit [7:0]  shared_prio;

  bit [7:0] irq_ctl [48];

  constraint valid_c {

    active_mask != 48'h0;
    enable_mask != 48'h0;

    (active_mask & enable_mask) != 48'h0;

    shared_prio inside {[8'h01:8'hFF]};
  }

  function new(string name = "random_equal_priority_seq");
    super.new(name);
  endfunction


  function automatic bit [15:0] ctl_addr(int id);
    return (16'h1003 + (id * 4));
  endfunction


  task body();

    int winner_id;

    if (!this.randomize()) begin
      `uvm_fatal("RAND_EQUAL_PRIO_SEQ", "Randomization failed")
    end

    // ----------------------------------------------------
    // ALL IRQs get SAME priority
    // ----------------------------------------------------

    foreach (irq_ctl[i]) begin
      irq_ctl[i] = shared_prio;
    end

    // ----------------------------------------------------
    // Expected winner
    // highest enabled + active ID
    // ----------------------------------------------------

    winner_id = -1;

    for (int i = 0; i < 48; i++) begin

      if (active_mask[i] && enable_mask[i]) begin

        if (i > winner_id) begin
          winner_id = i;
        end

      end

    end

    `uvm_info("RAND_EQUAL_PRIO_SEQ",
      $sformatf(
      "shared_prio=0x%0h active=0x%0h enable=0x%0h expected_winner=%0d expected_ack=0x%0h",
      shared_prio,
      active_mask,
      enable_mask,
      winner_id,
      (8'h10 + winner_id[7:0])),
      UVM_LOW)

    // ----------------------------------------------------
    // RESET
    // ----------------------------------------------------

    send_tr(
      "reset",
      1,
      48'h0,
      0,
      16'h0,
      32'h0,
      0,
      8'h0,
      48'h0,
      0,
      8'h00,
      0
    );

    // ----------------------------------------------------
    // Write SAME priority to ALL IRQs
    // ----------------------------------------------------

    for (int i = 0; i < 48; i++) begin

      write_ctl(
        $sformatf("write_irq%0d_ctl", i),
        ctl_addr(i),
        irq_ctl[i]
      );

    end

    // ----------------------------------------------------
    // Assert interrupts
    // ----------------------------------------------------

    send_tr(
      "assert_equal_priority_irqs",
      0,
      active_mask,
      0,
      16'h0,
      32'h0,
      0,
      8'h0,
      enable_mask,
      1,
      8'h00,
      0
    );

    // ----------------------------------------------------
    // Wait DUT resolve
    // ----------------------------------------------------

    repeat (5) begin

      send_tr(
        "wait_resolve",
        0,
        active_mask,
        0,
        16'h0,
        32'h0,
        0,
        8'h0,
        enable_mask,
        0,
        8'h00,
        0
      );

    end

    // ----------------------------------------------------
    // ACK winner
    // ----------------------------------------------------

    send_tr(
      "ack_winner",
      0,
      active_mask,
      0,
      16'h0,
      32'h0,
      0,
      8'h0,
      enable_mask,
      0,
      8'h00,
      1
    );

  endtask


  // ======================================================
  // Write helper
  // ======================================================

  task write_ctl(
    string name,
    bit [15:0] addr,
    bit [7:0] data
  );

    send_tr(
      name,
      0,
      48'h0,
      1,
      addr,
      {24'h0, data},
      0,
      8'h0,
      48'h0,
      0,
      8'h00,
      0
    );

  endtask


  // ======================================================
  // Generic transaction sender
  // ======================================================

  task send_tr(

    string name,

    bit zic_rst,

    bit [47:0] ext_int,

    bit wr_en,
    bit [15:0] wr_addr,
    bit [31:0] wr_data,

    bit eoi_valid,
    bit [7:0] eoi_id,

    bit [47:0] enable_bits,
    bit enable_valid,

    bit [7:0] active_lvl,

    bit ack_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);

    start_item(tr);

    tr.zic_rst = zic_rst;

    tr.ext_int = ext_int;

    tr.zic_mmr_write_en_i   = wr_en;
    tr.zic_mmr_write_addr_i = wr_addr;
    tr.zic_mmr_write_data_i = wr_data;

    tr.zic_mmr_read_en_i    = 0;
    tr.zic_mmr_read_addr_i  = 0;

    tr.zic_ack_read_valid_en = ack_valid;

    tr.zic_eoi_valid_i = eoi_valid;
    tr.zic_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_bits;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i  = 0;

    finish_item(tr);

  endtask

endclass

class random_enable_mask_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(random_enable_mask_seq)

  rand bit [7:0]  irq_ctl [48];
  rand bit [47:0] ext_mask;
  rand bit [47:0] en_mask;

  constraint valid_c {
    ext_mask != 48'h0;
    en_mask  != 48'h0;
    (ext_mask & en_mask) != 48'h0;

    foreach (irq_ctl[i]) {
      irq_ctl[i] inside {[8'h01:8'hFF]};
    }
  }

  function new(string name = "random_enable_mask_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int id);
    return 16'h1003 + (id * 4);
  endfunction

  task body();

    int best_id;
    bit [7:0] best_prio;

    if (!this.randomize()) begin
      `uvm_fatal("RAND_EN_MASK_SEQ", "Randomization failed")
    end

    best_id   = -1;
    best_prio = 8'h00;

    for (int i = 0; i < 48; i++) begin
      if (ext_mask[i] && en_mask[i]) begin
        if (best_id == -1) begin
          best_id   = i;
          best_prio = irq_ctl[i];
        end
        else if (irq_ctl[i] > best_prio) begin
          best_id   = i;
          best_prio = irq_ctl[i];
        end
        else if (irq_ctl[i] == best_prio && i > best_id) begin
          best_id   = i;
          best_prio = irq_ctl[i];
        end
      end
    end

    `uvm_info("RAND_EN_MASK_SEQ",
      $sformatf("ext_mask=0x%0h en_mask=0x%0h eligible=0x%0h expected_irq=%0d expected_ack=0x%0h expected_prio=0x%0h",
                ext_mask,
                en_mask,
                (ext_mask & en_mask),
                best_id,
                8'h10 + best_id[7:0],
                best_prio),
      UVM_LOW)

    send_tr("reset", 1, 48'h0,
            0, 16'h0, 32'h0,
            0, 8'h0,
            48'h0, 0,
            8'h00, 0);

    for (int i = 0; i < 48; i++) begin
      write_ctl($sformatf("write_irq%0d_ctl", i),
                ctl_addr(i),
                irq_ctl[i]);
    end

    send_tr("assert_random_enable_mask", 0, ext_mask,
            0, 16'h0, 32'h0,
            0, 8'h0,
            en_mask, 1,
            8'h00, 0);

    repeat (5) begin
      send_tr("wait_resolve", 0, ext_mask,
              0, 16'h0, 32'h0,
              0, 8'h0,
              en_mask, 0,
              8'h00, 0);
    end

    send_tr("ack_enabled_winner", 0, ext_mask,
            0, 16'h0, 32'h0,
            0, 8'h0,
            en_mask, 0,
            8'h00, 1);

  endtask


  task write_ctl(string name, bit [15:0] addr, bit [7:0] data);
    send_tr(name, 0, 48'h0,
            1, addr, {24'h0, data},
            0, 8'h0,
            48'h0, 0,
            8'h00, 0);
  endtask


  task send_tr(
    string name,
    bit zic_rst,
    bit [47:0] ext_int,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [31:0] wr_data,
    bit eoi_valid,
    bit [7:0] eoi_id,
    bit [47:0] enable_mask,
    bit enable_valid,
    bit [7:0] active_lvl,
    bit ack_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);
    start_item(tr);

    tr.zic_rst = zic_rst;
    tr.ext_int  = ext_int;

    tr.zic_mmr_write_en_i   = wr_en;
    tr.zic_mmr_write_addr_i = wr_addr;
    tr.zic_mmr_write_data_i = wr_data;

    tr.zic_mmr_read_en_i   = 0;
    tr.zic_mmr_read_addr_i = 0;

    tr.zic_ack_read_valid_en = ack_valid;

    tr.zic_eoi_valid_i = eoi_valid;
    tr.zic_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_mask;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i  = 0;

    finish_item(tr);

  endtask

endclass

class same_priority_random_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(same_priority_random_seq)

  rand int irq_id[5];
  rand bit [7:0] common_prio;

  constraint irq_c {
    foreach (irq_id[i]) {
      irq_id[i] inside {[0:47]};
    }

    foreach (irq_id[i]) {
      foreach (irq_id[j]) {
        if (i != j) irq_id[i] != irq_id[j];
      }
    }

    common_prio inside {[8'h01:8'hFF]};
  }

  function new(string name = "same_priority_random_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int id);
    return 16'h1003 + (id * 4);
  endfunction

  task body();

    bit [47:0] irq_mask;
    int expected_id;

    if (!this.randomize()) begin
      `uvm_fatal("SAME_PRIO_SEQ", "Randomization failed")
    end

    irq_mask    = 48'h0;
    expected_id = irq_id[0];

    foreach (irq_id[i]) begin
      irq_mask[irq_id[i]] = 1'b1;

      if (irq_id[i] > expected_id)
        expected_id = irq_id[i];
    end

    `uvm_info("SAME_PRIO_SEQ",
      $sformatf("IRQ IDs = %0d %0d %0d %0d %0d | common_prio=0x%0h | expected_irq=%0d expected_ack=0x%0h mask=0x%0h",
                irq_id[0], irq_id[1], irq_id[2], irq_id[3], irq_id[4],
                common_prio,
                expected_id,
                8'h10 + expected_id[7:0],
                irq_mask),
      UVM_LOW)

    // RESET
    send_tr("reset", 1, 48'h0,
            0, 16'h0, 32'h0,
            0, 8'h0,
            48'h0, 0,
            8'h00, 0);

    // Program all selected IRQs with same priority
    foreach (irq_id[i]) begin
      write_ctl($sformatf("write_irq%0d_ctl", irq_id[i]),
                ctl_addr(irq_id[i]),
                common_prio);
    end

    // Assert and enable all selected IRQs
    send_tr("assert_same_priority_irqs", 0, irq_mask,
            0, 16'h0, 32'h0,
            0, 8'h0,
            irq_mask, 1,
            8'h00, 0);

    repeat (5) begin
      send_tr("wait_resolve", 0, irq_mask,
              0, 16'h0, 32'h0,
              0, 8'h0,
              irq_mask, 0,
              8'h00, 0);
    end

    // ACK expected highest IRQ ID
    send_tr("ack_highest_id", 0, irq_mask,
            0, 16'h0, 32'h0,
            0, 8'h0,
            irq_mask, 0,
            8'h00, 1);

    repeat (3) begin
      send_tr("idle_after_ack", 0, irq_mask,
              0, 16'h0, 32'h0,
              0, 8'h0,
              irq_mask, 0,
              8'h00, 0);
    end

  endtask


  task write_ctl(string name, bit [15:0] addr, bit [7:0] data);

    send_tr(name, 0, 48'h0,
            1, addr, {24'h0, data},
            0, 8'h0,
            48'h0, 0,
            8'h00, 0);

  endtask


  task send_tr(
    string name,
    bit zic_rst,
    bit [47:0] ext_int,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [31:0] wr_data,
    bit eoi_valid,
    bit [7:0] eoi_id,
    bit [47:0] enable_mask,
    bit enable_valid,
    bit [7:0] active_lvl,
    bit ack_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);
    start_item(tr);

    tr.zic_rst = zic_rst;
    tr.ext_int  = ext_int;

    tr.zic_mmr_write_en_i   = wr_en;
    tr.zic_mmr_write_addr_i = wr_addr;
    tr.zic_mmr_write_data_i = wr_data;

    tr.zic_mmr_read_en_i   = 0;
    tr.zic_mmr_read_addr_i = 0;

    tr.zic_ack_read_valid_en = ack_valid;

    tr.zic_eoi_valid_i = eoi_valid;
    tr.zic_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_mask;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i  = 0;

    finish_item(tr);

  endtask

endclass


class random_all_48_irq_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(random_all_48_irq_seq)

  rand bit [7:0] irq_ctl [48];
  rand bit [47:0] irq_mask;

  constraint valid_c {
    irq_mask != 48'h0;

    foreach (irq_ctl[i]) {
      irq_ctl[i] inside {[8'h01:8'hFF]};
    }
  }

  function new(string name = "random_all_48_irq_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int irq_id);
    return 16'h1003 + (irq_id * 4);
  endfunction

  task body();

    int best_id;
    bit [7:0] best_prio;

    if (!this.randomize()) begin
      `uvm_fatal("RAND48_SEQ", "randomization failed")
    end

    best_id   = -1;
    best_prio = 8'h00;

    for (int i = 0; i < 48; i++) begin
      if (irq_mask[i]) begin
        if (best_id == -1) begin
          best_id   = i;
          best_prio = irq_ctl[i];
        end
        else if (irq_ctl[i] > best_prio) begin
          best_id   = i;
          best_prio = irq_ctl[i];
        end
        else if (irq_ctl[i] == best_prio) begin
          if (i > best_id) begin
            best_id   = i;
            best_prio = irq_ctl[i];
          end
        end
      end
    end

    `uvm_info("RAND48_SEQ",
      $sformatf("Random all-48 test: irq_mask=0x%0h expected_irq=%0d expected_ack=0x%0h expected_prio=0x%0h",
                irq_mask,
                best_id,
                8'h10 + best_id[7:0],
                best_prio),
      UVM_LOW)

    // RESET
    send_tr("reset", 1, 48'h0,
            0, 16'h0, 32'h0,
            0, 8'h0,
            48'h0, 0,
            8'h00, 0);

    // Program random control value for all 48 interrupts
    for (int i = 0; i < 48; i++) begin
      write_ctl($sformatf("write_irq%0d_ctl", i),
                ctl_addr(i),
                irq_ctl[i]);
    end

    // Enable all 48 interrupts and assert random interrupt mask
    send_tr("enable_all_assert_random_mask", 0, irq_mask,
            0, 16'h0, 32'h0,
            0, 8'h0,
            48'hFFFF_FFFF_FFFF,
            1,
            8'h00, 0);

    // Wait for DUT to resolve priority
    repeat (5) begin
      send_tr("wait_priority_resolve", 0, irq_mask,
              0, 16'h0, 32'h0,
              0, 8'h0,
              48'hFFFF_FFFF_FFFF,
              0,
              8'h00, 0);
    end

    // ACK read. Monitor/scoreboard should check expected winner.
    send_tr("ack_random_winner", 0, irq_mask,
            0, 16'h0, 32'h0,
            0, 8'h0,
            48'hFFFF_FFFF_FFFF,
            0,
            8'h00, 1);

    // Wait after first ACK
repeat (2) begin
  send_tr("idle_after_first_ack", 0, irq_mask,
          0, 16'h0, 32'h0,
          0, 8'h0,
          48'hFFFF_FFFF_FFFF,
          0,
          8'h00, 0);
end

irq_mask[best_id] = 1'b0;


// EOI first winner
send_tr("eoi_first_winner", 0, irq_mask,
        0, 16'h0, 32'h0,
        1, (8'h10 + best_id[7:0]),
        48'hFFFF_FFFF_FFFF,
        0,
        8'h00, 0);

// Wait for next pending interrupt
repeat (3) begin
  send_tr("wait_next_pending", 0, irq_mask,
          0, 16'h0, 32'h0,
          0, 8'h0,
          48'hFFFF_FFFF_FFFF,
          0,
          8'h00, 0);
end

// ACK next winner
send_tr("ack_next_winner", 0, irq_mask,
        0, 16'h0, 32'h0,
        0, 8'h0,
        48'hFFFF_FFFF_FFFF,
        0,
        8'h00, 1);

    repeat (3) begin
      send_tr("idle_after_ack", 0, irq_mask,
              0, 16'h0, 32'h0,
              0, 8'h0,
              48'hFFFF_FFFF_FFFF,
              0,
              8'h00, 0);
    end

  endtask


  task write_ctl(string name, bit [15:0] addr, bit [7:0] data);

    send_tr(name, 0, 48'h0,
            1, addr, {24'h0, data},
            0, 8'h0,
            48'h0, 0,
            8'h00, 0);

  endtask


  task send_tr(
    string name,
    bit zic_rst,
    bit [47:0] ext_int,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [31:0] wr_data,
    bit eoi_valid,
    bit [7:0] eoi_id,
    bit [47:0] enable_mask,
    bit enable_valid,
    bit [7:0] active_lvl,
    bit ack_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);
    start_item(tr);

    tr.zic_rst = zic_rst;
    tr.ext_int  = ext_int;

    tr.zic_mmr_write_en_i   = wr_en;
    tr.zic_mmr_write_addr_i = wr_addr;
    tr.zic_mmr_write_data_i = wr_data;

    tr.zic_mmr_read_en_i   = 0;
    tr.zic_mmr_read_addr_i = 0;

    tr.zic_ack_read_valid_en = ack_valid;

    tr.zic_eoi_valid_i = eoi_valid;
    tr.zic_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_mask;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i  = 0;

    finish_item(tr);

  endtask

endclass





class enable_disable_masking_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(enable_disable_masking_seq)

  function new(string name="enable_disable_masking_seq");
    super.new(name);
  endfunction

  task body();

    // RESET
    send_tr("reset", 1, 48'h0,
            0, 16'h0, 32'h0,
            0, 8'h0,
            48'h0, 0,
            8'h00, 0);

    // IRQ5 control = 0xE0
    write_ctl("irq5_ctl", 16'h1017, 8'hE0);

    // IRQ5 active, but disabled
    send_tr("irq5_active_disabled", 0, 48'h0000_0000_0020,
            0, 16'h0, 32'h0,
            0, 8'h0,
            48'h0, 1,
            8'h00, 0);

    repeat (5)
      send_tr("wait_disabled", 0, 48'h0000_0000_0020,
              0, 16'h0, 32'h0,
              0, 8'h0,
              48'h0, 0,
              8'h00, 0);

    // Enable IRQ5 while it is still active
    send_tr("enable_irq5", 0, 48'h0000_0000_0020,
            0, 16'h0, 32'h0,
            0, 8'h0,
            48'h0000_0000_0020, 1,
            8'h00, 0);

    repeat (3)
      send_tr("wait_enabled_irq5", 0, 48'h0000_0000_0020,
              0, 16'h0, 32'h0,
              0, 8'h0,
              48'h0000_0000_0020, 0,
              8'h00, 0);

    // ACK IRQ5 expected = 0x15
    send_tr("ack_irq5", 0, 48'h0000_0000_0020,
            0, 16'h0, 32'h0,
            0, 8'h0,
            48'h0000_0000_0020, 0,
            8'h00, 1);

    repeat (2)
      send_tr("idle_after_ack", 0, 48'h0000_0000_0020,
              0, 16'h0, 32'h0,
              0, 8'h0,
              48'h0000_0000_0020, 0,
              8'h00, 0);

    // Disable IRQ5 again while still externally active
    send_tr("disable_irq5_again", 0, 48'h0000_0000_0020,
            0, 16'h0, 32'h0,
            0, 8'h0,
            48'h0, 1,
            8'h00, 0);

    repeat (5)
      send_tr("wait_after_disable_again", 0, 48'h0000_0000_0020,
              0, 16'h0, 32'h0,
              0, 8'h0,
              48'h0, 0,
              8'h00, 0);

  endtask


  task write_ctl(string name, bit [15:0] addr, bit [7:0] data);
    send_tr(name, 0, 48'h0,
            1, addr, {24'h0, data},
            0, 8'h0,
            48'h0, 0,
            8'h00, 0);
  endtask


  task send_tr(
    string name,
    bit zic_rst,
    bit [47:0] ext_int,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [31:0] wr_data,
    bit eoi_valid,
    bit [7:0] eoi_id,
    bit [47:0] enable_mask,
    bit enable_valid,
    bit [7:0] active_lvl,
    bit ack_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);
    start_item(tr);

    tr.zic_rst = zic_rst;
    tr.ext_int  = ext_int;

    tr.zic_mmr_write_en_i   = wr_en;
    tr.zic_mmr_write_addr_i = wr_addr;
    tr.zic_mmr_write_data_i = wr_data;

    tr.zic_mmr_read_en_i   = 0;
    tr.zic_mmr_read_addr_i = 0;

    tr.zic_ack_read_valid_en = ack_valid;

    tr.zic_eoi_valid_i = eoi_valid;
    tr.zic_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_mask;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i  = 0;

    finish_item(tr);

  endtask

endclass

class simultaneous_new_irq_during_eoi_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(simultaneous_new_irq_during_eoi_seq)

  function new(string name="simultaneous_new_irq_during_eoi_seq");
    super.new(name);
  endfunction


  task body();

    // ----------------------------
    // RESET
    // ----------------------------
    send_tr(
      "reset",
      1,
      48'h0,
      0,16'h0,32'h0,
      0,8'h0,
      48'h0,0,
      8'h00,
      0
    );


    // ----------------------------
    // PROGRAM IRQ5 = 0x20
    // ----------------------------
    write_ctl("irq5_ctl",16'h1017,8'h20);


    // ----------------------------
    // PROGRAM IRQ6 = 0xE0
    // ----------------------------
    write_ctl("irq6_ctl",16'h101B,8'hE0);


    // ----------------------------
    // ASSERT IRQ5 ONLY
    // ----------------------------
    send_tr(
      "assert_irq5",
      0,
      48'h0000_0000_0020,
      0,16'h0,32'h0,
      0,8'h0,
      48'h0000_0000_0060,
      1,
      8'h00,
      0
    );


    repeat(3)
      send_tr(
        "wait_irq5",
        0,
        48'h0000_0000_0020,
        0,16'h0,32'h0,
        0,8'h0,
        48'h0000_0000_0060,
        0,
        8'h00,
        0
      );


    // ----------------------------
    // ACK IRQ5
    // expected = 0x15
    // ----------------------------
    send_tr(
      "ack_irq5",
      0,
      48'h0000_0000_0020,
      0,16'h0,32'h0,
      0,8'h0,
      48'h0000_0000_0060,
      0,
      8'h00,
      1
    );


    repeat(2)
      send_tr(
        "wait_after_ack5",
        0,
        48'h0000_0000_0020,
        0,16'h0,32'h0,
        0,8'h0,
        48'h0000_0000_0060,
        0,
        8'h00,
        0
      );


    // ====================================================
    // SAME CYCLE:
    // EOI IRQ5
    // NEW IRQ6 ARRIVES
    // ====================================================
    send_tr(
      "eoi_irq5_new_irq6",
      0,
      48'h0000_0000_0040,
      0,16'h0,32'h0,
      1,8'h15,
      48'h0000_0000_0060,
      0,
      8'h00,
      0
    );


    repeat(3)
      send_tr(
        "wait_irq6",
        0,
        48'h0000_0000_0040,
        0,16'h0,32'h0,
        0,8'h0,
        48'h0000_0000_0060,
        0,
        8'h00,
        0
      );


    // ----------------------------
    // ACK IRQ6
    // expected = 0x16
    // ----------------------------
    send_tr(
      "ack_irq6",
      0,
      48'h0000_0000_0040,
      0,16'h0,32'h0,
      0,8'h0,
      48'h0000_0000_0060,
      0,
      8'h00,
      1
    );


    repeat(3)
      send_tr(
        "idle",
        0,
        48'h0,
        0,16'h0,32'h0,
        0,8'h0,
        48'h0000_0000_0060,
        0,
        8'h00,
        0
      );

  endtask



  task write_ctl(
    string name,
    bit [15:0] addr,
    bit [7:0] data
  );
    send_tr(
      name,
      0,
      48'h0,
      1,
      addr,
      {24'h0,data},
      0,
      8'h0,
      48'h0,
      0,
      8'h00,
      0
    );
  endtask



  task send_tr(
    string name,
    bit zic_rst,
    bit [47:0] ext_int,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [31:0] wr_data,
    bit eoi_valid,
    bit [7:0] eoi_id,
    bit [47:0] enable_mask,
    bit enable_valid,
    bit [7:0] active_lvl,
    bit ack_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);

    start_item(tr);

    tr.zic_rst = zic_rst;
    tr.ext_int  = ext_int;

    tr.zic_mmr_write_en_i   = wr_en;
    tr.zic_mmr_write_addr_i = wr_addr;
    tr.zic_mmr_write_data_i = wr_data;

    tr.zic_mmr_read_en_i   = 0;
    tr.zic_mmr_read_addr_i = 0;

    tr.zic_ack_read_valid_en = ack_valid;

    tr.zic_eoi_valid_i = eoi_valid;
    tr.zic_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_mask;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i  = 0;

    finish_item(tr);

  endtask

endclass

class random_multi_irq_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(random_multi_irq_seq)

  rand int irq_a;
  rand int irq_b;
  rand int irq_c;

  rand bit [7:0] prio_a;
  rand bit [7:0] prio_b;
  rand bit [7:0] prio_c;

  constraint valid_irq_c {
    irq_a inside {[0:47]};
    irq_b inside {[0:47]};
    irq_c inside {[0:47]};

    irq_a != irq_b;
    irq_b != irq_c;
    irq_a != irq_c;

    prio_a != 8'h00;
    prio_b != 8'h00;
    prio_c != 8'h00;
  }

  function new(string name = "random_multi_irq_seq");
    super.new(name);
  endfunction

  function automatic bit [15:0] ctl_addr(int irq_id);
    return 16'h1003 + (irq_id * 4);
  endfunction

  task body();

    bit [47:0] irq_mask;

    if (!this.randomize()) begin
      `uvm_fatal("RAND_SEQ", "randomization failed")
    end

    irq_mask = 48'h0;
    irq_mask[irq_a] = 1'b1;
    irq_mask[irq_b] = 1'b1;
    irq_mask[irq_c] = 1'b1;

    `uvm_info("RAND_SEQ",
      $sformatf("Random IRQs: irq_a=%0d prio=0x%0h irq_b=%0d prio=0x%0h irq_c=%0d prio=0x%0h mask=0x%0h",
                irq_a, prio_a,
                irq_b, prio_b,
                irq_c, prio_c,
                irq_mask),
      UVM_LOW)

    send_tr("reset", 1, 48'h0,
            0, 16'h0, 32'h0,
            0, 8'h0,
            48'h0, 0,
            8'h00, 0);

    write_ctl("write_irq_a", ctl_addr(irq_a), prio_a);
    write_ctl("write_irq_b", ctl_addr(irq_b), prio_b);
    write_ctl("write_irq_c", ctl_addr(irq_c), prio_c);

    send_tr("assert_random_irqs", 0, irq_mask,
            0, 16'h0, 32'h0,
            0, 8'h0,
            irq_mask, 1,
            8'h00, 0);

    repeat (3)
      send_tr("wait_random_irqs", 0, irq_mask,
              0, 16'h0, 32'h0,
              0, 8'h0,
              irq_mask, 0,
              8'h00, 0);

    send_tr("ack_random_winner", 0, irq_mask,
            0, 16'h0, 32'h0,
            0, 8'h0,
            irq_mask, 0,
            8'h00, 1);

    repeat (2)
      send_tr("idle_after_ack", 0, irq_mask,
              0, 16'h0, 32'h0,
              0, 8'h0,
              irq_mask, 0,
              8'h00, 0);

  endtask


  task write_ctl(string name, bit [15:0] addr, bit [7:0] data);
    send_tr(name, 0, 48'h0,
            1, addr, {24'h0, data},
            0, 8'h0,
            48'h0, 0,
            8'h00, 0);
  endtask


  task send_tr(
    string name,
    bit zic_rst,
    bit [47:0] ext_int,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [31:0] wr_data,
    bit eoi_valid,
    bit [7:0] eoi_id,
    bit [47:0] enable_mask,
    bit enable_valid,
    bit [7:0] active_lvl,
    bit ack_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);
    start_item(tr);

    tr.zic_rst = zic_rst;
    tr.ext_int  = ext_int;

    tr.zic_mmr_write_en_i   = wr_en;
    tr.zic_mmr_write_addr_i = wr_addr;
    tr.zic_mmr_write_data_i = wr_data;

    tr.zic_mmr_read_en_i   = 0;
    tr.zic_mmr_read_addr_i = 0;

    tr.zic_ack_read_valid_en = ack_valid;

    tr.zic_eoi_valid_i = eoi_valid;
    tr.zic_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_mask;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i  = 0;

    finish_item(tr);

  endtask

endclass

class simul_new_irq_during_eoi_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(simul_new_irq_during_eoi_seq)

  function new(string name = "simul_new_irq_during_eoi_seq");
    super.new(name);
  endfunction

  task body();

    // reset
    send_tr("reset", 1, 48'h0, 0, 16'h0, 32'h0,
            0, 8'h0, 48'h0, 0, 8'h00, 0);

    // IRQ5 = 20, IRQ6 = E0
    write_ctl("irq5_ctl", 16'h1017, 8'h20);
    write_ctl("irq6_ctl", 16'h101B, 8'hE0);

    // assert only IRQ5 first
    send_tr("assert_irq5", 0, 48'h0000_0000_0020,
            0, 16'h0, 32'h0,
            0, 8'h0,
            48'h0000_0000_0060, 1,
            8'h00, 0);

    repeat (3)
      send_tr("wait_irq5", 0, 48'h0000_0000_0020,
              0, 16'h0, 32'h0,
              0, 8'h0,
              48'h0000_0000_0060, 0,
              8'h00, 0);

    // ACK IRQ5, expected 0x15
    send_tr("ack_irq5", 0, 48'h0000_0000_0020,
            0, 16'h0, 32'h0,
            0, 8'h0,
            48'h0000_0000_0060, 0,
            8'h00, 1);

    repeat (2)
      send_tr("idle_after_ack5", 0, 48'h0000_0000_0020,
              0, 16'h0, 32'h0,
              0, 8'h0,
              48'h0000_0000_0060, 0,
              8'h00, 0);

    // Same cycle:
    // EOI IRQ5 and new IRQ6 arrives
    send_tr("eoi_irq5_new_irq6", 0, 48'h0000_0000_0040,
            0, 16'h0, 32'h0,
            1, 8'h15,
            48'h0000_0000_0060, 0,
            8'h00, 0);

    repeat (3)
      send_tr("wait_irq6_after_eoi", 0, 48'h0000_0000_0040,
              0, 16'h0, 32'h0,
              0, 8'h0,
              48'h0000_0000_0060, 0,
              8'h00, 0);

    // ACK IRQ6, expected 0x16
    send_tr("ack_irq6_after_eoi", 0, 48'h0000_0000_0040,
            0, 16'h0, 32'h0,
            0, 8'h0,
            48'h0000_0000_0060, 0,
            8'h00, 1);

  endtask


  task write_ctl(string name, bit [15:0] addr, bit [7:0] data);
    send_tr(name, 0, 48'h0, 1, addr, {24'h0, data},
            0, 8'h0, 48'h0, 0, 8'h00, 0);
  endtask


  task send_tr(
    string name,
    bit zic_rst,
    bit [47:0] ext_int,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [31:0] wr_data,
    bit eoi_valid,
    bit [7:0] eoi_id,
    bit [47:0] enable_mask,
    bit enable_valid,
    bit [7:0] active_lvl,
    bit ack_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);
    start_item(tr);

    tr.zic_rst = zic_rst;
    tr.ext_int  = ext_int;

    tr.zic_mmr_write_en_i   = wr_en;
    tr.zic_mmr_write_addr_i = wr_addr;
    tr.zic_mmr_write_data_i = wr_data;

    tr.zic_mmr_read_en_i   = 0;
    tr.zic_mmr_read_addr_i = 0;

    tr.zic_ack_read_valid_en = ack_valid;

    tr.zic_eoi_valid_i = eoi_valid;
    tr.zic_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_mask;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i  = 0;

    finish_item(tr);

  endtask

endclass

class reset_during_active_irq_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(reset_during_active_irq_seq)

  function new(string name = "reset_during_active_irq_seq");
    super.new(name);
  endfunction

  task body();

    // reset
    send_tr("reset", 1, 48'h0, 0, 16'h0, 32'h0, 0, 8'h0,
            48'h0, 0, 8'h00, 0);

    // IRQ6 priority = E0
    write_ctl("irq6_ctl", 16'h101B, 8'hE0);

    // assert IRQ6 + enable
    send_tr("assert_irq6", 0, 48'h0000_0000_0040,
            0, 16'h0, 32'h0, 0, 8'h0,
            48'h0000_0000_0040, 1, 8'h00, 0);

    repeat (3)
      send_tr("wait_irq6_request", 0, 48'h0000_0000_0040,
              0, 16'h0, 32'h0, 0, 8'h0,
              48'h0000_0000_0040, 0, 8'h00, 0);

    // reset while interrupt is active/requesting
    send_tr("reset_during_irq", 1, 48'h0000_0000_0040,
            0, 16'h0, 32'h0, 0, 8'h0,
            48'h0000_0000_0040, 0, 8'h00, 0);

    repeat (3)
      send_tr("idle_after_reset", 0, 48'h0,
              0, 16'h0, 32'h0, 0, 8'h0,
              48'h0, 0, 8'h00, 0);

  endtask


  task write_ctl(string name, bit [15:0] addr, bit [7:0] data);
    send_tr(name, 0, 48'h0, 1, addr, {24'h0, data},
            0, 8'h0, 48'h0, 0, 8'h00, 0);
  endtask


  task send_tr(
    string name,
    bit zic_rst,
    bit [47:0] ext_int,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [31:0] wr_data,
    bit eoi_valid,
    bit [7:0] eoi_id,
    bit [47:0] enable_mask,
    bit enable_valid,
    bit [7:0] active_lvl,
    bit ack_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);
    start_item(tr);

    tr.zic_rst = zic_rst;
    tr.ext_int  = ext_int;

    tr.zic_mmr_write_en_i   = wr_en;
    tr.zic_mmr_write_addr_i = wr_addr;
    tr.zic_mmr_write_data_i = wr_data;

    tr.zic_mmr_read_en_i   = 0;
    tr.zic_mmr_read_addr_i = 0;

    tr.zic_ack_read_valid_en = ack_valid;

    tr.zic_eoi_valid_i = eoi_valid;
    tr.zic_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_mask;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i  = 0;

    finish_item(tr);

  endtask

endclass

class active_lvl_threshold_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(active_lvl_threshold_seq)

  function new(string name = "active_lvl_threshold_seq");
    super.new(name);
  endfunction

  task body();

    // RESET
    send_tr("reset", 1, 48'h0,
            0, 16'h0, 32'h0,
            0, 8'h00,
            48'h0, 0,
            8'h00, 0);

    // Program IRQ5 = 0x20
    write_ctl("irq5_ctl_low", 16'h1017, 8'h20);

    // Assert IRQ5, enable IRQ5, active level = 0x80
    // Since IRQ5 level 0x20 < active 0x80, it should be blocked.
    send_tr("assert_irq5_blocked", 0, 48'h0000_0000_0020,
            0, 16'h0, 32'h0,
            0, 8'h00,
            48'h0000_0000_0020, 1,
            8'h80, 0);

    repeat (5) begin
      send_tr("wait_blocked_irq5", 0, 48'h0000_0000_0020,
              0, 16'h0, 32'h0,
              0, 8'h00,
              48'h0000_0000_0020, 0,
              8'h80, 0);
    end

    // No ACK read here because interrupt should be blocked.

    // Program IRQ6 = 0xE0
    write_ctl("irq6_ctl_high", 16'h101B, 8'hE0);

    // Assert IRQ6 also, enable IRQ5+IRQ6, active level still 0x80
    // IRQ6 should preempt because 0xE0 > 0x80.
    send_tr("assert_irq6_preempt", 0, 48'h0000_0000_0060,
            0, 16'h0, 32'h0,
            0, 8'h00,
            48'h0000_0000_0060, 1,
            8'h80, 0);

    repeat (3) begin
      send_tr("wait_irq6_preempt", 0, 48'h0000_0000_0060,
              0, 16'h0, 32'h0,
              0, 8'h00,
              48'h0000_0000_0060, 0,
              8'h80, 0);
    end

    // ACK read: expected IRQ6 = 0x16
    send_tr("ack_irq6", 0, 48'h0000_0000_0060,
            0, 16'h0, 32'h0,
            0, 8'h00,
            48'h0000_0000_0060, 0,
            8'h80, 1);

  endtask


  task write_ctl(string name, bit [15:0] addr, bit [7:0] data);

    send_tr(name, 0, 48'h0,
            1, addr, {24'h0, data},
            0, 8'h00,
            48'h0, 0,
            8'h00, 0);

  endtask


  task send_tr(
    string name,
    bit zic_rst,
    bit [47:0] ext_int,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [31:0] wr_data,
    bit eoi_valid,
    bit [7:0] eoi_id,
    bit [47:0] enable_mask,
    bit enable_valid,
    bit [7:0] active_lvl,
    bit ack_valid
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);
    start_item(tr);

    tr.zic_rst = zic_rst;
    tr.ext_int  = ext_int;

    tr.zic_mmr_write_en_i   = wr_en;
    tr.zic_mmr_write_addr_i = wr_addr;
    tr.zic_mmr_write_data_i = wr_data;

    tr.zic_mmr_read_en_i   = 0;
    tr.zic_mmr_read_addr_i = 0;

    tr.zic_ack_read_valid_en = ack_valid;

    tr.zic_eoi_valid_i = eoi_valid;
    tr.zic_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = active_lvl;

    tr.global_int_enable_bit_i   = enable_mask;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i  = 0;

    finish_item(tr);

  endtask

endclass


class equal_priority_tie_break_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(equal_priority_tie_break_seq)

  function new(string name = "equal_priority_tie_break_seq");
    super.new(name);
  endfunction

  task body();

    int_seq_item tr;

    // RESET
    send_tr("reset", 1, 48'h0, 0, 16'h0, 32'h0, 0, 8'h00, 48'h0, 0);

    // Program equal priorities
    write_ctl("irq5_ctl", 16'h1017, 8'h80);
    write_ctl("irq6_ctl", 16'h101B, 8'h80);
    write_ctl("irq9_ctl", 16'h1027, 8'h80);

    // Assert IRQ5 + IRQ6 + IRQ9, enable all
    send_tr("assert_all", 0, 48'h0000_0000_0260,
            0, 16'h0, 32'h0,
            0, 8'h00,
            48'h0000_0000_0260, 1);

    repeat (3)
      send_tr("wait_irq9", 0, 48'h0000_0000_0260,
              0, 16'h0, 32'h0,
              0, 8'h00,
              48'h0000_0000_0260, 0);

    // ACK 1: expected IRQ9 = 0x19
    ack_read("ack_irq9", 48'h0000_0000_0260);

    repeat (2)
      send_tr("idle_after_ack9", 0, 48'h0000_0000_0260,
              0, 16'h0, 32'h0,
              0, 8'h00,
              48'h0000_0000_0260, 0);

    // EOI IRQ9, deassert IRQ9
    send_tr("eoi_irq9", 0, 48'h0000_0000_0060,
            0, 16'h0, 32'h0,
            1, 8'h19,
            48'h0000_0000_0260, 0);

    repeat (3)
      send_tr("wait_irq6", 0, 48'h0000_0000_0060,
              0, 16'h0, 32'h0,
              0, 8'h00,
              48'h0000_0000_0260, 0);

    // ACK 2: expected IRQ6 = 0x16
    ack_read("ack_irq6", 48'h0000_0000_0060);

    repeat (2)
      send_tr("idle_after_ack6", 0, 48'h0000_0000_0060,
              0, 16'h0, 32'h0,
              0, 8'h00,
              48'h0000_0000_0260, 0);

    // EOI IRQ6, deassert IRQ6
    send_tr("eoi_irq6", 0, 48'h0000_0000_0020,
            0, 16'h0, 32'h0,
            1, 8'h16,
            48'h0000_0000_0260, 0);

    repeat (3)
      send_tr("wait_irq5", 0, 48'h0000_0000_0020,
              0, 16'h0, 32'h0,
              0, 8'h00,
              48'h0000_0000_0260, 0);

    // ACK 3: expected IRQ5 = 0x15
    ack_read("ack_irq5", 48'h0000_0000_0020);

  endtask


  task write_ctl(string name, bit [15:0] addr, bit [7:0] data);
    send_tr(name, 0, 48'h0,
            1, addr, {24'h0, data},
            0, 8'h00,
            48'h0, 0);
  endtask


  task ack_read(string name, bit [47:0] irq_mask);
    send_tr(name, 0, irq_mask,
            0, 16'h0, 32'h0,
            0, 8'h00,
            48'h0000_0000_0260, 0,
            1);
  endtask


  task send_tr(
    string name,
    bit zic_rst,
    bit [47:0] ext_int,
    bit wr_en,
    bit [15:0] wr_addr,
    bit [31:0] wr_data,
    bit eoi_valid,
    bit [7:0] eoi_id,
    bit [47:0] enable_mask,
    bit enable_valid,
    bit ack_valid = 0
  );

    int_seq_item tr;

    tr = int_seq_item::type_id::create(name);
    start_item(tr);

    tr.zic_rst = zic_rst;
    tr.ext_int  = ext_int;

    tr.zic_mmr_write_en_i   = wr_en;
    tr.zic_mmr_write_addr_i = wr_addr;
    tr.zic_mmr_write_data_i = wr_data;

    tr.zic_mmr_read_en_i   = 0;
    tr.zic_mmr_read_addr_i = 0;

    tr.zic_ack_read_valid_en = ack_valid;

    tr.zic_eoi_valid_i = eoi_valid;
    tr.zic_eoi_id_i    = eoi_id;

    tr.active_lvl_pr_i = 8'h00;

    tr.global_int_enable_bit_i   = enable_mask;
    tr.global_int_enable_valid_i = enable_valid;

    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i  = 0;

    finish_item(tr);

  endtask

endclass

class eoi_flow_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(eoi_flow_seq)

  function new(string name = "eoi_flow_seq");
    super.new(name);
  endfunction

  task body();

    int_seq_item tr;

    // RESET
    tr = int_seq_item::type_id::create("reset_tr");
    start_item(tr);
    tr.zic_rst = 1;
    tr.ext_int = '0;
    tr.zic_mmr_write_en_i = 0;
    tr.zic_mmr_write_addr_i = 0;
    tr.zic_mmr_write_data_i = 0;
    tr.zic_mmr_read_en_i = 0;
    tr.zic_mmr_read_addr_i = 0;
    tr.zic_ack_read_valid_en = 0;
    tr.zic_eoi_valid_i = 0;
    tr.zic_eoi_id_i = 0;
    tr.active_lvl_pr_i = 8'h00;
    tr.global_int_enable_bit_i = 0;
    tr.global_int_enable_valid_i = 0;
    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i = 0;
    finish_item(tr);

    // IRQ5 control = 0x20
    tr = int_seq_item::type_id::create("prog_irq5_ctl");
    start_item(tr);
    tr.zic_rst = 0;
    tr.ext_int = '0;
    tr.zic_mmr_write_en_i = 1;
    tr.zic_mmr_write_addr_i = 16'h1017;
    tr.zic_mmr_write_data_i = 32'h0000_0020;
    tr.zic_mmr_read_en_i = 0;
    tr.zic_mmr_read_addr_i = 0;
    tr.zic_ack_read_valid_en = 0;
    tr.zic_eoi_valid_i = 0;
    tr.zic_eoi_id_i = 0;
    tr.active_lvl_pr_i = 8'h00;
    tr.global_int_enable_bit_i = 0;
    tr.global_int_enable_valid_i = 0;
    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i = 0;
    finish_item(tr);

    // IRQ6 control = 0xE0
    tr = int_seq_item::type_id::create("prog_irq6_ctl");
    start_item(tr);
    tr.zic_rst = 0;
    tr.ext_int = '0;
    tr.zic_mmr_write_en_i = 1;
    tr.zic_mmr_write_addr_i = 16'h101B;
    tr.zic_mmr_write_data_i = 32'h0000_00E0;
    tr.zic_mmr_read_en_i = 0;
    tr.zic_mmr_read_addr_i = 0;
    tr.zic_ack_read_valid_en = 0;
    tr.zic_eoi_valid_i = 0;
    tr.zic_eoi_id_i = 0;
    tr.active_lvl_pr_i = 8'h00;
    tr.global_int_enable_bit_i = 0;
    tr.global_int_enable_valid_i = 0;
    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i = 0;
    finish_item(tr);

    // Assert IRQ5 + IRQ6, enable both
    tr = int_seq_item::type_id::create("assert_irq5_irq6");
    start_item(tr);
    tr.zic_rst = 0;
    tr.ext_int = '0;
    tr.ext_int[5] = 1;
    tr.ext_int[6] = 1;
    tr.zic_mmr_write_en_i = 0;
    tr.zic_mmr_write_addr_i = 0;
    tr.zic_mmr_write_data_i = 0;
    tr.zic_mmr_read_en_i = 0;
    tr.zic_mmr_read_addr_i = 0;
    tr.zic_ack_read_valid_en = 0;
    tr.zic_eoi_valid_i = 0;
    tr.zic_eoi_id_i = 0;
    tr.active_lvl_pr_i = 8'h00;
    tr.global_int_enable_bit_i = 48'h0000_0000_0060;
    tr.global_int_enable_valid_i = 1;
    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i = 0;
    finish_item(tr);

    // Wait for first request
    repeat (3) begin
      tr = int_seq_item::type_id::create("wait_first_irq");
      start_item(tr);
      tr.zic_rst = 0;
      tr.ext_int = '0;
      tr.ext_int[5] = 1;
      tr.ext_int[6] = 1;
      tr.zic_mmr_write_en_i = 0;
      tr.zic_mmr_write_addr_i = 0;
      tr.zic_mmr_write_data_i = 0;
      tr.zic_mmr_read_en_i = 0;
      tr.zic_mmr_read_addr_i = 0;
      tr.zic_ack_read_valid_en = 0;
      tr.zic_eoi_valid_i = 0;
      tr.zic_eoi_id_i = 0;
      tr.active_lvl_pr_i = 8'h00;
      tr.global_int_enable_bit_i = 48'h0000_0000_0060;
      tr.global_int_enable_valid_i = 0;
      tr.debug_mode_valid_i = 0;
      tr.debug_mode_reset_i = 0;
      tr.debug_ndm_reset_i = 0;
      finish_item(tr);
    end

    // First ACK read: expected IRQ6 = 0x16
    tr = int_seq_item::type_id::create("ack_irq6");
    start_item(tr);
    tr.zic_rst = 0;
    tr.ext_int = '0;
    tr.ext_int[5] = 1;
    tr.ext_int[6] = 1;
    tr.zic_mmr_write_en_i = 0;
    tr.zic_mmr_write_addr_i = 0;
    tr.zic_mmr_write_data_i = 0;
    tr.zic_mmr_read_en_i = 0;
    tr.zic_mmr_read_addr_i = 0;
    tr.zic_ack_read_valid_en = 1;
    tr.zic_eoi_valid_i = 0;
    tr.zic_eoi_id_i = 0;
    tr.active_lvl_pr_i = 8'h00;
    tr.global_int_enable_bit_i = 48'h0000_0000_0060;
    tr.global_int_enable_valid_i = 0;
    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i = 0;
    finish_item(tr);

    // Idle after first ACK
    repeat (2) begin
      tr = int_seq_item::type_id::create("idle_after_ack6");
      start_item(tr);
      tr.zic_rst = 0;
      tr.ext_int = '0;
      tr.ext_int[5] = 1;
      tr.ext_int[6] = 1;
      tr.zic_mmr_write_en_i = 0;
      tr.zic_mmr_write_addr_i = 0;
      tr.zic_mmr_write_data_i = 0;
      tr.zic_mmr_read_en_i = 0;
      tr.zic_mmr_read_addr_i = 0;
      tr.zic_ack_read_valid_en = 0;
      tr.zic_eoi_valid_i = 0;
      tr.zic_eoi_id_i = 0;
      tr.active_lvl_pr_i = 8'h00;
      tr.global_int_enable_bit_i = 48'h0000_0000_0060;
      tr.global_int_enable_valid_i = 0;
      tr.debug_mode_valid_i = 0;
      tr.debug_mode_reset_i = 0;
      tr.debug_ndm_reset_i = 0;
      finish_item(tr);
    end

    // EOI for IRQ6
    tr = int_seq_item::type_id::create("eoi_irq6");
    start_item(tr);
    tr.zic_rst = 0;

    // Keep IRQ5 active, deassert IRQ6 after EOI for clean next winner
    tr.ext_int = '0;
    tr.ext_int[5] = 1;
    tr.ext_int[6] = 0;

    tr.zic_mmr_write_en_i = 0;
    tr.zic_mmr_write_addr_i = 0;
    tr.zic_mmr_write_data_i = 0;
    tr.zic_mmr_read_en_i = 0;
    tr.zic_mmr_read_addr_i = 0;
    tr.zic_ack_read_valid_en = 0;

    tr.zic_eoi_valid_i = 1;
    tr.zic_eoi_id_i = 8'h16;

    tr.active_lvl_pr_i = 8'h00;
    tr.global_int_enable_bit_i = 48'h0000_0000_0060;
    tr.global_int_enable_valid_i = 0;
    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i = 0;
    finish_item(tr);

    // Wait for next request IRQ5
    repeat (3) begin
      tr = int_seq_item::type_id::create("wait_next_irq5");
      start_item(tr);
      tr.zic_rst = 0;
      tr.ext_int = '0;
      tr.ext_int[5] = 1;
      tr.ext_int[6] = 0;
      tr.zic_mmr_write_en_i = 0;
      tr.zic_mmr_write_addr_i = 0;
      tr.zic_mmr_write_data_i = 0;
      tr.zic_mmr_read_en_i = 0;
      tr.zic_mmr_read_addr_i = 0;
      tr.zic_ack_read_valid_en = 0;
      tr.zic_eoi_valid_i = 0;
      tr.zic_eoi_id_i = 0;
      tr.active_lvl_pr_i = 8'h00;
      tr.global_int_enable_bit_i = 48'h0000_0000_0060;
      tr.global_int_enable_valid_i = 0;
      tr.debug_mode_valid_i = 0;
      tr.debug_mode_reset_i = 0;
      tr.debug_ndm_reset_i = 0;
      finish_item(tr);
    end

    // Second ACK read: expected IRQ5 = 0x15
    tr = int_seq_item::type_id::create("ack_irq5_after_eoi");
    start_item(tr);
    tr.zic_rst = 0;
    tr.ext_int = '0;
    tr.ext_int[5] = 1;
    tr.ext_int[6] = 0;
    tr.zic_mmr_write_en_i = 0;
    tr.zic_mmr_write_addr_i = 0;
    tr.zic_mmr_write_data_i = 0;
    tr.zic_mmr_read_en_i = 0;
    tr.zic_mmr_read_addr_i = 0;
    tr.zic_ack_read_valid_en = 1;
    tr.zic_eoi_valid_i = 0;
    tr.zic_eoi_id_i = 0;
    tr.active_lvl_pr_i = 8'h00;
    tr.global_int_enable_bit_i = 48'h0000_0000_0060;
    tr.global_int_enable_valid_i = 0;
    tr.debug_mode_valid_i = 0;
    tr.debug_mode_reset_i = 0;
    tr.debug_ndm_reset_i = 0;
    finish_item(tr);

  endtask

endclass



// ============================================================
// reset_basic_seq
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
              1, 48'h0,
              0, 16'h0, 32'h0,
              0, 16'h0,
              0, 8'h00,
              48'h0, 0,
              8'h00,
              0);
    end

    idle(post_idle_cycles);

  endtask

endclass


// ============================================================
// mmr_basic_seq
// ============================================================
class mmr_basic_seq extends zic_comman_base_seq;

  `uvm_object_utils(mmr_basic_seq)

  rand int unsigned num_ops;

  constraint c {
    num_ops inside {[5:30]};
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

    repeat (num_ops) begin

      irq      = $urandom_range(1, 46);
      ctl_data = $urandom_range(8'h01, 8'hFF);
      rd_addr  = ctl_addr(irq);

      write_ctl(irq, ctl_data);

      send_tr("random_mmr_read",
              0, 48'h0,
              0, 16'h0, 32'h0,
              1, rd_addr,
              0, 8'h00,
              VALID_IRQ_MASK, 0,
              8'h00,
              0);

      idle($urandom_range(1, 3));

    end

  endtask

endclass


// ============================================================
// single_irq_seq
// ============================================================
class single_irq_seq extends zic_comman_base_seq;

  `uvm_object_utils(single_irq_seq)

  rand int irq;
  rand bit [7:0] irq_ctl;
  rand int unsigned ack_delay;
  rand int unsigned eoi_delay;

  constraint c {
    irq       inside {[1:46]};
    irq_ctl   inside {[8'h01:8'hFF]};
    ack_delay inside {[2:10]};
    eoi_delay inside {[1:5]};
  }

  function new(string name = "single_irq_seq");
    super.new(name);
  endfunction

  task body();

    bit [47:0] ext;
    bit [47:0] en;

    if (!this.randomize())
      `uvm_fatal("SINGLE_IRQ_SEQ", "Randomization failed")

    ext = 48'h0;
    en  = VALID_IRQ_MASK;
    ext[irq] = 1'b1;

    write_ctl(irq, irq_ctl);

    send_tr("single_irq_assert",
            0, ext,
            0, 16'h0, 32'h0,
            0, 16'h0,
            0, 8'h00,
            en, 1,
            8'h00,
            0);

    idle(ack_delay, ext, en);

    send_tr("single_irq_ack",
            0, ext,
            0, 16'h0, 32'h0,
            0, 16'h0,
            0, 8'h00,
            en, 0,
            8'h00,
            1);

    idle(eoi_delay, ext, en);

    send_tr("single_irq_clear",
            0, 48'h0,
            0, 16'h0, 32'h0,
            0, 16'h0,
            0, 8'h00,
            en, 0,
            8'h00,
            0);

    send_tr("single_irq_eoi",
            0, 48'h0,
            0, 16'h0, 32'h0,
            0, 16'h0,
            1, 8'h10 + irq[7:0],
            en, 0,
            8'h00,
            0);

    idle(3);

  endtask

endclass


// ============================================================
// multi_irq_seq
// ============================================================
class multi_irq_seq extends zic_comman_base_seq;

  `uvm_object_utils(multi_irq_seq)

  rand bit [7:0] irq_ctl [48];
  rand int unsigned irq_count;
  rand int unsigned ack_delay;

  constraint c {
    irq_count inside {[2:10]};
    ack_delay inside {[3:10]};
    foreach (irq_ctl[i]) irq_ctl[i] inside {[8'h01:8'hFF]};
  }

  function new(string name = "multi_irq_seq");
    super.new(name);
  endfunction

  function automatic int find_best_id(bit [47:0] mask);
    int best_id;
    bit found;
    bit [7:0] best_ctl;

    best_id  = 0;
    found    = 0;
    best_ctl = 8'h00;

    for (int i = 1; i <= 46; i++) begin
      if (mask[i]) begin
        if (!found ||
            (irq_ctl[i] > best_ctl) ||
            ((irq_ctl[i] == best_ctl) && (i > best_id))) begin
          found    = 1;
          best_id  = i;
          best_ctl = irq_ctl[i];
        end
      end
    end

    return best_id;
  endfunction

  task body();

    bit [47:0] ext;
    bit [47:0] en;
    int irq;
    int best_id;

    if (!this.randomize())
      `uvm_fatal("MULTI_IRQ_SEQ", "Randomization failed")

    ext = 48'h0;
    en  = VALID_IRQ_MASK;

    for (int i = 1; i <= 46; i++) begin
      write_ctl(i, irq_ctl[i]);
    end

    repeat (irq_count) begin
      irq = $urandom_range(1, 46);
      ext[irq] = 1'b1;
    end

    best_id = find_best_id(ext);

    send_tr("multi_irq_assert",
            0, ext,
            0, 16'h0, 32'h0,
            0, 16'h0,
            0, 8'h00,
            en, 1,
            8'h00,
            0);

    idle(ack_delay, ext, en);

    send_tr("multi_irq_ack",
            0, ext,
            0, 16'h0, 32'h0,
            0, 16'h0,
            0, 8'h00,
            en, 0,
            8'h00,
            1);

    idle(2, ext, en);

    send_tr("multi_irq_clear",
            0, 48'h0,
            0, 16'h0, 32'h0,
            0, 16'h0,
            0, 8'h00,
            en, 0,
            8'h00,
            0);

    send_tr("multi_irq_eoi",
            0, 48'h0,
            0, 16'h0, 32'h0,
            0, 16'h0,
            1, 8'h10 + best_id[7:0],
            en, 0,
            8'h00,
            0);

    idle(3);

  endtask

endclass


class priority_range_stress_seq extends uvm_sequence #(int_seq_item);

`uvm_object_utils(priority_range_stress_seq)

function new(string name="priority_range_stress_seq");
   super.new(name);
endfunction

task body();

int_seq_item tr;
bit [47:0] ext;

for(int grp=0; grp<6; grp++) begin

   ext='0;

   for(int irq=(grp*8);
       irq<((grp*8)+8) && irq<48;
       irq++) begin

      tr=int_seq_item::type_id::create("cfg");

      start_item(tr);

      tr.zic_rst=1;

      tr.zic_mmr_write_en_i=1;
      tr.zic_mmr_write_addr_i=16'h1003+(irq*4);

      case(grp)
        0: tr.zic_mmr_write_data_i=32'h00000010;
        1: tr.zic_mmr_write_data_i=32'h00000040;
        2: tr.zic_mmr_write_data_i=32'h00000080;
        3: tr.zic_mmr_write_data_i=32'h000000B0;
        4: tr.zic_mmr_write_data_i=32'h000000D0;
        5: tr.zic_mmr_write_data_i=32'h000000FF;
      endcase

      finish_item(tr);

      ext[irq]=1;

   end

   tr=int_seq_item::type_id::create("drive");

   start_item(tr);

   tr.ext_int=ext;
   tr.global_int_enable_valid_i=1;
   tr.global_int_enable_bit_i=48'h7FFF_FFFFFFFE;

   finish_item(tr);

end

endtask

endclass

// ============================================================
// FULL REGRESSION SEQUENCE
// ============================================================
class zic_full_regression_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(zic_full_regression_seq)

  reset_basic_seq                reset_seq;
  mmr_basic_seq                  mmr_seq;
  single_irq_seq                 single_seq;
  multi_irq_seq                  multi_seq;
  random_enable_mask_seq         enable_seq;
  random_equal_priority_seq      equal_seq;
  same_priority_random_seq       same_pri_seq;
  dynamic_priority_override_seq  dyn_pri_seq;
 // random_ack_latency_seq         ack_lat_seq;
  random_eoi_progression_seq     eoi_seq;
  random_all_48_irq_seq          all_irq_seq;
  random_interrupt_storm_seq     storm_seq;
  rand_storm_seq                 rand_storm;
  priority_range_stress_seq pri_seq;


  function new(string name = "zic_full_regression_seq");
    super.new(name);
  endfunction

  task body();

    `uvm_info("ZIC_REG_SEQ", "FULL ZIC RANDOM REGRESSION STARTED", UVM_LOW)

    repeat (10) begin
      reset_seq = reset_basic_seq::type_id::create("reset_seq");
      reset_seq.start(m_sequencer);
    end

    repeat (20) begin
      mmr_seq = mmr_basic_seq::type_id::create("mmr_seq");
      mmr_seq.start(m_sequencer);
    end

    repeat (30) begin
      single_seq = single_irq_seq::type_id::create("single_seq");
      single_seq.start(m_sequencer);
    end

    repeat (30) begin
      multi_seq = multi_irq_seq::type_id::create("multi_seq");
      multi_seq.start(m_sequencer);
    end

    repeat (30) begin
      enable_seq = random_enable_mask_seq::type_id::create("enable_seq");
      enable_seq.start(m_sequencer);
    end

    repeat (30) begin
      equal_seq = random_equal_priority_seq::type_id::create("equal_seq");
      equal_seq.start(m_sequencer);
    end

    repeat (30) begin
      same_pri_seq = same_priority_random_seq::type_id::create("same_pri_seq");
      same_pri_seq.start(m_sequencer);
    end

    repeat (30) begin
      dyn_pri_seq = dynamic_priority_override_seq::type_id::create("dyn_pri_seq");
      dyn_pri_seq.start(m_sequencer);
    end

  //  repeat (30) begin
 //     ack_lat_seq = random_ack_latency_seq::type_id::create("ack_lat_seq");
 //     ack_lat_seq.start(m_sequencer);
//    end

    repeat (30) begin
      eoi_seq = random_eoi_progression_seq::type_id::create("eoi_seq");
      eoi_seq.start(m_sequencer);
    end

    repeat (10) begin
      all_irq_seq = random_all_48_irq_seq::type_id::create("all_irq_seq");
      all_irq_seq.start(m_sequencer);
    end

    repeat(20) begin
      pri_seq=priority_range_stress_seq::type_id::create("pri_seq");
      pri_seq.start(m_sequencer);
    end


    storm_seq = random_interrupt_storm_seq::type_id::create("storm_seq");
    storm_seq.storm_cycles = 500;
    storm_seq.start(m_sequencer);

    rand_storm = rand_storm_seq::type_id::create("rand_storm");
    rand_storm.storm_cycles = 1000;
    rand_storm.start(m_sequencer);

    `uvm_info("ZIC_REG_SEQ", "FULL ZIC RANDOM REGRESSION COMPLETED", UVM_LOW)

  endtask

endclass

