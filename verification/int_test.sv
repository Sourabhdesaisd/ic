class int_base_test extends uvm_test;

  `uvm_component_utils(int_base_test)

  int_env env;

  function new(string name = "int_base_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = int_env::type_id::create("env", this);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);

  int_reset_seq      reset_seq;
  int_single_irq_seq irq_seq;

  phase.raise_objection(this);

  reset_seq = int_reset_seq::type_id::create("reset_seq");
  reset_seq.start(env.agent.sqr);

  #20;

  irq_seq = int_single_irq_seq::type_id::create("irq_seq");
  irq_seq.start(env.agent.sqr);

  #100;

  phase.drop_objection(this);

endtask

endclass
