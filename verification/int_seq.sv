class int_reset_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(int_reset_seq)

  function new(string name = "int_reset_seq");
    super.new(name);
  endfunction

  task body();

    int_seq_item tr;

    tr = int_seq_item::type_id::create("tr");

    start_item(tr);

    tr.do_reset = 1'b1;

    tr.ext_int                   = '0;
    tr.threshold                 = '0;

    tr.zic_mmr_write_en_i        = 1'b0;
    tr.zic_mmr_write_addr_i      = '0;
    tr.zic_mmr_write_data_i      = '0;

    tr.zic_mmr_read_en_i         = 1'b0;
    tr.zic_mmr_read_addr_i       = '0;

    tr.zic_ack_read_valid_en     = 1'b0;

    tr.zic_eoi_valid_i           = 1'b0;
    tr.zic_eoi_id_i              = '0;

    tr.global_int_enable_bit_i   = '0;
    tr.global_int_enable_valid_i = 1'b0;

    finish_item(tr);

  endtask

endclass


class int_single_irq_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(int_single_irq_seq)

  function new(string name = "int_single_irq_seq");
    super.new(name);
  endfunction

task body();

    int_seq_item tr;

    // -------------------------
    // RESET
    // -------------------------
    tr = int_seq_item::type_id::create("tr");

    start_item(tr);

    tr.do_reset = 1'b1;

    tr.ext_int                   = '0;
    tr.threshold                 = 8'd0;

    tr.zic_mmr_write_en_i        = 0;
    tr.zic_mmr_write_addr_i      = 0;
    tr.zic_mmr_write_data_i      = 0;

    tr.zic_mmr_read_en_i         = 0;
    tr.zic_mmr_read_addr_i       = 0;

    tr.zic_ack_read_valid_en     = 0;

    tr.zic_eoi_valid_i           = 0;
    tr.zic_eoi_id_i              = 0;

    tr.global_int_enable_bit_i   = 0;
    tr.global_int_enable_valid_i = 0;

    finish_item(tr);

    // -------------------------
    // NORMAL IRQ5 TEST
    // -------------------------
   // ONE FULL INPUT TRANSACTION
tr = int_seq_item::type_id::create("all_input_tr");

start_item(tr);

tr.do_reset = 1'b0;

// interrupt input
tr.ext_int[5] = 1'b1;

// threshold
tr.threshold = 8'd1;

// MMR write input
tr.zic_mmr_write_en_i   = 1'b1;
tr.zic_mmr_write_addr_i = 16'h1007;
tr.zic_mmr_write_data_i = 32'h000000FF;

// MMR read input
tr.zic_mmr_read_en_i    = 1'b1;
tr.zic_mmr_read_addr_i  = 16'h1007;

// ACK input
tr.zic_ack_read_valid_en = 1'b1;

// EOI input
tr.zic_eoi_valid_i = 1'b1;
tr.zic_eoi_id_i    = 8'd0;

// global enable input
tr.global_int_enable_bit_i    = 48'd16;
tr.global_int_enable_bit_i[5] = 1'b1;
tr.global_int_enable_valid_i  = 1'b1;

finish_item(tr);



endtask

endclass

