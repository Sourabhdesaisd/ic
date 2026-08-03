class int_driver extends uvm_driver #(int_seq_item);

  `uvm_component_utils(int_driver)

  virtual intf vif;

  function new(string name = "int_driver",
               uvm_component parent);
    super.new(name, parent);
  endfunction


  //============================================================
  // Build Phase
  //============================================================
  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if (!uvm_config_db #(virtual intf)::get(this, "", "vif", vif))
      `uvm_fatal("INT_DRV", "Virtual Interface not found")

  endfunction


  //============================================================
  // Drive Idle Values
  //============================================================
  task drive_idle();

    vif.soc_rst <= 1'b1;

    vif.ext_int <= 16'h0000;

    vif.debug_mode_valid_i <= 1'b0;

  endtask


  //============================================================
  // Reset
  //============================================================
  task drive_reset();

    `uvm_info(get_type_name(),"Driving Reset",UVM_LOW)

    drive_idle();

    @(posedge vif.soc_clk);

    vif.soc_rst <= 1'b0;

    repeat(5)
      @(posedge vif.soc_clk);

    vif.soc_rst <= 1'b1;

    repeat(3)
      @(posedge vif.soc_clk);

  endtask


  //============================================================
  // Drive External Interrupt
  //============================================================
  task drive_normal(int_seq_item tr);

    @(posedge vif.soc_clk);

    vif.soc_rst <= 1'b1;

    vif.ext_int <= tr.ext_int;

    vif.debug_mode_valid_i <= tr.debug_mode_valid_i;

    @(posedge vif.soc_clk);

    // Remove interrupt after one clock
    vif.ext_int <= 16'h0000;

    vif.debug_mode_valid_i <= 1'b0;

  endtask


  //============================================================
  // Run Phase
  //============================================================
  task run_phase(uvm_phase phase);

    super.run_phase(phase);

    drive_idle();

    forever begin

      seq_item_port.get_next_item(req);

      if(req.soc_rst == 1'b0)
        drive_reset();
      else
        drive_normal(req);

      seq_item_port.item_done();

    end

  endtask

endclass
