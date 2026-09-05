

class tc026_higher_priority_preempt_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(tc026_higher_priority_preempt_seq)

  int_seq_item tr;

  function new(string name="tc026_higher_priority_preempt_seq");
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
    // Transaction-3 : Program IRQ0
    //------------------------------------------------------------
    tr = int_seq_item::type_id::create("program_irq0");

    start_item(tr);

    tr.soc_rst = 1'b1;

    tr.ext_int = 16'h0000;

    tr.soc_mmr_write_en_i   = 1'b1;
    tr.soc_mmr_write_addr_i = 16'h1003;
    tr.soc_mmr_write_data_i = 32'h00000060;

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
    // Transaction-4 : Program IRQ1
    //------------------------------------------------------------
    tr = int_seq_item::type_id::create("program_irq1");

    start_item(tr);

    tr.soc_rst = 1'b1;

    tr.ext_int = 16'h0000;

    tr.soc_mmr_write_en_i   = 1'b1;
    tr.soc_mmr_write_addr_i = 16'h1007;
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
    // Transaction-5 : Enable IRQ0 and IRQ1
    //------------------------------------------------------------
    tr = int_seq_item::type_id::create("enable_irq0_irq1");

    start_item(tr);

    tr.soc_rst = 1'b1;

    tr.ext_int = 16'h0000;

    tr.soc_mmr_write_en_i   = 1'b0;
    tr.soc_mmr_write_addr_i = 16'h0000;
    tr.soc_mmr_write_data_i = 32'h00000000;

    tr.soc_mmr_read_en_i    = 1'b0;
    tr.soc_mmr_read_addr_i  = 16'h0000;

    // Enable IRQ0 and IRQ1
    tr.global_int_enable_valid_i = 1'b1;
    tr.global_int_enable_bit_i   = 16'h0003;

    tr.soc_ack_read_valid_en = 1'b0;

    tr.soc_eoi_valid_i = 1'b0;
    tr.soc_eoi_id_i    = 8'h00;

    tr.active_lvl_pr_i = 8'h00;

    tr.debug_mode_valid_i = 1'b0;

    finish_item(tr);


    //------------------------------------------------------------
    // Transaction-6 : Assert IRQ0 Only
    //------------------------------------------------------------
    tr = int_seq_item::type_id::create("assert_irq0");

    start_item(tr);

    tr.soc_rst = 1'b1;

    tr.ext_int = 16'h0001;      // IRQ0 only

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
    // Transaction-7 : Wait
    //------------------------------------------------------------
    tr = int_seq_item::type_id::create("wait_irq0");

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
    // Transaction-8 : ACK IRQ0
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
    // Transaction-9 : ACK Low
    //------------------------------------------------------------
    tr = int_seq_item::type_id::create("ack_low_irq0");

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

    tr.active_lvl_pr_i = 8'h60;      // IRQ0 now active

    tr.debug_mode_valid_i = 1'b0;

    finish_item(tr);


    //------------------------------------------------------------
    // Transaction-10 : Assert Higher Priority IRQ1
    //------------------------------------------------------------
    tr = int_seq_item::type_id::create("assert_irq1");

    start_item(tr);

    tr.soc_rst = 1'b1;

    tr.ext_int = 16'h0003;      // IRQ0 + IRQ1

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

    tr.active_lvl_pr_i = 8'h60;

    tr.debug_mode_valid_i = 1'b0;

    finish_item(tr);


    //------------------------------------------------------------
    // Transaction-11 : Wait
    //------------------------------------------------------------
    tr = int_seq_item::type_id::create("wait_irq1");

    start_item(tr);

    tr.soc_rst = 1'b1;

    tr.ext_int = 16'h0003;

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

    tr.active_lvl_pr_i = 8'h60;

    tr.debug_mode_valid_i = 1'b0;

    finish_item(tr);


    //------------------------------------------------------------
    // Transaction-12 : ACK IRQ1
    //------------------------------------------------------------
    tr = int_seq_item::type_id::create("ack_irq1");

    start_item(tr);

    tr.soc_rst = 1'b1;

    tr.ext_int = 16'h0003;

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

    tr.active_lvl_pr_i = 8'h60;

    tr.debug_mode_valid_i = 1'b0;

    finish_item(tr);

        //------------------------------------------------------------
    // Transaction-13 : ACK Low IRQ1
    //------------------------------------------------------------
    tr = int_seq_item::type_id::create("ack_low_irq1");

    start_item(tr);

    tr.soc_rst = 1'b1;

    tr.ext_int = 16'h0003;

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

    tr.active_lvl_pr_i = 8'hA0;

    tr.debug_mode_valid_i = 1'b0;

    finish_item(tr);


    //------------------------------------------------------------
    // Transaction-14 : EOI IRQ1
    //------------------------------------------------------------
    tr = int_seq_item::type_id::create("eoi_irq1");

    start_item(tr);

    tr.soc_rst = 1'b1;

    tr.ext_int = 16'h0003;

    tr.soc_mmr_write_en_i   = 1'b0;
    tr.soc_mmr_write_addr_i = 16'h0000;
    tr.soc_mmr_write_data_i = 32'h00000000;

    tr.soc_mmr_read_en_i    = 1'b0;
    tr.soc_mmr_read_addr_i  = 16'h0000;

    tr.global_int_enable_valid_i = 1'b0;
    tr.global_int_enable_bit_i   = 16'h0000;

    tr.soc_ack_read_valid_en = 1'b0;

    tr.soc_eoi_valid_i = 1'b1;
    tr.soc_eoi_id_i    = 8'h11;

    tr.active_lvl_pr_i = 8'hA0;

    tr.debug_mode_valid_i = 1'b0;

    finish_item(tr);


    //------------------------------------------------------------
    // Transaction-15 : EOI Low IRQ1
    //------------------------------------------------------------
    tr = int_seq_item::type_id::create("eoi_low_irq1");

    start_item(tr);

    tr.soc_rst = 1'b1;

    tr.ext_int = 16'h0001;      // IRQ1 removed, IRQ0 still pending

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

    tr.active_lvl_pr_i = 8'h60;

    tr.debug_mode_valid_i = 1'b0;

    finish_item(tr);


    //------------------------------------------------------------
    // Transaction-16 : EOI IRQ0
    //------------------------------------------------------------
    tr = int_seq_item::type_id::create("eoi_irq0");

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

    tr.active_lvl_pr_i = 8'h60;

    tr.debug_mode_valid_i = 1'b0;

    finish_item(tr);


    //------------------------------------------------------------
    // Transaction-17 : EOI Low IRQ0
    //------------------------------------------------------------
    tr = int_seq_item::type_id::create("eoi_low_irq0");

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
    // Transaction-18 : Disable Global Enable
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
    // Transaction-19 : Cleanup
    //------------------------------------------------------------
    tr = int_seq_item::type_id::create("cleanup");

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

  endtask : body

endclass 
