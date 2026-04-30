class ic_test extends uvm_test;
  `uvm_component_utils(ic_test)

  ic_env env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = ic_env::type_id::create("env", this);
  endfunction

  
  task run_phase(uvm_phase phase);
  ic_base_seq seq;

  phase.raise_objection(this);
 //   `uvm_info("TEST", "Printing UVM topology...", UVM_LOW)
   
  uvm_top.print_topology();

  seq = ic_base_seq::type_id::create("seq");
  seq.start(env.agent.seqr);

  #10;

  phase.drop_objection(this);
endtask

endclass
