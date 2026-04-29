class ic_env extends uvm_env;
	//Factory registration
	`uvm_component_utils(ic_env)

	//Declare agent,scb & subscr handles
	ic_agent agent;
	ic_scb scb;
	ic_subscr subscr;

	//Constructor new()
	function new(string name="ic_env", uvm_component parent);
		super.new(name,parent);
	endfunction

	//Build_phase for agent,scb & subscr
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent = ic_agent::type_id::create("agent",this);
		scb   = ic_scb::type_id::create("scb",this);
		subscr= ic_subscr::type_id::create("subscr",this);
	endfunction

	//Connect_phase for mon-scb & mon-subscr
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		agent.mon.mon_port.connect(scb.scb_imp);
		agent.mon.mon_port.connect(subscr.subscr_imp);
	endfunction

endclass

