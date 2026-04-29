class ic_seq extends uvm_sequence #(ic_seq_item);
	//Factory registration
	`uvm_object_utils(ic_seq)
	
	//Declare seq_item handles
	ic_seq_item seq_item;
	
	//Constructor new()
	function new (string name="ic_seq");
		super.new(name);
	endfunction

	//body() method to define sequence(s)
	virtual task body();
		seq_item = ic_seq_item::type_id::create("seq_item");

	
endclass
