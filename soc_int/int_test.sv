class int_base_test extends uvm_test;

  `uvm_component_utils(int_base_test)

  int_env env;

  function new(string name = "int_base_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = int_env::type_id::create("env", this);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);

   // irq0_basic_seq seq;
  //  irq0_irq5_priority_seq seq;

  //  irq5_irq6_priority_seq seq;
//
 //  disabled_irq_seq seq;

  // three_way_priority_seq seq;

 //  eoi_flow_seq seq;

  // equal_priority_tie_break_seq seq;

 //  active_lvl_threshold_seq  seq;

 //  reset_during_active_irq_seq seq;

//   simul_new_irq_during_eoi_seq seq;

  // random_multi_irq_seq  seq;

//   simultaneous_new_irq_during_eoi_seq seq;

// enable_disable_masking_seq seq;

// back_to_back_interrupts_seq seq;

// wrong_eoi_fail_seq seq;

// random_all_48_irq_seq seq;

// same_priority_random_seq seq;

// random_enable_mask_seq seq;

// random_equal_priority_seq seq;

// random_ack_latency_seq seq;

// random_eoi_progression_seq seq;

// random_tie_break_eoi_seq seq;

// dynamic_priority_override_seq seq;

// random_interrupt_storm_seq seq;
 
// rand_storm_seq seq;
//random_active_level_priority_seq seq;

//zic_seq_base seq;


/////zic_full_regression_seq seq;



//tc001_mmr_single_rw_seq  seq;
//tc002_mmr_multiple_rw_seq   seq;
//tc003_mmr_random_rw_seq seq;
//tc004_mmr_random_stress_rw_seq seq;

//tc005_global_enable_single_seq seq;

//tc006_global_enable_multiple_seq seq;

//tc007_global_enable_all_bits_seq seq;

//tc008_global_enable_random_seq seq;

//tc009_global_enable_random_stress_seq seq;

//tc010_single_interrupt_seq seq;


//tc011_multiple_interrupt_seq seq;

//tc012_priority_arbitration_seq seq;

//tc013_same_priority_tie_break_seq seq;

//tc014_global_enable_masking_seq seq;

//tc015_ack_verification_seq seq;

//tc016_multiple_ack_seq seq;

//tc017_ack_priority_seq  seq;

//tc010_interrupt_ack_latency_seq seq;

//tc018_back_to_back_ack_seq seq;

//tc019_same_priority_tie_break_seq seq;

//tc020_random_interrupt_seq seq;

//tc021_random_interrupt_stress_seq seq;

//tc022_basic_full_system_seq  seq;

//tc010_debug_single_interrupt_seq seq;

//tc023_invalid_eoi_seq seq;

//tc024_retrigger_after_eoi_seq seq;

//tc025_global_enable_toggle_pending_seq seq;

//tc026_higher_priority_preempt_seq seq;

tc029_random_mixed_seq seq;
   
 //zic_multi_irq_seq seq;

    phase.raise_objection(this);

  //  seq = tc001_mmr_single_rw_seq::type_id::create("seq");

   // seq = tc002_mmr_multiple_rw_seq::type_id::create("seq");
   // seq = tc003_mmr_random_rw_seq::type_id::create("seq");

 //   seq = tc004_mmr_random_stress_rw_seq::type_id::create("seq");

  //  seq = tc005_global_enable_single_seq::type_id::create("seq");

  //  seq = tc006_global_enable_multiple_seq::type_id::create("seq");

   // seq = tc007_global_enable_all_bits_seq::type_id::create("seq");
   // seq = tc008_global_enable_random_seq::type_id::create("seq");

   // seq = tc009_global_enable_random_stress_seq::type_id::create("seq");

//    seq = tc010_single_interrupt_seq::type_id::create("seq");

  //  seq = tc011_multiple_interrupt_seq::type_id::create("seq");

   // seq = tc012_priority_arbitration_seq::type_id::create("seq");

   // seq = tc013_same_priority_tie_break_seq::type_id::create("seq");

   // seq = tc014_global_enable_masking_seq::type_id::create("seq");

  // seq = tc015_ack_verification_seq::type_id::create("seq");

  //  seq = tc016_multiple_ack_seq::type_id::create("seq");

 //   seq = tc017_ack_priority_seq::type_id::create("seq");

  //  seq = tc010_interrupt_ack_latency_seq::type_id::create("seq");

 //   seq = tc018_back_to_back_ack_seq::type_id::create("seq");

//    seq = tc019_same_priority_tie_break_seq::type_id::create("seq");

 //   seq = tc020_random_interrupt_seq::type_id::create("seq");

  //  seq = tc021_random_interrupt_stress_seq::type_id::create("seq");

 //   seq = tc022_basic_full_system_seq::type_id::create("seq");

 //   seq = tc010_debug_single_interrupt_seq::type_id::create("seq");

   // seq = tc023_invalid_eoi_seq::type_id::create("seq");

  //  seq = tc024_retrigger_after_eoi_seq::type_id::create("seq");

 //   seq = tc025_global_enable_toggle_pending_seq::type_id::create("seq");

//    seq = tc026_higher_priority_preempt_seq::type_id::create("seq");

    seq = tc029_random_mixed_seq::type_id::create("seq");
    
    
    


    
    
 
    

    
    
    

    
    
    

    
 

 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

   // seq = irq0_basic_seq::type_id::create("seq");

  //  seq = irq0_irq5_priority_seq::type_id::create("seq");

 //  seq = irq5_irq6_priority_seq::type_id::create("seq");

    //seq = disabled_irq_seq::type_id::create("seq");

   // seq = three_way_priority_seq::type_id::create("seq");
    
   // seq = eoi_flow_seq::type_id::create("seq");

   // seq = equal_priority_tie_break_seq::type_id::create("seq");
    
//    seq = active_lvl_threshold_seq::type_id::create("seq");

   // seq = reset_during_active_irq_seq::type_id::create("seq");

 //   seq = simul_new_irq_during_eoi_seq::type_id::create("seq");

  //  seq = random_multi_irq_seq::type_id::create("seq");

   // seq = simultaneous_new_irq_during_eoi_seq::type_id::create("seq");

  //  seq = enable_disable_masking_seq::type_id::create("seq");

   // seq = back_to_back_interrupts_seq::type_id::create("seq");

  //  seq = wrong_eoi_fail_seq::type_id::create("seq");

  //  seq = random_all_48_irq_seq::type_id::create("seq");

  // seq = same_priority_random_seq::type_id::create("seq");

 //  seq = random_enable_mask_seq::type_id::create("seq");


  // seq = random_equal_priority_seq::type_id::create("seq");

 //  seq = random_ack_latency_seq::type_id::create("seq");

 //  seq = random_eoi_progression_seq::type_id::create("seq");

  // seq = random_tie_break_eoi_seq::type_id::create("seq");
   
   
   
 //  seq = dynamic_priority_override_seq::type_id::create("seq");
   
 //  seq = random_interrupt_storm_seq::type_id::create("seq");
   
  // seq = rand_storm_seq::type_id::create("seq");
//  seq = random_active_level_priority_seq::type_id::create("seq");




  // seq = zic_seq_base::type_id::create("seq");

 /// seq = zic_full_regression_seq::type_id::create("seq");
  ////
   
  

   

   
  


    
    
    
   
    
 
    
 
    seq.start(env.agent.sqr);

    #200;

    phase.drop_objection(this);

  endtask

endclass
