class int_monitor extends uvm_monitor;

  `uvm_component_utils(int_monitor)

  virtual intf vif;

  uvm_analysis_port #(int_seq_item) ap;

  int_seq_item tr;

  function new(string name = "int_monitor",
               uvm_component parent);

    super.new(name, parent);

    ap = new("ap", this);

  endfunction


  //============================================================
  // Build Phase
  //============================================================
  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if(!uvm_config_db #(virtual intf)::get(this,
                                           "",
                                           "vif",
                                           vif))
    begin
      `uvm_fatal("INT_MON","Virtual Interface Not Found")
    end

  endfunction


  //============================================================
  // Run Phase
  //============================================================
  task run_phase(uvm_phase phase);

    forever begin

      @(posedge vif.soc_clk);

      tr = int_seq_item::type_id::create("tr");

      //--------------------------------------------------------
      // Sample DUT Inputs
      //--------------------------------------------------------
      tr.soc_rst = vif.soc_rst;

      tr.ext_int = vif.ext_int;

      tr.debug_mode_valid_i = vif.debug_mode_valid_i;

      //--------------------------------------------------------
      // Send transaction
      //--------------------------------------------------------
      ap.write(tr);

      //--------------------------------------------------------
      // Print only when interrupt is present
      //--------------------------------------------------------
      if(vif.ext_int != 16'h0000)
      begin
        `uvm_info(get_type_name(),
                  $sformatf("External Interrupt = %h",
                            vif.ext_int),
                  UVM_LOW)
      end

    end

  endtask

endclass
