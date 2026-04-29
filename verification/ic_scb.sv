class ic_scb extends uvm_scoreboard;
	//Factory registration
	`uvm_component_utils(ic_scb)

	//Declare uvm_analysis_imp handle
	uvm_analysis_imp#(ic_seq_item, ic_scb) scb_imp;

	//Constructor new()
	function new(string name="ic_scb", uvm_component parent);
		super.new(name,parent);
	endfunction
	
	//Build_phase for imp handle
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		scb_imp = new("scb_imp",this);
	endfunction

	//Reference model
	


	//Implement write() Method

endclass

