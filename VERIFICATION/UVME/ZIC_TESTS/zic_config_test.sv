class zic_config_test extends uvm_test;

  `uvm_component_utils(zic_config_test)

  zic_environment zic_env;
  zic_config_sequence zic_config_seq;

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
      zic_config_seq = zic_config_sequence::type_id::create("zic_config_seq",this);
      zic_config_seq.start(zic_env.zic_agn.zic_seqcr);  
      repeat(5)@(posedge zic_env.zic_agn.zic_drv.zic_vif.clk);
    end
    phase.drop_objection(this);

  endtask

endclass
