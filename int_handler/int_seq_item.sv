class int_seq_item extends uvm_sequence_item;

   rand bit soc_rst;

   rand bit [5:0] gpio_pad_in;
   

   `uvm_object_utils_begin(int_seq_item)

      `uvm_field_int(soc_rst,UVM_ALL_ON)

      `uvm_field_int(gpio_pad_in,UVM_ALL_ON)
       `uvm_object_utils_end

   function new(string name="int_seq_item");
      super.new(name);
   endfunction

endclass
