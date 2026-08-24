class int_driver extends uvm_driver #(int_seq_item);

   `uvm_component_utils(int_driver)

   virtual intf vif;

   int_config cfg;

   function new(string name, uvm_component parent);

      super.new(name,parent);

   endfunction

   function void build_phase(uvm_phase phase);

      super.build_phase(phase);

      if(!uvm_config_db #(int_config)::get(this,"","int_cfg",cfg))
         `uvm_fatal("DRV","Cannot get int_config")

      vif = cfg.vif;

   endfunction

   task drive_idle();

      vif.gpio_pad_in <= 0;
     
   endtask

   task run_phase(uvm_phase phase);

      drive_idle();

      forever begin

         seq_item_port.get_next_item(req);

         @(posedge vif.soc_clk);

         vif.gpio_pad_in <= req.gpio_pad_in;
     
         @(posedge vif.soc_clk);

         drive_idle();

         seq_item_port.item_done();

      end

   endtask

endclass
