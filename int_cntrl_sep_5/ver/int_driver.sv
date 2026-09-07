class int_driver extends uvm_driver #(int_seq_item);

  `uvm_component_utils(int_driver)

  virtual intf vif;


  function new(
    string name = "int_driver",
    uvm_component parent
  );

    super.new(name, parent);

  endfunction


  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if (!uvm_config_db#(virtual intf)::get(
          this,
          "",
          "vif",
          vif
        )) begin

      `uvm_fatal(
        "DRV",
        "Virtual interface not found"
      )

    end

  endfunction


  // ============================================================
  // IDLE
  // ============================================================

  task drive_idle();

    vif.soc_rst = 1'b1;

    vif.ext_int = 16'h0000;

    vif.soc_mmr_write_en_i   = 1'b0;
    vif.soc_mmr_write_addr_i = 16'h0000;
    vif.soc_mmr_write_data_i = 8'h00;

    vif.soc_mmr_read_en_i    = 1'b0;
    vif.soc_mmr_read_addr_i  = 16'h0000;

    vif.soc_eoi_valid_i = 1'b0;
    vif.soc_eoi_id_i    = 8'h00;

    vif.active_lvl_pr_i = 8'h00;

    vif.global_int_enable_bit_i   = 16'h0000;
    vif.global_int_enable_valid_i = 1'b0;

    vif.debug_mode_valid_i = 1'b0;

  endtask


  // ============================================================
  // RESET
  // ============================================================

  task drive_reset();

    `uvm_info(
      "DRV",
      "RESET transaction received",
      UVM_LOW
    )

    drive_idle();

    @(posedge vif.soc_clk);

    vif.soc_rst = 1'b0;

    repeat (5)
      @(posedge vif.soc_clk);

    vif.soc_rst = 1'b1;

    repeat (2)
      @(posedge vif.soc_clk);

    `uvm_info(
      "DRV",
      "RESET done",
      UVM_LOW
    )

  endtask


  // ============================================================
  // NORMAL TRANSACTION
  // ============================================================

  task drive_normal(int_seq_item tr);

    @(posedge vif.soc_clk);

    vif.soc_rst = 1'b1;

    vif.ext_int = tr.ext_int;

    vif.soc_mmr_write_en_i   = tr.soc_mmr_write_en_i;
    vif.soc_mmr_write_addr_i = tr.soc_mmr_write_addr_i;
    vif.soc_mmr_write_data_i = tr.soc_mmr_write_data_i;

    vif.soc_mmr_read_en_i   = tr.soc_mmr_read_en_i;
    vif.soc_mmr_read_addr_i = tr.soc_mmr_read_addr_i;

    vif.global_int_enable_valid_i =
      tr.global_int_enable_valid_i;

    vif.global_int_enable_bit_i =
      tr.global_int_enable_bit_i;

    vif.soc_eoi_valid_i = tr.soc_eoi_valid_i;
    vif.soc_eoi_id_i    = tr.soc_eoi_id_i;

    vif.active_lvl_pr_i =
      tr.active_lvl_pr_i;

    vif.debug_mode_valid_i =
      tr.debug_mode_valid_i;


    `uvm_info(
      "DRV",
      $sformatf(
        "DRIVE ext=%04h en=%04h en_valid=%0b wr=%0b wr_addr=%04h wr_data=%02h rd=%0b rd_addr=%04h eoi=%0b eoi_id=%02h active=%02h debug=%0b",
        vif.ext_int,
        vif.global_int_enable_bit_i,
        vif.global_int_enable_valid_i,
        vif.soc_mmr_write_en_i,
        vif.soc_mmr_write_addr_i,
        vif.soc_mmr_write_data_i,
        vif.soc_mmr_read_en_i,
        vif.soc_mmr_read_addr_i,
        vif.soc_eoi_valid_i,
        vif.soc_eoi_id_i,
        vif.active_lvl_pr_i,
        vif.debug_mode_valid_i
      ),
      UVM_LOW
    );


    @(posedge vif.soc_clk);

    vif.soc_mmr_write_en_i        = 1'b0;
    vif.soc_mmr_read_en_i         = 1'b0;
    vif.global_int_enable_valid_i = 1'b0;
    vif.soc_eoi_valid_i           = 1'b0;

  endtask


  // ============================================================
  // RUN
  // ============================================================

  task run_phase(uvm_phase phase);

    int_seq_item req;

    `uvm_info(
      "DRV",
      "Driver run_phase started",
      UVM_LOW
    )

    drive_idle();

    forever begin

      seq_item_port.get_next_item(req);

      if (req.soc_rst == 1'b0)
        drive_reset();
      else
        drive_normal(req);

      seq_item_port.item_done();

    end

  endtask

endclass
