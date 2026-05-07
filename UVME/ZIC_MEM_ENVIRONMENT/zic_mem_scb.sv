class zic_mem_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(zic_mem_scoreboard)

  uvm_analysis_imp#(zic_mem_seq_item,zic_mem_scoreboard) analysis_imp_scb;

  zic_mem_seq_item zic_item;

  zic_mem_seq_item sampled_data[$];
  logic [63:0] mem [int];
  logic [15:0]zic_int_en_address[$]={16'h1001,16'h1005,16'h1009,16'h100D,16'h1011,16'h1015,16'h1019,16'h101D,16'h1021,16'h1025,16'h1029,16'h102D,16'h1031,16'h1035,16'h1039,16'h103D,16'h1041,16'h1045,16'h1049,16'h104D,16'h1051,16'h1055,16'h1059,16'h105D,16'h1061,16'h1065,16'h1069,16'h106D,16'h1071,16'h1075,16'h1079,16'h107D,16'h1081,16'h1085,16'h1089,16'h108D,16'h1091,16'h1095,16'h1099,16'h109D,16'h10A1,16'h10A5,16'h10A9,16'h10AD,16'h10B1,16'h10B5,16'h10B9,16'h10BD};

  logic[15:0]zic_int_p_address[$]={16'h1000,16'h1004,16'h1008,16'h100c,16'h1010,16'h1014,16'h1018,16'h101c,16'h1020,16'h1024,16'h1028,16'h102c,16'h1030,16'h1034,16'h1038,16'h103c,16'h1040,16'h1044,16'h1048,16'h104c,16'h1050,16'h1054,16'h1058,16'h105c,16'h1060,16'h1064,16'h1068,16'h106c,16'h1070,16'h1074,16'h1078,16'h107c,16'h1080,16'h1084,16'h1088,16'h108c,16'h1090,16'h1094,16'h1098,16'h109c,16'h10A0,16'h10A4,16'h10A8,16'h10AC,16'h10B0,16'h10B4,16'h10B8,16'h10BC};

  logic[15:0]zic_ctl_address[$]={16'h1003,16'h1007,16'h100B,16'h100F,16'h1013,16'h1017,16'h101B,16'h101F,16'h1023,16'h1027,16'h102B,16'h102F,16'h1033,16'h1037,16'h103B,16'h103F,16'h1043,16'h1047,16'h104B,16'h104F,16'h1053,16'h1057,16'h105B,16'h105F,16'h1063,16'h1067,16'h106B,16'h106F,16'h1073,16'h1077,16'h107B,16'h107F,16'h1083,16'h1087,16'h108B,16'h108F,16'h1093,16'h1097,16'h109B,16'h109F,16'h10A3,16'h10A7,16'h10AB,16'h10AF,16'h10B3,16'h10B7,16'h10BB,16'h10BF};

  logic [15:0]zic_int_attr_address[$]={16'h1002,16'h1006,16'h100A,16'h100E,16'h1012,16'h1016,16'h101A,16'h101E,16'h1022,16'h1026,16'h102A,16'h102E,16'h1032,16'h1036,16'h103A,16'h103E,16'h1042,16'h1046,16'h104A,16'h104E,16'h1052,16'h1056,16'h105A,16'h105E,16'h1062,16'h1066,16'h106A,16'h106E,16'h1072,16'h1076,16'h107A,16'h107E,16'h1082,16'h1086,16'h108A,16'h108E,16'h1092,16'h1096,16'h109A,16'h109E,16'h10A2,16'h10A6,16'h10AA,16'h10AE,16'h10B2,16'h10B6,16'h10BA,16'h10BE};
 
 function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  //build phase
 function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   reset_values();
   analysis_imp_scb = new("analysis_imp_scb", this);
  endfunction

