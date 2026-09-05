class int_monitor extends uvm_monitor;

  `uvm_component_utils(int_monitor)

  localparam int NUM_IRQ = 16;
  localparam bit [15:0] IRQ_CTL_BASE = 16'h9014;

  virtual intf vif;
  uvm_analysis_port #(int_seq_item) mon_ap;

  bit [7:0]  irq_ctl_mirror [NUM_IRQ];
  bit [15:0] global_en_mirror;


  function new(string name = "int_monitor",
               uvm_component parent = null);
    super.new(name, parent);
    mon_ap = new("mon_ap", this);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual intf)::get(
          this, "", "vif", vif)) begin
      `uvm_fatal("MON", "virtual interface not found")
    end

    reset_model();
  endfunction


  function void reset_model();

    foreach (irq_ctl_mirror[i])
      irq_ctl_mirror[i] = 8'h00;

    global_en_mirror = 16'h0000;

  endfunction


  function automatic int get_irq_id_from_ctl_addr(
    bit [15:0] addr
  );

    int id;

    if (addr < IRQ_CTL_BASE)
      return -1;

    if (((addr - IRQ_CTL_BASE) % 4) != 0)
      return -1;

    id = (addr - IRQ_CTL_BASE) / 4;

    if ((id < 0) || (id >= NUM_IRQ))
      return -1;

    return id;

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


  task run_phase(uvm_phase phase);

    int_seq_item tr;

    forever begin

      @(posedge vif.soc_clk);
      #1step;

      tr = int_seq_item::type_id::create("tr", this);

      sample_dut(tr);

      if (!vif.soc_rst) begin

        reset_model();

        tr.exp_valid          = 1'b0;
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


  task sample_dut(int_seq_item tr);

    tr.soc_rst = vif.soc_rst;

    tr.interrupt_request_o =
        vif.interrupt_request_o;

    tr.highest_pending_lvl_pr_o =
        vif.highest_pending_lvl_pr_o;

    tr.soc_mmr_read_data_o =
        vif.soc_mmr_read_data_o;

    tr.soc_read_rsp_o =
        vif.soc_read_rsp_o;

    tr.ext_int =
        vif.ext_int[15:0];

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

    tr.soc_eoi_valid_i =
        vif.soc_eoi_valid_i;

    tr.soc_eoi_id_i =
        vif.soc_eoi_id_i;

    tr.active_lvl_pr_i =
        vif.active_lvl_pr_i;

    tr.global_int_enable_bit_i =
        vif.global_int_enable_bit_i[15:0];

    tr.global_int_enable_valid_i =
        vif.global_int_enable_valid_i;

    tr.debug_mode_valid_i =
        vif.debug_mode_valid_i;

    `uvm_info("RAW_DUT",
      $sformatf(
        "ext=%04h irq_req=%0b highest_lvl=%02h read_rsp=%0b read_data=%02h",
        tr.ext_int,
        tr.interrupt_request_o,
        tr.highest_pending_lvl_pr_o,
        tr.soc_read_rsp_o,
        tr.soc_mmr_read_data_o
      ),
      UVM_LOW);

  endtask


  task update_mirror(int_seq_item tr);

    int irq_id;

    if (tr.soc_mmr_write_en_i) begin

      irq_id =
          get_irq_id_from_ctl_addr(
            tr.soc_mmr_write_addr_i
          );

      if (irq_id != -1) begin

        irq_ctl_mirror[irq_id] =
            tr.soc_mmr_write_data_i[7:0];

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


    if (tr.global_int_enable_valid_i) begin

      global_en_mirror =
          tr.global_int_enable_bit_i[15:0];

      `uvm_info("GLOBAL_UPDATE",
        $sformatf(
          "Mirror Updated -> %04h",
          global_en_mirror
        ),
        UVM_LOW);

    end

  endtask


  task predict_expected(int_seq_item tr);

    int       best_id;
    bit       best_found;
    bit [7:0] best_ctl;

    best_id    = 0;
    best_found = 1'b0;
    best_ctl   = 8'h00;

    tr.exp_valid          = 1'b0;
    tr.exp_irq_req        = 1'b0;
    tr.exp_highest_lvl_pr = 8'h00;


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


    if (best_found &&
        (best_ctl[7:5] >
         tr.active_lvl_pr_i[7:5])) begin

      tr.exp_irq_req        = 1'b1;
      tr.exp_highest_lvl_pr = best_ctl;

    end


    tr.exp_valid =
        tr.exp_irq_req;


    `uvm_info("MON_PREDICT",
      $sformatf(
        "ext=0x%04h en=0x%04h best_id=%0d best_ctl=0x%02h active_lvl=0x%02h | exp_irq=%0b exp_valid=%0b exp_lvl=0x%02h | act_irq=%0b act_lvl=0x%02h",
        tr.ext_int,
        global_en_mirror,
        best_id,
        best_ctl,
        tr.active_lvl_pr_i,
        tr.exp_irq_req,
        tr.exp_valid,
        tr.exp_highest_lvl_pr,
        tr.interrupt_request_o,
        tr.highest_pending_lvl_pr_o
      ),
      UVM_MEDIUM);

  endtask


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

        tr.exp_mmr_read_valid = 1'b1;

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

