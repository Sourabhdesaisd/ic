class zic_seq_item extends uvm_sequence_item;

  rand logic        zic_rst;
  rand logic  	    zic_mmr_write_en_i;     
  rand logic [15:0] zic_mmr_write_addr_i;   
  rand logic [31:0] zic_mmr_write_data_i;  
  rand logic  	    zic_mmr_read_en_i;	  
  rand logic [15:0] zic_mmr_read_addr_i;	  
  rand logic  	    zic_ack_read_valid_en;  
  rand logic  	    zic_eoi_valid_i;		  
  rand logic [7:0]  zic_eoi_id_i;			  
  rand logic [7:0]  active_lvl_pr_i;		  
  rand logic [47:0] global_int_enable_bit_i;		
  rand logic   	    global_int_enable_valid_i;	 
  rand logic  	    ext_int0_i;	  
  rand logic  	    ext_int1_i;	  
  rand logic  	    ext_int2_i;	  
  rand logic  	    ext_int3_i;	  
  rand logic  	    ext_int4_i;	  
  rand logic  	    ext_int5_i;	  
  rand logic  	    ext_int6_i;	  
  rand logic  	    ext_int7_i;	  
  rand logic  	    ext_int8_i;	  
  rand logic  	    ext_int9_i;	  
  rand logic  	    ext_int10_i;	  
  rand logic  	    ext_int11_i;	  
  rand logic  	    ext_int12_i;	  
  rand logic  	    ext_int13_i;	  
  rand logic  	    ext_int14_i;	  
  rand logic  	    ext_int15_i;	  
  rand logic  	    ext_int16_i;	  
  rand logic  	    ext_int17_i;	  
  rand logic  	    ext_int18_i;	  
  rand logic  	    ext_int19_i;	  
  rand logic  	    ext_int20_i;	  
  rand logic  	    ext_int21_i;	  
  rand logic  	    ext_int22_i;	  
  rand logic  	    ext_int23_i;	  
  rand logic  	    ext_int24_i;	  
  rand logic  	    ext_int25_i;	  
  rand logic  	    ext_int26_i;	  
  rand logic  	    ext_int27_i;	  
  rand logic  	    ext_int28_i;	  
  rand logic  	    ext_int29_i;	  
  rand logic  	    ext_int30_i;	  
  rand logic  	    ext_int31_i;	  
  rand logic  	    ext_int32_i;	  
  rand logic  	    ext_int33_i;	  
  rand logic  	    ext_int34_i;	  
  rand logic  	    ext_int35_i;	  
  rand logic  	    ext_int36_i;	  
  rand logic  	    ext_int37_i;	  
  rand logic  	    ext_int38_i;	  
  rand logic  	    ext_int39_i;	  
  rand logic  	    ext_int40_i;	  
  rand logic  	    ext_int41_i;	  
  rand logic  	    ext_int42_i;	  
  rand logic  	    ext_int43_i;	  
  rand logic  	    ext_int44_i;	  
  rand logic  	    ext_int45_i;	  
  rand logic  	    ext_int46_i;	  
  rand logic  	    ext_int47_i;
       logic [31:0] zic_mmr_read_data_o;		
       logic [7:0]  zic_ack_int_id_o;		    
       logic  	    interrupt_request_o;		
       logic [7:0] 	highest_pending_lvl_pr_o;

  `uvm_object_utils_begin(zic_seq_item)

    `uvm_field_int(zic_rst,UVM_ALL_ON)
    `uvm_field_int(zic_mmr_write_en_i,UVM_ALL_ON)
    `uvm_field_int(zic_mmr_write_addr_i,UVM_ALL_ON) 
    `uvm_field_int(zic_mmr_write_data_i,UVM_ALL_ON) 
    `uvm_field_int(zic_mmr_read_en_i,UVM_ALL_ON) 
    `uvm_field_int(zic_mmr_read_addr_i,UVM_ALL_ON) 
    `uvm_field_int(zic_ack_read_valid_en,UVM_ALL_ON) 
    `uvm_field_int(zic_eoi_valid_i,UVM_ALL_ON) 
    `uvm_field_int(zic_eoi_id_i,UVM_ALL_ON)
    `uvm_field_int(active_lvl_pr_i,UVM_ALL_ON) 
    `uvm_field_int(global_int_enable_bit_i,UVM_ALL_ON) 
    `uvm_field_int(global_int_enable_valid_i,UVM_ALL_ON)   
    `uvm_field_int(ext_int0_i,UVM_ALL_ON)
    `uvm_field_int(ext_int1_i,UVM_ALL_ON)
    `uvm_field_int(ext_int2_i,UVM_ALL_ON)
    `uvm_field_int(ext_int3_i,UVM_ALL_ON)
    `uvm_field_int(ext_int4_i,UVM_ALL_ON)
    `uvm_field_int(ext_int5_i,UVM_ALL_ON)
    `uvm_field_int(ext_int6_i,UVM_ALL_ON)
    `uvm_field_int(ext_int7_i,UVM_ALL_ON)
	`uvm_field_int(ext_int8_i,UVM_ALL_ON)
    `uvm_field_int(ext_int9_i,UVM_ALL_ON)
    `uvm_field_int(ext_int10_i,UVM_ALL_ON)
    `uvm_field_int(ext_int11_i,UVM_ALL_ON)
    `uvm_field_int(ext_int12_i,UVM_ALL_ON)
    `uvm_field_int(ext_int13_i,UVM_ALL_ON)
    `uvm_field_int(ext_int14_i,UVM_ALL_ON)
    `uvm_field_int(ext_int15_i,UVM_ALL_ON)
	`uvm_field_int(ext_int16_i,UVM_ALL_ON)
    `uvm_field_int(ext_int17_i,UVM_ALL_ON)
    `uvm_field_int(ext_int18_i,UVM_ALL_ON)
    `uvm_field_int(ext_int19_i,UVM_ALL_ON)
    `uvm_field_int(ext_int20_i,UVM_ALL_ON)
    `uvm_field_int(ext_int21_i,UVM_ALL_ON)
    `uvm_field_int(ext_int22_i,UVM_ALL_ON)
    `uvm_field_int(ext_int23_i,UVM_ALL_ON)
	`uvm_field_int(ext_int24_i,UVM_ALL_ON)
    `uvm_field_int(ext_int25_i,UVM_ALL_ON)
    `uvm_field_int(ext_int26_i,UVM_ALL_ON)
    `uvm_field_int(ext_int27_i,UVM_ALL_ON)
    `uvm_field_int(ext_int28_i,UVM_ALL_ON)
    `uvm_field_int(ext_int29_i,UVM_ALL_ON)
    `uvm_field_int(ext_int30_i,UVM_ALL_ON)
    `uvm_field_int(ext_int31_i,UVM_ALL_ON)
	`uvm_field_int(ext_int32_i,UVM_ALL_ON)
    `uvm_field_int(ext_int33_i,UVM_ALL_ON)
    `uvm_field_int(ext_int34_i,UVM_ALL_ON)
    `uvm_field_int(ext_int35_i,UVM_ALL_ON)
    `uvm_field_int(ext_int36_i,UVM_ALL_ON)
    `uvm_field_int(ext_int37_i,UVM_ALL_ON)
    `uvm_field_int(ext_int38_i,UVM_ALL_ON)
    `uvm_field_int(ext_int39_i,UVM_ALL_ON)
	`uvm_field_int(ext_int40_i,UVM_ALL_ON)
    `uvm_field_int(ext_int41_i,UVM_ALL_ON)
    `uvm_field_int(ext_int42_i,UVM_ALL_ON)
    `uvm_field_int(ext_int43_i,UVM_ALL_ON)
    `uvm_field_int(ext_int44_i,UVM_ALL_ON)
    `uvm_field_int(ext_int45_i,UVM_ALL_ON)
    `uvm_field_int(ext_int46_i,UVM_ALL_ON)
    `uvm_field_int(ext_int47_i,UVM_ALL_ON)
    `uvm_field_int(active_lvl_pr_i	,UVM_ALL_ON)
    `uvm_field_int(zic_eoi_valid_i,UVM_ALL_ON)
    `uvm_field_int(interrupt_request_o,UVM_ALL_ON)
	`uvm_field_int(zic_mmr_read_data_o,UVM_ALL_ON) 
	`uvm_field_int(zic_ack_int_id_o,UVM_ALL_ON) 
	`uvm_field_int(interrupt_request_o,UVM_ALL_ON)
    `uvm_field_int(highest_pending_lvl_pr_o,UVM_ALL_ON) 

  `uvm_object_utils_end

  logic[15:0]zic_ctl_address[$]={16'h1001,16'h1005,16'h1009,16'h100D,16'h1011,16'h1015,16'h1019,16'h101D,16'h1021,16'h1025,16'h1029,16'h102D,16'h1031,16'h1035,16'h1039,16'h103D,16'h1041,16'h1045,16'h1049,16'h104D,16'h1051,16'h1055,16'h1059,16'h105D,16'h1061,16'h1065,16'h1069,16'h106D,16'h1071,16'h1075,16'h1079,16'h107D,16'h1081,16'h1085,16'h1089,16'h108D,16'h1091,16'h1095,16'h1099,16'h109D,16'h10A1,16'h10A5,16'h10A9,16'h10AD,16'h10B1,16'h10B5,16'h10B9,16'h10BD,16'h1000,16'h1004,16'h1008,16'h100c,16'h1010,16'h1014,16'h1018,16'h101c,16'h1020,16'h1024,16'h1028,16'h102c,16'h1030,16'h1034,16'h1038,16'h103c,16'h1040,16'h1044,16'h1048,16'h104c,16'h1050,16'h1054,16'h1058,16'h105c,16'h1060,16'h1064,16'h1068,16'h106c,16'h1070,16'h1074,16'h1078,16'h107c,16'h1080,16'h1084,16'h1088,16'h108c,16'h1090,16'h1094,16'h1098,16'h109C,16'h10A0,16'h10A4,16'h10A8,16'h10AC,16'h10B0,16'h10B4,16'h10B8,16'h10BC,16'h1003,16'h1007,16'h100B,16'h100F,16'h1013,16'h1017,16'h101B,16'h101F,16'h1023,16'h1027,16'h102B,16'h102F,16'h1033,16'h1037,16'h103B,16'h103F,16'h1043,16'h1047,16'h104B,16'h104F,16'h1053,16'h1057,16'h105B,16'h105F,16'h1063,16'h1067,16'h106B,16'h106F,16'h1073,16'h1077,16'h107B,16'h107F,16'h1083,16'h1087,16'h108B,16'h108F,16'h1093,16'h1097,16'h109B,16'h109F,16'h10A3,16'h10A7,16'h10AB,16'h10AF,16'h10B3,16'h10B7,16'h10BB,16'h10BF,16'h1002,16'h1006,16'h100A,16'h100E,16'h1012,16'h1016,16'h101A,16'h101E,16'h1022,16'h1026,16'h102A,16'h102E,16'h1032,16'h1036,16'h103A,16'h103E,16'h1042,16'h1046,16'h104A,16'h104E,16'h1052,16'h1056,16'h105A,16'h105E,16'h1062,16'h1066,16'h106A,16'h106E,16'h1072,16'h1076,16'h107A,16'h107E,16'h1082,16'h1086,16'h108A,16'h108E,16'h1092,16'h1096,16'h109A,16'h109E,16'h10A2,16'h10A6,16'h10AA,16'h10AE,16'h10B2,16'h10B6,16'h10BA,16'h10BE};

  constraint write_addr{soft zic_mmr_write_addr_i inside {zic_ctl_address};}

  constraint write_data{soft zic_mmr_write_data_i inside {[3:255]};}

  constraint read_addr{soft zic_mmr_read_addr_i inside {zic_ctl_address};}


  function new(string name = "");

    super.new(name);

  endfunction

endclass
