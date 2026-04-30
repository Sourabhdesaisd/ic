class ic_sequencer extends uvm_sequencer #(ic_txn);
  `uvm_component_utils(ic_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass
