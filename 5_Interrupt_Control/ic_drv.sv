class ic_drv extends uvm_driver #(ic_seq_item);
`uvm_component_utils(ic_drv)
	
	ic_seq_item seq_item;
	virtual ic_intf intf;

	function new(string name="ic_drv", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual ic_intf)::get(this,"","vif",intf))
		`uvm_fatal(get_type_name(),"DRV_INTERFACE IS NOT SET")
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);

		forever begin
			seq_item_port.get_next_item(seq_item);
			driver_logic(seq_item);
			seq_item_port.item_done();
		end
	endtask
	
	task driver_logic(ic_seq_item seq_item);
	
	@(negedge intf.ic_clk);

        if(seq_item.ic_rst ==0) begin      
		intf.ic_rst			 <= 0 ;  
		intf.ic_mmr_write_en_i		 <= 0 ; 
		intf.ic_mmr_write_addr_i	 <= 0 ;  
		intf.ic_mmr_write_data_i	 <= 0 ;  
		intf.ic_mmr_read_en_i	 	 <= 0 ; 
		intf.ic_mmr_read_addr_i	 	 <= 0 ; 
		intf.ic_ack_read_valid_en	 <= 0 ;  
		intf.ic_eoi_valid_i		 <= 0 ;  
		intf.ic_eoi_id_i		 <= 0 ;  
		intf.active_lvl_pr_i	 	 <= 0 ; 
		intf.global_int_enable_bit_i  	 <= 0 ; 
		intf.global_int_enable_valid_i	 <= 0 ; 
		intf.ext_int0_i			 <= 0 ; 
		intf.ext_int1_i			 <= 0 ; 
		intf.ext_int2_i			 <= 0 ; 
		intf.ext_int3_i			 <= 0 ; 
		intf.ext_int4_i			 <= 0 ; 
		intf.ext_int5_i			 <= 0 ; 
		intf.ext_int6_i			 <= 0 ; 
		intf.ext_int7_i			 <= 0 ; 
		intf.ext_int8_i			 <= 0 ; 
		intf.ext_int9_i			 <= 0 ; 
		intf.ext_int10_i		 <= 0 ; 	 
		intf.ext_int11_i		 <= 0 ;  	
		intf.ext_int12_i		 <= 0 ;  	
		intf.ext_int13_i		 <= 0 ;  	
		intf.ext_int14_i		 <= 0 ;  
		intf.ext_int15_i		 <= 0 ;  	
		intf.ext_int16_i		 <= 0 ;  	
		intf.ext_int17_i		 <= 0 ;  	
		intf.ext_int18_i		 <= 0 ;  	
		intf.ext_int19_i		 <= 0 ;  	
		intf.ext_int20_i		 <= 0 ;  	
		intf.ext_int21_i		 <= 0 ;  	
		intf.ext_int22_i		 <= 0 ;  	
		intf.ext_int23_i		 <= 0 ;  	
		intf.ext_int24_i		 <= 0 ;  	
		intf.ext_int25_i		 <= 0 ;  	
		intf.ext_int26_i		 <= 0 ;  	
		intf.ext_int27_i		 <= 0 ;  	
		intf.ext_int28_i		 <= 0 ;  	
		intf.ext_int29_i		 <= 0 ;  	
		intf.ext_int30_i		 <= 0 ;  	
		intf.ext_int31_i		 <= 0 ;  	
		intf.ext_int32_i		 <= 0 ;  	
		intf.ext_int33_i		 <= 0 ;  	
		intf.ext_int34_i		 <= 0 ;  	
		intf.ext_int35_i		 <= 0 ;  	
		intf.ext_int36_i		 <= 0 ;  	
		intf.ext_int37_i		 <= 0 ;  	
		intf.ext_int38_i		 <= 0 ;  	
		intf.ext_int39_i		 <= 0 ;  	
		intf.ext_int40_i		 <= 0 ;  	
		intf.ext_int41_i		 <= 0 ;  	
		intf.ext_int42_i		 <= 0 ;  	
		intf.ext_int43_i		 <= 0 ;  	
		intf.ext_int44_i		 <= 0 ;  	
		intf.ext_int45_i		 <= 0 ;  	
		intf.ext_int46_i		 <= 0 ;  	
