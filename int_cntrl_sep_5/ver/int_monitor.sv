class int_monitor extends uvm_monitor;

  `uvm_component_utils(int_monitor)

  localparam int NUM_IRQ = 16;

  // ============================================================
  // IRQ CTL register map
  // IRQ0  = 0x9020
  // IRQ1  = 0x9030
  // ...
  // IRQ10 = 0x90C0
  // ...
  // IRQ15 = 0x9110
  // ============================================================

  localparam bit [15:0] IRQ_CTL_BASE = 16'h9020;
  localparam bit [15:0] IRQ_CTL_STEP = 16'h0010;


  virtual intf vif;

  uvm_analysis_port #(int_seq_item) mon_ap;


  // ============================================================
  // Mirror
  // ============================================================

  bit [7:0]  irq_ctl_mirror [NUM_IRQ];
  bit [15:0] global_en_mirror;


  // ============================================================
  // Constructor
  // ============================================================

  function new(string name = "int_monitor",
               uvm_component parent = null);

    super.new(name, parent);

    mon_ap = new("mon_ap", this);

  endfunction


  // ============================================================
  // Build
  // ============================================================

  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if (!uvm_config_db #(virtual intf)::get(
          this,
          "",
          "vif",
          vif)) begin

      `uvm_fatal("MON",
                 "virtual interface not found")

    end

    reset_model();

  endfunction


  // ============================================================
  // Reset mirror
  // ============================================================

  function void reset_model();

    foreach (irq_ctl_mirror[i])
      irq_ctl_mirror[i] = 8'h00;

    global_en_mirror = 16'h0000;

  endfunction


  // ============================================================
  // Convert CTL address to IRQ number
  // ============================================================

  function automatic int get_irq_id_from_ctl_addr(
    bit [15:0] addr
  );

    int id;
    bit [15:0] offset;

    if (addr < IRQ_CTL_BASE)
      return -1;

    offset = addr - IRQ_CTL_BASE;

    if ((offset % IRQ_CTL_STEP) != 0)
      return -1;

    id = offset / IRQ_CTL_STEP;

    if ((id < 0) || (id >= NUM_IRQ))
      return -1;

    return id;

  endfunction


  // ============================================================
  // Priority comparison
  // ============================================================

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


  // ============================================================
  // Run phase
  // ============================================================

  task run_phase(uvm_phase phase);

    int_seq_item tr;

    forever begin

      @(posedge vif.soc_clk);

      #1step;

      tr = int_seq_item::type_id::create("tr", this);

      sample_dut(tr);

      if (!vif.soc_rst) begin

        reset_model();

        tr.exp_irq_req        = 1'b0;
        tr.exp_highest_lvl_pr = 8'h00;

        tr.exp_mmr_read_valid = 1'b0;
        tr.exp_mmr_read_data  = 8'h00;

      end
      else begin

        update_mirror(tr);

        predict_expected(tr);

        predict_mmr_read(tr);

      end

      mon_ap.write(tr);

    end

  endtask


  // ============================================================
  // Sample DUT
  // ============================================================

  task sample_dut(int_seq_item tr);

    tr.soc_rst = vif.soc_rst;


    // ------------------------------------------------------------
    // DUT outputs
    // ------------------------------------------------------------

    tr.interrupt_request_o =
        vif.interrupt_request_o;

    tr.highest_pending_lvl_pr_o =
        vif.highest_pending_lvl_pr_o;

    tr.current_int_id_o =
        vif.current_int_id_o;

    tr.trace_data_int_o =
        vif.trace_data_int_o;

    tr.trace_event_int_o =
        vif.trace_event_int_o;

    tr.soc_mmr_read_data_o =
        vif.soc_mmr_read_data_o;

    tr.soc_read_rsp_o =
        vif.soc_read_rsp_o;


    // ------------------------------------------------------------
    // External interrupts
    // ------------------------------------------------------------

    tr.ext_int =
        vif.ext_int[15:0];


    // ------------------------------------------------------------
    // MMR
    // ------------------------------------------------------------

    tr.soc_mmr_write_en_i =
        vif.soc_mmr_write_en_i;

    tr.soc_mmr_write_addr_i =
        vif.soc_mmr_write_addr_i;

    tr.soc_mmr_write_data_i =
        vif.soc_mmr_write_data_i;

    tr.soc_mmr_read_en_i =
        vif.soc_mmr_read_en_i;

    tr.soc_mmr_read_addr_i =
        vif.soc_mmr_read_addr_i;


    // ------------------------------------------------------------
    // EOI
    // ------------------------------------------------------------

    tr.soc_eoi_valid_i =
        vif.soc_eoi_valid_i;

    tr.soc_eoi_id_i =
        vif.soc_eoi_id_i;


    // ------------------------------------------------------------
    // Active priority
    // ------------------------------------------------------------

    tr.active_lvl_pr_i =
        vif.active_lvl_pr_i;


    // ------------------------------------------------------------
    // Global enable
    // ------------------------------------------------------------

    tr.global_int_enable_bit_i =
        vif.global_int_enable_bit_i[15:0];

    tr.global_int_enable_valid_i =
        vif.global_int_enable_valid_i;


    // ------------------------------------------------------------
    // Debug
    // ------------------------------------------------------------

    tr.debug_mode_valid_i =
        vif.debug_mode_valid_i;


    `uvm_info("RAW_DUT",
      $sformatf(
        "ext=%04h irq_req=%0b current_id=%02h highest_lvl=%02h read_rsp=%0b read_data=%02h",
        tr.ext_int,
        tr.interrupt_request_o,
        tr.current_int_id_o,
        tr.highest_pending_lvl_pr_o,
        tr.soc_read_rsp_o,
        tr.soc_mmr_read_data_o
      ),
      UVM_LOW);

  endtask


  // ============================================================
  // Update mirror
  // ============================================================

  task update_mirror(int_seq_item tr);

    int irq_id;


    // ------------------------------------------------------------
    // CTL write
    // ------------------------------------------------------------

    if (tr.soc_mmr_write_en_i) begin

      irq_id =
          get_irq_id_from_ctl_addr(
            tr.soc_mmr_write_addr_i
          );

      if (irq_id != -1) begin

        irq_ctl_mirror[irq_id] =
            tr.soc_mmr_write_data_i;

        `uvm_info("MON_MIRROR",
          $sformatf(
            "IRQ%0d CTL mirror updated addr=0x%04h data=0x%02h",
            irq_id,
            tr.soc_mmr_write_addr_i,
            irq_ctl_mirror[irq_id]
          ),
          UVM_MEDIUM);

      end

    end


    // ------------------------------------------------------------
    // Global enable update
    // ------------------------------------------------------------

    if (tr.global_int_enable_valid_i) begin

      global_en_mirror =
          tr.global_int_enable_bit_i[15:0];

      `uvm_info("GLOBAL_UPDATE",
        $sformatf(
          "Global enable mirror updated -> %04h",
          global_en_mirror
        ),
        UVM_LOW);

    end

  endtask


  // ============================================================
  // Predict interrupt request
  // ============================================================

  task predict_expected(int_seq_item tr);

    int       best_id;
    bit       best_found;
    bit [7:0] best_ctl;


    best_id    = -1;
    best_found = 1'b0;
    best_ctl   = 8'h00;

    tr.exp_irq_req        = 1'b0;
    tr.exp_highest_lvl_pr = 8'h00;


    // ------------------------------------------------------------
    // Search highest priority enabled interrupt
    // ------------------------------------------------------------

    for (int i = 0; i < NUM_IRQ; i++) begin

      if (tr.ext_int[i] &&
          global_en_mirror[i]) begin

        if (!best_found) begin

          best_found = 1'b1;
          best_id    = i;
          best_ctl   = irq_ctl_mirror[i];

        end
        else if (higher_priority(
                   irq_ctl_mirror[i],
                   i,
                   best_ctl,
                   best_id)) begin

          best_id  = i;
          best_ctl = irq_ctl_mirror[i];

        end

      end

    end


    `uvm_info("MON_DEBUG",
      $sformatf(
        "best_found=%0b best_id=%0d best_ctl=%02h active_lvl=%02h ext=%04h en=%04h",
        best_found,
        best_id,
        best_ctl,
        tr.active_lvl_pr_i,
        tr.ext_int,
        global_en_mirror
      ),
      UVM_LOW);


    // ------------------------------------------------------------
    // Priority threshold check
    // ------------------------------------------------------------

    if (best_found &&
        (best_ctl[7:5] >
         tr.active_lvl_pr_i[7:5])) begin

      tr.exp_irq_req =
          1'b1;

      tr.exp_highest_lvl_pr =
          best_ctl;

    end


    `uvm_info("MON_PREDICT",
      $sformatf(
        "ext=0x%04h en=0x%04h best_id=%0d best_ctl=0x%02h active_lvl=0x%02h | exp_irq=%0b exp_lvl=0x%02h | act_irq=%0b act_id=0x%02h act_lvl=0x%02h",
        tr.ext_int,
        global_en_mirror,
        best_id,
        best_ctl,
        tr.active_lvl_pr_i,
        tr.exp_irq_req,
        tr.exp_highest_lvl_pr,
        tr.interrupt_request_o,
        tr.current_int_id_o,
        tr.highest_pending_lvl_pr_o
      ),
      UVM_MEDIUM);

  endtask


  // ============================================================
  // Predict MMR read
  // ============================================================

  task predict_mmr_read(int_seq_item tr);

    int irq_id;

    tr.exp_mmr_read_valid = 1'b0;
    tr.exp_mmr_read_data  = 8'h00;


    if (tr.soc_mmr_read_en_i) begin

      irq_id =
          get_irq_id_from_ctl_addr(
            tr.soc_mmr_read_addr_i
          );

      if (irq_id != -1) begin

        tr.exp_mmr_read_valid =
            1'b1;

        tr.exp_mmr_read_data =
            irq_ctl_mirror[irq_id];

        `uvm_info("MON_READ",
          $sformatf(
            "addr=0x%04h irq=%0d exp_data=0x%02h rsp=%0b actual=0x%02h",
            tr.soc_mmr_read_addr_i,
            irq_id,
            tr.exp_mmr_read_data,
            tr.soc_read_rsp_o,
            tr.soc_mmr_read_data_o
          ),
          UVM_LOW);

      end

    end

  endtask

endclass
