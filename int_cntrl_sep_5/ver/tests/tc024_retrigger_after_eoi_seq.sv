

class tc024_retrigger_after_eoi_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(tc024_retrigger_after_eoi_seq)

  int_seq_item tr;

  function new(string name = "tc024_retrigger_after_eoi_seq");
    super.new(name);
  endfunction

  
task body();

  int_seq_item tr;

  //------------------------------------------------------------
  // Transaction-1 : Reset
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("reset");

  start_item(tr);

  tr.soc_rst = 1'b0;

  tr.ext_int = 16'h0000;

  tr.soc_mmr_write_en_i   = 1'b0;
  tr.soc_mmr_write_addr_i = 16'h0000;
  tr.soc_mmr_write_data_i = 32'h00000000;

  tr.soc_mmr_read_en_i    = 1'b0;
  tr.soc_mmr_read_addr_i  = 16'h0000;

  tr.global_int_enable_valid_i = 1'b0;
  tr.global_int_enable_bit_i   = 16'h0000;

  tr.soc_ack_read_valid_en = 1'b0;

  tr.soc_eoi_valid_i = 1'b0;
  tr.soc_eoi_id_i    = 8'h00;

  tr.active_lvl_pr_i = 8'h00;

  tr.debug_mode_valid_i = 1'b0;

  finish_item(tr);


  //------------------------------------------------------------
  // Transaction-2 : Release Reset
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("release_reset");

  start_item(tr);

  tr.soc_rst = 1'b1;

  tr.ext_int = 16'h0000;

  tr.soc_mmr_write_en_i   = 1'b0;
  tr.soc_mmr_write_addr_i = 16'h0000;
  tr.soc_mmr_write_data_i = 32'h00000000;

  tr.soc_mmr_read_en_i    = 1'b0;
  tr.soc_mmr_read_addr_i  = 16'h0000;

  tr.global_int_enable_valid_i = 1'b0;
  tr.global_int_enable_bit_i   = 16'h0000;

  tr.soc_ack_read_valid_en = 1'b0;

  tr.soc_eoi_valid_i = 1'b0;
  tr.soc_eoi_id_i    = 8'h00;

  tr.active_lvl_pr_i = 8'h00;

  tr.debug_mode_valid_i = 1'b0;

  finish_item(tr);


  //------------------------------------------------------------
  // Transaction-3 : Program IRQ0 = A0
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("program_irq0");

  start_item(tr);

  tr.soc_rst = 1'b1;

  tr.ext_int = 16'h0000;

  tr.soc_mmr_write_en_i   = 1'b1;
  tr.soc_mmr_write_addr_i = 16'h1003;
  tr.soc_mmr_write_data_i = 32'h000000A0;

  tr.soc_mmr_read_en_i    = 1'b0;
  tr.soc_mmr_read_addr_i  = 16'h0000;

  tr.global_int_enable_valid_i = 1'b0;
  tr.global_int_enable_bit_i   = 16'h0000;

  tr.soc_ack_read_valid_en = 1'b0;

  tr.soc_eoi_valid_i = 1'b0;
  tr.soc_eoi_id_i    = 8'h00;

  tr.active_lvl_pr_i = 8'h00;

  tr.debug_mode_valid_i = 1'b0;

  finish_item(tr);


  //------------------------------------------------------------
  // Transaction-4 : Enable IRQ0
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("enable_irq0");

  start_item(tr);

  tr.soc_rst = 1'b1;

  tr.ext_int = 16'h0000;

  tr.soc_mmr_write_en_i   = 1'b0;
  tr.soc_mmr_write_addr_i = 16'h0000;
  tr.soc_mmr_write_data_i = 32'h00000000;

  tr.soc_mmr_read_en_i    = 1'b0;
  tr.soc_mmr_read_addr_i  = 16'h0000;

  tr.global_int_enable_valid_i = 1'b1;
  tr.global_int_enable_bit_i   = 16'h0001;

  tr.soc_ack_read_valid_en = 1'b0;

  tr.soc_eoi_valid_i = 1'b0;
  tr.soc_eoi_id_i    = 8'h00;

  tr.active_lvl_pr_i = 8'h00;

  tr.debug_mode_valid_i = 1'b0;

  finish_item(tr);


  //------------------------------------------------------------
  // Transaction-5 : Assert IRQ0
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("assert_irq0");

  start_item(tr);

  tr.soc_rst = 1'b1;

  tr.ext_int = 16'h0001;

  tr.soc_mmr_write_en_i   = 1'b0;
  tr.soc_mmr_write_addr_i = 16'h0000;
  tr.soc_mmr_write_data_i = 32'h00000000;

  tr.soc_mmr_read_en_i    = 1'b0;
  tr.soc_mmr_read_addr_i  = 16'h0000;

  tr.global_int_enable_valid_i = 1'b0;
  tr.global_int_enable_bit_i   = 16'h0000;

  tr.soc_ack_read_valid_en = 1'b0;

  tr.soc_eoi_valid_i = 1'b0;
  tr.soc_eoi_id_i    = 8'h00;

  tr.active_lvl_pr_i = 8'h00;

  tr.debug_mode_valid_i = 1'b0;

  finish_item(tr);


  //------------------------------------------------------------
  // Transaction-6 : Pipeline Wait
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("wait1");

  start_item(tr);

  tr.soc_rst = 1'b1;

  tr.ext_int = 16'h0001;

  tr.soc_mmr_write_en_i   = 1'b0;
  tr.soc_mmr_write_addr_i = 16'h0000;
  tr.soc_mmr_write_data_i = 32'h00000000;

  tr.soc_mmr_read_en_i    = 1'b0;
  tr.soc_mmr_read_addr_i  = 16'h0000;

  tr.global_int_enable_valid_i = 1'b0;
  tr.global_int_enable_bit_i   = 16'h0000;

  tr.soc_ack_read_valid_en = 1'b0;

  tr.soc_eoi_valid_i = 1'b0;
  tr.soc_eoi_id_i    = 8'h00;

  tr.active_lvl_pr_i = 8'h00;

  tr.debug_mode_valid_i = 1'b0;

  finish_item(tr);

    //------------------------------------------------------------
  // Transaction-7 : Pipeline Wait
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("wait2");

  start_item(tr);

  tr.soc_rst = 1'b1;

  tr.ext_int = 16'h0001;

  tr.soc_mmr_write_en_i   = 1'b0;
  tr.soc_mmr_write_addr_i = 16'h0000;
  tr.soc_mmr_write_data_i = 32'h00000000;

  tr.soc_mmr_read_en_i    = 1'b0;
  tr.soc_mmr_read_addr_i  = 16'h0000;

  tr.global_int_enable_valid_i = 1'b0;
  tr.global_int_enable_bit_i   = 16'h0000;

  tr.soc_ack_read_valid_en = 1'b0;

  tr.soc_eoi_valid_i = 1'b0;
  tr.soc_eoi_id_i    = 8'h00;

  tr.active_lvl_pr_i = 8'h00;

  tr.debug_mode_valid_i = 1'b0;

  finish_item(tr);

  //------------------------------------------------------------
  // Transaction-8 : First ACK Read
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("ack_read_1");

  start_item(tr);

  tr.soc_rst = 1'b1;

  tr.ext_int = 16'h0001;

  tr.soc_mmr_write_en_i   = 1'b0;
  tr.soc_mmr_write_addr_i = 16'h0000;
  tr.soc_mmr_write_data_i = 32'h00000000;

  tr.soc_mmr_read_en_i    = 1'b0;
  tr.soc_mmr_read_addr_i  = 16'h0000;

  tr.global_int_enable_valid_i = 1'b0;
  tr.global_int_enable_bit_i   = 16'h0000;

  tr.soc_ack_read_valid_en = 1'b1;

  tr.soc_eoi_valid_i = 1'b0;
  tr.soc_eoi_id_i    = 8'h00;

  tr.active_lvl_pr_i = 8'h00;

  tr.debug_mode_valid_i = 1'b0;

  finish_item(tr);

  //------------------------------------------------------------
  // Transaction-9 : ACK Low
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("ack_low_1");

  start_item(tr);

  tr.soc_rst = 1'b1;

  tr.ext_int = 16'h0001;

  tr.soc_mmr_write_en_i   = 1'b0;
  tr.soc_mmr_write_addr_i = 16'h0000;
  tr.soc_mmr_write_data_i = 32'h00000000;

  tr.soc_mmr_read_en_i    = 1'b0;
  tr.soc_mmr_read_addr_i  = 16'h0000;

  tr.global_int_enable_valid_i = 1'b0;
  tr.global_int_enable_bit_i   = 16'h0000;

  tr.soc_ack_read_valid_en = 1'b0;

  tr.soc_eoi_valid_i = 1'b0;
  tr.soc_eoi_id_i    = 8'h00;

  tr.active_lvl_pr_i = 8'h00;

  tr.debug_mode_valid_i = 1'b0;

  finish_item(tr);

  //------------------------------------------------------------
  // Transaction-10 : First Valid EOI
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("eoi1");

  start_item(tr);

  tr.soc_rst = 1'b1;

  tr.ext_int = 16'h0001;      // IMPORTANT : Keep interrupt HIGH

  tr.soc_mmr_write_en_i   = 1'b0;
  tr.soc_mmr_write_addr_i = 16'h0000;
  tr.soc_mmr_write_data_i = 32'h00000000;

  tr.soc_mmr_read_en_i    = 1'b0;
  tr.soc_mmr_read_addr_i  = 16'h0000;

  tr.global_int_enable_valid_i = 1'b0;
  tr.global_int_enable_bit_i   = 16'h0000;

  tr.soc_ack_read_valid_en = 1'b0;

  tr.soc_eoi_valid_i = 1'b1;
  tr.soc_eoi_id_i    = 8'h10;

  tr.active_lvl_pr_i = 8'h00;

  tr.debug_mode_valid_i = 1'b0;

  finish_item(tr);

  //------------------------------------------------------------
  // Transaction-11 : EOI Low
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("eoi_low1");

  start_item(tr);

  tr.soc_rst = 1'b1;

  tr.ext_int = 16'h0001;      // STILL HIGH

  tr.soc_mmr_write_en_i   = 1'b0;
  tr.soc_mmr_write_addr_i = 16'h0000;
  tr.soc_mmr_write_data_i = 32'h00000000;

  tr.soc_mmr_read_en_i    = 1'b0;
  tr.soc_mmr_read_addr_i  = 16'h0000;

  tr.global_int_enable_valid_i = 1'b0;
  tr.global_int_enable_bit_i   = 16'h0000;

  tr.soc_ack_read_valid_en = 1'b0;

  tr.soc_eoi_valid_i = 1'b0;
  tr.soc_eoi_id_i    = 8'h00;

  tr.active_lvl_pr_i = 8'h00;

  tr.debug_mode_valid_i = 1'b0;

  finish_item(tr);

  //------------------------------------------------------------
  // Transaction-12 : Wait For Retrigger
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("wait_retrigger");

  start_item(tr);

  tr.soc_rst = 1'b1;

  tr.ext_int = 16'h0001;      // STILL ASSERTED

  tr.soc_mmr_write_en_i   = 1'b0;
  tr.soc_mmr_write_addr_i = 16'h0000;
  tr.soc_mmr_write_data_i = 32'h00000000;

  tr.soc_mmr_read_en_i    = 1'b0;
  tr.soc_mmr_read_addr_i  = 16'h0000;

  tr.global_int_enable_valid_i = 1'b0;
  tr.global_int_enable_bit_i   = 16'h0000;

  tr.soc_ack_read_valid_en = 1'b0;

  tr.soc_eoi_valid_i = 1'b0;
  tr.soc_eoi_id_i    = 8'h00;

  tr.active_lvl_pr_i = 8'h00;

  tr.debug_mode_valid_i = 1'b0;

  finish_item(tr);

    //------------------------------------------------------------
  // Transaction-13 : Second ACK Read
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("ack_read_2");

  start_item(tr);

  tr.soc_rst = 1'b1;

  tr.ext_int = 16'h0001;

  tr.soc_mmr_write_en_i   = 1'b0;
  tr.soc_mmr_write_addr_i = 16'h0000;
  tr.soc_mmr_write_data_i = 32'h00000000;

  tr.soc_mmr_read_en_i    = 1'b0;
  tr.soc_mmr_read_addr_i  = 16'h0000;

  tr.global_int_enable_valid_i = 1'b0;
  tr.global_int_enable_bit_i   = 16'h0000;

  tr.soc_ack_read_valid_en = 1'b1;

  tr.soc_eoi_valid_i = 1'b0;
  tr.soc_eoi_id_i    = 8'h00;

  tr.active_lvl_pr_i = 8'h00;

  tr.debug_mode_valid_i = 1'b0;

  finish_item(tr);


  //------------------------------------------------------------
  // Transaction-14 : ACK Low
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("ack_low_2");

  start_item(tr);

  tr.soc_rst = 1'b1;

  tr.ext_int = 16'h0001;

  tr.soc_mmr_write_en_i   = 1'b0;
  tr.soc_mmr_write_addr_i = 16'h0000;
  tr.soc_mmr_write_data_i = 32'h00000000;

  tr.soc_mmr_read_en_i    = 1'b0;
  tr.soc_mmr_read_addr_i  = 16'h0000;

  tr.global_int_enable_valid_i = 1'b0;
  tr.global_int_enable_bit_i   = 16'h0000;

  tr.soc_ack_read_valid_en = 1'b0;

  tr.soc_eoi_valid_i = 1'b0;
  tr.soc_eoi_id_i    = 8'h00;

  tr.active_lvl_pr_i = 8'h00;

  tr.debug_mode_valid_i = 1'b0;

  finish_item(tr);


  //------------------------------------------------------------
  // Transaction-15 : Second Valid EOI
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("eoi2");

  start_item(tr);

  tr.soc_rst = 1'b1;

  tr.ext_int = 16'h0001;

  tr.soc_mmr_write_en_i   = 1'b0;
  tr.soc_mmr_write_addr_i = 16'h0000;
  tr.soc_mmr_write_data_i = 32'h00000000;

  tr.soc_mmr_read_en_i    = 1'b0;
  tr.soc_mmr_read_addr_i  = 16'h0000;

  tr.global_int_enable_valid_i = 1'b0;
  tr.global_int_enable_bit_i   = 16'h0000;

  tr.soc_ack_read_valid_en = 1'b0;

  tr.soc_eoi_valid_i = 1'b1;
  tr.soc_eoi_id_i    = 8'h10;

  tr.active_lvl_pr_i = 8'h00;

  tr.debug_mode_valid_i = 1'b0;

  finish_item(tr);


  //------------------------------------------------------------
  // Transaction-16 : Second EOI Low
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("eoi_low2");

  start_item(tr);

  tr.soc_rst = 1'b1;

  tr.ext_int = 16'h0001;

  tr.soc_mmr_write_en_i   = 1'b0;
  tr.soc_mmr_write_addr_i = 16'h0000;
  tr.soc_mmr_write_data_i = 32'h00000000;

  tr.soc_mmr_read_en_i    = 1'b0;
  tr.soc_mmr_read_addr_i  = 16'h0000;

  tr.global_int_enable_valid_i = 1'b0;
  tr.global_int_enable_bit_i   = 16'h0000;

  tr.soc_ack_read_valid_en = 1'b0;

  tr.soc_eoi_valid_i = 1'b0;
  tr.soc_eoi_id_i    = 8'h00;

  tr.active_lvl_pr_i = 8'h00;

  tr.debug_mode_valid_i = 1'b0;

  finish_item(tr);


  //------------------------------------------------------------
  // Transaction-17 : Remove External Interrupt
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("remove_irq");

  start_item(tr);

  tr.soc_rst = 1'b1;

  tr.ext_int = 16'h0000;

  tr.soc_mmr_write_en_i   = 1'b0;
  tr.soc_mmr_write_addr_i = 16'h0000;
  tr.soc_mmr_write_data_i = 32'h00000000;

  tr.soc_mmr_read_en_i    = 1'b0;
  tr.soc_mmr_read_addr_i  = 16'h0000;

  tr.global_int_enable_valid_i = 1'b0;
  tr.global_int_enable_bit_i   = 16'h0000;

  tr.soc_ack_read_valid_en = 1'b0;

  tr.soc_eoi_valid_i = 1'b0;
  tr.soc_eoi_id_i    = 8'h00;

  tr.active_lvl_pr_i = 8'h00;

  tr.debug_mode_valid_i = 1'b0;

  finish_item(tr);


  //------------------------------------------------------------
  // Transaction-18 : Disable Global Interrupt
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("disable_global");

  start_item(tr);

  tr.soc_rst = 1'b1;

  tr.ext_int = 16'h0000;

  tr.soc_mmr_write_en_i   = 1'b0;
  tr.soc_mmr_write_addr_i = 16'h0000;
  tr.soc_mmr_write_data_i = 32'h00000000;

  tr.soc_mmr_read_en_i    = 1'b0;
  tr.soc_mmr_read_addr_i  = 16'h0000;

  tr.global_int_enable_valid_i = 1'b1;
  tr.global_int_enable_bit_i   = 16'h0000;

  tr.soc_ack_read_valid_en = 1'b0;

  tr.soc_eoi_valid_i = 1'b0;
  tr.soc_eoi_id_i    = 8'h00;

  tr.active_lvl_pr_i = 8'h00;

  tr.debug_mode_valid_i = 1'b0;

  finish_item(tr);

  endtask : body

endclass 
