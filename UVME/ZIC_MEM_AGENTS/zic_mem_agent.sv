class zic_mem_agent extends uvm_agent;

  `uvm_component_utils(zic_mem_agent)

  zic_mem_driver    zic_drv;
  zic_mem_monitor   zic_mon;
  zic_mem_sequencer zic_seqcr;

  uvm_analysis_port#(zic_mem_seq_item) analysis_port_agent;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    zic_drv = zic_mem_driver::type_id::create("zic_drv",this);
    zic_mon = zic_mem_monitor::type_id::create("zic_mon",this);
    zic_seqcr = zic_mem_sequencer::type_id::create("zic_seqcr",this);
    analysis_port_agent = new("analysis_port_agent",this);

  endfunction


  function void connect_phase(uvm_phase phase);

    zic_drv.seq_item_port.connect(zic_seqcr.seq_item_export);
    zic_mon.analysis_port_monitor.connect(analysis_port_agent);

  endfunction

endclass
