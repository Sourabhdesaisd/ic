class tc001_mmr_single_rw_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(tc001_mmr_single_rw_seq)

  int_seq_item tr;

  function new(string name = "tc001_mmr_single_rw_seq");
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
    tr.soc_mmr_write_data_i = 8'h00;

    tr.soc_mmr_read_en_i    = 1'b0;
    tr.soc_mmr_read_addr_i  = 16'h0000;

    tr.soc_eoi_valid_i = 1'b0;
    tr.soc_eoi_id_i    = 8'h00;

    tr.active_lvl_pr_i = 8'h00;

    tr.global_int_enable_bit_i   = 16'h0000;
    tr.global_int_enable_valid_i = 1'b0;

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
    tr.soc_mmr_write_data_i = 8'h00;

    tr.soc_mmr_read_en_i    = 1'b0;
    tr.soc_mmr_read_addr_i  = 16'h0000;

    tr.soc_eoi_valid_i = 1'b0;
    tr.soc_eoi_id_i    = 8'h00;

    tr.active_lvl_pr_i = 8'h00;

    tr.global_int_enable_bit_i   = 16'h0000;
    tr.global_int_enable_valid_i = 1'b0;

    tr.debug_mode_valid_i = 1'b0;

    finish_item(tr);


    //------------------------------------------------------------
    // Transaction-3 : Write IRQ10 CTL
    //
    // IRQ10 CTL address = 0x9020 + (10 * 0x10)
    //                    = 0x90C0
    //------------------------------------------------------------
    tr = int_seq_item::type_id::create("write_irq10_ctl");
    start_item(tr);

    tr.soc_rst = 1'b1;

    tr.ext_int = 16'h0000;

    tr.soc_mmr_write_en_i   = 1'b1;
    tr.soc_mmr_write_addr_i = 16'h90C0;
    tr.soc_mmr_write_data_i = 8'h78;

    tr.soc_mmr_read_en_i    = 1'b0;
    tr.soc_mmr_read_addr_i  = 16'h0000;

    tr.soc_eoi_valid_i = 1'b0;
    tr.soc_eoi_id_i    = 8'h00;

    tr.active_lvl_pr_i = 8'h00;

    tr.global_int_enable_bit_i   = 16'h0000;
    tr.global_int_enable_valid_i = 1'b0;

    tr.debug_mode_valid_i = 1'b0;

    finish_item(tr);


    //------------------------------------------------------------
    // Transaction-4 : Idle
    //------------------------------------------------------------
    tr = int_seq_item::type_id::create("idle_after_write");
    start_item(tr);

    tr.soc_rst = 1'b1;

    tr.ext_int = 16'h0000;

    tr.soc_mmr_write_en_i   = 1'b0;
    tr.soc_mmr_write_addr_i = 16'h0000;
    tr.soc_mmr_write_data_i = 8'h00;

    tr.soc_mmr_read_en_i    = 1'b0;
    tr.soc_mmr_read_addr_i  = 16'h0000;

    tr.soc_eoi_valid_i = 1'b0;
    tr.soc_eoi_id_i    = 8'h00;

    tr.active_lvl_pr_i = 8'h00;

    tr.global_int_enable_bit_i   = 16'h0000;
    tr.global_int_enable_valid_i = 1'b0;

    tr.debug_mode_valid_i = 1'b0;

    finish_item(tr);


    //------------------------------------------------------------
    // Transaction-5 : Read IRQ10 CTL
    //------------------------------------------------------------
    tr = int_seq_item::type_id::create("read_irq10_ctl");
    start_item(tr);

    tr.soc_rst = 1'b1;

    tr.ext_int = 16'h0000;

    tr.soc_mmr_write_en_i   = 1'b0;
    tr.soc_mmr_write_addr_i = 16'h0000;
    tr.soc_mmr_write_data_i = 8'h00;

    tr.soc_mmr_read_en_i    = 1'b1;
    tr.soc_mmr_read_addr_i  = 16'h90C0;

    tr.soc_eoi_valid_i = 1'b0;
    tr.soc_eoi_id_i    = 8'h00;

    tr.active_lvl_pr_i = 8'h00;

    tr.global_int_enable_bit_i   = 16'h0000;
    tr.global_int_enable_valid_i = 1'b0;

    tr.debug_mode_valid_i = 1'b0;

    finish_item(tr);


    //------------------------------------------------------------
    // Transaction-6 : Idle
    //------------------------------------------------------------
    tr = int_seq_item::type_id::create("end");
    start_item(tr);

    tr.soc_rst = 1'b1;

    tr.ext_int = 16'h0000;

    tr.soc_mmr_write_en_i   = 1'b0;
    tr.soc_mmr_write_addr_i = 16'h0000;
    tr.soc_mmr_write_data_i = 8'h00;

    tr.soc_mmr_read_en_i    = 1'b0;
    tr.soc_mmr_read_addr_i  = 16'h0000;

    tr.soc_eoi_valid_i = 1'b0;
    tr.soc_eoi_id_i    = 8'h00;

    tr.active_lvl_pr_i = 8'h00;

    tr.global_int_enable_bit_i   = 16'h0000;
    tr.global_int_enable_valid_i = 1'b0;

    tr.debug_mode_valid_i = 1'b0;

    finish_item(tr);

  endtask

endclass