//preset values
  function void reset_values();
    mem[16'h0000]=8'b0_00_0011_1;//zic_config
    mem[16'h0004]=32'h00C00030;//zic_info
    mem[16'h0800]='0;//zic_nxtp_int
    mem[16'h0804]='0;//zic_ack
    mem[16'h0808]='0;//zic_eoi
    foreach(zic_int_en_address[i]) mem[zic_int_en_address[i]]='0;//zic_int_en[i]
    foreach(zic_int_p_address[i]) mem[zic_int_p_address[i]]='0;//zic_int_p[i]
    foreach(zic_int_attr_address[i]) mem[zic_int_attr_address[i]]=8'b11_000_00_0;//zic_attr[i]
    mem[16'h1003]=8'hff;//zic_int_ctl[0]
    mem[16'h1007]=8'hfb;//zic_int_ctl[1]
    mem[16'h100B]=8'hf7;//zic_int_ctl[2]
    mem[16'h100F]=8'hf3;//zic_int_ctl[3]
    mem[16'h1013]=8'hef;//zic_int_ctl[4]
    mem[16'h1017]=8'heb;//zic_int_ctl[5]
    mem[16'h101B]=8'he7;//zic_int_ctl[6]
    mem[16'h101F]=8'hdf;//zic_int_ctl[7]
    mem[16'h1023]=8'hdb;//zic_int_ctl[8]
    mem[16'h1027]=8'hd7;//zic_int_ctl[9]
    mem[16'h102B]=8'hd3;//zic_int_ctl[10]
    mem[16'h102F]=8'hcf;//zic_int_ctl[11]
    mem[16'h1033]=8'hcb;//zic_int_ctl[12]
    mem[16'h1037]=8'hc7;//zic_int_ctl[13]
    mem[16'h103B]=8'hbf;//zic_int_ctl[14]
    mem[16'h103F]=8'hbb;//zic_int_ctl[15]
    mem[16'h1043]=8'hb7;//zic_int_ctl[16]
    mem[16'h1047]=8'hb3;//zic_int_ctl[17]
    mem[16'h104B]=8'haf;//zic_int_ctl[18]
    mem[16'h104F]=8'hab;//zic_int_ctl[19]
    mem[16'h1053]=8'h9f;//zic_int_ctl[20]
    mem[16'h1057]=8'h9b;//zic_int_ctl[21]
    mem[16'h105B]=8'h97;//zic_int_ctl[22]
    mem[16'h105F]=8'h93;//zic_int_ctl[23]
    mem[16'h1063]=8'h8f;//zic_int_ctl[24]
    mem[16'h1067]=8'h8b;//zic_int_ctl[25]
    mem[16'h106B]=8'h87;//zic_int_ctl[26]
    mem[16'h106F]=8'h7f;//zic_int_ctl[27]
    mem[16'h1073]=8'h7b;//zic_int_ctl[28]
    mem[16'h1077]=8'h77;//zic_int_ctl[29]
    mem[16'h107B]=8'h73;//zic_int_ctl[30]
    mem[16'h107F]=8'h6f;//zic_int_ctl[31]
    mem[16'h1083]=8'h6b;//zic_int_ctl[32]
    mem[16'h1087]=8'h67;//zic_int_ctl[33]
    mem[16'h108B]=8'h5f;//zic_int_ctl[34]
    mem[16'h108F]=8'h5b;//zic_int_ctl[35]
    mem[16'h1093]=8'h57;//zic_int_ctl[36]
    mem[16'h1097]=8'h53;//zic_int_ctl[37]
    mem[16'h109B]=8'h4f;//zic_int_ctl[38]
    mem[16'h109F]=8'h4b;//zic_int_ctl[39]
    mem[16'h10A3]=8'h47;//zic_int_ctl[40]
    mem[16'h10A7]=8'h3f;//zic_int_ctl[41]
    mem[16'h10AB]=8'h3b;//zic_int_ctl[42]
    mem[16'h10AF]=8'h37;//zic_int_ctl[43]
    mem[16'h10B3]=8'h33;//zic_int_ctl[44]
    mem[16'h10B7]=8'h2f;//zic_int_ctl[45]
    mem[16'h10BB]=8'h2b;//zic_int_ctl[46]
    mem[16'h10BF]=8'h27;//zic_int_ctl[47]
  endfunction

//write method
function void write(zic_mem_seq_item zic_item);
		sampled_data.push_back(zic_item);
	`uvm_info("SCOREBOARD",$sformatf("SCB"), UVM_MEDIUM)
	endfunction:write
	
	task run_phase(uvm_phase phase);
		forever
		begin
		  zic_mem_seq_item zic_in;
		  wait(sampled_data.size()>0);
		  zic_in=sampled_data.pop_front();

	      if(zic_in.rst==0)begin
		      reset_values();
	    `uvm_info("RESET",$sformatf("reset : %0h",zic_in.rst), UVM_MEDIUM)
          end

         else
          begin
	         fork
                zic_int_en_reg(zic_in);
                zic_int_p_reg(zic_in);
                zic_attr_reg(zic_in);
	            zic_ctl_reg(zic_in);
                zic_config_reg(zic_in);
                zic_info_reg(zic_in);
                zic_ack_reg(zic_in);
                zic_eoi_reg(zic_in);
                zic_nxtp_reg(zic_in);
                zic_irq_ctl_reg(zic_in);
	         join
         end
      end
 endtask:run_phase
//-----------zic_irq_ctl_reg[i]----------//
function void zic_irq_ctl_reg(zic_mem_seq_item zic_in);

    if(mem[16'h1003][7:0]===zic_in.irq0_ctrl_o)
      `uvm_info("irq0_ctrl_o",$sformatf("rtl_irq0_ctrl_o: %0h ref_irq0_ctrl_o : %0h",zic_in.irq0_ctrl_o,mem[16'h1003][7:0]),UVM_HIGH)
    else
      `uvm_error("irq0_ctrl_o",$sformatf("rtl_irq0_ctrl_o : %0h ref_irq0_ctrl_o : %0h",zic_in.irq0_ctrl_o,mem[16'h1003][7:0]))

    if(mem[16'h1007][7:0]===zic_in.irq1_ctrl_o)
      `uvm_info("irq1_ctrl_o",$sformatf("rtl_irq1_ctrl_o: %0h ref_irq1_ctrl_o : %0h",zic_in.irq1_ctrl_o,mem[16'h1007][7:0]),UVM_HIGH)
    else
      `uvm_error("irq1_ctrl_o",$sformatf("rtl_irq1_ctrl_o : %0h ref_irq1_ctrl_o : %0h",zic_in.irq1_ctrl_o,mem[16'h1007][7:0]))

    if(mem[16'h100B][7:0]===zic_in.irq2_ctrl_o)
      `uvm_info("irq2_ctrl_o",$sformatf("rtl_irq2_ctrl_o: %0h ref_irq2_ctrl_o : %0h",zic_in.irq2_ctrl_o,mem[16'h100B][7:0]),UVM_HIGH)
    else
      `uvm_error("irq2_ctrl_o",$sformatf("rtl_irq2_ctrl_o : %0h ref_irq2_ctrl_o : %0h",zic_in.irq2_ctrl_o,mem[16'h100B][7:0]))

    if(mem[16'h100F][7:0]===zic_in.irq3_ctrl_o)
      `uvm_info("irq3_ctrl_o",$sformatf("rtl_irq3_ctrl_o: %0h ref_irq3_ctrl_o : %0h",zic_in.irq3_ctrl_o,mem[16'h100F][7:0]),UVM_HIGH)
    else
      `uvm_error("irq3_ctrl_o",$sformatf("rtl_irq3_ctrl_o : %0h ref_irq3_ctrl_o : %0h",zic_in.irq3_ctrl_o,mem[16'h100F][7:0]))

    if(mem[16'h1013][7:0]===zic_in.irq4_ctrl_o)
      `uvm_info("irq4_ctrl_o",$sformatf("rtl_irq4_ctrl_o: %0h ref_irq4_ctrl_o : %0h",zic_in.irq4_ctrl_o,mem[16'h1013][7:0]),UVM_HIGH)
    else
      `uvm_error("irq4_ctrl_o",$sformatf("rtl_irq4_ctrl_o : %0h ref_irq4_ctrl_o : %0h",zic_in.irq4_ctrl_o,mem[16'h1013][7:0]))

    if(mem[16'h1017][7:0]===zic_in.irq5_ctrl_o)
      `uvm_info("irq5_ctrl_o",$sformatf("rtl_irq5_ctrl_o: %0h ref_irq5_ctrl_o : %0h",zic_in.irq5_ctrl_o,mem[16'h1017][7:0]),UVM_HIGH)
    else
      `uvm_error("irq5_ctrl_o",$sformatf("rtl_irq5_ctrl_o : %0h ref_irq5_ctrl_o : %0h",zic_in.irq5_ctrl_o,mem[16'h1017][7:0]))

    if(mem[16'h101B][7:0]===zic_in.irq6_ctrl_o)
      `uvm_info("irq6_ctrl_o",$sformatf("rtl_irq6_ctrl_o: %0h ref_irq6_ctrl_o : %0h",zic_in.irq6_ctrl_o,mem[16'h101B][7:0]),UVM_HIGH)
    else
      `uvm_error("irq6_ctrl_o",$sformatf("rtl_irq6_ctrl_o : %0h ref_irq6_ctrl_o : %0h",zic_in.irq6_ctrl_o,mem[16'h101B][7:0]))

    if(mem[16'h101F][7:0]===zic_in.irq7_ctrl_o)
      `uvm_info("irq7_ctrl_o",$sformatf("rtl_irq7_ctrl_o: %0h ref_irq7_ctrl_o : %0h",zic_in.irq7_ctrl_o,mem[16'h101F][7:0]),UVM_HIGH)
    else
      `uvm_error("irq7_ctrl_o",$sformatf("rtl_irq7_ctrl_o : %0h ref_irq7_ctrl_o : %0h",zic_in.irq7_ctrl_o,mem[16'h101F][7:0]))

    if(mem[16'h1023][7:0]===zic_in.irq8_ctrl_o)
      `uvm_info("irq8_ctrl_o",$sformatf("rtl_irq8_ctrl_o: %0h ref_irq8_ctrl_o : %0h",zic_in.irq8_ctrl_o,mem[16'h1023][7:0]),UVM_HIGH)
    else
      `uvm_error("irq8_ctrl_o",$sformatf("rtl_irq8_ctrl_o : %0h ref_irq8_ctrl_o : %0h",zic_in.irq8_ctrl_o,mem[16'h1023][7:0]))

    if(mem[16'h1027][7:0]===zic_in.irq9_ctrl_o)
      `uvm_info("irq9_ctrl_o",$sformatf("rtl_irq9_ctrl_o: %0h ref_irq9_ctrl_o : %0h",zic_in.irq9_ctrl_o,mem[16'h1027][7:0]),UVM_HIGH)
    else
      `uvm_error("irq9_ctrl_o",$sformatf("rtl_irq9_ctrl_o : %0h ref_irq9_ctrl_o : %0h",zic_in.irq9_ctrl_o,mem[16'h1027][7:0]))

    if(mem[16'h102B][7:0]===zic_in.irq10_ctrl_o)
      `uvm_info("irq10_ctrl_o",$sformatf("rtl_irq10_ctrl_o: %0h ref_irq10_ctrl_o : %0h",zic_in.irq10_ctrl_o,mem[16'h102B][7:0]),UVM_HIGH)
    else
      `uvm_error("irq10_ctrl_o",$sformatf("rtl_irq10_ctrl_o : %0h ref_irq10_ctrl_o : %0h",zic_in.irq10_ctrl_o,mem[16'h102B][7:0]))

    if(mem[16'h102F][7:0]===zic_in.irq11_ctrl_o)
      `uvm_info("irq11_ctrl_o",$sformatf("rtl_irq11_ctrl_o: %0h ref_irq11_ctrl_o : %0h",zic_in.irq11_ctrl_o,mem[16'h102F][7:0]),UVM_HIGH)
    else
      `uvm_error("irq11_ctrl_o",$sformatf("rtl_irq11_ctrl_o : %0h ref_irq11_ctrl_o : %0h",zic_in.irq11_ctrl_o,mem[16'h102F][7:0]))

    if(mem[16'h1033][7:0]===zic_in.irq12_ctrl_o)
      `uvm_info("irq12_ctrl_o",$sformatf("rtl_irq12_ctrl_o: %0h ref_irq12_ctrl_o : %0h",zic_in.irq12_ctrl_o,mem[16'h1033][7:0]),UVM_HIGH)
    else
      `uvm_error("irq12_ctrl_o",$sformatf("rtl_irq12_ctrl_o : %0h ref_irq12_ctrl_o : %0h",zic_in.irq12_ctrl_o,mem[16'h1033][7:0]))

    if(mem[16'h1037][7:0]===zic_in.irq13_ctrl_o)
      `uvm_info("irq13_ctrl_o",$sformatf("rtl_irq13_ctrl_o: %0h ref_irq13_ctrl_o : %0h",zic_in.irq13_ctrl_o,mem[16'h1037][7:0]),UVM_HIGH)
    else
      `uvm_error("irq13_ctrl_o",$sformatf("rtl_irq13_ctrl_o : %0h ref_irq13_ctrl_o : %0h",zic_in.irq13_ctrl_o,mem[16'h1037][7:0]))

    if(mem[16'h103B][7:0]===zic_in.irq14_ctrl_o)
      `uvm_info("irq14_ctrl_o",$sformatf("rtl_irq14_ctrl_o: %0h ref_irq14_ctrl_o : %0h",zic_in.irq14_ctrl_o,mem[16'h103B][7:0]),UVM_HIGH)
    else
      `uvm_error("irq14_ctrl_o",$sformatf("rtl_irq14_ctrl_o : %0h ref_irq14_ctrl_o : %0h",zic_in.irq14_ctrl_o,mem[16'h103B][7:0]))

    if(mem[16'h103F][7:0]===zic_in.irq15_ctrl_o)
      `uvm_info("irq15_ctrl_o",$sformatf("rtl_irq15_ctrl_o: %0h ref_irq15_ctrl_o : %0h",zic_in.irq15_ctrl_o,mem[16'h103F][7:0]),UVM_HIGH)
    else
      `uvm_error("irq15_ctrl_o",$sformatf("rtl_irq15_ctrl_o : %0h ref_irq15_ctrl_o : %0h",zic_in.irq15_ctrl_o,mem[16'h103F][7:0]))

    if(mem[16'h1043][7:0]===zic_in.irq16_ctrl_o)
      `uvm_info("irq16_ctrl_o",$sformatf("rtl_irq16_ctrl_o: %0h ref_irq16_ctrl_o : %0h",zic_in.irq16_ctrl_o,mem[16'h1043][7:0]),UVM_HIGH)
    else
      `uvm_error("irq16_ctrl_o",$sformatf("rtl_irq16_ctrl_o : %0h ref_irq16_ctrl_o : %0h",zic_in.irq16_ctrl_o,mem[16'h1043][7:0]))

    if(mem[16'h1047][7:0]===zic_in.irq17_ctrl_o)
      `uvm_info("irq17_ctrl_o",$sformatf("rtl_irq17_ctrl_o: %0h ref_irq17_ctrl_o : %0h",zic_in.irq17_ctrl_o,mem[16'h1047][7:0]),UVM_HIGH)
    else
      `uvm_error("irq17_ctrl_o",$sformatf("rtl_irq17_ctrl_o : %0h ref_irq17_ctrl_o : %0h",zic_in.irq17_ctrl_o,mem[16'h1047][7:0]))

    if(mem[16'h104B][7:0]===zic_in.irq18_ctrl_o)
      `uvm_info("irq18_ctrl_o",$sformatf("rtl_irq18_ctrl_o: %0h ref_irq18_ctrl_o : %0h",zic_in.irq18_ctrl_o,mem[16'h104B][7:0]),UVM_HIGH)
    else
      `uvm_error("irq18_ctrl_o",$sformatf("rtl_irq18_ctrl_o : %0h ref_irq18_ctrl_o : %0h",zic_in.irq18_ctrl_o,mem[16'h104B][7:0]))

    if(mem[16'h104F][7:0]===zic_in.irq19_ctrl_o)
      `uvm_info("irq19_ctrl_o",$sformatf("rtl_irq19_ctrl_o: %0h ref_irq19_ctrl_o : %0h",zic_in.irq19_ctrl_o,mem[16'h104F][7:0]),UVM_HIGH)
    else
      `uvm_error("irq19_ctrl_o",$sformatf("rtl_irq19_ctrl_o : %0h ref_irq19_ctrl_o : %0h",zic_in.irq19_ctrl_o,mem[16'h104F][7:0]))

    if(mem[16'h1053][7:0]===zic_in.irq20_ctrl_o)
      `uvm_info("irq20_ctrl_o",$sformatf("rtl_irq20_ctrl_o: %0h ref_irq20_ctrl_o : %0h",zic_in.irq20_ctrl_o,mem[16'h1053][7:0]),UVM_HIGH)
    else
      `uvm_error("irq20_ctrl_o",$sformatf("rtl_irq20_ctrl_o : %0h ref_irq20_ctrl_o : %0h",zic_in.irq20_ctrl_o,mem[16'h1053][7:0]))

    if(mem[16'h1057][7:0]===zic_in.irq21_ctrl_o)
      `uvm_info("irq21_ctrl_o",$sformatf("rtl_irq21_ctrl_o: %0h ref_irq21_ctrl_o : %0h",zic_in.irq21_ctrl_o,mem[16'h1057][7:0]),UVM_HIGH)
    else
      `uvm_error("irq21_ctrl_o",$sformatf("rtl_irq21_ctrl_o : %0h ref_irq21_ctrl_o : %0h",zic_in.irq21_ctrl_o,mem[16'h1057][7:0]))

    if(mem[16'h105B][7:0]===zic_in.irq22_ctrl_o)
      `uvm_info("irq22_ctrl_o",$sformatf("rtl_irq22_ctrl_o: %0h ref_irq22_ctrl_o : %0h",zic_in.irq22_ctrl_o,mem[16'h105B][7:0]),UVM_HIGH)
    else
      `uvm_error("irq22_ctrl_o",$sformatf("rtl_irq22_ctrl_o : %0h ref_irq22_ctrl_o : %0h",zic_in.irq22_ctrl_o,mem[16'h105B][7:0]))

    if(mem[16'h105F][7:0]===zic_in.irq23_ctrl_o)
      `uvm_info("irq23_ctrl_o",$sformatf("rtl_irq23_ctrl_o: %0h ref_irq23_ctrl_o : %0h",zic_in.irq23_ctrl_o,mem[16'h105F][7:0]),UVM_HIGH)
    else
      `uvm_error("irq23_ctrl_o",$sformatf("rtl_irq23_ctrl_o : %0h ref_irq23_ctrl_o : %0h",zic_in.irq23_ctrl_o,mem[16'h105F][7:0]))

    if(mem[16'h1063][7:0]===zic_in.irq24_ctrl_o)
      `uvm_info("irq24_ctrl_o",$sformatf("rtl_irq24_ctrl_o: %0h ref_irq24_ctrl_o : %0h",zic_in.irq24_ctrl_o,mem[16'h1063][7:0]),UVM_HIGH)
    else
      `uvm_error("irq24_ctrl_o",$sformatf("rtl_irq24_ctrl_o : %0h ref_irq24_ctrl_o : %0h",zic_in.irq24_ctrl_o,mem[16'h1063][7:0]))

    if(mem[16'h1067][7:0]===zic_in.irq25_ctrl_o)
      `uvm_info("irq25_ctrl_o",$sformatf("rtl_irq25_ctrl_o: %0h ref_irq25_ctrl_o : %0h",zic_in.irq25_ctrl_o,mem[16'h1067][7:0]),UVM_HIGH)
    else
      `uvm_error("irq25_ctrl_o",$sformatf("rtl_irq25_ctrl_o : %0h ref_irq25_ctrl_o : %0h",zic_in.irq25_ctrl_o,mem[16'h1067][7:0]))

    if(mem[16'h106B][7:0]===zic_in.irq26_ctrl_o)
      `uvm_info("irq26_ctrl_o",$sformatf("rtl_irq26_ctrl_o: %0h ref_irq26_ctrl_o : %0h",zic_in.irq26_ctrl_o,mem[16'h106B][7:0]),UVM_HIGH)
    else
      `uvm_error("irq26_ctrl_o",$sformatf("rtl_irq26_ctrl_o : %0h ref_irq26_ctrl_o : %0h",zic_in.irq26_ctrl_o,mem[16'h106B][7:0]))

    if(mem[16'h106F][7:0]===zic_in.irq27_ctrl_o)
      `uvm_info("irq27_ctrl_o",$sformatf("rtl_irq27_ctrl_o: %0h ref_irq27_ctrl_o : %0h",zic_in.irq27_ctrl_o,mem[16'h106F][7:0]),UVM_HIGH)
    else
      `uvm_error("irq27_ctrl_o",$sformatf("rtl_irq27_ctrl_o : %0h ref_irq27_ctrl_o : %0h",zic_in.irq27_ctrl_o,mem[16'h106F][7:0]))

    if(mem[16'h1073][7:0]===zic_in.irq28_ctrl_o)
      `uvm_info("irq28_ctrl_o",$sformatf("rtl_irq28_ctrl_o: %0h ref_irq28_ctrl_o : %0h",zic_in.irq28_ctrl_o,mem[16'h1073][7:0]),UVM_HIGH)
    else
      `uvm_error("irq28_ctrl_o",$sformatf("rtl_irq28_ctrl_o : %0h ref_irq28_ctrl_o : %0h",zic_in.irq28_ctrl_o,mem[16'h1073][7:0]))

    if(mem[16'h1077][7:0]===zic_in.irq29_ctrl_o)
      `uvm_info("irq29_ctrl_o",$sformatf("rtl_irq29_ctrl_o: %0h ref_irq29_ctrl_o : %0h",zic_in.irq29_ctrl_o,mem[16'h1077][7:0]),UVM_HIGH)
    else
      `uvm_error("irq29_ctrl_o",$sformatf("rtl_irq29_ctrl_o : %0h ref_irq29_ctrl_o : %0h",zic_in.irq29_ctrl_o,mem[16'h1077][7:0]))

    if(mem[16'h107B][7:0]===zic_in.irq30_ctrl_o)
      `uvm_info("irq30_ctrl_o",$sformatf("rtl_irq30_ctrl_o : %0h ref_irq30_ctrl_o : %0h",zic_in.irq30_ctrl_o,mem[16'h107B][7:0]),UVM_HIGH)
    else
      `uvm_error("irq30_ctrl_o",$sformatf("rtl_irq30_ctrl_o : %0h ref_irq30_ctrl_o : %0h",zic_in.irq30_ctrl_o,mem[16'h107B][7:0]))

    if(mem[16'h107F][7:0]===zic_in.irq31_ctrl_o)
      `uvm_info("irq31_ctrl_o",$sformatf("rtl_irq31_ctrl_o : %0h ref_irq31_ctrl_o : %0h",zic_in.irq31_ctrl_o,mem[16'h107F][7:0]),UVM_HIGH)
    else
      `uvm_error("irq31_ctrl_o",$sformatf("rtl_irq31_ctrl_o : %0h ref_irq31_ctrl_o : %0h",zic_in.irq31_ctrl_o,mem[16'h107F][7:0]))

    if(mem[16'h1083][7:0]===zic_in.irq32_ctrl_o)
      `uvm_info("irq32_ctrl_o",$sformatf("rtl_irq32_ctrl_o : %0h ref_irq32_ctrl_o : %0h",zic_in.irq32_ctrl_o,mem[16'h1083][7:0]),UVM_HIGH)
    else
      `uvm_error("irq32_ctrl_o",$sformatf("rtl_irq32_ctrl_o : %0h ref_irq32_ctrl_o : %0h",zic_in.irq32_ctrl_o,mem[16'h1083][7:0]))

    if(mem[16'h1087][7:0]===zic_in.irq33_ctrl_o)
      `uvm_info("irq33_ctrl_o",$sformatf("rtl_irq33_ctrl_o : %0h ref_irq33_ctrl_o : %0h",zic_in.irq33_ctrl_o,mem[16'h1087][7:0]),UVM_HIGH)
    else
      `uvm_error("irq33_ctrl_o",$sformatf("rtl_irq33_ctrl_o : %0h ref_irq33_ctrl_o : %0h",zic_in.irq33_ctrl_o,mem[16'h1087][7:0]))

    if(mem[16'h108B][7:0]===zic_in.irq34_ctrl_o)
      `uvm_info("irq34_ctrl_o",$sformatf("rtl_irq34_ctrl_o : %0h ref_irq34_ctrl_o : %0h",zic_in.irq34_ctrl_o,mem[16'h108B][7:0]),UVM_HIGH)
    else
      `uvm_error("irq34_ctrl_o",$sformatf("rtl_irq34_ctrl_o : %0h ref_irq34_ctrl_o : %0h",zic_in.irq34_ctrl_o,mem[16'h108B][7:0]))

    if(mem[16'h108F][7:0]===zic_in.irq35_ctrl_o)
      `uvm_info("irq35_ctrl_o",$sformatf("rtl_irq35_ctrl_o : %0h ref_irq35_ctrl_o : %0h",zic_in.irq35_ctrl_o,mem[16'h108F][7:0]),UVM_HIGH)
    else
      `uvm_error("irq35_ctrl_o",$sformatf("rtl_irq35_ctrl_o : %0h ref_irq35_ctrl_o : %0h",zic_in.irq35_ctrl_o,mem[16'h108F][7:0]))

    if(mem[16'h1093][7:0]===zic_in.irq36_ctrl_o)
      `uvm_info("irq36_ctrl_o",$sformatf("rtl_irq36_ctrl_o : %0h ref_irq36_ctrl_o : %0h",zic_in.irq36_ctrl_o,mem[16'h1093][7:0]),UVM_HIGH)
    else
      `uvm_error("irq36_ctrl_o",$sformatf("rtl_irq36_ctrl_o : %0h ref_irq36_ctrl_o : %0h",zic_in.irq36_ctrl_o,mem[16'h1093][7:0]))

    if(mem[16'h1097][7:0]===zic_in.irq37_ctrl_o)
      `uvm_info("irq37_ctrl_o",$sformatf("rtl_irq37_ctrl_o : %0h ref_irq37_ctrl_o : %0h",zic_in.irq37_ctrl_o,mem[16'h1097][7:0]),UVM_HIGH)
    else
      `uvm_error("irq37_ctrl_o",$sformatf("rtl_irq37_ctrl_o : %0h ref_irq37_ctrl_o : %0h",zic_in.irq37_ctrl_o,mem[16'h1097][7:0]))

    if(mem[16'h109B][7:0]===zic_in.irq38_ctrl_o)
      `uvm_info("irq38_ctrl_o",$sformatf("rtl_irq38_ctrl_o : %0h ref_irq38_ctrl_o : %0h",zic_in.irq38_ctrl_o,mem[16'h109B][7:0]),UVM_HIGH)
    else
      `uvm_error("irq38_ctrl_o",$sformatf("rtl_irq38_ctrl_o : %0h ref_irq38_ctrl_o : %0h",zic_in.irq38_ctrl_o,mem[16'h109B][7:0]))

    if(mem[16'h109F][7:0]===zic_in.irq39_ctrl_o)
      `uvm_info("irq39_ctrl_o",$sformatf("rtl_irq39_ctrl_o : %0h ref_irq39_ctrl_o : %0h",zic_in.irq39_ctrl_o,mem[16'h109B][7:0]),UVM_HIGH)
    else
      `uvm_error("irq39_ctrl_o",$sformatf("rtl_irq39_ctrl_o : %0h ref_irq39_ctrl_o : %0h",zic_in.irq39_ctrl_o,mem[16'h109B][7:0]))

    if(mem[16'h10A3][7:0]===zic_in.irq40_ctrl_o)
      `uvm_info("irq40_ctrl_o",$sformatf("rtl_irq40_ctrl_o : %0h ref_irq40_ctrl_o : %0h",zic_in.irq40_ctrl_o,mem[16'h10A3][7:0]),UVM_HIGH)
    else
      `uvm_error("irq40_ctrl_o",$sformatf("rtl_irq40_ctrl_o : %0h ref_irq40_ctrl_o : %0h",zic_in.irq40_ctrl_o,mem[16'h10A3][7:0]))

    if(mem[16'h10A7][7:0]===zic_in.irq41_ctrl_o)
      `uvm_info("irq41_ctrl_o",$sformatf("rtl_irq41_ctrl_o : %0h ref_irq41_ctrl_o : %0h",zic_in.irq41_ctrl_o,mem[16'h10A7][7:0]),UVM_HIGH)
    else
      `uvm_error("irq41_ctrl_o",$sformatf("rtl_irq41_ctrl_o : %0h ref_irq41_ctrl_o : %0h",zic_in.irq41_ctrl_o,mem[16'h10A7][7:0]))

    if(mem[16'h10AB][7:0]===zic_in.irq42_ctrl_o)
      `uvm_info("irq42_ctrl_o",$sformatf("rtl_irq42_ctrl_o : %0h ref_irq42_ctrl_o : %0h",zic_in.irq42_ctrl_o,mem[16'h10AB][7:0]),UVM_HIGH)
    else
      `uvm_error("irq42_ctrl_o",$sformatf("rtl_irq42_ctrl_o : %0h ref_irq42_ctrl_o : %0h",zic_in.irq42_ctrl_o,mem[16'h10AB][7:0]))

    if(mem[16'h10AF][7:0]===zic_in.irq43_ctrl_o)
      `uvm_info("irq43_ctrl_o",$sformatf("rtl_irq43_ctrl_o : %0h ref_irq43_ctrl_o : %0h",zic_in.irq43_ctrl_o,mem[16'h10AF][7:0]),UVM_HIGH)
    else
      `uvm_error("irq43_ctrl_o",$sformatf("rtl_irq43_ctrl_o : %0h ref_irq43_ctrl_o : %0h",zic_in.irq43_ctrl_o,mem[16'h10AF][7:0]))

    if(mem[16'h10B3][7:0]===zic_in.irq44_ctrl_o)
      `uvm_info("irq44_ctrl_o",$sformatf("rtl_irq44_ctrl_o : %0h ref_irq44_ctrl_o : %0h",zic_in.irq44_ctrl_o,mem[16'h10B3][7:0]),UVM_HIGH)
    else
      `uvm_error("irq44_ctrl_o",$sformatf("rtl_irq44_ctrl_o : %0h ref_irq44_ctrl_o : %0h",zic_in.irq44_ctrl_o,mem[16'h10B3][7:0]))

    if(mem[16'h10B7][7:0]===zic_in.irq45_ctrl_o)
      `uvm_info("irq45_ctrl_o",$sformatf("rtl_irq45_ctrl_o : %0h ref_irq45_ctrl_o : %0h",zic_in.irq45_ctrl_o,mem[16'h10B7][7:0]),UVM_HIGH)
    else
      `uvm_error("irq45_ctrl_o",$sformatf("rtl_irq45_ctrl_o : %0h ref_irq45_ctrl_o : %0h",zic_in.irq45_ctrl_o,mem[16'h10B7][7:0]))

    if(mem[16'h10BB][7:0]===zic_in.irq46_ctrl_o)
      `uvm_info("irq46_ctrl_o",$sformatf("rtl_irq46_ctrl_o : %0h ref_irq46_ctrl_o : %0h",zic_in.irq46_ctrl_o,mem[16'h10BB][7:0]),UVM_HIGH)
    else
      `uvm_error("irq46_ctrl_o",$sformatf("rtl_irq46_ctrl_o : %0h ref_irq46_ctrl_o : %0h",zic_in.irq46_ctrl_o,mem[16'h10BB][7:0]))

    if(mem[16'h10BF][7:0]===zic_in.irq47_ctrl_o)
      `uvm_info("irq47_ctrl_o",$sformatf("rtl_irq47_ctrl_o : %0h ref_irq47_ctrl_o : %0h",zic_in.irq47_ctrl_o,mem[16'h10BF][7:0]),UVM_HIGH)
    else
      `uvm_error("irq47_ctrl_o",$sformatf("rtl_irq47_ctrl_o : %0h ref_irq47_ctrl_o : %0h",zic_in.irq47_ctrl_o,mem[16'h10BF][7:0]))
   
   endfunction : zic_irq_ctl_reg
 
//-----------zic_int_en[i]-------------//
  function void zic_int_en_reg(zic_mem_seq_item zic_in);
          
    logic zic_write_flag=0;
    logic zic_read_flag=0;
    int write_count;
    int read_count;

  foreach(zic_int_en_address[i])
    begin

      //read
      if(zic_in.zic_mmr_read_addr_i==zic_int_en_address[i])
      begin
        zic_read_flag=1'b1;
        read_count=i;
      end

      if(zic_read_flag && zic_in.zic_mmr_read_en_i)
      begin
        if(mem[zic_in.zic_mmr_read_addr_i][0]===zic_in.zic_mmr_read_data_o)
          `uvm_info("zic_int_en_read",$sformatf("r_count:%0d,rtl_zic_int_en_read_reg : %0h ref_zic_int_en_read_reg : %0h",read_count,zic_in.zic_mmr_read_data_o,mem[zic_in.zic_mmr_read_addr_i][0]), UVM_MEDIUM)
        else
          `uvm_error("zic_int_en_read",$sformatf("r_count:%0d,rtl_zic_int_en_read_reg:%0h ref_zic_int_en_read_reg : %0h",read_count,zic_in.zic_mmr_read_data_o,mem[zic_in.zic_mmr_read_addr_i][0]))
      end
      zic_read_flag=0;
    end
     
    //global_int_enable_valid_i
    if(zic_in.global_int_enable_valid_i)
    begin
          mem[16'h1001][0]=zic_in.global_int_enable_bit_i[0];
          mem[16'h1005][0]=zic_in.global_int_enable_bit_i[1];
          mem[16'h1009][0]=zic_in.global_int_enable_bit_i[2];
          mem[16'h100D][0]=zic_in.global_int_enable_bit_i[3];
          mem[16'h1011][0]=zic_in.global_int_enable_bit_i[4];
          mem[16'h1015][0]=zic_in.global_int_enable_bit_i[5];
          mem[16'h1019][0]=zic_in.global_int_enable_bit_i[6];
          mem[16'h101D][0]=zic_in.global_int_enable_bit_i[7];
          mem[16'h1021][0]=zic_in.global_int_enable_bit_i[8];
          mem[16'h1025][0]=zic_in.global_int_enable_bit_i[9];
          mem[16'h1029][0]=zic_in.global_int_enable_bit_i[10];
          mem[16'h102D][0]=zic_in.global_int_enable_bit_i[11];
          mem[16'h1031][0]=zic_in.global_int_enable_bit_i[12];
          mem[16'h1035][0]=zic_in.global_int_enable_bit_i[13];
          mem[16'h1039][0]=zic_in.global_int_enable_bit_i[14];
          mem[16'h103D][0]=zic_in.global_int_enable_bit_i[15];
          mem[16'h1041][0]=zic_in.global_int_enable_bit_i[16];
          mem[16'h1045][0]=zic_in.global_int_enable_bit_i[17];
          mem[16'h1049][0]=zic_in.global_int_enable_bit_i[18];
          mem[16'h104D][0]=zic_in.global_int_enable_bit_i[19];
          mem[16'h1051][0]=zic_in.global_int_enable_bit_i[20];
          mem[16'h1055][0]=zic_in.global_int_enable_bit_i[21];
          mem[16'h1059][0]=zic_in.global_int_enable_bit_i[22];
          mem[16'h105D][0]=zic_in.global_int_enable_bit_i[23];
          mem[16'h1061][0]=zic_in.global_int_enable_bit_i[24];
          mem[16'h1065][0]=zic_in.global_int_enable_bit_i[25];
          mem[16'h1069][0]=zic_in.global_int_enable_bit_i[26];
          mem[16'h106D][0]=zic_in.global_int_enable_bit_i[27];
          mem[16'h1071][0]=zic_in.global_int_enable_bit_i[28];
          mem[16'h1075][0]=zic_in.global_int_enable_bit_i[29];
          mem[16'h1079][0]=zic_in.global_int_enable_bit_i[30];
          mem[16'h107D][0]=zic_in.global_int_enable_bit_i[31];
          mem[16'h1081][0]=zic_in.global_int_enable_bit_i[32];
          mem[16'h1085][0]=zic_in.global_int_enable_bit_i[33];
          mem[16'h1089][0]=zic_in.global_int_enable_bit_i[34];
          mem[16'h108D][0]=zic_in.global_int_enable_bit_i[35];
          mem[16'h1091][0]=zic_in.global_int_enable_bit_i[36];
          mem[16'h1095][0]=zic_in.global_int_enable_bit_i[37];
          mem[16'h1099][0]=zic_in.global_int_enable_bit_i[38];
          mem[16'h109D][0]=zic_in.global_int_enable_bit_i[39];
          mem[16'h10A1][0]=zic_in.global_int_enable_bit_i[40];
          mem[16'h10A5][0]=zic_in.global_int_enable_bit_i[41];
          mem[16'h10A9][0]=zic_in.global_int_enable_bit_i[42];
          mem[16'h10AD][0]=zic_in.global_int_enable_bit_i[43];
          mem[16'h10B1][0]=zic_in.global_int_enable_bit_i[44];
          mem[16'h10B5][0]=zic_in.global_int_enable_bit_i[45];
          mem[16'h10B9][0]=zic_in.global_int_enable_bit_i[46];
          mem[16'h10BD][0]=zic_in.global_int_enable_bit_i[47];
    end
 //write

     
  foreach(zic_int_en_address[i])
    begin
      if(zic_in.zic_mmr_write_addr_i==zic_int_en_address[i])
      begin
        zic_write_flag=1'b1;
        write_count=i;
      end
      
      if(zic_write_flag && zic_in.zic_mmr_write_en_i)
      begin
        mem[zic_in.zic_mmr_write_addr_i][0]=zic_in.zic_mmr_write_data_i[0];

        `uvm_info("zic_int_en_write",$sformatf("WRITE OPERATION count:%0d,ref_zic_int_en:%0h, ",write_count,mem[zic_in.zic_mmr_write_addr_i][0]), UVM_MEDIUM)
      end
      zic_write_flag=0;

    end 

  endfunction

 //-----------zic_int_p[i]-------------//
  function void zic_int_p_reg(zic_mem_seq_item zic_in);
         
    logic zic_write_flag=0;
    logic zic_read_flag=0;
    int write_count;
    int read_count;

 foreach(zic_int_p_address[i])
    begin

      //read
      if(zic_in.zic_mmr_read_addr_i==zic_int_p_address[i])
      begin
        zic_read_flag=1'b1;
        read_count=i;
      end

      if(zic_read_flag && zic_in.zic_mmr_read_en_i)
      begin
        if(mem[zic_in.zic_mmr_read_addr_i][0]===zic_in.zic_mmr_read_data_o)
          `uvm_info("zic_int_p_read",$sformatf("count: %0d, rtl_zic_int_p_read_reg: %0h, ref_zic_int_p_read_reg : %0h",read_count,zic_in.zic_mmr_read_data_o,mem[zic_in.zic_mmr_read_addr_i][0]), UVM_MEDIUM)
	    else
	      `uvm_error("zic_int_p_read",$sformatf("count: %0d, rtl_zic_int_p_read_reg: %0h ref_zic_int_p_read_reg : %0h",read_count,zic_in.zic_mmr_read_data_o,mem[zic_in.zic_mmr_read_addr_i][0]))
      end
      zic_read_flag=0;
   end
//zic_int_pending_valid_i
    if(zic_in.zic_int_pending_valid_i)
    begin
      `uvm_info("zic_int_pending_valid_i",$sformatf("PENDING_VALID_I OPERATION : %0h, ",zic_in.zic_int_pending_bit_i), UVM_MEDIUM)
          
          mem[16'h1000][0]=zic_in.zic_int_pending_bit_i[0];
          mem[16'h1004][0]=zic_in.zic_int_pending_bit_i[1];
          mem[16'h1008][0]=zic_in.zic_int_pending_bit_i[2];
          mem[16'h100C][0]=zic_in.zic_int_pending_bit_i[3];
          mem[16'h1010][0]=zic_in.zic_int_pending_bit_i[4];
          mem[16'h1014][0]=zic_in.zic_int_pending_bit_i[5];
          mem[16'h1018][0]=zic_in.zic_int_pending_bit_i[6];
          mem[16'h101C][0]=zic_in.zic_int_pending_bit_i[7];
          mem[16'h1020][0]=zic_in.zic_int_pending_bit_i[8];
          mem[16'h1024][0]=zic_in.zic_int_pending_bit_i[9];
          mem[16'h1028][0]=zic_in.zic_int_pending_bit_i[10];
          mem[16'h102C][0]=zic_in.zic_int_pending_bit_i[11];
          mem[16'h1030][0]=zic_in.zic_int_pending_bit_i[12];
          mem[16'h1034][0]=zic_in.zic_int_pending_bit_i[13];
          mem[16'h1038][0]=zic_in.zic_int_pending_bit_i[14];
          mem[16'h103C][0]=zic_in.zic_int_pending_bit_i[15];
          mem[16'h1040][0]=zic_in.zic_int_pending_bit_i[16];
          mem[16'h1044][0]=zic_in.zic_int_pending_bit_i[17];
          mem[16'h1048][0]=zic_in.zic_int_pending_bit_i[18];
          mem[16'h104C][0]=zic_in.zic_int_pending_bit_i[19];
          mem[16'h1050][0]=zic_in.zic_int_pending_bit_i[20];
          mem[16'h1054][0]=zic_in.zic_int_pending_bit_i[21];
          mem[16'h1058][0]=zic_in.zic_int_pending_bit_i[22];
          mem[16'h105C][0]=zic_in.zic_int_pending_bit_i[23];
          mem[16'h1060][0]=zic_in.zic_int_pending_bit_i[24];
          mem[16'h1064][0]=zic_in.zic_int_pending_bit_i[25];
          mem[16'h1068][0]=zic_in.zic_int_pending_bit_i[26];
          mem[16'h106C][0]=zic_in.zic_int_pending_bit_i[27];
          mem[16'h1070][0]=zic_in.zic_int_pending_bit_i[28];
          mem[16'h1074][0]=zic_in.zic_int_pending_bit_i[29];
          mem[16'h1078][0]=zic_in.zic_int_pending_bit_i[30];
          mem[16'h107C][0]=zic_in.zic_int_pending_bit_i[31];
          mem[16'h1080][0]=zic_in.zic_int_pending_bit_i[32];
          mem[16'h1084][0]=zic_in.zic_int_pending_bit_i[33];
          mem[16'h1088][0]=zic_in.zic_int_pending_bit_i[34];
          mem[16'h108C][0]=zic_in.zic_int_pending_bit_i[35];
          mem[16'h1090][0]=zic_in.zic_int_pending_bit_i[36];
          mem[16'h1094][0]=zic_in.zic_int_pending_bit_i[37];
          mem[16'h1098][0]=zic_in.zic_int_pending_bit_i[38];
          mem[16'h109C][0]=zic_in.zic_int_pending_bit_i[39];
          mem[16'h10A0][0]=zic_in.zic_int_pending_bit_i[40];
          mem[16'h10A4][0]=zic_in.zic_int_pending_bit_i[41];
          mem[16'h10A8][0]=zic_in.zic_int_pending_bit_i[42];
          mem[16'h10AC][0]=zic_in.zic_int_pending_bit_i[43];
          mem[16'h10B0][0]=zic_in.zic_int_pending_bit_i[44];
          mem[16'h10B4][0]=zic_in.zic_int_pending_bit_i[45];
          mem[16'h10B8][0]=zic_in.zic_int_pending_bit_i[46];
          mem[16'h10BC][0]=zic_in.zic_int_pending_bit_i[47];
   end


      //write
 foreach(zic_int_p_address[i])
    begin
      if(zic_in.zic_mmr_write_addr_i==zic_int_p_address[i])
      begin
        zic_write_flag=1'b1;
        write_count=i;
      end

      if(zic_write_flag && zic_in.zic_mmr_write_en_i)
      begin
        mem[zic_in.zic_mmr_write_addr_i][0] = zic_in.zic_mmr_write_data_i[0];
        `uvm_info("zic_int_p_write",$sformatf("WRITE OPERATION count: %0d, ref_zic_int_p: %0h, ",write_count,mem[zic_in.zic_mmr_write_addr_i][0]), UVM_MEDIUM)
      end
     
      zic_write_flag=0;
    end

   endfunction


 //-----------zic_attr[i]-------------//
  function void zic_attr_reg(zic_mem_seq_item zic_in);
          
    logic zic_flag=0;
    int count;

    foreach(zic_int_attr_address[i])
    begin
      if(zic_in.zic_mmr_read_addr_i==zic_int_attr_address[i])
 	  begin
        zic_flag=1'b1;
        count=i;
      end

      //read
      if(zic_flag && zic_in.zic_mmr_read_en_i)
      begin
        if(mem[zic_in.zic_mmr_read_addr_i][7:0]===zic_in.zic_mmr_read_data_o)
        begin
          `uvm_info("zic_attr_reg",$sformatf("count: %0d, rtl_zic_attr_read_reg: %0h, ref_zic_attr_read_reg : %0h",count,zic_in.zic_mmr_read_data_o,mem[zic_in.zic_mmr_read_addr_i][7:0]), UVM_MEDIUM)
		end
	    else
	    begin
	      `uvm_error("zic_attr_reg",$sformatf("count: %0d, rtl_zic_attr_read_reg: %0h ref_zic_attr_read_reg : %0h",count,zic_in.zic_mmr_read_data_o,mem[zic_in.zic_mmr_read_addr_i][7:0]))
        end
      end
      zic_flag=0;
    end
  endfunction

 //-----------zic_ctl[i]-------------//
  task zic_ctl_reg(zic_mem_seq_item zic_in);
    
    logic write_flag=0;
    logic read_flag=0;
    int w_count;
    int r_count;

       foreach(zic_ctl_address[i])
    begin

      //read
      if(zic_in.zic_mmr_read_addr_i==zic_ctl_address[i])
      begin
        read_flag=1'b1;
        r_count=i;
      end

      if(read_flag && zic_in.zic_mmr_read_en_i)
      begin
        if(mem[zic_in.zic_mmr_read_addr_i][7:0]===zic_in.zic_mmr_read_data_o)
          `uvm_info("zic_ctl_reg read",$sformatf("r_count: %0d, rtl_zic_ctl_read_reg: %0h, ref_zic_ctl_read_reg : %0h",r_count,zic_in.zic_mmr_read_data_o,mem[zic_in.zic_mmr_read_addr_i][7:0]), UVM_MEDIUM)
        else
          `uvm_error("zic_ctl_reg read",$sformatf("r_count: %0d, rtl_zic_ctl_read_reg: %0h ref_zic_ctl_read_reg : %0h",r_count,zic_in.zic_mmr_read_data_o,mem[zic_in.zic_mmr_read_addr_i][7:0]))
      end
      read_flag=0;
  end


      //write 
      foreach(zic_ctl_address[i])
    begin
      if(zic_in.zic_mmr_write_addr_i==zic_ctl_address[i])
      begin
        write_flag=1'b1;
        w_count=i;
      end
     
      if(write_flag && zic_in.zic_mmr_write_en_i)
      begin
        mem[zic_in.zic_mmr_write_addr_i] = zic_in.zic_mmr_write_data_i;

        `uvm_info("zic_ctl_reg write ",$sformatf("WRITE OPERATION w_count: %0d, ref_zic_ctl: %0h, ",w_count,mem[zic_in.zic_mmr_write_addr_i]), UVM_MEDIUM)
      end
      write_flag=0;
    end
  endtask 
//------------zic_config_reg-------------//

	function void zic_config_reg(zic_mem_seq_item zic_in);
     //read
	  if(zic_in.zic_mmr_read_addr_i==16'h0000 && zic_in.zic_mmr_read_en_i)
	  begin
        if(mem[16'h0000]===zic_in.zic_mmr_read_data_o)
          `uvm_info("zic_config_reg",$sformatf("rtl_zic_config_register:%0h ref_zic_config_register:   %0h",zic_in.zic_mmr_read_data_o,mem[16'h0000]), UVM_MEDIUM)
        else
          `uvm_error("zic_config_reg",$sformatf("rtl_zic_config_register: %0h ref_zic_config_register : %0h",zic_in.zic_mmr_read_data_o,mem[16'h0000]))
      end
    endfunction:zic_config_reg

//------------zic_info_reg-------------//

	function void zic_info_reg(zic_mem_seq_item zic_in);

      //read
	  if(zic_in.zic_mmr_read_addr_i==16'h0004 && zic_in.zic_mmr_read_en_i)
	  begin
        if(mem[16'h0004]===zic_in.zic_mmr_read_data_o)
          `uvm_info("zic_info_reg",$sformatf("rtl_zic_info_register:%0h ref_zic_info_register:   %0h",zic_in.zic_mmr_read_data_o,mem[16'h0004]), UVM_MEDIUM)
        else
          `uvm_error("zic_info_reg",$sformatf("rtl_zic_info_register:%0h ref_zic_info_register : %0h",zic_in.zic_mmr_read_data_o,mem[16'h0004]))
      end
    endfunction : zic_info_reg

    //------------zic_ack_reg-------------//

	function void zic_ack_reg(zic_mem_seq_item zic_in);

     //read
      if(zic_in.zic_mmr_read_addr_i==16'h0804 && zic_in.zic_mmr_read_en_i)
	  begin
        if(mem[16'h0804]===zic_in.zic_mmr_read_data_o)
          `uvm_info("zic_ack_reg",$sformatf("rtl_zic_ack_read_o: %0h ref_zic_ack_read_o: %0h",zic_in.zic_mmr_read_data_o,mem[16'h0804]), UVM_MEDIUM)
        else
          `uvm_error("zic_ack_reg",$sformatf("rtl_zic_ack_read_o: %0h ref_zic_ack_read_o : %0h",zic_in.zic_mmr_read_data_o,mem[16'h0804]))
      end

      //zic_ack_o
      if( zic_in.zic_ack_read_valid_en===zic_in.zic_ack_o)
          `uvm_info("zic_ack_o",$sformatf("rtl_zic_ack_o: %0h rtl_zic_ack_read_valid_en: %0h",zic_in.zic_ack_o,zic_in.zic_ack_read_valid_en), UVM_MEDIUM)
        else
          `uvm_error("zic_ack_o",$sformatf("rtl_zic_ack_o: %0h rtl_zic_ack_read_valid_en : %0h",zic_in.zic_ack_o,zic_in.zic_ack_read_valid_en))  
          

      //zic_ack_read_valid_en
	  if(zic_in.zic_ack_read_valid_en)
	  begin
        if(mem[16'h0804]===zic_in.zic_ack_int_id_o)
          `uvm_info("zic_ack_int_id_o",$sformatf("rtl_zic_ack_int_id_o: %0h ref_zic_ack_int_id_o: %0h",zic_in.zic_ack_int_id_o,mem[16'h0804]), UVM_MEDIUM)
        else
          `uvm_error("zic_ack_int_id_o",$sformatf("rtl_zic_ack_int_id_o : %0h ref_zic_ack_int_id_o : %0h",zic_in.zic_ack_int_id_o,mem[16'h0804]))  
      end

      //zic_ack_write_valid_i
       if(zic_in.zic_ack_write_valid_i)
      begin
        mem[16'h0804] = zic_in.zic_ack_int_id_i;
      end

    endfunction:zic_ack_reg

    //------------zic_eoi_reg-------------//

	function void zic_eoi_reg(zic_mem_seq_item zic_in);

      //read
	  if(zic_in.zic_mmr_read_addr_i==16'h0808 && zic_in.zic_mmr_read_en_i)
	  begin
        if(mem[16'h0808]===zic_in.zic_mmr_read_data_o)
          `uvm_info("zic_eoi_read",$sformatf("rtl_zic_eoi_read_o: %0h, ref_zic_eoi_read_o :%0h",zic_in.zic_mmr_read_data_o,mem[16'h0808]), UVM_MEDIUM)
        else
          `uvm_error("zic_eoi_read",$sformatf("rtl_zic_eoi_read_o:%0h ref_zic_eoi_read_o : %0h",zic_in.zic_mmr_read_data_o,mem[16'h0808]))
      end

      //zic_eoi_o
      if(zic_in.zic_eoi_valid_i===zic_in.zic_eoi_o)
          `uvm_info("zic_eoi_o",$sformatf("rtl_zic_eoi_o: %0h rtl_zic_eoi_valid_i: %0h",zic_in.zic_eoi_o,zic_in.zic_eoi_valid_i), UVM_MEDIUM)
        else
          `uvm_error("zic_eoi_o",$sformatf("rtl_zic_eoi_o: %0h rtl_zic_eoi_valid_i : %0h",zic_in.zic_eoi_o,zic_in.zic_eoi_valid_i))  
          

      //zic_eoi_valid_i
      if(zic_in.zic_eoi_valid_i)
      begin
        mem[16'h0808] = zic_in.zic_eoi_id_i;
      end

    endfunction:zic_eoi_reg

    //------------zic_nxtp_reg-------------//

	function void zic_nxtp_reg(zic_mem_seq_item zic_in);

      //read
	  if(zic_in.zic_mmr_read_addr_i==16'h0800 && zic_in.zic_mmr_read_en_i)
	  begin
        if(mem[16'h0800]===zic_in.zic_mmr_read_data_o)
        begin
          `uvm_info("zic_nxtp_int_read",$sformatf("rtl_zic_nxtp_int_read: %0h, ref_zic_nxtp_int_read: %0h",zic_in.zic_mmr_read_data_o,mem[16'h0800]), UVM_MEDIUM)
        end
        else
        begin
          `uvm_error("zic_nxtp_int_read",$sformatf("rtl_zic_nxtp_int_read:%0h ref_zic_nxtp_int_read : %0h",zic_in.zic_mmr_read_data_o,mem[16'h0800]))
        end
      end

      //zic_nxtp_valid_i
      if(zic_in.zic_nxtp_valid_i)
      begin
        mem[16'h0800] = zic_in.zic_nxtp_id_i;
      end

    endfunction:zic_nxtp_reg
  
endclass
