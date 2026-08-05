class int_seq_item extends uvm_sequence_item;

   rand bit soc_rst;

   rand bit ext_int10_i;
   rand bit ext_int11_i;
   rand bit ext_int12_i;
   rand bit ext_int13_i;
   rand bit ext_int14_i;
   rand bit ext_int15_i;

   `uvm_object_utils_begin(int_seq_item)

      `uvm_field_int(soc_rst,UVM_ALL_ON)

      `uvm_field_int(ext_int10_i,UVM_ALL_ON)
      `uvm_field_int(ext_int11_i,UVM_ALL_ON)
      `uvm_field_int(ext_int12_i,UVM_ALL_ON)
      `uvm_field_int(ext_int13_i,UVM_ALL_ON)
      `uvm_field_int(ext_int14_i,UVM_ALL_ON)
      `uvm_field_int(ext_int15_i,UVM_ALL_ON)

   `uvm_object_utils_end

   function new(string name="int_seq_item");
      super.new(name);
   endfunction

endclass
