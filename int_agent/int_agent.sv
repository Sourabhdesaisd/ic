class int_agent extends uvm_agent;

   `uvm_component_utils(int_agent)

   int_driver drv;

   int_monitor mon;

   int_sequencer seqr;

   int_config cfg;

   function new(string name, uvm_component parent);

      super.new(name,parent);

   endfunction

   function void build_phase(uvm_phase phase);

      super.build_phase(phase);

      if(!uvm_config_db #(int_config)::get(this,"","int_cfg",cfg))
         `uvm_fatal("AGENT","Cannot get int_config")

      uvm_config_db #(int_config)::set(this,"drv","int_cfg",cfg);

      uvm_config_db #(int_config)::set(this,"mon","int_cfg",cfg);

      drv  = int_driver::type_id::create("drv",this);

      mon  = int_monitor::type_id::create("mon",this);

      seqr = int_sequencer::type_id::create("seqr",this);

   endfunction

   function void connect_phase(uvm_phase phase);

      drv.seq_item_port.connect(seqr.seq_item_export);

   endfunction

endclass
