class tc029_random_mixed_seq extends int_base_seq;

  `uvm_object_utils(tc029_random_mixed_seq)

  //------------------------------------------------------------
  // Constructor
  //------------------------------------------------------------

  function new(string name = "tc029_random_mixed_seq");
    super.new(name);
  endfunction

  //------------------------------------------------------------
  // Transaction Handle
  //------------------------------------------------------------

  int_seq_item tr;

  //------------------------------------------------------------
  // Random Variables
  //------------------------------------------------------------

  typedef enum int
  {
      MMR_WRITE,
      MMR_READ,
      GLOBAL_ENABLE,
      EXT_INTERRUPT,
      ACK,
      EOI,
      ACTIVE_LEVEL,
      DEBUG_MODE,
      DEBUG_RESET,
      NDM_RESET,
      IDLE
  } operation_e;

  rand operation_e operation;

  //------------------------------------------------------------
  // Local Variables
  //------------------------------------------------------------

  rand bit [3:0]   irq_id;

  rand bit [15:0]  ext_irq;

  rand bit [15:0]  enable_mask;

  rand bit [7:0]   ctl_data;

  rand bit [7:0]   active_level;

  rand bit [7:0]   eoi_id;

  rand bit          debug_mode;

  rand bit          debug_reset;

  rand bit          ndm_reset;

  //------------------------------------------------------------
  // Helper Variables
  //------------------------------------------------------------

  bit [15:0] programmed_irq;

  bit [15:0] enabled_irq;

  bit [15:0] pending_irq;

  bit        ack_done;

    //------------------------------------------------------------
  // Constraints
  //------------------------------------------------------------

  constraint irq_c
  {
      irq_id inside {[0:15]};
  }

  constraint ctl_c
  {
      ctl_data inside {[8'h01:8'hFF]};
  }

  constraint ext_irq_c
  {
      ext_irq != 16'h0000;
  }

  constraint enable_c
  {
      enable_mask != 16'h0000;
  }

  constraint active_level_c
  {
      active_level inside {[8'h00:8'hFF]};
  }

  constraint eoi_c
  {
      eoi_id == (8'h10 + irq_id);
  }

  constraint debug_c
  {
      !(debug_reset && ndm_reset);
  }

  constraint multi_irq_c
  {
      $countones(ext_irq) inside {[1:6]};
  }

  constraint operation_c
  {
      operation dist
      {
          MMR_WRITE      := 15,
          MMR_READ       := 10,
          GLOBAL_ENABLE  := 10,
          EXT_INTERRUPT  := 25,
          ACK            := 10,
          EOI            := 10,
          ACTIVE_LEVEL   := 5,
          DEBUG_MODE     := 5,
          DEBUG_RESET    := 2,
          NDM_RESET      := 2,
          IDLE           := 6
      };
  }

    //------------------------------------------------------------
  // Body
  //------------------------------------------------------------

  virtual task body();

    programmed_irq = 16'h0000;

    enabled_irq    = 16'h0000;

    pending_irq    = 16'h0000;

    ack_done       = 1'b0;

    `uvm_info(get_type_name(),
              "==============================================",
              UVM_LOW)

    `uvm_info(get_type_name(),
              "TC029 RANDOM MIXED TEST STARTED",
              UVM_LOW)

    `uvm_info(get_type_name(),
              "==============================================",
              UVM_LOW)


    
