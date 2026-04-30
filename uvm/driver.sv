class ic_driver extends uvm_driver #(ic_txn);

  `uvm_component_utils(ic_driver)

  virtual ic_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual ic_if)::get(this, "", "vif", vif))
      `uvm_fatal("DRV", "No vif")
  endfunction

  task run_phase(uvm_phase phase);
    ic_txn txn;

    forever begin
      seq_item_port.get_next_item(txn);

      @(posedge vif.ic_clk);

      // ================= DRIVE INPUTS =================
      vif.ext_int   <= txn.intr;
      vif.threshold <= txn.threshold;

      `uvm_info("DRV",
        $sformatf("Driving txn: %s", txn.convert2string()),
        UVM_LOW)

      seq_item_port.item_done();
    end
  endtask

endclass
