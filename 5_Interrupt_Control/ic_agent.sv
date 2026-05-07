class ic_agent extends uvm_agent;
`uvm_component_utils(ic_agent)

	ic_seqr seqr;
	ic_drv   drv;
	ic_mon   mon;

	function new (string name="ic_agent", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		seqr = ic_seqr::type_id::create("seqr",this);
		drv  = ic_drv::type_id::create("drv",this);
		mon  = ic_mon::type_id::create("mon",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		drv.seq_item_port.connect(seqr.seq_item_export);
	endfunction

endclass

