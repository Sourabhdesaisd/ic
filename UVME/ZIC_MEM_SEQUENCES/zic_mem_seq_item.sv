class zic_mem_seq_item extends uvm_sequence_item;

 rand logic        rst;
 rand logic        zic_mmr_write_en_i ;
 rand logic [15:0] zic_mmr_write_addr_i;
 rand logic [31:0] zic_mmr_write_data_i;
 rand logic        zic_mmr_read_en_i;
 rand logic [15:0] zic_mmr_read_addr_i;
 rand logic [7:0]  zic_ack_int_id_i;
 rand logic        zic_ack_write_valid_i;
 rand logic        zic_ack_read_valid_en;
 rand logic        zic_eoi_valid_i; 
 rand logic [7:0]  zic_eoi_id_i;
 rand logic        zic_nxtp_valid_i;
 rand logic [7:0]  zic_nxtp_id_i;
 rand logic        zic_int_pending_valid_i;
 rand logic [47:0] zic_int_pending_bit_i;
 rand logic [47:0] global_int_enable_bit_i;
 rand logic        global_int_enable_valid_i;
      logic [31:0] zic_mmr_read_data_o;
      logic [7:0]  zic_ack_int_id_o;
      logic        zic_ack_o;
      logic        zic_eoi_o;
      logic [7:0] irq0_ctrl_o;
      logic [7:0] irq1_ctrl_o;
      logic [7:0] irq2_ctrl_o;
      logic [7:0] irq3_ctrl_o;
      logic [7:0] irq4_ctrl_o;
      logic [7:0] irq5_ctrl_o;
      logic [7:0] irq6_ctrl_o;
      logic [7:0] irq7_ctrl_o;
      logic [7:0] irq8_ctrl_o;
      logic [7:0] irq9_ctrl_o;
      logic [7:0] irq10_ctrl_o;
      logic [7:0] irq11_ctrl_o;
      logic [7:0] irq12_ctrl_o;
      logic [7:0] irq13_ctrl_o;
      logic [7:0] irq14_ctrl_o;
      logic [7:0] irq15_ctrl_o;
      logic [7:0] irq16_ctrl_o;
      logic [7:0] irq17_ctrl_o;
      logic [7:0] irq18_ctrl_o;
      logic [7:0] irq19_ctrl_o;
      logic [7:0] irq20_ctrl_o;
      logic [7:0] irq21_ctrl_o;
      logic [7:0] irq22_ctrl_o;
      logic [7:0] irq23_ctrl_o;
      logic [7:0] irq24_ctrl_o;
      logic [7:0] irq25_ctrl_o;
      logic [7:0] irq26_ctrl_o;
      logic [7:0] irq27_ctrl_o;
      logic [7:0] irq28_ctrl_o;
      logic [7:0] irq29_ctrl_o;
      logic [7:0] irq30_ctrl_o;
      logic [7:0] irq31_ctrl_o;
      logic [7:0] irq32_ctrl_o;
      logic [7:0] irq33_ctrl_o;
      logic [7:0] irq34_ctrl_o;
      logic [7:0] irq35_ctrl_o;
      logic [7:0] irq36_ctrl_o;
      logic [7:0] irq37_ctrl_o;
      logic [7:0] irq38_ctrl_o;
      logic [7:0] irq39_ctrl_o;
      logic [7:0] irq40_ctrl_o;
      logic [7:0] irq41_ctrl_o;
      logic [7:0] irq42_ctrl_o;
      logic [7:0] irq43_ctrl_o;
      logic [7:0] irq44_ctrl_o;
      logic [7:0] irq45_ctrl_o;
      logic [7:0] irq46_ctrl_o;
      logic [7:0] irq47_ctrl_o;
    

  `uvm_object_utils_begin(zic_mem_seq_item)

    `uvm_field_int(rst ,UVM_ALL_ON)
    `uvm_field_int(zic_ack_write_valid_i ,UVM_ALL_ON)
    `uvm_field_int(zic_mmr_write_en_i ,UVM_ALL_ON)
    `uvm_field_int(zic_mmr_write_addr_i,UVM_ALL_ON)
    `uvm_field_int(zic_mmr_write_data_i,UVM_ALL_ON)
    `uvm_field_int(zic_mmr_read_en_i,UVM_ALL_ON)
    `uvm_field_int(zic_mmr_read_addr_i,UVM_ALL_ON)
    `uvm_field_int(zic_ack_int_id_i,UVM_ALL_ON)
    `uvm_field_int(zic_ack_read_valid_en,UVM_ALL_ON)
    `uvm_field_int(zic_eoi_valid_i,UVM_ALL_ON)
    `uvm_field_int(zic_eoi_id_i,UVM_ALL_ON)
    `uvm_field_int(zic_nxtp_valid_i,UVM_ALL_ON)
    `uvm_field_int(zic_nxtp_id_i,UVM_ALL_ON)
    `uvm_field_int(zic_int_pending_valid_i,UVM_ALL_ON)
    `uvm_field_int(zic_int_pending_bit_i,UVM_ALL_ON)
    `uvm_field_int(global_int_enable_bit_i,UVM_ALL_ON)
    `uvm_field_int(global_int_enable_valid_i,UVM_ALL_ON)
    `uvm_field_int(zic_mmr_read_data_o,UVM_ALL_ON)
    `uvm_field_int(zic_ack_int_id_o,UVM_ALL_ON)
    `uvm_field_int(zic_ack_o,UVM_ALL_ON)
    `uvm_field_int(zic_eoi_o,UVM_ALL_ON)
    `uvm_field_int(irq0_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq1_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq2_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq3_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq4_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq5_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq6_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq7_ctrl_o,UVM_ALL_ON)
	`uvm_field_int(irq8_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq9_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq10_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq11_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq12_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq13_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq14_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq15_ctrl_o,UVM_ALL_ON)
	`uvm_field_int(irq16_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq17_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq18_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq19_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq20_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq21_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq22_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq23_ctrl_o,UVM_ALL_ON)
	`uvm_field_int(irq24_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq25_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq26_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq27_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq28_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq29_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq30_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq31_ctrl_o,UVM_ALL_ON)
	`uvm_field_int(irq32_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq33_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq34_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq35_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq36_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq37_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq38_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq39_ctrl_o,UVM_ALL_ON)
	`uvm_field_int(irq40_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq41_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq42_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq43_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq44_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq45_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq46_ctrl_o,UVM_ALL_ON)
    `uvm_field_int(irq47_ctrl_o,UVM_ALL_ON)


  `uvm_object_utils_end


  function new(string name = "zic_mem_seq_item");

    super.new(name);

  endfunction

endclass
