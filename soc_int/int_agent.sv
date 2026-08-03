class int_agent extends uvm_agent;

  `uvm_component_utils(int_agent)

  //------------------------------------------------------------
  // Configuration
  //------------------------------------------------------------
  int_config cfg;

  //------------------------------------------------------------
  // Components
  //------------------------------------------------------------
  int_sequencer sqr;
  int_driver    drv;
  int_monitor   mon;

  //------------------------------------------------------------
  // Constructor
  //------------------------------------------------------------
  function new(string name = "int_agent",
               uvm_component parent);
    super.new(name, parent);
  endfunction

  //------------------------------------------------------------
  // Build Phase
  //------------------------------------------------------------
  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    // Get Configuration
    if(!uvm_config_db#(int_config)::get(this,"","cfg",cfg))
      `uvm_fatal("INT_AGENT","Cannot get int_config")

    // Create Components
    sqr = int_sequencer::type_id::create("sqr", this);
    drv = int_driver   ::type_id::create("drv", this);
    mon = int_monitor  ::type_id::create("mon", this);

  endfunction

  //------------------------------------------------------------
  // Connect Phase
  //------------------------------------------------------------
  function void connect_phase(uvm_phase phase);

    super.connect_phase(phase);

    drv.seq_item_port.connect(sqr.seq_item_export);

  endfunction

endclass
