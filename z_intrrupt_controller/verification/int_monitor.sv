class int_monitor extends uvm_monitor;

  `uvm_component_utils(int_monitor)

  virtual intf vif;

  uvm_analysis_port #(int_seq_item) mon_ap;

  bit [7:0] irq_ctl_mirror [48];

  // ACK compare control
  bit ack_check_pending;

  localparam bit [15:0] IRQ_CTL_BASE = 16'h1003;

  function new(string name = "int_monitor", uvm_component parent);
    super.new(name, parent);
    mon_ap = new("mon_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual intf)::get(this, "", "vif", vif)) begin
      `uvm_fatal("MON", "virtual interface not found")
    end

    foreach (irq_ctl_mirror[i]) begin
      irq_ctl_mirror[i] = 8'h00;
    end

    ack_check_pending = 1'b0;
  endfunction

  function automatic int get_irq_id_from_ctl_addr(bit [15:0] addr);
    int id;

    if (addr < IRQ_CTL_BASE)
      return -1;

    if (((addr - IRQ_CTL_BASE) % 4) != 0)
      return -1;

    id = (addr - IRQ_CTL_BASE) / 4;

    if (id < 0 || id >= 48)
      return -1;

    return id;
  endfunction

  task run_phase(uvm_phase phase);
    int_seq_item tr;

    forever begin
      @(posedge vif.zic_clk);

      tr = int_seq_item::type_id::create("tr", this);

      sample_dut(tr);
      update_mirror(tr);
      update_ack_compare_control(tr);
      predict_expected(tr);

      mon_ap.write(tr);
    end
  endtask

  task sample_dut(int_seq_item tr);

    // DUT outputs
    tr.interrupt_request_o       = vif.interrupt_request_o;
    tr.zic_ack_int_id_o          = vif.zic_ack_int_id_o;
    tr.highest_pending_lvl_pr_o  = vif.highest_pending_lvl_pr_o;

    // DUT inputs
    tr.ext_int                   = vif.ext_int;

    tr.zic_mmr_write_en_i        = vif.zic_mmr_write_en_i;
    tr.zic_mmr_write_addr_i      = vif.zic_mmr_write_addr_i;
    tr.zic_mmr_write_data_i      = vif.zic_mmr_write_data_i;

    tr.zic_mmr_read_en_i         = vif.zic_mmr_read_en_i;
    tr.zic_mmr_read_addr_i       = vif.zic_mmr_read_addr_i;

    tr.zic_ack_read_valid_en     = vif.zic_ack_read_valid_en;

    tr.global_int_enable_bit_i   = vif.global_int_enable_bit_i;
    tr.global_int_enable_valid_i = vif.global_int_enable_valid_i;

  endtask

  task update_mirror(int_seq_item tr);
    int irq_id;

    if (tr.zic_mmr_write_en_i) begin

      irq_id = get_irq_id_from_ctl_addr(tr.zic_mmr_write_addr_i);

      if (irq_id != -1) begin
        irq_ctl_mirror[irq_id] = tr.zic_mmr_write_data_i[7:0];

        `uvm_info("MON_MIRROR",
          $sformatf("IRQ%0d CTL mirror updated: addr=0x%0h data=0x%0h",
                    irq_id,
                    tr.zic_mmr_write_addr_i,
                    irq_ctl_mirror[irq_id]),
          UVM_MEDIUM)
      end

    end
  endtask

  task update_ack_compare_control(int_seq_item tr);

    // When sequence/core asks for ACK read, arm one compare.
    if (tr.zic_ack_read_valid_en) begin
      ack_check_pending = 1'b1;
    end

    // Default: no compare this cycle.
    tr.zic_ack_read_valid_en = 1'b0;

    // Compare only when ACK output becomes valid.
    // Your DUT ACK encoding is non-zero:
    // IRQ5 -> 0x15, IRQ6 -> 0x16, etc.
    if (ack_check_pending && (tr.zic_ack_int_id_o != 8'h00)) begin
      tr.zic_ack_read_valid_en = 1'b1;
      ack_check_pending        = 1'b0;
    end

  endtask

  task predict_expected(int_seq_item tr);

    int best_id;
    bit [7:0] best_lvl_pr;

    best_id     = -1;
    best_lvl_pr = 8'h00;

    tr.exp_valid          = 1'b0;
    tr.exp_irq_req        = 1'b0;
    tr.exp_ack_id         = 8'h00;
    tr.exp_highest_lvl_pr = 8'h00;

    // Generic interrupt prediction
    for (int i = 0; i < 48; i++) begin

      if (tr.ext_int[i] && tr.global_int_enable_bit_i[i]) begin

        if (best_id == -1) begin
          best_id     = i;
          best_lvl_pr = irq_ctl_mirror[i];
        end
        else if (irq_ctl_mirror[i] > best_lvl_pr) begin
          best_id     = i;
          best_lvl_pr = irq_ctl_mirror[i];
        end
        else if (irq_ctl_mirror[i] == best_lvl_pr) begin
          if (i > best_id) begin
            best_id     = i;
            best_lvl_pr = irq_ctl_mirror[i];
          end
        end

      end
    end

    if (best_id != -1) begin

      tr.exp_irq_req        = 1'b1;

      // DUT ACK encoding:
      // IRQ5 -> 8'h15
      // IRQ6 -> 8'h16
      tr.exp_ack_id         = 8'h10 + best_id[7:0];

      tr.exp_highest_lvl_pr = best_lvl_pr;

      // Compare only when ACK output is actually valid.
      if (tr.zic_ack_read_valid_en) begin
        tr.exp_valid = 1'b1;
      end

    end

    `uvm_info("MON_PREDICT",
      $sformatf("ack_compare=%0b pending=%0b ext_int=0x%0h en=0x%0h | EXP valid=%0b irq=%0b ack=0x%0h lvl_pr=0x%0h | ACT irq=%0b ack=0x%0h lvl_pr=0x%0h",
                tr.zic_ack_read_valid_en,
                ack_check_pending,
                tr.ext_int,
                tr.global_int_enable_bit_i,
                tr.exp_valid,
                tr.exp_irq_req,
                tr.exp_ack_id,
                tr.exp_highest_lvl_pr,
                tr.interrupt_request_o,
                tr.zic_ack_int_id_o,
                tr.highest_pending_lvl_pr_o),
      UVM_MEDIUM)

  endtask

