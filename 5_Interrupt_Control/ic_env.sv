class ic_env extends uvm_env;
`uvm_component_utils(ic_env)
	
	ic_agent agent;
	ic_scb scb;
	ic_subscr subscr;

	function new(string name="ic_env", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent = ic_agent::type_id::create("agent",this);
		scb   = ic_scb::type_id::create("scb",this);
		subscr= ic_subscr::type_id::create("subscr",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		agent.mon.mon_port.connect(scb.scb_imp);
		agent.mon.mon_port.connect(subscr.subscr_imp);
	endfunction
	
endclass
