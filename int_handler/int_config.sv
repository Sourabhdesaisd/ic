class int_config extends uvm_object;

   `uvm_object_utils(int_config)

   virtual intf vif;

   function new(string name = "int_config");
      super.new(name);
   endfunction

endclass
