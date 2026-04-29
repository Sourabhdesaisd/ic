class ic_subscr extends uvm_subscriber#(ic_seq_item);
	//Factory registration
	`uvm_component_utils(ic_subscr)
	
	//Declare seq_item & uvm_analysis_imp handle
	ic_seq_item item;
	uvm_analysis_imp#(ic_seq_item, ic_subscr) subscr_imp;
	
	//Cover group 
	
	//Constructor new()
	function new(string name="ic_subscr", uvm_component parent);
		super.new(name,parent);
		cg = new();
	endfunction
	
	//Build_phase for imp & covergroup handles
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		subscr_imp=new("subscr_imp",this);
	endfunction
	
	//Implement write() Method to sample
	virtual function void write(ic_seq_item t);
		item = t;
		cg.sample();
	endfunction

endclass

