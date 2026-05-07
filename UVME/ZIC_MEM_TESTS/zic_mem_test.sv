class zic_mem_test extends uvm_test;

  `uvm_component_utils(zic_mem_test)

  zic_mem_env zic_en;
  zic_mem_sequence zic_seq;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    zic_en = zic_mem_env::type_id::create("zic_en",this);

  endfunction

  task run_phase(uvm_phase phase);

    phase.raise_objection(this);
    begin

      zic_seq = zic_mem_sequence::type_id::create("zic_seq",this);
       repeat(48)begin
      zic_seq.scenario=$urandom_range(1,14);
      zic_seq.count=2;
      zic_seq.start(zic_en.zic_agn.zic_seqcr);
     end  

    end
    repeat(1)@(posedge zic_en.zic_agn.zic_drv.zic_vif.clk);

    phase.drop_objection(this);

  endtask

endclass
