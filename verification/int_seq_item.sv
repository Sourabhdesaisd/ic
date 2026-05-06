class int_seq_item extends uvm_sequence_item;

  rand bit do_reset;

  rand bit [47:0] ext_int;
  rand bit [7:0]  threshold;

  rand bit        zic_mmr_write_en_i;
  rand bit [15:0] zic_mmr_write_addr_i;
  rand bit [31:0] zic_mmr_write_data_i;

  rand bit        zic_mmr_read_en_i;
  rand bit [15:0] zic_mmr_read_addr_i;

  rand bit        zic_ack_read_valid_en;

  rand bit        zic_eoi_valid_i;
  rand bit [7:0]  zic_eoi_id_i;

  rand bit [47:0] global_int_enable_bit_i;
  rand bit        global_int_enable_valid_i;

  `uvm_object_utils(int_seq_item)

  function new(string name = "int_seq_item");
    super.new(name);
  endfunction

endclass
