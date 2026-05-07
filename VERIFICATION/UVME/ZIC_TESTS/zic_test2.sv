class zic_test2 extends uvm_test;

  `uvm_component_utils(zic_test2)

  zic_environment zic_env;
  zic_sequence2 zic_seq2;


  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    zic_env = zic_environment::type_id::create("zic_env",this);
      endfunction

  task run_phase(uvm_phase phase);

    phase.raise_objection(this);
    begin
      zic_seq2 = zic_sequence2::type_id::create("zic_seq2",this);
      zic_seq2.start(zic_env.zic_agn.zic_seqcr);  
      repeat(5)@(posedge zic_env.zic_agn.zic_drv.zic_vif.clk);
    end
    phase.drop_objection(this);

  endtask

endclass
