class ic_agent extends uvm_agent;
	//Factory registration
	`uvm_component_utils(ic_agent)

	//Declare seqr, drv & mon handles
	ic_seqr seqr;
	ic_drv   drv;
	ic_mon   mon;

	//Constructor new()
	function new (string name="ic_agent", uvm_component parent);
		super.new(name,parent);
	endfunction

	//Build_phase for seqr, drv & mon
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		seqr = ic_seqr::type_id::create("seqr",this);
		drv  = ic_drv::type_id::create("drv",this);
		mon  = ic_mon::type_id::create("mon",this);
	endfunction

	//Connect_phase for seqr-drv
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		drv.seq_item_port.connect(seqr.seq_item_export);
	endfunction

endclass

