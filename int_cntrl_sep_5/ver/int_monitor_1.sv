class int_monitor extends uvm_monitor;

  `uvm_component_utils(int_monitor)

  //------------------------------------------------------------
  // Configuration
  //------------------------------------------------------------
  localparam int NUM_IRQ      = 16;
  localparam bit [15:0] IRQ_CTL_BASE = 16'h1003;

  //------------------------------------------------------------
  // Interface
  //------------------------------------------------------------
  virtual intf vif;

  //------------------------------------------------------------
  // Analysis Port
  //------------------------------------------------------------
  uvm_analysis_port #(int_seq_item) mon_ap;

  //------------------------------------------------------------
  // Reference Model
  //------------------------------------------------------------
  bit [31:0] irq_ctl_mirror [NUM_IRQ];
  bit [15:0] global_en_mirror;

  //------------------------------------------------------------
  // ACK Pipeline
  //------------------------------------------------------------
  bit       ack_pending;
  bit [7:0] pend_exp_ack_id;
  bit [7:0] pend_exp_lvl_pr;

  //------------------------------------------------------------
  // Constructor
  //------------------------------------------------------------
  function new(string name = "int_monitor",
               uvm_component parent);
    super.new(name,parent);
    mon_ap = new("mon_ap",this);
  endfunction

  //------------------------------------------------------------
  // Build Phase
  //------------------------------------------------------------
  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if(!uvm_config_db#(virtual intf)::get(this,"","vif",vif))
      `uvm_fatal("MON","virtual interface not found")

    reset_model();

  endfunction

  //------------------------------------------------------------
  // Reset Reference Model
  //------------------------------------------------------------
  function void reset_model();

    foreach(irq_ctl_mirror[i])
      irq_ctl_mirror[i]=32'h0;

    global_en_mirror = 16'h0000;

    ack_pending     = 1'b0;
    pend_exp_ack_id = 8'h00;
    pend_exp_lvl_pr = 8'h00;

  endfunction

    //--------------------------------------------------------------------
  // Convert IRQ_CTL register address to IRQ ID
  //--------------------------------------------------------------------
  function automatic int get_irq_id_from_ctl_addr(bit [15:0] addr);

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


  //--------------------------------------------------------------------
  // Compare two interrupt priorities
  //
  // Higher LEVEL wins.
  // If LEVEL is equal -> Higher PRIORITY wins.
  // If both equal -> Higher IRQ ID wins.
  //--------------------------------------------------------------------
  function automatic bit higher_priority
  (
      bit [7:0] cur_ctl,
      int       cur_id,
      bit [7:0] best_ctl,
      int       best_id
  );

      //----------------------------------------------------------
      // Compare LEVEL
      //----------------------------------------------------------
      if (cur_ctl[7:5] > best_ctl[7:5])
        return 1'b1;

      //----------------------------------------------------------
      // Compare PRIORITY
      //----------------------------------------------------------
      if ((cur_ctl[7:5] == best_ctl[7:5]) &&
          (cur_ctl[4:2] > best_ctl[4:2]))
        return 1'b1;

      //----------------------------------------------------------
      // Tie Break
      //----------------------------------------------------------
      if ((cur_ctl[7:5] == best_ctl[7:5]) &&
          (cur_ctl[4:2] == best_ctl[4:2]) &&
          (cur_id > best_id))
        return 1'b1;

      return 1'b0;

  endfunction

  task run_phase(uvm_phase phase);

  int_seq_item tr;

  forever begin

    //------------------------------------------------------------
    // Sample DUT after clock edge
    //------------------------------------------------------------
    @(posedge vif.soc_clk);
    #1step;

    tr = int_seq_item::type_id::create("tr", this);

    //------------------------------------------------------------
    // Collect DUT signals
    //------------------------------------------------------------
    sample_dut(tr);

    //------------------------------------------------------------
    // Reset Handling
    //------------------------------------------------------------
    if (!vif.soc_rst) begin

      reset_model();

      tr.exp_valid          = 1'b0;
      tr.exp_irq_req        = 1'b0;
      tr.exp_ack_id         = 8'h00;
      tr.exp_highest_lvl_pr = 8'h00;

      tr.exp_mmr_read_valid = 1'b0;
      tr.exp_mmr_read_data  = 32'h0000_0000;

    end
    else begin

      //----------------------------------------------------------
      // Step-1
      // Predict expected outputs using current reference model.
      //
      // At this instant DUT outputs correspond to the
      // configuration already visible inside RTL.
      //----------------------------------------------------------
      predict_expected(tr);

      //----------------------------------------------------------
      // Step-2
      // Predict expected MMR read.
      //----------------------------------------------------------
      predict_mmr_read(tr);

      //----------------------------------------------------------
      // Step-3
      // AFTER prediction update the mirror.
      //
      // New programming becomes visible for NEXT clock.
      //----------------------------------------------------------
      update_mirror(tr);

    end

    //------------------------------------------------------------
    // Send transaction
    //------------------------------------------------------------
    mon_ap.write(tr);

  end

