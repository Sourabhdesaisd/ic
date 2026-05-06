class int_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(int_scoreboard)

  function new(string name = "int_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass
