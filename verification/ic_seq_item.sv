class ic_seq_item extends uvm_sequence_item;

	//Declare Input signals with rand keyword


	//Declare Output signals
	
	//Factory registration with field macros
	`uvm_object_utils_begin(ic_seq_item)
	    `uvm_field_int(rst,UVM_ALL_ON)
	    `uvm_field_int(A,  UVM_ALL_ON)
	    `uvm_field_int(B,  UVM_ALL_ON)
	    `uvm_field_int(OP, UVM_ALL_ON)
	    `uvm_field_int(Y,  UVM_ALL_ON)
	`uvm_object_utils_end

	//Constructor new()
	function new(string name ="ic_seq_item");
		super.new(name);
	endfunction

	//Constraints

endclass
