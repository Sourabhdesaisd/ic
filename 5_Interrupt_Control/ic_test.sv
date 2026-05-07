class ic_test extends uvm_test;
`uvm_component_utils(ic_test)

 	ic_env env;
	ic_seq seq;
	ic_uncov_seq uncov_seq;

	function new (string name="ic_test", uvm_component parent);
		super.new(name,parent);
	endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		env = ic_env::type_id::create("env", this);
		seq = ic_seq::type_id::create("seq");
		uncov_seq = ic_uncov_seq::type_id::create("uncov_seq");
	endfunction

endclass
//####################################################################
//Reset Test
class ic_rst_test extends ic_test;
`uvm_component_utils(ic_rst_test)

	ic_rst_seq rst_seq;

	function new (string name="ic_rst_test", uvm_component parent);
		super.new(name,parent);
	endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rst_seq = ic_rst_seq::type_id::create("rst_seq");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		phase.raise_objection(this);
		rst_seq.start(env.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass
//####################################################################
//MMR Read Test
class ic_mmr_read_test extends ic_test;
`uvm_component_utils(ic_mmr_read_test)

	ic_mmr_read_seq mmr_read_seq;

	function new (string name="ic_mmr_read_test", uvm_component parent);
		super.new(name,parent);
	endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mmr_read_seq = ic_mmr_read_seq::type_id::create("mmr_read_seq");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		phase.raise_objection(this);
		mmr_read_seq.start(env.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass
//####################################################################

//MMR Write Test
class ic_mmr_write_test extends ic_test;
`uvm_component_utils(ic_mmr_write_test)

	ic_mmr_write_seq mmr_write_seq;

	function new (string name="ic_mmr_write_test", uvm_component parent);
		super.new(name,parent);
	endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mmr_write_seq = ic_mmr_write_seq::type_id::create("mmr_write_seq");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		phase.raise_objection(this);
		mmr_write_seq.start(env.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass
//####################################################################
//MMR Read-Write-Read Test
class ic_mmr_rd_wr_rd_test extends ic_test;
`uvm_component_utils(ic_mmr_rd_wr_rd_test)

	ic_mmr_rd_wr_rd_seq mmr_rd_wr_rd_seq;

	function new (string name="ic_mmr_rd_wr_rd_test", uvm_component parent);
		super.new(name,parent);
	endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mmr_rd_wr_rd_seq = ic_mmr_rd_wr_rd_seq::type_id::create("mmr_rd_wr_rd_seq");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		phase.raise_objection(this);
		mmr_rd_wr_rd_seq.start(env.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass
//####################################################################
//IC configuration and information registers Read to verify Test
class ic_config_test extends ic_test;
`uvm_component_utils(ic_config_test)

	ic_config_seq config_seq;

	function new (string name="ic_config_test", uvm_component parent);
		super.new(name,parent);
	endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		config_seq = ic_config_seq::type_id::create("config_seq");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		phase.raise_objection(this);
		config_seq.start(env.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass
//####################################################################

//IC Single Interrupt Test
class ic_single_int_test extends ic_test;
`uvm_component_utils(ic_single_int_test)

	ic_single_int_seq single_int_seq;

	function new (string name="ic_single_int_test", uvm_component parent);
		super.new(name,parent);
	endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		single_int_seq = ic_single_int_seq::type_id::create("single_int_seq");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		phase.raise_objection(this);
		single_int_seq.start(env.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass
//####################################################################
//IC Multiple Interrupt Test
class ic_multi_int_test extends ic_test;
`uvm_component_utils(ic_multi_int_test)

	ic_multi_int_seq multi_int_seq;

	function new (string name="ic_multi_int_test", uvm_component parent);
		super.new(name,parent);
	endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		multi_int_seq = ic_multi_int_seq::type_id::create("multi_int_seq");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		phase.raise_objection(this);
		multi_int_seq.start(env.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass
//####################################################################
//IC Continuos Interrupt Test
class ic_cont_int_test extends ic_test;
`uvm_component_utils(ic_cont_int_test)

	ic_cont_int_seq cont_int_seq;

	function new (string name="ic_cont_int_test", uvm_component parent);
		super.new(name,parent);
	endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cont_int_seq = ic_cont_int_seq::type_id::create("cont_int_seq");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		phase.raise_objection(this);
		cont_int_seq.start(env.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass
//####################################################################

//IC Preemtion Test
class ic_preempt_test extends ic_test;
`uvm_component_utils(ic_preempt_test)

	ic_preempt_seq preempt_seq;

	function new (string name="ic_preempt_test", uvm_component parent);
		super.new(name,parent);
	endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		preempt_seq = ic_preempt_seq::type_id::create("preempt_seq");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		phase.raise_objection(this);
		preempt_seq.start(env.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass
//####################################################################

//IC Equal Level and Diff Priority Test
class ic_equal_lvl_diff_pri_test extends ic_test;
`uvm_component_utils(ic_equal_lvl_diff_pri_test)

	ic_equal_lvl_diff_pri_seq equal_lvl_diff_pri_seq;

	function new (string name="ic_equal_lvl_diff_pri_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		equal_lvl_diff_pri_seq = ic_equal_lvl_diff_pri_seq::type_id::create("equal_lvl_diff_pri_seq");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		phase.raise_objection(this);
		equal_lvl_diff_pri_seq.start(env.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass
//####################################################################

//IC All Interrupts Enabled Test
class ic_all_int_test extends ic_test;
`uvm_component_utils(ic_all_int_test)

	ic_all_int_seq all_int_seq;

	function new (string name="ic_all_int_test", uvm_component parent);
		super.new(name,parent);
	endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		all_int_seq = ic_all_int_seq::type_id::create("all_int_seq");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		phase.raise_objection(this);
		all_int_seq.start(env.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass
//####################################################################

//IC Disabled Interrupt Test
class ic_disable_int_test extends ic_test;
`uvm_component_utils(ic_disable_int_test)

	ic_disable_int_seq disable_int_seq;

	function new (string name="ic_disable_int_test", uvm_component parent);
		super.new(name,parent);
	endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		disable_int_seq = ic_disable_int_seq::type_id::create("disable_int_seq");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		phase.raise_objection(this);
		disable_int_seq.start(env.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass
//####################################################################

//IC wrong EOI ID Test
class ic_wrong_eoi_id_test extends ic_test;
`uvm_component_utils(ic_wrong_eoi_id_test)

	ic_wrong_eoi_id_seq wrong_eoi_id_seq;

	function new (string name="ic_wrong_eoi_id_test", uvm_component parent);
		super.new(name,parent);
	endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		wrong_eoi_id_seq = ic_wrong_eoi_id_seq::type_id::create("wrong_eoi_id_seq");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		phase.raise_objection(this);
		wrong_eoi_id_seq.start(env.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass
//####################################################################

//IC Random Test
class ic_random_test extends ic_test;
`uvm_component_utils(ic_random_test)

	ic_random_seq random_seq;

	function new (string name="ic_random_test", uvm_component parent);
		super.new(name,parent);
	endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		random_seq = ic_random_seq::type_id::create("random_seq");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		phase.raise_objection(this);
		random_seq.start(env.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass
//####################################################################

//IC MMR Read & ALL Int Test
class ic_rd_all_test extends ic_test;
`uvm_component_utils(ic_rd_all_test)

	ic_rd_all_int_seq rd_all_seq;

	function new (string name="ic_rd_all_test", uvm_component parent);
		super.new(name,parent);
	endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rd_all_seq = ic_rd_all_int_seq::type_id::create("rd_all_seq");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		phase.raise_objection(this);
		rd_all_seq.start(env.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass
//####################################################################

//IC Uncovered Test
class ic_uncov_test extends uvm_test;
`uvm_component_utils(ic_uncov_test)

	ic_uncov_seq uncov_seq;
	ic_env env;

	function new (string name="ic_uncov_test", uvm_component parent);
		super.new(name,parent);
	endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uncov_seq = ic_uncov_seq::type_id::create("uncov_seq");
		env = ic_env::type_id::create("env", this);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		phase.raise_objection(this);
		uncov_seq.start(env.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass
//####################################################################