//		intf.ext_int47_i		 <= 0 ;
		intf.dbg_mode_valid_i	         <= 0 ;
	end else begin 	
		intf.ic_rst			 <= seq_item.ic_rst		       ;
		intf.ic_mmr_write_en_i		 <= seq_item.ic_mmr_write_en_i	       ;
		intf.ic_mmr_write_addr_i	 <= seq_item.ic_mmr_write_addr_i       ;
		intf.ic_mmr_write_data_i	 <= seq_item.ic_mmr_write_data_i       ;
		intf.ic_mmr_read_en_i	 	 <= seq_item.ic_mmr_read_en_i	       ;
		intf.ic_mmr_read_addr_i	 	 <= seq_item.ic_mmr_read_addr_i	       ;
		intf.ic_ack_read_valid_en	 <= seq_item.ic_ack_read_valid_en      ;
		intf.ic_eoi_valid_i		 <= seq_item.ic_eoi_valid_i	       ;
		intf.ic_eoi_id_i		 <= seq_item.ic_eoi_id_i	       ;
		intf.active_lvl_pr_i	 	 <= seq_item.active_lvl_pr_i	       ;
		intf.global_int_enable_bit_i  	 <= seq_item.global_int_enable_bit_i   ;
		intf.global_int_enable_valid_i	 <= seq_item.global_int_enable_valid_i ;
		intf.ext_int0_i			 <= seq_item.ext_int0_i		       ;
		intf.ext_int1_i			 <= seq_item.ext_int1_i		       ;
		intf.ext_int2_i			 <= seq_item.ext_int2_i		       ;
		intf.ext_int3_i			 <= seq_item.ext_int3_i		       ;
		intf.ext_int4_i			 <= seq_item.ext_int4_i		       ;
		intf.ext_int5_i			 <= seq_item.ext_int5_i		       ;
		intf.ext_int6_i			 <= seq_item.ext_int6_i		       ;
		intf.ext_int7_i			 <= seq_item.ext_int7_i		       ;
		intf.ext_int8_i			 <= seq_item.ext_int8_i		       ;
		intf.ext_int9_i			 <= seq_item.ext_int9_i		       ;
		intf.ext_int10_i		 <= seq_item.ext_int10_i	       ;
		intf.ext_int11_i		 <= seq_item.ext_int11_i	       ;
		intf.ext_int12_i		 <= seq_item.ext_int12_i	       ;
		intf.ext_int13_i		 <= seq_item.ext_int13_i	       ;
		intf.ext_int14_i		 <= seq_item.ext_int14_i	       ;
		intf.ext_int15_i		 <= seq_item.ext_int15_i	       ;
		intf.ext_int16_i		 <= seq_item.ext_int16_i	       ;
		intf.ext_int17_i		 <= seq_item.ext_int17_i	       ;
		intf.ext_int18_i		 <= seq_item.ext_int18_i	       ;
		intf.ext_int19_i		 <= seq_item.ext_int19_i	       ;
		intf.ext_int20_i		 <= seq_item.ext_int20_i	       ;
		intf.ext_int21_i		 <= seq_item.ext_int21_i	       ;
		intf.ext_int22_i		 <= seq_item.ext_int22_i	       ;
		intf.ext_int23_i		 <= seq_item.ext_int23_i	       ;
		intf.ext_int24_i		 <= seq_item.ext_int24_i	       ;
		intf.ext_int25_i		 <= seq_item.ext_int25_i	       ;
		intf.ext_int26_i		 <= seq_item.ext_int26_i	       ;
		intf.ext_int27_i		 <= seq_item.ext_int27_i	       ;
		intf.ext_int28_i		 <= seq_item.ext_int28_i	       ;
		intf.ext_int29_i		 <= seq_item.ext_int29_i	       ;
		intf.ext_int30_i		 <= seq_item.ext_int30_i	       ;
		intf.ext_int31_i		 <= seq_item.ext_int31_i	       ;
		intf.ext_int32_i		 <= seq_item.ext_int32_i	       ;
		intf.ext_int33_i		 <= seq_item.ext_int33_i	       ;
		intf.ext_int34_i		 <= seq_item.ext_int34_i	       ;
		intf.ext_int35_i		 <= seq_item.ext_int35_i	       ;
		intf.ext_int36_i		 <= seq_item.ext_int36_i	       ;
		intf.ext_int37_i		 <= seq_item.ext_int37_i	       ;
		intf.ext_int38_i		 <= seq_item.ext_int38_i	       ;
		intf.ext_int39_i		 <= seq_item.ext_int39_i	       ;
		intf.ext_int40_i		 <= seq_item.ext_int40_i	       ;
		intf.ext_int41_i		 <= seq_item.ext_int41_i	       ;
		intf.ext_int42_i		 <= seq_item.ext_int42_i	       ;
		intf.ext_int43_i		 <= seq_item.ext_int43_i	       ;
		intf.ext_int44_i		 <= seq_item.ext_int44_i	       ;
		intf.ext_int45_i		 <= seq_item.ext_int45_i	       ;
		intf.ext_int46_i		 <= seq_item.ext_int46_i	       ;
		//intf.ext_int47_i		 <= seq_item.ext_int47_i	       ;
		intf.dbg_mode_valid_i	         <= seq_item.dbg_mode_valid_i	       ;
		
//		if(seq_item.ic_ack_read_valid_en == 1) intf.ack_fetch <= 1;
	end

	@(negedge intf.ic_clk);
	@(negedge intf.ic_clk);
	@(negedge intf.ic_clk);
	@(negedge intf.ic_clk);

//	seq_item.print();
	endtask

endclass

