class ic_env extends uvm_env;
  `uvm_component_utils(ic_env)

  ic_agent              agent;
  ic_scoreboard         sb;
  ic_virtual_sequencer  vseqr;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agent = ic_agent             ::type_id::create("agent", this);
    sb    = ic_scoreboard        ::type_id::create("sb", this);
    vseqr = ic_virtual_sequencer ::type_id::create("vseqr", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    agent.mon.ap.connect(sb.analysis_export);
  endfunction

endclass
