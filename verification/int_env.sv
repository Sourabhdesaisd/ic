class int_env extends uvm_env;

  `uvm_component_utils(int_env)

  int_agent      agent;
  int_scoreboard scb;

  function new(string name = "int_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agent = int_agent     ::type_id::create("agent", this);
    scb   = int_scoreboard::type_id::create("scb", this);
  endfunction

endclass
