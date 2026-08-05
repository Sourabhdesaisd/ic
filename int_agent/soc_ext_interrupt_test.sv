class soc_ext_interrupt_test extends soc_base_test;

  `uvm_component_utils(soc_ext_interrupt_test)

  ext_interrupt_seq seq;

  function new(string name = "soc_ext_interrupt_test",
               uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    //----------------------------------------------------------
    // Existing boot flow
    //----------------------------------------------------------
    boot_flow();

    //----------------------------------------------------------
    // Wait until C test finishes driving ext_int0-9
    //----------------------------------------------------------
    wait(handshake_from_c_to_sv == 1);

    handshake_from_c_to_sv = 0;

    //----------------------------------------------------------
    // Start UVM sequence for ext_int10-15
    //----------------------------------------------------------
    seq = ext_interrupt_seq::type_id::create("seq");

    seq.start(env_h.int_seqr);

    //----------------------------------------------------------
    // Give DUT some cycles
    //----------------------------------------------------------
    #100ns;

    phase.drop_objection(this);

  endtask

endclass
