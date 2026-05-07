class zic_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(zic_scoreboard)

  uvm_analysis_imp#(zic_seq_item,zic_scoreboard) analysis_imp_scb;

  virtual zic_intf zic_vif;

  logic[15:0]zic_ctl_address[$]={16'h1003,16'h1007,16'h100B,16'h100F,16'h1013,16'h1017,16'h101B,16'h101F,16'h1023,16'h1027,16'h102B,16'h102F,16'h1033,16'h1037,16'h103B,16'h103F,16'h1043,16'h1047,16'h104B,16'h104F,16'h1053,16'h1057,16'h105B,16'h105F,16'h1063,16'h1067,16'h106B,16'h106F,16'h1073,16'h1077,16'h107B,16'h107F,16'h1083,16'h1087,16'h108B,16'h108F,16'h1093,16'h1097,16'h109B,16'h109F,16'h10A3,16'h10A7,16'h10AB,16'h10AF,16'h10B3,16'h10B7,16'h10BB,16'h10BF};
 
  

  logic [7:0] config_mem [int];

  logic [7:0] enable_mem [int];

  logic [7:0] sorted_value[$];

  logic [7:0] store_value [$];

  logic [7:0]  h_v ;

  logic [7:0] current_level;

  logic [7:0] eoi_id;

  logic [47:0] pending_bit;

  logic [47:0] check_pending = 0;

  int location ;

  int id;

  int x;

  int y;
  
  logic [47:0] id_bits = '1;

  zic_seq_item zic_sampled_data_item;


  zic_seq_item sampled_data[$];

 function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

 function void build_phase(uvm_phase phase);
   super.build_phase(phase);

   analysis_imp_scb = new("analysis_imp_scb", this);

   if(!uvm_config_db#(virtual zic_intf)::get(this,"","vif",zic_vif))        
      `uvm_error("Scoreboard","No resource found")

  endfunction

  function void reset_values();

   config_mem[16'h1003]=8'hff;//zic_int_ctl[0]
   config_mem[16'h1007]=8'hfb;//zic_int_ctl[1]
   config_mem[16'h100B]=8'hf7;//zic_int_ctl[2]
   config_mem[16'h100F]=8'hf3;//zic_int_ctl[3]
   config_mem[16'h1013]=8'hef;//zic_int_ctl[4]
   config_mem[16'h1017]=8'heb;//zic_int_ctl[5]
   config_mem[16'h101B]=8'he7;//zic_int_ctl[6]
   config_mem[16'h101F]=8'hdf;//zic_int_ctl[7]
   config_mem[16'h1023]=8'hdb;//zic_int_ctl[8]
   config_mem[16'h1027]=8'hd7;//zic_int_ctl[9]
   config_mem[16'h102B]=8'hd3;//zic_int_ctl[10]
   config_mem[16'h102F]=8'hcf;//zic_int_ctl[11]
   config_mem[16'h1033]=8'hcb;//zic_int_ctl[12]
   config_mem[16'h1037]=8'hc7;//zic_int_ctl[13]
   config_mem[16'h103B]=8'hbf;//zic_int_ctl[14]
   config_mem[16'h103F]=8'hbb;//zic_int_ctl[15]
   config_mem[16'h1043]=8'hb7;//zic_int_ctl[16]
   config_mem[16'h1047]=8'hb3;//zic_int_ctl[17]
   config_mem[16'h104B]=8'haf;//zic_int_ctl[18]
   config_mem[16'h104F]=8'hab;//zic_int_ctl[19]
   config_mem[16'h1053]=8'h9f;//zic_int_ctl[20]
   config_mem[16'h1057]=8'h9b;//zic_int_ctl[21]
   config_mem[16'h105B]=8'h97;//zic_int_ctl[22]
   config_mem[16'h105F]=8'h93;//zic_int_ctl[23]
   config_mem[16'h1063]=8'h8f;//zic_int_ctl[24]
   config_mem[16'h1067]=8'h8b;//zic_int_ctl[25]
   config_mem[16'h106B]=8'h87;//zic_int_ctl[26]
   config_mem[16'h106F]=8'h7f;//zic_int_ctl[27]
   config_mem[16'h1073]=8'h7b;//zic_int_ctl[28]
   config_mem[16'h1077]=8'h77;//zic_int_ctl[29]
   config_mem[16'h107B]=8'h73;//zic_int_ctl[30]
   config_mem[16'h107F]=8'h6f;//zic_int_ctl[31]
   config_mem[16'h1083]=8'h6b;//zic_int_ctl[32]
   config_mem[16'h1087]=8'h67;//zic_int_ctl[33]
   config_mem[16'h108B]=8'h5f;//zic_int_ctl[34]
   config_mem[16'h108F]=8'h5b;//zic_int_ctl[35]
   config_mem[16'h1093]=8'h57;//zic_int_ctl[36]
   config_mem[16'h1097]=8'h53;//zic_int_ctl[37]
   config_mem[16'h109B]=8'h4f;//zic_int_ctl[38]
   config_mem[16'h109F]=8'h4b;//zic_int_ctl[39]
   config_mem[16'h10A3]=8'h47;//zic_int_ctl[40]
   config_mem[16'h10A7]=8'h3f;//zic_int_ctl[41]
   config_mem[16'h10AB]=8'h3b;//zic_int_ctl[42]
   config_mem[16'h10AF]=8'h37;//zic_int_ctl[43]
   config_mem[16'h10B3]=8'h33;//zic_int_ctl[44]
   config_mem[16'h10B7]=8'h2f;//zic_int_ctl[45]
   config_mem[16'h10BB]=8'h2b;//zic_int_ctl[46]
   config_mem[16'h10BF]=8'h27;//zic_int_ctl[47]

  endfunction

//reset_phase
  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
      reset_values();
    phase.drop_objection(this);
  endtask:reset_phase

//write method
  function void write(zic_seq_item zic_sampled_data_item);
      
      sampled_data.push_back(zic_sampled_data_item);
	
  endfunction

//run_phase 
  task run_phase(uvm_phase phase);
    forever
    begin
      ////----////
      zic_seq_item zic_item;
      wait(sampled_data.size()>0);
      zic_item=sampled_data.pop_front();

      ////--EOI--//
      if(zic_item.zic_eoi_valid_i)
      begin
        eoi_id = zic_item.zic_eoi_id_i;
      end
      
      ////--ACK ENABLE--//
      if(check_pending != zic_vif.int_pending_bits)
      begin
        x =1;
        y = 1;
      end

      check_pending = zic_vif.int_pending_bits;

      if(y>=1)
      begin
        y = y+1;
      end

      if(zic_item.zic_ack_read_valid_en == 1 && y >=2)
      begin
        ack_id(zic_item);
      end
      current_level = zic_item.active_lvl_pr_i;
      
      ////--CONFIG REG--////
      if(zic_item.zic_mmr_write_en_i || zic_item.zic_mmr_read_en_i)
      begin    
        config_reg(zic_item);
      end

      ////----////
      if(zic_item.global_int_enable_valid_i)
      begin
        pending_bits(zic_item);
        enable_compare(zic_item);
      end

      if(x>=1)
      begin
        x = x+ 1;
      end

      if(zic_vif.int_pending_bits!= 0 && x == 3)
      begin
        int_req(zic_item);
        x = 0;
      end

    end
 
  endtask

  function void extract_phase(uvm_phase phase);
  super.extract_phase(phase);
      $display("conig_mem size = %0d",config_mem.size());
      $display("enable_mem size = %0d",enable_mem.size());
      $display("**********Configured values**********");
      foreach(config_mem[key]) begin
      $display("\tconfig_mem[%0h] \t = %0d",key,config_mem[key]);
      end
      $display("**********Enabled interrupts**********");
      foreach(enable_mem[key]) begin
      $display("\tenable_mem[%0h] \t = %0d",key,enable_mem[key]);
      end
      $display("Highest level priority = %0d location = %0h",h_v,location);
      $display("Interrupt ID = %0d",id);
  endfunction


 function void config_reg(zic_seq_item zic_item);
        
    logic zic_flag=0;
    int count;

              
    foreach(zic_ctl_address[i])
    begin
      if(zic_item.zic_mmr_write_addr_i==zic_ctl_address[i])
      begin
        zic_flag=1'b1;
        count=i;
      end
      if(zic_flag && zic_item.zic_mmr_write_en_i)
      begin
        `uvm_info(" Level and Priority",$sformatf("Configuring level and priority  "), UVM_MEDIUM)

        config_mem[zic_item.zic_mmr_write_addr_i]=zic_item.zic_mmr_write_data_i;
        `uvm_info("Level and Priority",$sformatf("Value : %0d, Address : %0h \n",zic_item.zic_mmr_write_data_i,zic_item.zic_mmr_write_addr_i), UVM_MEDIUM)
      end
      if(zic_flag && zic_item.zic_mmr_read_en_i)
      begin
        if(config_mem[zic_item.zic_mmr_read_addr_i]===zic_item.zic_mmr_read_data_o)
        begin
          `uvm_info(" Level and Priority",$sformatf("VALUE MATCH Value : %0d, Address : %0h\n ",zic_item.zic_mmr_read_data_o,zic_item.zic_mmr_read_addr_i), UVM_MEDIUM)
        end
        else
        begin
          `uvm_error("zic_int_en_reg",$sformatf("VALUE MISSMATCH RTL Value : %0d, Address : %0h ",zic_item.zic_mmr_read_data_o,zic_item.zic_mmr_read_addr_i))
          `uvm_error("zic_int_en_reg",$sformatf("VALUE MISSMATCH REF Value : %0d, Address : %0h \n",config_mem[zic_item.zic_mmr_read_addr_i],zic_item.zic_mmr_read_addr_i))
        
        end
      end
      zic_flag=0;
    end
  endfunction :config_reg 

  function void pending_bits(zic_seq_item zic_item);

    pending_bit[0]  = zic_item.global_int_enable_bit_i[0]  *id_bits[0]  * zic_item.ext_int0_i;
    pending_bit[1]  = zic_item.global_int_enable_bit_i[1]  *id_bits[1]  * zic_item.ext_int1_i;
    pending_bit[2]  = zic_item.global_int_enable_bit_i[2]  *id_bits[2]  * zic_item.ext_int2_i;
    pending_bit[3]  = zic_item.global_int_enable_bit_i[3]  *id_bits[3]  * zic_item.ext_int3_i;
    pending_bit[4]  = zic_item.global_int_enable_bit_i[4]  *id_bits[4]  * zic_item.ext_int4_i;
    pending_bit[5]  = zic_item.global_int_enable_bit_i[5]  *id_bits[5]  * zic_item.ext_int5_i;
    pending_bit[6]  = zic_item.global_int_enable_bit_i[6]  *id_bits[6]  * zic_item.ext_int6_i;
    pending_bit[7]  = zic_item.global_int_enable_bit_i[7]  *id_bits[7]  * zic_item.ext_int7_i;
    pending_bit[8]  = zic_item.global_int_enable_bit_i[8]  *id_bits[8]  * zic_item.ext_int8_i;
    pending_bit[9]  = zic_item.global_int_enable_bit_i[9]  *id_bits[9]  * zic_item.ext_int9_i;
    pending_bit[10] = zic_item.global_int_enable_bit_i[10] *id_bits[10] * zic_item.ext_int10_i;
    pending_bit[11] = zic_item.global_int_enable_bit_i[11] *id_bits[11] * zic_item.ext_int11_i;
    pending_bit[12] = zic_item.global_int_enable_bit_i[12] *id_bits[12] * zic_item.ext_int12_i;
    pending_bit[13] = zic_item.global_int_enable_bit_i[13] *id_bits[13] * zic_item.ext_int13_i;
    pending_bit[14] = zic_item.global_int_enable_bit_i[14] *id_bits[14] * zic_item.ext_int14_i;
    pending_bit[15] = zic_item.global_int_enable_bit_i[15] *id_bits[15] * zic_item.ext_int15_i;
    pending_bit[16] = zic_item.global_int_enable_bit_i[16] *id_bits[16] * zic_item.ext_int16_i;
    pending_bit[17] = zic_item.global_int_enable_bit_i[17] *id_bits[17] * zic_item.ext_int17_i;
    pending_bit[18] = zic_item.global_int_enable_bit_i[18] *id_bits[18] * zic_item.ext_int18_i;
    pending_bit[19] = zic_item.global_int_enable_bit_i[19] *id_bits[19] * zic_item.ext_int19_i;
    pending_bit[20] = zic_item.global_int_enable_bit_i[20] *id_bits[20] * zic_item.ext_int20_i;
    pending_bit[21] = zic_item.global_int_enable_bit_i[21] *id_bits[21] * zic_item.ext_int21_i;
    pending_bit[22] = zic_item.global_int_enable_bit_i[22] *id_bits[22] * zic_item.ext_int22_i;
    pending_bit[23] = zic_item.global_int_enable_bit_i[23] *id_bits[23] * zic_item.ext_int23_i;
    pending_bit[24] = zic_item.global_int_enable_bit_i[24] *id_bits[24] * zic_item.ext_int24_i;
    pending_bit[25] = zic_item.global_int_enable_bit_i[25] *id_bits[25] * zic_item.ext_int25_i;
    pending_bit[26] = zic_item.global_int_enable_bit_i[26] *id_bits[26] * zic_item.ext_int26_i;
    pending_bit[27] = zic_item.global_int_enable_bit_i[27] *id_bits[27] * zic_item.ext_int27_i;
    pending_bit[28] = zic_item.global_int_enable_bit_i[28] *id_bits[28] * zic_item.ext_int28_i;
    pending_bit[29] = zic_item.global_int_enable_bit_i[29] *id_bits[29] * zic_item.ext_int29_i;
    pending_bit[30] = zic_item.global_int_enable_bit_i[30] *id_bits[30] * zic_item.ext_int30_i;
    pending_bit[31] = zic_item.global_int_enable_bit_i[31] *id_bits[31] * zic_item.ext_int31_i;
    pending_bit[32] = zic_item.global_int_enable_bit_i[32] *id_bits[32] * zic_item.ext_int32_i;
    pending_bit[33] = zic_item.global_int_enable_bit_i[33] *id_bits[33] * zic_item.ext_int33_i;
    pending_bit[34] = zic_item.global_int_enable_bit_i[34] *id_bits[34] * zic_item.ext_int34_i;
    pending_bit[35] = zic_item.global_int_enable_bit_i[35] *id_bits[35] * zic_item.ext_int35_i;
    pending_bit[36] = zic_item.global_int_enable_bit_i[36] *id_bits[36] * zic_item.ext_int36_i;
    pending_bit[37] = zic_item.global_int_enable_bit_i[37] *id_bits[37] * zic_item.ext_int37_i;
    pending_bit[38] = zic_item.global_int_enable_bit_i[38] *id_bits[38] * zic_item.ext_int38_i;
    pending_bit[39] = zic_item.global_int_enable_bit_i[39] *id_bits[39] * zic_item.ext_int39_i;
    pending_bit[40] = zic_item.global_int_enable_bit_i[40] *id_bits[40] * zic_item.ext_int40_i;
    pending_bit[41] = zic_item.global_int_enable_bit_i[41] *id_bits[41] * zic_item.ext_int41_i;
    pending_bit[42] = zic_item.global_int_enable_bit_i[42] *id_bits[42] * zic_item.ext_int42_i;
    pending_bit[43] = zic_item.global_int_enable_bit_i[43] *id_bits[43] * zic_item.ext_int43_i;
    pending_bit[44] = zic_item.global_int_enable_bit_i[44] *id_bits[44] * zic_item.ext_int44_i;
    pending_bit[45] = zic_item.global_int_enable_bit_i[45] *id_bits[45] * zic_item.ext_int45_i;
    pending_bit[46] = zic_item.global_int_enable_bit_i[46] *id_bits[46] * zic_item.ext_int46_i;
    pending_bit[47] = zic_item.global_int_enable_bit_i[47] *id_bits[47] * zic_item.ext_int47_i;

  endfunction :pending_bits

  function void clear_pending();

    case(id)
  
      16  :  id_bits[0]   = 0; 
      17  :  id_bits[1]   = 0; 
      18  :  id_bits[2]   = 0; 
      19  :  id_bits[3]   = 0; 
      20  :  id_bits[4]   = 0; 
      21  :  id_bits[5]   = 0; 
      22  :  id_bits[6]   = 0; 
      23  :  id_bits[7]   = 0; 
      24  :  id_bits[8]   = 0; 
      25  :  id_bits[9]   = 0; 
      26  :  id_bits[10]  = 0; 
      27  :  id_bits[11]  = 0; 
      28  :  id_bits[12]  = 0; 
      29  :  id_bits[13]  = 0; 
      30  :  id_bits[14]  = 0; 
      31  :  id_bits[15]  = 0; 
      32  :  id_bits[16]  = 0; 
      33  :  id_bits[17]  = 0; 
      34  :  id_bits[18]  = 0; 
      35  :  id_bits[19]  = 0; 
      36  :  id_bits[20]  = 0; 
      37  :  id_bits[21]  = 0; 
      38  :  id_bits[22]  = 0; 
      39  :  id_bits[23]  = 0; 
      40  :  id_bits[24]  = 0; 
      41  :  id_bits[25]  = 0; 
      42  :  id_bits[26]  = 0; 
      43  :  id_bits[27]  = 0; 
      44  :  id_bits[28]  = 0; 
      45  :  id_bits[29]  = 0; 
      46  :  id_bits[30]  = 0; 
      47  :  id_bits[31]  = 0; 
      48  :  id_bits[32]  = 0; 
      49  :  id_bits[33]  = 0; 
      50  :  id_bits[34]  = 0; 
      51  :  id_bits[35]  = 0; 
      52  :  id_bits[36]  = 0; 
      53  :  id_bits[37]  = 0; 
      54  :  id_bits[38]  = 0; 
      55  :  id_bits[39]  = 0; 
      56  :  id_bits[40]  = 0; 
      57  :  id_bits[41]  = 0; 
      58  :  id_bits[42]  = 0; 
      59  :  id_bits[43]  = 0; 
      60  :  id_bits[44]  = 0; 
      61  :  id_bits[45]  = 0; 
      62  :  id_bits[46]  = 0; 
      63  :  id_bits[47]  = 0; 

    endcase

  endfunction :clear_pending


  task  enable_compare(zic_seq_item zic_item);

    enable_mem[16'h1003] = config_mem[16'h1003] * pending_bit[0];  
    enable_mem[16'h1007] = config_mem[16'h1007] * pending_bit[1];  
    enable_mem[16'h100B] = config_mem[16'h100B] * pending_bit[2];  
    enable_mem[16'h100F] = config_mem[16'h100F] * pending_bit[3];  
    enable_mem[16'h1013] = config_mem[16'h1013] * pending_bit[4];  
    enable_mem[16'h1017] = config_mem[16'h1017] * pending_bit[5];  
    enable_mem[16'h101B] = config_mem[16'h101B] * pending_bit[6];  
    enable_mem[16'h101F] = config_mem[16'h101F] * pending_bit[7];  
    enable_mem[16'h1023] = config_mem[16'h1023] * pending_bit[8];  
    enable_mem[16'h1027] = config_mem[16'h1027] * pending_bit[9];  
    enable_mem[16'h102B] = config_mem[16'h102B] * pending_bit[10]; 
    enable_mem[16'h102F] = config_mem[16'h102F] * pending_bit[11]; 
    enable_mem[16'h1033] = config_mem[16'h1033] * pending_bit[12]; 
    enable_mem[16'h1037] = config_mem[16'h1037] * pending_bit[13]; 
    enable_mem[16'h103B] = config_mem[16'h103B] * pending_bit[14]; 
    enable_mem[16'h103F] = config_mem[16'h103F] * pending_bit[15]; 
    enable_mem[16'h1043] = config_mem[16'h1043] * pending_bit[16]; 
    enable_mem[16'h1047] = config_mem[16'h1047] * pending_bit[17]; 
    enable_mem[16'h104B] = config_mem[16'h104B] * pending_bit[18]; 
    enable_mem[16'h104F] = config_mem[16'h104F] * pending_bit[19]; 
    enable_mem[16'h1053] = config_mem[16'h1053] * pending_bit[20]; 
    enable_mem[16'h1057] = config_mem[16'h1057] * pending_bit[21]; 
    enable_mem[16'h105B] = config_mem[16'h105B] * pending_bit[22]; 
    enable_mem[16'h105F] = config_mem[16'h105F] * pending_bit[23]; 
    enable_mem[16'h1063] = config_mem[16'h1063] * pending_bit[24]; 
    enable_mem[16'h1067] = config_mem[16'h1067] * pending_bit[25]; 
    enable_mem[16'h106B] = config_mem[16'h106B] * pending_bit[26]; 
    enable_mem[16'h106F] = config_mem[16'h106F] * pending_bit[27]; 
    enable_mem[16'h1073] = config_mem[16'h1073] * pending_bit[28]; 
    enable_mem[16'h1077] = config_mem[16'h1077] * pending_bit[29]; 
    enable_mem[16'h107B] = config_mem[16'h107B] * pending_bit[30]; 
    enable_mem[16'h107F] = config_mem[16'h107F] * pending_bit[31]; 
    enable_mem[16'h1083] = config_mem[16'h1083] * pending_bit[32]; 
    enable_mem[16'h1087] = config_mem[16'h1087] * pending_bit[33]; 
    enable_mem[16'h108B] = config_mem[16'h108B] * pending_bit[34]; 
    enable_mem[16'h108F] = config_mem[16'h108F] * pending_bit[35]; 
    enable_mem[16'h1093] = config_mem[16'h1093] * pending_bit[36]; 
    enable_mem[16'h1097] = config_mem[16'h1097] * pending_bit[37]; 
    enable_mem[16'h109B] = config_mem[16'h109B] * pending_bit[38]; 
    enable_mem[16'h109F] = config_mem[16'h109F] * pending_bit[39]; 
    enable_mem[16'h10A3] = config_mem[16'h10A3] * pending_bit[40]; 
    enable_mem[16'h10A7] = config_mem[16'h10A7] * pending_bit[41]; 
    enable_mem[16'h10AB] = config_mem[16'h10AB] * pending_bit[42]; 
    enable_mem[16'h10AF] = config_mem[16'h10AF] * pending_bit[43]; 
    enable_mem[16'h10B3] = config_mem[16'h10B3] * pending_bit[44]; 
    enable_mem[16'h10B7] = config_mem[16'h10B7] * pending_bit[45]; 
    enable_mem[16'h10BB] = config_mem[16'h10BB] * pending_bit[46]; 
    enable_mem[16'h10BF] = config_mem[16'h10BF] * pending_bit[47]; 

  
     
    h_v = enable_mem[16'h1003];
    location = 16'h1003;
    foreach(enable_mem[key])
    begin
      if(enable_mem[key]>h_v)
      begin
        h_v = enable_mem[key];
        location = key;
      end
    end



//////////////////// EOI ////////////////////
    if(zic_item.zic_eoi_valid_i)
    begin

      if(zic_vif.eoi_mem_id == eoi_id)
      begin
        `uvm_info("EOI ID",$sformatf("EOI ID is correct : %0d\n",zic_vif.eoi_mem_id),UVM_LOW)
      end

      else
      begin
        
        `uvm_error("EOI ID",$sformatf("EOI ID is incorrect RTL : %0d REF : %0d\n",zic_vif.eoi_mem_id,eoi_id))
        
      end
    end


endtask : enable_compare

  function void int_req(zic_seq_item zic_item);
   case(location)

      16'h1003  :  begin  id =  16;    end  
      16'h1007  :  begin  id =  17;    end
      16'h100B  :  begin  id =  18;    end
      16'h100F  :  begin  id =  19;    end
      16'h1013  :  begin  id =  20;    end
      16'h1017  :  begin  id =  21;    end
      16'h101B  :  begin  id =  22;    end
      16'h101F  :  begin  id =  23;    end
      16'h1023  :  begin  id =  24;    end
      16'h1027  :  begin  id =  25;    end
      16'h102B  :  begin  id =  26;    end
      16'h102F  :  begin  id =  27;    end
      16'h1033  :  begin  id =  28;    end
      16'h1037  :  begin  id =  29;    end
      16'h103B  :  begin  id =  30;    end
      16'h103F  :  begin  id =  31;    end
      16'h1043  :  begin  id =  32;    end
      16'h1047  :  begin  id =  33;    end
      16'h104B  :  begin  id =  34;    end
      16'h104F  :  begin  id =  35;    end
      16'h1053  :  begin  id =  36;    end
      16'h1057  :  begin  id =  37;    end
      16'h105B  :  begin  id =  38;    end
      16'h105F  :  begin  id =  39;    end
      16'h1063  :  begin  id =  40;    end
      16'h1067  :  begin  id =  41;    end
      16'h106B  :  begin  id =  42;    end
      16'h106F  :  begin  id =  43;    end
      16'h1073  :  begin  id =  44;    end
      16'h1077  :  begin  id =  45;    end
      16'h107B  :  begin  id =  46;    end
      16'h107F  :  begin  id =  47;    end
      16'h1083  :  begin  id =  48;    end
      16'h1087  :  begin  id =  49;    end
      16'h108B  :  begin  id =  50;    end
      16'h108F  :  begin  id =  51;    end
      16'h1093  :  begin  id =  52;    end
      16'h1097  :  begin  id =  53;    end
      16'h109B  :  begin  id =  54;    end
      16'h109F  :  begin  id =  55;    end
      16'h10A3  :  begin  id =  56;    end
      16'h10A7  :  begin  id =  57;    end
      16'h10AB  :  begin  id =  58;    end
      16'h10AF  :  begin  id =  59;    end
      16'h10B3  :  begin  id =  60;    end
      16'h10B7  :  begin  id =  61;    end
      16'h10BB  :  begin  id =  62;    end
      16'h10BF  :  begin  id =  63;    end

      default   :  `uvm_error("Interrupt ID",$sformatf("Interrupt ID not found"))

    endcase

    if(current_level>8'b000_000_11)
    begin
      if(h_v[7:5] > current_level[7:5])
      begin
      
        if(zic_item.interrupt_request_o == 1)
        begin
          `uvm_info("Interrupt",$sformatf("Interrupt Request generated after premption New level: %0h Active level: %0h\n",h_v,current_level),UVM_LOW)
        end

        else
        begin
          `uvm_error("Interrupt",$sformatf("Interrupt Request not generated\n"))
        end
      end
      else
      begin
        `uvm_info("Active Value",$sformatf("Continue serving current interrupt New level: %0h Active level: %0h\n",h_v,current_level),UVM_LOW)
      end
    end
    else if(current_level <= 8'b000_000_11)
    begin
      if(h_v > 8'b000_111_11)
      begin
        if(zic_item.interrupt_request_o == 1)
        begin
          `uvm_info("Interrupt",$sformatf("Interrupt Request generated New level: %0h \n",h_v),UVM_LOW)
        end

        else
        begin
          `uvm_error("Interrupt",$sformatf("Interrupt Request not generated\n"))
        end
      end

      else if(h_v <= 8'b000_111_11)
      begin
        if(zic_item.interrupt_request_o == 1)
        begin
          `uvm_error("Interrupt",$sformatf("Interrupt Request generated with zero level\n"))
        end
      end

    end




  endfunction :int_req 



//////////////////// ACK ////////////////////

  function void ack_id(zic_seq_item zic_item);

    if(zic_item.zic_ack_read_valid_en )
    begin

      if(zic_item.zic_ack_int_id_o == id)
      begin

        `uvm_info("ACK ID",$sformatf("ACK ID is correct : %0d\n",zic_item.zic_ack_int_id_o),UVM_LOW)
      //  y =0;
        clear_pending();

      end

      else
      begin
        
        `uvm_error("ACK ID",$sformatf("ACK ID is incorrect RTL : %0d REF : %0d\n",zic_item.zic_ack_int_id_o,id))
        
      end
    end
  
  endfunction :ack_id


endclass


 	

  
