class int_config extends uvm_object;

  bit [15:0] ext_int;

  `uvm_object_utils(int_config)

  function new(string name="int_config");
    super.new(name);
  endfunction

endclass
