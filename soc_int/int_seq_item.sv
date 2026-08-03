class int_seq_item extends uvm_sequence_item;

  
  rand logic        soc_rst;

    rand logic ext_int0_i;
  rand logic ext_int1_i;
  rand logic ext_int2_i;
  rand logic ext_int3_i;
  rand logic ext_int4_i;
  rand logic ext_int5_i;
  rand logic ext_int6_i;
  rand logic ext_int7_i;
  rand logic ext_int8_i;
  rand logic ext_int9_i;
  rand logic ext_int10_i;
  rand logic ext_int11_i;
  rand logic ext_int12_i;
  rand logic ext_int13_i;
  rand logic ext_int14_i;
  rand logic ext_int15_i;

  // Packed vector used by monitor/scoreboard for simple loops
  logic [15:0] ext_int;


  //============================================================
  // DEBUG INPUTS
  //============================================================
  rand logic debug_mode_valid_i;
 
   
  //============================================================
  // HELPER FUNCTION
  // Converts individual interrupt pins into packed vector.
  //============================================================
  function void pack_ext_int();

    ext_int[0]  = ext_int0_i;
    ext_int[1]  = ext_int1_i;
    ext_int[2]  = ext_int2_i;
    ext_int[3]  = ext_int3_i;
    ext_int[4]  = ext_int4_i;
    ext_int[5]  = ext_int5_i;
    ext_int[6]  = ext_int6_i;
    ext_int[7]  = ext_int7_i;
    ext_int[8]  = ext_int8_i;
    ext_int[9]  = ext_int9_i;
    ext_int[10] = ext_int10_i;
    ext_int[11] = ext_int11_i;
    ext_int[12] = ext_int12_i;
    ext_int[13] = ext_int13_i;
    ext_int[14] = ext_int14_i;
    ext_int[15] = ext_int15_i;

  endfunction

  //============================================================
  // FACTORY REGISTRATION
  //============================================================
  `uvm_object_utils_begin(int_seq_item)

    

    `uvm_field_int(soc_rst,                   UVM_ALL_ON)

    

    `uvm_field_int(ext_int0_i,                UVM_ALL_ON)
    `uvm_field_int(ext_int1_i,                UVM_ALL_ON)
    `uvm_field_int(ext_int2_i,                UVM_ALL_ON)
    `uvm_field_int(ext_int3_i,                UVM_ALL_ON)
    `uvm_field_int(ext_int4_i,                UVM_ALL_ON)
    `uvm_field_int(ext_int5_i,                UVM_ALL_ON)
    `uvm_field_int(ext_int6_i,                UVM_ALL_ON)
    `uvm_field_int(ext_int7_i,                UVM_ALL_ON)
    `uvm_field_int(ext_int8_i,                UVM_ALL_ON)
    `uvm_field_int(ext_int9_i,                UVM_ALL_ON)
    `uvm_field_int(ext_int10_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int11_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int12_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int13_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int14_i,               UVM_ALL_ON)
    `uvm_field_int(ext_int15_i,               UVM_ALL_ON)

    `uvm_field_int(ext_int,                   UVM_ALL_ON)

    `uvm_field_int(debug_mode_valid_i,        UVM_ALL_ON)
    

  `uvm_object_utils_end

  function new(string name = "int_seq_item");
    super.new(name);
  endfunction

endclass
