class ic_seqr extends uvm_sequencer#(ic_seq_item);
	//Factory registration
	`uvm_component_utils(ic_seqr)

	//Constructor new()
	function new(string name="ic_seqr", uvm_component parent); 
		super.new(name,parent);
	endfunction
endclass

