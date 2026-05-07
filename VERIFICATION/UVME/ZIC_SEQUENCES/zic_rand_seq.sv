class zic_rand_sequence extends uvm_sequence#(zic_seq_item);

  `uvm_object_utils(zic_rand_sequence)

  zic_seq_item zic_item;
  



  function new(string name = "zic_rand_sequence");
    super.new(name);
  endfunction

  task body();


    ////--RESET--//// 
    `uvm_do_with(zic_item,{zic_item.zic_rst == 0;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_write_addr_i == 0;zic_item.zic_mmr_write_data_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_mmr_read_addr_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 0;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 0;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
    0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
    0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i == 0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
    0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
  

    repeat(48)
    begin
      `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 1;zic_item.zic_mmr_read_en_i == 0;zic_item.zic_ack_read_valid_en == 0;zic_item.zic_eoi_valid_i == 0;zic_item.zic_eoi_id_i == 8'h00;zic_item.active_lvl_pr_i == 0;zic_item.global_int_enable_bit_i == 48'h000000000000;zic_item.global_int_enable_valid_i == 0;zic_item.ext_int0_i == 0;zic_item.ext_int1_i ==
      0;zic_item.ext_int2_i == 0;zic_item.ext_int3_i == 0;zic_item.ext_int4_i == 0;zic_item.ext_int5_i == 0;zic_item.ext_int6_i == 0;zic_item.ext_int7_i == 0;zic_item.ext_int8_i == 0;zic_item.ext_int9_i == 0;zic_item.ext_int10_i == 0;zic_item.ext_int11_i == 0;zic_item.ext_int12_i == 0;zic_item.ext_int13_i == 0;zic_item.ext_int14_i == 0;zic_item.ext_int15_i == 0;zic_item.ext_int16_i == 0;zic_item.ext_int17_i == 0;zic_item.ext_int18_i == 0;zic_item.ext_int19_i == 0;zic_item.ext_int20_i ==
      0;zic_item.ext_int21_i == 0;zic_item.ext_int22_i == 0;zic_item.ext_int23_i == 0;zic_item.ext_int24_i == 0;zic_item.ext_int25_i == 0;zic_item.ext_int26_i == 0;zic_item.ext_int27_i == 0;zic_item.ext_int28_i == 0;zic_item.ext_int29_i == 0;zic_item.ext_int30_i == 0;zic_item.ext_int31_i == 0;zic_item.ext_int32_i == 0;zic_item.ext_int33_i == 0;zic_item.ext_int34_i == 0;zic_item.ext_int35_i == 0;zic_item.ext_int36_i == 0;zic_item.ext_int37_i == 0;zic_item.ext_int38_i == 0;zic_item.ext_int39_i ==
      0;zic_item.ext_int40_i == 0;zic_item.ext_int41_i == 0;zic_item.ext_int42_i == 0;zic_item.ext_int43_i == 0;zic_item.ext_int44_i == 0;zic_item.ext_int45_i == 0;zic_item.ext_int46_i == 0;zic_item.ext_int47_i == 0;})
    end


    ////--RANDOM INTERRUPTS--////
    `uvm_do_with(zic_item,{zic_item.zic_rst == 1;zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 0;zic_item.global_int_enable_valid_i == 1;})
   



  endtask

endclass
