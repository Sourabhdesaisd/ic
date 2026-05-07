class zic_driver extends uvm_driver#(zic_seq_item);

  `uvm_component_utils(zic_driver)

  virtual zic_intf zic_vif;    
  zic_seq_item zic_item;

  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);

    if(!uvm_config_db#(virtual zic_intf)::get(this,"","vif",zic_vif))        ////////
      `uvm_error("Driver","No resource found")

  endfunction

  task run_phase(uvm_phase phase);
	
    forever  
	begin
      seq_item_port.get_next_item(zic_item);
      if(zic_item.zic_rst == 0)
      begin

	  	zic_vif.zic_rst                    = 0;		
	    zic_vif.zic_mmr_write_en_i 		   = 0;
        zic_vif.zic_mmr_write_addr_i	   = 0;
        zic_vif.zic_mmr_write_data_i	   = 0;
        zic_vif.zic_mmr_read_en_i 		   = 0;
        zic_vif.zic_mmr_read_addr_i		   = 0;
        zic_vif.zic_ack_read_valid_en 	   = 0;
        zic_vif.zic_eoi_valid_i 		   = 0;
        zic_vif.zic_eoi_id_i			   = 0; 
        zic_vif.active_lvl_pr_i			   = 0;
        zic_vif.global_int_enable_bit_i	   = 0;
        zic_vif.global_int_enable_valid_i  = 0;
        zic_vif.ext_int0_i				   = 0;
        zic_vif.ext_int1_i				   = 0;
        zic_vif.ext_int2_i				   = 0;
        zic_vif.ext_int3_i				   = 0;
        zic_vif.ext_int4_i				   = 0; 
        zic_vif.ext_int5_i				   = 0; 	      
        zic_vif.ext_int6_i				   = 0;	      
        zic_vif.ext_int7_i				   = 0;	      
        zic_vif.ext_int8_i				   = 0;	      
        zic_vif.ext_int9_i				   = 0;	      
        zic_vif.ext_int10_i				   = 0;	      
        zic_vif.ext_int11_i				   = 0;	      
        zic_vif.ext_int12_i				   = 0;	      
        zic_vif.ext_int13_i				   = 0;	      
        zic_vif.ext_int14_i				   = 0;	      
        zic_vif.ext_int15_i				   = 0;	      
        zic_vif.ext_int16_i				   = 0;	      
        zic_vif.ext_int17_i				   = 0;	      
        zic_vif.ext_int18_i				   = 0;	      
        zic_vif.ext_int19_i				   = 0;	      
        zic_vif.ext_int20_i				   = 0;	      
        zic_vif.ext_int21_i				   = 0;	      
        zic_vif.ext_int22_i				   = 0;	      
        zic_vif.ext_int23_i				   = 0;	      
        zic_vif.ext_int24_i				   = 0;	      
        zic_vif.ext_int25_i				   = 0;	      
        zic_vif.ext_int26_i				   = 0;	      
        zic_vif.ext_int27_i				   = 0;	      
        zic_vif.ext_int28_i				   = 0;	      
        zic_vif.ext_int29_i				   = 0;	      
        zic_vif.ext_int30_i				   = 0;	      
        zic_vif.ext_int31_i				   = 0;	      
        zic_vif.ext_int32_i				   = 0;	      
        zic_vif.ext_int33_i				   = 0;	      
        zic_vif.ext_int34_i				   = 0;	      
        zic_vif.ext_int35_i				   = 0;	      
        zic_vif.ext_int36_i				   = 0;	      
        zic_vif.ext_int37_i				   = 0;	      
        zic_vif.ext_int38_i				   = 0;          
        zic_vif.ext_int39_i				   = 0;          
        zic_vif.ext_int40_i				   = 0;          
        zic_vif.ext_int41_i				   = 0;          
        zic_vif.ext_int42_i				   = 0;          
        zic_vif.ext_int43_i				   = 0;          
        zic_vif.ext_int44_i				   = 0;          
        zic_vif.ext_int45_i				   = 0;          
        zic_vif.ext_int46_i				   = 0;          
        zic_vif.ext_int47_i                = 0; 
        repeat(2)@(posedge zic_vif.clk);
        zic_vif.zic_rst                    = 1;
      end

      else if(zic_item.zic_rst == 1)
      begin
        @(negedge zic_vif.clk);
        zic_vif.zic_rst                    = 1;
        zic_vif.zic_mmr_write_en_i  	   = zic_item.zic_mmr_write_en_i;		
        zic_vif.zic_mmr_write_addr_i	   = zic_item.zic_mmr_write_addr_i;		
        zic_vif.zic_mmr_write_data_i	   = zic_item.zic_mmr_write_data_i;		
        zic_vif.zic_mmr_read_en_i		   = zic_item.zic_mmr_read_en_i;		
        zic_vif.zic_mmr_read_addr_i 	   = zic_item.zic_mmr_read_addr_i;		
        zic_vif.zic_ack_read_valid_en	   = zic_item.zic_ack_read_valid_en && zic_vif.interrupt_request_o;		
        zic_vif.zic_eoi_valid_i 		   = zic_item.zic_eoi_valid_i;			
        zic_vif.zic_eoi_id_i			   = zic_item.zic_eoi_id_i;			
        zic_vif.active_lvl_pr_i 		   = zic_item.active_lvl_pr_i;			
        zic_vif.global_int_enable_bit_i    = zic_item.global_int_enable_bit_i;	
        zic_vif.global_int_enable_valid_i  = zic_item.global_int_enable_valid_i;	
        zic_vif.ext_int0_i				   = zic_item.ext_int0_i;				 
        zic_vif.ext_int1_i				   = zic_item.ext_int1_i;				 
        zic_vif.ext_int2_i				   = zic_item.ext_int2_i;				 
        zic_vif.ext_int3_i				   = zic_item.ext_int3_i;				 
        zic_vif.ext_int4_i				   = zic_item.ext_int4_i;				 
        zic_vif.ext_int5_i				   = zic_item.ext_int5_i;				 
        zic_vif.ext_int6_i				   = zic_item.ext_int6_i;				 
        zic_vif.ext_int7_i				   = zic_item.ext_int7_i;				 
        zic_vif.ext_int8_i				   = zic_item.ext_int8_i;				 
        zic_vif.ext_int9_i				   = zic_item.ext_int9_i;				 
        zic_vif.ext_int10_i				   = zic_item.ext_int10_i;				 
        zic_vif.ext_int11_i				   = zic_item.ext_int11_i;				 
        zic_vif.ext_int12_i				   = zic_item.ext_int12_i;				 
        zic_vif.ext_int13_i				   = zic_item.ext_int13_i;				 
        zic_vif.ext_int14_i				   = zic_item.ext_int14_i;				 
        zic_vif.ext_int15_i				   = zic_item.ext_int15_i;				 
        zic_vif.ext_int16_i				   = zic_item.ext_int16_i;				 
        zic_vif.ext_int17_i				   = zic_item.ext_int17_i;				 
        zic_vif.ext_int18_i				   = zic_item.ext_int18_i;				 
        zic_vif.ext_int19_i				   = zic_item.ext_int19_i;				 
        zic_vif.ext_int20_i				   = zic_item.ext_int20_i;				 
        zic_vif.ext_int21_i				   = zic_item.ext_int21_i;				 
        zic_vif.ext_int22_i				   = zic_item.ext_int22_i;				 
        zic_vif.ext_int23_i				   = zic_item.ext_int23_i;				 
        zic_vif.ext_int24_i				   = zic_item.ext_int24_i;				 
        zic_vif.ext_int25_i				   = zic_item.ext_int25_i;				 
        zic_vif.ext_int26_i				   = zic_item.ext_int26_i;				 
        zic_vif.ext_int27_i				   = zic_item.ext_int27_i;				 
        zic_vif.ext_int28_i				   = zic_item.ext_int28_i;				 
        zic_vif.ext_int29_i				   = zic_item.ext_int29_i;				 
        zic_vif.ext_int30_i				   = zic_item.ext_int30_i;				 
        zic_vif.ext_int31_i				   = zic_item.ext_int31_i;				 
        zic_vif.ext_int32_i				   = zic_item.ext_int32_i;				 
        zic_vif.ext_int33_i				   = zic_item.ext_int33_i;				 
        zic_vif.ext_int34_i				   = zic_item.ext_int34_i;				 
        zic_vif.ext_int35_i				   = zic_item.ext_int35_i;				 
        zic_vif.ext_int36_i				   = zic_item.ext_int36_i;				 
        zic_vif.ext_int37_i				   = zic_item.ext_int37_i;				 
        zic_vif.ext_int38_i				   = zic_item.ext_int38_i;				 
        zic_vif.ext_int39_i				   = zic_item.ext_int39_i;				 
        zic_vif.ext_int40_i				   = zic_item.ext_int40_i;				 
        zic_vif.ext_int41_i				   = zic_item.ext_int41_i;				 
        zic_vif.ext_int42_i				   = zic_item.ext_int42_i;				 
        zic_vif.ext_int43_i				   = zic_item.ext_int43_i;				 
        zic_vif.ext_int44_i				   = zic_item.ext_int44_i;				 
        zic_vif.ext_int45_i				   = zic_item.ext_int45_i;				 
        zic_vif.ext_int46_i				   = zic_item.ext_int46_i;				 
        zic_vif.ext_int47_i                = zic_item.ext_int47_i;
       
      end

      seq_item_port.item_done();  
	end
  
	
  endtask
endclass
	

       
