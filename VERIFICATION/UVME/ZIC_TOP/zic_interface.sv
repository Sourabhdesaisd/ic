interface zic_intf(input logic clk);

  logic        zic_rst;
  logic		   zic_mmr_write_en_i;		
  logic [15:0] zic_mmr_write_addr_i;		
  logic [31:0] zic_mmr_write_data_i;		
  logic        zic_mmr_read_en_i;		
  logic [15:0] zic_mmr_read_addr_i;		
  logic		   zic_ack_read_valid_en;		
  logic		   zic_eoi_valid_i;			
  logic [7:0]  zic_eoi_id_i;			
  logic [7:0]  active_lvl_pr_i;			
  logic [47:0] global_int_enable_bit_i;		
  logic 	   global_int_enable_valid_i;	
  logic		   ext_int0_i;				  
  logic		   ext_int1_i;				  
  logic		   ext_int2_i;				  
  logic		   ext_int3_i;				  
  logic		   ext_int4_i;				  
  logic		   ext_int5_i;				  
  logic		   ext_int6_i;				  
  logic		   ext_int7_i;				  
  logic		   ext_int8_i;				  
  logic		   ext_int9_i;				  
  logic		   ext_int10_i;				  
  logic		   ext_int11_i;				  
  logic		   ext_int12_i;				  
  logic		   ext_int13_i;				  
  logic		   ext_int14_i;				  
  logic		   ext_int15_i;				  
  logic		   ext_int16_i;				  
  logic		   ext_int17_i;				  
  logic		   ext_int18_i;				  
  logic		   ext_int19_i;				  
  logic		   ext_int20_i;				  
  logic		   ext_int21_i;				  
  logic		   ext_int22_i;				  
  logic		   ext_int23_i;				  
  logic		   ext_int24_i;				  
  logic		   ext_int25_i;				  
  logic		   ext_int26_i;				  
  logic		   ext_int27_i;				  
  logic		   ext_int28_i;				  
  logic		   ext_int29_i;				  
  logic		   ext_int30_i;				  
  logic		   ext_int31_i;				  
  logic		   ext_int32_i;				  
  logic		   ext_int33_i;				  
  logic		   ext_int34_i;				  
  logic		   ext_int35_i;				  
  logic		   ext_int36_i;				  
  logic		   ext_int37_i;				  
  logic		   ext_int38_i;				  
  logic		   ext_int39_i;				  
  logic		   ext_int40_i;				  
  logic		   ext_int41_i;				  
  logic		   ext_int42_i;				  
  logic		   ext_int43_i;				  
  logic		   ext_int44_i;				  
  logic		   ext_int45_i;				  
  logic		   ext_int46_i;				  
  logic		   ext_int47_i;
  logic [31:0] zic_mmr_read_data_o;		
  logic [7:0]  zic_ack_int_id_o;		
  logic 	   interrupt_request_o; 
  logic [7:0]  highest_pending_lvl_pr_o;

  logic [7:0]  eoi_mem_id;//// INTERNAL SIGNAL /////
  logic [47:0] int_pending_bits;//// INTERNAL SIGNAL /////

  
endinterface
