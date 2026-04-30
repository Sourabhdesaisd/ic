class ic_scoreboard extends uvm_component;
  `uvm_component_utils(ic_scoreboard)

  uvm_analysis_imp #(uvm_sequence_item, ic_scoreboard) analysis_export;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    analysis_export = new("analysis_export", this);
  endfunction

  function void write(uvm_sequence_item t);
    `uvm_info("SCOREBOARD", "Received transaction (dummy)", UVM_LOW)
  endfunction

endclass
