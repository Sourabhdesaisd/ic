class ic_monitor extends uvm_monitor;
  `uvm_component_utils(ic_monitor)

  uvm_analysis_port #(uvm_sequence_item) ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("MONITOR", "Monitor is running (no functionality)", UVM_LOW)
  endtask

endclass
