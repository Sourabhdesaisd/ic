class zic_mem_sequencer extends uvm_sequencer#(zic_mem_seq_item);

  `uvm_component_utils(zic_mem_sequencer)


  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction


endclass