endclass


/*

class int_monitor extends uvm_monitor;

  `uvm_component_utils(int_monitor)

  virtual intf vif;

  uvm_analysis_port #(int_seq_item) mon_ap;

  bit [7:0] irq_ctl_mirror [48];

  // ACK compare control
  bit ack_check_pending;

  localparam bit [15:0] IRQ_CTL_BASE = 16'h1003;

  function new(string name = "int_monitor", uvm_component parent);
    super.new(name, parent);
    mon_ap = new("mon_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual intf)::get(this, "", "vif", vif)) begin
      `uvm_fatal("MON", "virtual interface not found")
    end

    foreach (irq_ctl_mirror[i]) begin
      irq_ctl_mirror[i] = 8'h00;
    end

    ack_check_pending = 1'b0;
  endfunction

  function automatic int get_irq_id_from_ctl_addr(bit [15:0] addr);
    int id;

    if (addr < IRQ_CTL_BASE)
      return -1;

    if (((addr - IRQ_CTL_BASE) % 4) != 0)
      return -1;

    id = (addr - IRQ_CTL_BASE) / 4;

    if (id < 0 || id >= 48)
      return -1;

    return id;
  endfunction

  task run_phase(uvm_phase phase);
    int_seq_item tr;

    forever begin
      @(posedge vif.zic_clk);

      tr = int_seq_item::type_id::create("tr", this);

      sample_dut(tr);
      update_mirror(tr);
      update_ack_compare_control(tr);
      predict_expected(tr);

      mon_ap.write(tr);
    end
  endtask

  task sample_dut(int_seq_item tr);

    // DUT outputs
    tr.interrupt_request_o       = vif.interrupt_request_o;
    tr.zic_ack_int_id_o          = vif.zic_ack_int_id_o;
    tr.highest_pending_lvl_pr_o  = vif.highest_pending_lvl_pr_o;

    // DUT inputs
    tr.ext_int                   = vif.ext_int;

    tr.zic_mmr_write_en_i        = vif.zic_mmr_write_en_i;
    tr.zic_mmr_write_addr_i      = vif.zic_mmr_write_addr_i;
    tr.zic_mmr_write_data_i      = vif.zic_mmr_write_data_i;

    tr.zic_mmr_read_en_i         = vif.zic_mmr_read_en_i;
    tr.zic_mmr_read_addr_i       = vif.zic_mmr_read_addr_i;

    tr.zic_ack_read_valid_en     = vif.zic_ack_read_valid_en;

    tr.global_int_enable_bit_i   = vif.global_int_enable_bit_i;
    tr.global_int_enable_valid_i = vif.global_int_enable_valid_i;

  endtask

  task update_mirror(int_seq_item tr);
    int irq_id;

    if (tr.zic_mmr_write_en_i) begin

      irq_id = get_irq_id_from_ctl_addr(tr.zic_mmr_write_addr_i);

      if (irq_id != -1) begin
        irq_ctl_mirror[irq_id] = tr.zic_mmr_write_data_i[7:0];

        `uvm_info("MON_MIRROR",
          $sformatf("IRQ%0d CTL mirror updated: addr=0x%0h data=0x%0h",
                    irq_id,
                    tr.zic_mmr_write_addr_i,
                    irq_ctl_mirror[irq_id]),
          UVM_MEDIUM)
      end

    end
  endtask

  task update_ack_compare_control(int_seq_item tr);

    // When sequence/core asks for ACK read, arm one compare.
    if (tr.zic_ack_read_valid_en) begin
      ack_check_pending = 1'b1;
    end

    // Default: no compare this cycle.
    tr.zic_ack_read_valid_en = 1'b0;

    // Compare only when ACK output becomes valid.
    // Your DUT ACK encoding is non-zero:
    // IRQ5 -> 0x15, IRQ6 -> 0x16, etc.
    if (ack_check_pending && (tr.zic_ack_int_id_o != 8'h00)) begin
      tr.zic_ack_read_valid_en = 1'b1;
      ack_check_pending        = 1'b0;
    end

  endtask

  task predict_expected(int_seq_item tr);

    int best_id;
    bit [7:0] best_lvl_pr;

    best_id     = -1;
    best_lvl_pr = 8'h00;

    tr.exp_valid          = 1'b0;
    tr.exp_irq_req        = 1'b0;
    tr.exp_ack_id         = 8'h00;
    tr.exp_highest_lvl_pr = 8'h00;

    // Generic interrupt prediction
    for (int i = 0; i < 48; i++) begin

      if (tr.ext_int[i] && tr.global_int_enable_bit_i[i]) begin

        if (best_id == -1) begin
          best_id     = i;
          best_lvl_pr = irq_ctl_mirror[i];
        end
        else if (irq_ctl_mirror[i] > best_lvl_pr) begin
          best_id     = i;
          best_lvl_pr = irq_ctl_mirror[i];
        end
        else if (irq_ctl_mirror[i] == best_lvl_pr) begin
          if (i > best_id) begin
            best_id     = i;
            best_lvl_pr = irq_ctl_mirror[i];
          end
        end

      end
    end

if ((best_id != -1) && (best_lvl_pr > tr.active_lvl_pr_i)) begin

      tr.exp_irq_req        = 1'b1;

      // DUT ACK encoding:
      // IRQ5 -> 8'h15
      // IRQ6 -> 8'h16
      tr.exp_ack_id         = 8'h10 + best_id[7:0];

      tr.exp_highest_lvl_pr = best_lvl_pr;

      // Compare only when ACK output is actually valid.
      if (tr.zic_ack_read_valid_en) begin
        tr.exp_valid = 1'b1;
      end

    end

    `uvm_info("MON_PREDICT",
      $sformatf("ack_compare=%0b pending=%0b ext_int=0x%0h en=0x%0h | EXP valid=%0b irq=%0b ack=0x%0h lvl_pr=0x%0h | ACT irq=%0b ack=0x%0h lvl_pr=0x%0h",
                tr.zic_ack_read_valid_en,
                ack_check_pending,
                tr.ext_int,
                tr.global_int_enable_bit_i,
                tr.exp_valid,
                tr.exp_irq_req,
                tr.exp_ack_id,
                tr.exp_highest_lvl_pr,
                tr.interrupt_request_o,
                tr.zic_ack_int_id_o,
                tr.highest_pending_lvl_pr_o),
      UVM_MEDIUM)

  endtask

endclass  */
