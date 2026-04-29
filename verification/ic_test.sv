class ic_test extends uvm_test;
	//Factory registration
	`uvm_component_utils(ic_test)

	//Declare seq & env handles
 	ic_env env;
	ic_seq seq;

	//Constructor new()
	function new (string name="ic_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	//Build_phase for env, seq
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		env = ic_env::type_id::create("env", this);
		seq = ic_seq::type_id::create("seq");
	endfunction

	//Run_phase for starting seq in seqr
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		phase.raise_objection(this);
		seq.start(env.agent.seqr);
//		#10;
		phase.phase_done.set_drain_time(this, 20);
		phase.drop_objection(this);
	endtask
endclass

