class int_monitor extends uvm_monitor;

   `uvm_component_utils(int_monitor)

   virtual intf vif;

   int_config cfg;

   function new(string name, uvm_component parent);

      super.new(name,parent);

   endfunction

   function void build_phase(uvm_phase phase);

      super.build_phase(phase);

      if(!uvm_config_db #(int_config)::get(this,"","int_cfg",cfg))
         `uvm_fatal("MON","Cannot get int_config")

      vif = cfg.vif;

   endfunction

endclass
