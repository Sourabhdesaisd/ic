class ic_mon extends uvm_monitor;
	//Factory registration
	`uvm_component_utils(ic_mon)
	
	//Declare seq_item & interface handles
	ic_seq_item item;
	virtual ic_intf intf;

	//Declare uvm_analysis_port handle
	uvm_analysis_port#(ic_seq_item) mon_port;

	//Constructor new()
	function new(string name="ic_mon", uvm_component parent);
		super.new(name,parent);
		mon_port = new("mon_port", this);
	endfunction

	//Build_phase for getting interface
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual ic_intf)::get(this, "","vif",intf))
		`uvm_fatal(get_type_name(),"MON_INTERFACE IS NOT SET")
	endfunction

	//Run_phase to receive stimulus & send to write()
	
    
endclass

