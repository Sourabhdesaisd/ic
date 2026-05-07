class zic_rand2_sequence extends uvm_sequence#(zic_seq_item);

  `uvm_object_utils(zic_rand2_sequence)

  zic_seq_item zic_item;
  
  int case_sel =1;


  function new(string name = "zic_rand2_sequence");
    super.new(name);
  endfunction

  task body();


    ////--RESET--//// 
    `uvm_do_with(zic_item,{zic_item.zic_rst == 0;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_write_addr_i == 0;zic_item.zic_mmr_write_data_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_mmr_read_addr_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 0;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 0;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
    0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
    0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i == 0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
    0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
  
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_write_addr_i == 0;zic_item.zic_mmr_write_data_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_mmr_read_addr_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 0;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 0;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
    0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
    0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i == 0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
    0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
  
    `uvm_do_with(zic_item,{zic_item.zic_rst == 0;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_write_addr_i == 0;zic_item.zic_mmr_write_data_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_mmr_read_addr_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 0;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 0;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
    0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
    0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i == 0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
    0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
  

    case(case_sel)
    
    ////--INTERRUPT 0--////
    1:
	begin
      repeat(3)
      begin
        `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000001;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 1;zic_item.ext_int1_i ==
        0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
        0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
        0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
      end
	
    
      `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
    ////--INTERRUPT 1--////
    2:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000002;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      1;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end

    ////--INTERRUPT 2--////
    3:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000004;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 1;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
    ////--INTERRUPT 3--////
    4:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000008;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 1;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
    ////--INTERRUPT 4--////
    5:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000010;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 1;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end

    ////--INTERRUPT 5--////
    6:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000020;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 1;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
    ////--INTERRUPT 6--////
    7:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000040;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 1;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
    ////--INTERRUPT 7--////
    8:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000080;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 1;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
    ////--INTERRUPT 8--////
    9:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000100;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 1;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 1;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
    ////--INTERRUPT 9--////
    10:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000200;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 9;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 10--////
    11:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000400;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 1;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 11--////
    12:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000800;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 11;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 12--////
    13:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000001000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 1;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 13--////
    14:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000002000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 1;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 14--////
    15:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000004000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 1;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 15--////
    16:
	begin	
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000008000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 1;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 16--////
    17:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000010000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 1;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 17--////
    18:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000020000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 1;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 18--////
    19:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000040000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 1;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 19--////
    20:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000080000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 1;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 20--////
    21:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000100000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      1;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 21--////
    22:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000200000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 1;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 22--////
    23:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000400000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 1;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 23--////
    24:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000800000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 1;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 24--////
    25:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000001000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 1;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 25--////
    26:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000002000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 1;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 26--////
    27:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000004000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 1;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 27--////
    28:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000008000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==1;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 28--////
    29:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000010000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 1;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 29--////
    30:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000020000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 1;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 30--////
    31:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000040000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 1;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 0;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 31--////
    32:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000080000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 1;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 32--////
    33:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000100000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 1;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 33--////
    34:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000200000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 1;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	
	////--INTERRUPT 34--////
    35:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000400000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 1;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 35--////
    36:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000800000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 1;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 36--////
    37:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h001000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 1;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 37--////
    38:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h002000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 1;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end

	////--INTERRUPT 38--////
    39:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h004000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 1;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 39--////
    40:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h008000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      1;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 40--////
    41:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h010000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 1;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 41--////
    42:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h020000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 1;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 1;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 42--////
    43:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h040000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 1;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 43--////
    44:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h080000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 1;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 44--////
    45:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h100000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 1;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 45--////
    46:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h200000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 1;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 46--////
    47:
	begin
    repeat(3)
    begin
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h400000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 1;zic_item.ext_int47_i == 0;})
    end
    
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 0;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end
	
	////--INTERRUPT 47--////
    48:
	begin
      repeat(3)
      begin
        `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h800000000000;zic_item.global_int_enable_valid_i == 1;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
         0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
         0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
         0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 1;})
        end
        
      `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 1;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 0;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i ==0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end


      

  endcase
  endtask

endclass
