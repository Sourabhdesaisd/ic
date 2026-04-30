class ic_agent extends uvm_agent;
  `uvm_component_utils(ic_agent)

  ic_sequencer seqr;
  ic_driver    drv;
  ic_monitor   mon;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    seqr = ic_sequencer::type_id::create("seqr", this);
    drv  = ic_driver   ::type_id::create("drv",  this);
    mon  = ic_monitor  ::type_id::create("mon",  this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

endclass