endtask

task predict_expected(int_seq_item tr);

  int       best_id;
  bit       best_found;
  bit [7:0] best_ctl;

  //------------------------------------------------------------
  // Initialize
  //------------------------------------------------------------
  best_id    = 0;
  best_found = 1'b0;
  best_ctl   = 8'h00;

  tr.exp_valid          = 1'b0;
  tr.exp_irq_req        = 1'b0;
  tr.exp_ack_id         = 8'h00;
  tr.exp_highest_lvl_pr = 8'h00;

  //------------------------------------------------------------
  // Scan all interrupts
  //------------------------------------------------------------
  for (int i = 0; i < NUM_IRQ; i++) begin

    //----------------------------------------------------------
    // Interrupt is eligible only if:
    //   1. External interrupt asserted
    //   2. Global enable set
    //----------------------------------------------------------
    if (tr.ext_int[i] && global_en_mirror[i]) begin

      //--------------------------------------------------------
      // First valid interrupt
      //--------------------------------------------------------
      if (!best_found) begin
        best_found = 1'b1;
        best_id    = i;
        best_ctl   = irq_ctl_mirror[i][7:0];
      end

      //--------------------------------------------------------
      // Compare against current best interrupt
      //--------------------------------------------------------
      else if (higher_priority(
                    irq_ctl_mirror[i][7:0],
                    i,
                    best_ctl,
                    best_id)) begin

        best_id  = i;
        best_ctl = irq_ctl_mirror[i][7:0];

      end

    end

  end

  //------------------------------------------------------------
  // Debug
  //------------------------------------------------------------
  `uvm_info("MON_DEBUG",
    $sformatf(
      "best_found=%0b best_id=%0d best_ctl=%02h active_lvl=%02h active_level=%0d best_level=%0d ext=%04h en=%04h",
      best_found,
      best_id,
      best_ctl,
      tr.active_lvl_pr_i,
      tr.active_lvl_pr_i[7:5],
      best_ctl[7:5],
      tr.ext_int,
      global_en_mirror),
    UVM_LOW)

  //------------------------------------------------------------
  // Interrupt Request Prediction
  //
  // RTL compares ONLY LEVEL bits.
  //------------------------------------------------------------
  if (best_found &&
      (best_ctl[7:5] > tr.active_lvl_pr_i[7:5])) begin

    tr.exp_irq_req        = 1'b1;
    tr.exp_ack_id         = 8'h10 + best_id[7:0];
    tr.exp_highest_lvl_pr = best_ctl;

  end

    //------------------------------------------------------------
  // Default
  //------------------------------------------------------------
  tr.exp_valid = 1'b0;

  //------------------------------------------------------------
  // ACK Prediction
  //
  // Case-1:
  // ACK request and ACK ID available in same cycle.
  //------------------------------------------------------------
  if (tr.soc_ack_read_valid_en &&
      tr.exp_irq_req &&
      (tr.soc_ack_int_id_o != 8'h00)) begin

    tr.exp_valid = 1'b1;

    `uvm_info("ACK_PREDICT",
      $sformatf("Immediate ACK detected exp_ack=%0h act_ack=%0h",
                tr.exp_ack_id,
                tr.soc_ack_int_id_o),
      UVM_LOW)

  end

  //------------------------------------------------------------
  // Case-2:
  // ACK request observed but DUT has not yet returned ACK ID.
  //------------------------------------------------------------
  else if (tr.soc_ack_read_valid_en &&
           tr.exp_irq_req &&
           (tr.soc_ack_int_id_o == 8'h00)) begin

    ack_pending     = 1'b1;
    pend_exp_ack_id = tr.exp_ack_id;
    pend_exp_lvl_pr = tr.exp_highest_lvl_pr;

    `uvm_info("ACK_PENDING",
      $sformatf("ACK delayed exp_ack=%0h",
                pend_exp_ack_id),
      UVM_LOW)

  end

  //------------------------------------------------------------
  // Case-3:
  // Delayed ACK arrives.
  //------------------------------------------------------------
  else if (ack_pending &&
           (tr.soc_ack_int_id_o != 8'h00)) begin

    tr.exp_valid          = 1'b1;
    tr.exp_ack_id         = pend_exp_ack_id;
    tr.exp_highest_lvl_pr = pend_exp_lvl_pr;

    ack_pending = 1'b0;

    `uvm_info("ACK_PENDING",
      $sformatf("Delayed ACK matched exp=%0h act=%0h",
                tr.exp_ack_id,
                tr.soc_ack_int_id_o),
      UVM_LOW)

  end

  //------------------------------------------------------------
  // Debug Print
  //------------------------------------------------------------
  `uvm_info("MON_PREDICT",
    $sformatf(
      "ext=%04h en=%04h best_id=%0d best_ctl=%02h active_lvl=%02h | exp_irq=%0b exp_valid=%0b exp_ack=%02h exp_lvl=%02h | act_irq=%0b act_ack=%02h act_lvl=%02h",
      tr.ext_int,
      global_en_mirror,
      best_id,
      best_ctl,
      tr.active_lvl_pr_i,
      tr.exp_irq_req,
      tr.exp_valid,
      tr.exp_ack_id,
      tr.exp_highest_lvl_pr,
      tr.interrupt_request_o,
      tr.soc_ack_int_id_o,
      tr.highest_pending_lvl_pr_o),
    UVM_MEDIUM)

endtask

  //--------------------------------------------------------------------
  // Sample DUT Interface Signals
  //--------------------------------------------------------------------
  task sample_dut(int_seq_item tr);

    //------------------------------------------------------------
    // Reset
    //------------------------------------------------------------
    tr.soc_rst = vif.soc_rst;

    //------------------------------------------------------------
    // DUT Outputs
    //------------------------------------------------------------
    tr.interrupt_request_o      = vif.interrupt_request_o;
    tr.soc_ack_int_id_o         = vif.soc_ack_int_id_o;
    tr.highest_pending_lvl_pr_o = vif.highest_pending_lvl_pr_o;
    tr.soc_mmr_read_data_o      = vif.soc_mmr_read_data_o;

    //------------------------------------------------------------
    // External Interrupt Inputs
    //------------------------------------------------------------
    tr.ext_int = vif.ext_int[15:0];

    //------------------------------------------------------------
    // MMR Write Interface
    //------------------------------------------------------------
    tr.soc_mmr_write_en_i   = vif.soc_mmr_write_en_i;
    tr.soc_mmr_write_addr_i = vif.soc_mmr_write_addr_i;
    tr.soc_mmr_write_data_i = vif.soc_mmr_write_data_i;

    //------------------------------------------------------------
    // MMR Read Interface
    //------------------------------------------------------------
    tr.soc_mmr_read_en_i   = vif.soc_mmr_read_en_i;
    tr.soc_mmr_read_addr_i = vif.soc_mmr_read_addr_i;

    //------------------------------------------------------------
    // ACK Interface
    //------------------------------------------------------------
    tr.soc_ack_read_valid_en = vif.soc_ack_read_valid_en;

    //------------------------------------------------------------
    // End Of Interrupt
    //------------------------------------------------------------
    tr.soc_eoi_valid_i = vif.soc_eoi_valid_i;
    tr.soc_eoi_id_i    = vif.soc_eoi_id_i;

    //------------------------------------------------------------
    // Active Interrupt Level
    //------------------------------------------------------------
    tr.active_lvl_pr_i = vif.active_lvl_pr_i;

    //------------------------------------------------------------
    // Global Interrupt Enable
    //------------------------------------------------------------
    tr.global_int_enable_bit_i   = vif.global_int_enable_bit_i[15:0];
    tr.global_int_enable_valid_i = vif.global_int_enable_valid_i;

    //------------------------------------------------------------
    // Debug Signals
    //------------------------------------------------------------
    tr.debug_mode_valid_i = vif.debug_mode_valid_i;
    tr.debug_mode_reset_i = vif.debug_mode_reset_i;
    tr.debug_ndm_reset_i  = vif.debug_ndm_reset_i;

    //------------------------------------------------------------
    // Debug Print
    //------------------------------------------------------------
    `uvm_info("RAW_DUT",
      $sformatf(
      "ext=%04h irq_req=%0b highest_lvl=%02h ack=%02h active_lvl=%02h",
      tr.ext_int,
      tr.interrupt_request_o,
      tr.highest_pending_lvl_pr_o,
      tr.soc_ack_int_id_o,
      tr.active_lvl_pr_i),
      UVM_LOW)

  endtask


    //--------------------------------------------------------------------
  // Update Reference Model
  //
  // NOTE:
  // This task is called AFTER prediction.
  // Therefore any register programming performed in this cycle
  // becomes visible from the NEXT sampled cycle.
  //--------------------------------------------------------------------
  task update_mirror(int_seq_item tr);

    int irq_id;

    //------------------------------------------------------------
    // IRQ Control Register Programming
    //------------------------------------------------------------
    if (tr.soc_mmr_write_en_i) begin

      irq_id = get_irq_id_from_ctl_addr(tr.soc_mmr_write_addr_i);

      if (irq_id != -1) begin

        irq_ctl_mirror[irq_id] = tr.soc_mmr_write_data_i;

        `uvm_info("MON_MIRROR",
          $sformatf(
            "IRQ%0d CTL Updated Addr=0x%04h Data=0x%08h",
            irq_id,
            tr.soc_mmr_write_addr_i,
            irq_ctl_mirror[irq_id]),
          UVM_MEDIUM)

      end
      else begin

        `uvm_warning("MON_MIRROR",
          $sformatf(
            "Unknown IRQ_CTL address 0x%04h",
            tr.soc_mmr_write_addr_i))

      end

    end

    //------------------------------------------------------------
    // Global Interrupt Enable Programming
    //------------------------------------------------------------
    if (tr.global_int_enable_valid_i) begin

      global_en_mirror = tr.global_int_enable_bit_i;

      `uvm_info("GLOBAL_UPDATE",
        $sformatf(
          "GLOBAL_EN Mirror Updated = 0x%04h",
          global_en_mirror),
        UVM_LOW)

    end

  endtask


    //--------------------------------------------------------------------
  // Predict MMR Read Data
  //--------------------------------------------------------------------
  task predict_mmr_read(int_seq_item tr);

    int irq_id;

    tr.exp_mmr_read_valid = 1'b0;
    tr.exp_mmr_read_data  = 32'h00000000;

    if (tr.soc_mmr_read_en_i) begin

      irq_id = get_irq_id_from_ctl_addr(tr.soc_mmr_read_addr_i);

      if (irq_id != -1) begin

        tr.exp_mmr_read_valid = 1'b1;
        tr.exp_mmr_read_data  = irq_ctl_mirror[irq_id];

        `uvm_info("MMR_READ",
          $sformatf(
            "Predicted Read IRQ%0d Data=0x%08h",
            irq_id,
            tr.exp_mmr_read_data),
          UVM_LOW)

      end
      else begin

        `uvm_warning("MMR_READ",
          $sformatf(
            "Unknown Read Address 0x%04h",
            tr.soc_mmr_read_addr_i))

      end

    end

  endtask

endclass

  
