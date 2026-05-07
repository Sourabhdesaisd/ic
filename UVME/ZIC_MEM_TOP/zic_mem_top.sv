module top;

  import uvm_pkg::*;
  import zic_mem_pkg::*;

	bit [5:0]clock;
	bit [5:0] reset;
	
 //clock generation
  logic clk;
	initial begin
	   clock=$urandom_range(10,5);
		forever begin
		clk=1;
		#clock;
		clk=0;
		#clock;
		end
	end
	
 //reset generation
  logic rst;
		  initial
	        begin
				reset=$urandom_range(10,5);
				rst = 1;
                #reset;
				rst = 0;
                #reset;
                rst = 1;
                #reset;
                rst = 0;
                #reset;
                rst = 1;
                #reset;
               end


  zic_mem_intf vif(clk,rst);

  zic_mmr_top dut (.zic_clk(vif.clk),
                   .zic_rst(vif.rst),
                   .zic_mmr_write_en_i(vif.zic_mmr_write_en_i),
                   .zic_mmr_write_addr_i(vif.zic_mmr_write_addr_i),
                   .zic_mmr_write_data_i(vif.zic_mmr_write_data_i),
                   .zic_mmr_read_en_i(vif.zic_mmr_read_en_i),
                   .zic_mmr_read_addr_i(vif.zic_mmr_read_addr_i),
                   .zic_mmr_read_data_o(vif.zic_mmr_read_data_o),
                   .irq0_ctrl_o(vif.irq0_ctrl_o),
                   .irq1_ctrl_o(vif.irq1_ctrl_o),
                   .irq2_ctrl_o(vif.irq2_ctrl_o),
                   .irq3_ctrl_o(vif.irq3_ctrl_o),
                   .irq4_ctrl_o(vif.irq4_ctrl_o),
                   .irq5_ctrl_o(vif.irq5_ctrl_o),
                   .irq6_ctrl_o(vif.irq6_ctrl_o),
                   .irq7_ctrl_o(vif.irq7_ctrl_o),
                   .irq8_ctrl_o(vif.irq8_ctrl_o),
                   .irq9_ctrl_o(vif.irq9_ctrl_o),
                   .irq10_ctrl_o(vif.irq10_ctrl_o),
                   .irq11_ctrl_o(vif.irq11_ctrl_o),
                   .irq12_ctrl_o(vif.irq12_ctrl_o),
                   .irq13_ctrl_o(vif.irq13_ctrl_o),
                   .irq14_ctrl_o(vif.irq14_ctrl_o),
                   .irq15_ctrl_o(vif.irq15_ctrl_o),
                   .irq16_ctrl_o(vif.irq16_ctrl_o),
                   .irq17_ctrl_o(vif.irq17_ctrl_o),
                   .irq18_ctrl_o(vif.irq18_ctrl_o),
                   .irq19_ctrl_o(vif.irq19_ctrl_o),
                   .irq20_ctrl_o(vif.irq20_ctrl_o),
                   .irq21_ctrl_o(vif.irq21_ctrl_o),
                   .irq22_ctrl_o(vif.irq22_ctrl_o),
                   .irq23_ctrl_o(vif.irq23_ctrl_o),
                   .irq24_ctrl_o(vif.irq24_ctrl_o),
                   .irq25_ctrl_o(vif.irq25_ctrl_o),
                   .irq26_ctrl_o(vif.irq26_ctrl_o),
                   .irq27_ctrl_o(vif.irq27_ctrl_o),
                   .irq28_ctrl_o(vif.irq28_ctrl_o),
                   .irq29_ctrl_o(vif.irq29_ctrl_o),
                   .irq30_ctrl_o(vif.irq30_ctrl_o),
                   .irq31_ctrl_o(vif.irq31_ctrl_o),
                   .irq32_ctrl_o(vif.irq32_ctrl_o),
                   .irq33_ctrl_o(vif.irq33_ctrl_o),
                   .irq34_ctrl_o(vif.irq34_ctrl_o),
                   .irq35_ctrl_o(vif.irq35_ctrl_o),
                   .irq36_ctrl_o(vif.irq36_ctrl_o),
                   .irq37_ctrl_o(vif.irq37_ctrl_o),
                   .irq38_ctrl_o(vif.irq38_ctrl_o),
                   .irq39_ctrl_o(vif.irq39_ctrl_o),
                   .irq40_ctrl_o(vif.irq40_ctrl_o),
                   .irq41_ctrl_o(vif.irq41_ctrl_o),
                   .irq42_ctrl_o(vif.irq42_ctrl_o),
                   .irq43_ctrl_o(vif.irq43_ctrl_o),
                   .irq44_ctrl_o(vif.irq44_ctrl_o),
                   .irq45_ctrl_o(vif.irq45_ctrl_o),
                   .irq46_ctrl_o(vif.irq46_ctrl_o),
                   .irq47_ctrl_o(vif.irq47_ctrl_o),
                   .zic_ack_write_valid_i(vif.zic_ack_write_valid_i),
                   .zic_ack_int_id_i(vif.zic_ack_int_id_i),
                   .zic_ack_read_valid_en(vif.zic_ack_read_valid_en),
                   .zic_ack_int_id_o(vif.zic_ack_int_id_o),
                   .zic_ack_o(vif.zic_ack_o),
                   .zic_eoi_valid_i(vif.zic_eoi_valid_i),
                   .zic_eoi_id_i(vif.zic_eoi_id_i),
                   .zic_eoi_o(vif.zic_eoi_o),
                   .zic_nxtp_valid_i(vif.zic_nxtp_valid_i),
                   .zic_nxtp_id_i(vif.zic_nxtp_id_i),
                   .zic_int_pending_valid_i(vif.zic_int_pending_valid_i),
                   .zic_int_pending_bit_i(vif.zic_int_pending_bit_i),
                   .global_int_enable_bit_i(vif.global_int_enable_bit_i	),
                   .global_int_enable_valid_i(vif.global_int_enable_valid_i));

 initial
 begin

    $shm_open("wave.shm");
    $shm_probe("ACTMF");
    uvm_config_db#(virtual zic_mem_intf)::set(null,"","vif",vif);
    run_test("zic_mem_test");
    run_test("zic_memtest");
    run_test("zic_mem_rand_test");

  end 

endmodule
