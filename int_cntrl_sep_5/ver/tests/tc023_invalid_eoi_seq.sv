class tc023_invalid_eoi_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(tc023_invalid_eoi_seq)

  int_seq_item tr;

  function new(string name="tc023_invalid_eoi_seq");
    super.new(name);
  endfunction

  task body();

  //------------------------------------------------------------
  // Transaction-1 : Apply Reset
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
  // Transaction-3 : Enable Global IRQ0
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
  // Transaction-4 : Global Enable Low
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("enable_low");

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
  // Transaction-5 : Program IRQ0
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
  // Transaction-6 : Write Low
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("write_low");

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
  // Transaction-7 : Assert IRQ0
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
  // Transaction-8 : Pipeline Wait
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
  // Transaction-9 : Pipeline Wait-2
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
  // Transaction-10 : ACK Pulse
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("ack_irq0");

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
  // Transaction-11 : ACK Low
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("ack_low");

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
  // Transaction-12 : INVALID EOI
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("invalid_eoi");

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

  // Wrong EOI ID
  tr.soc_eoi_valid_i = 1'b1;
  tr.soc_eoi_id_i    = 8'h11;

  tr.active_lvl_pr_i = 8'h00;

  tr.debug_mode_valid_i = 1'b0;

  finish_item(tr);

  //------------------------------------------------------------
  // Transaction-13 : INVALID EOI Low
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("invalid_eoi_low");

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
  // Transaction-14 : Wait (IRQ should still be active)
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("wait_after_invalid_eoi");

  start_item(tr);

  tr.soc_rst = 1'b1;

  tr.ext_int = 16'h0001;    // Keep IRQ0 asserted

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
  // Transaction-15 : Correct EOI
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("correct_eoi");

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

  // Correct ACK ID
  tr.soc_eoi_valid_i = 1'b1;
  tr.soc_eoi_id_i    = 8'h10;

  tr.active_lvl_pr_i = 8'h00;

  tr.debug_mode_valid_i = 1'b0;

  finish_item(tr);


  //------------------------------------------------------------
  // Transaction-16 : Correct EOI Low
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("correct_eoi_low");

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


  //------------------------------------------------------------
  // Transaction-19 : Idle
  //------------------------------------------------------------
  tr = int_seq_item::type_id::create("idle");

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

  endtask

endclass
