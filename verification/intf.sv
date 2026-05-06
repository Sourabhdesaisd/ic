interface intf(input logic ic_clk);

  logic ic_rst;
  logic ic_rst_ack;

  logic [47:0] ext_int;

  logic [7:0] threshold;
  logic irq_request;
  logic [7:0] interrupt_out;

  logic zic_mmr_write_en_i;
  logic [15:0] zic_mmr_write_addr_i;
  logic [31:0] zic_mmr_write_data_i;

  logic zic_mmr_read_en_i;
  logic [15:0] zic_mmr_read_addr_i;
  logic [31:0] zic_mmr_read_data_o;

  logic zic_ack_read_valid_en;
  logic [7:0] zic_ack_int_id_o;

  logic zic_eoi_valid_i;
  logic [7:0] zic_eoi_id_i;

  logic [47:0] global_int_enable_bit_i;
  logic global_int_enable_valid_i;

endinterface
