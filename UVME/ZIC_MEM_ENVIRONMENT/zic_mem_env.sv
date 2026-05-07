class zic_mem_env extends uvm_env;

 `uvm_component_utils(zic_mem_env)

 zic_mem_agent zic_agn;
 zic_mem_scoreboard  zic_scb;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);

    zic_agn = zic_mem_agent::type_id::create("zic_agn",this);

    zic_scb = zic_mem_scoreboard::type_id::create("zic_scb",this);

  endfunction

  function void connect_phase(uvm_phase phase);

    zic_agn.analysis_port_agent.connect(zic_scb.analysis_imp_scb);

  endfunction

endclass
