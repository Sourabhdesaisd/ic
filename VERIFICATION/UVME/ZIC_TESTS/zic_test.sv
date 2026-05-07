class zic_test extends uvm_test;

  `uvm_component_utils(zic_test)

  zic_environment zic_env;
  zic_sequence zic_seq;

  int test_case;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    zic_env = zic_environment::type_id::create("zic_env",this);

  endfunction

  task run_phase(uvm_phase phase);

    phase.raise_objection(this);
    begin
      zic_seq = zic_sequence::type_id::create("zic_seq",this); 
      $value$plusargs("TEST_CASE=%d",test_case);
      zic_seq.case_sel = test_case;
      zic_seq.start(zic_env.zic_agn.zic_seqcr);  
      repeat(5)@(posedge zic_env.zic_agn.zic_drv.zic_vif.clk)
    end
    phase.drop_objection(this);

  endtask

endclass
