class ic_mon extends uvm_monitor;
`uvm_component_utils(ic_mon)
	
	ic_seq_item item;
	virtual ic_intf intf;
	
	uvm_analysis_port#(ic_seq_item) mon_port;

	function new(string name="ic_mon", uvm_component parent);
		super.new(name,parent);
		mon_port = new("mon_port", this);
	endfunction

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual ic_intf)::get(this, "","vif",intf))
		`uvm_fatal(get_type_name(),"MON_INTERFACE IS NOT SET")
	endfunction

	task run_phase (uvm_phase phase);
		super.run_phase(phase);
//		item = ic_seq_item::type_id::create("item",this);

		forever begin
			item = ic_seq_item::type_id::create("item",this);
			@(negedge intf.ic_clk);
			@(negedge intf.ic_clk);
			item.ic_mmr_read_data_o	 	 = intf.ic_mmr_read_data_o	  ;

			@(negedge intf.ic_clk);
			@(negedge intf.ic_clk);				
			item.interrupt_request_o	 = intf.interrupt_request_o       ; 	 
			item.highest_pending_lvl_pr_o	 = intf.highest_pending_lvl_pr_o  ; 

			@(negedge intf.ic_clk);
			item.ic_ack_int_id_o		 = intf.ic_ack_int_id_o	   	  ;

			item.ic_rst			 = intf.ic_rst		          ;  
			item.ic_mmr_write_en_i		 = intf.ic_mmr_write_en_i	  ; 
			item.ic_mmr_write_addr_i	 = intf.ic_mmr_write_addr_i       ;  
			item.ic_mmr_write_data_i	 = intf.ic_mmr_write_data_i       ;  
			item.ic_mmr_read_en_i	 	 = intf.ic_mmr_read_en_i	  ; 
			item.ic_mmr_read_addr_i	 	 = intf.ic_mmr_read_addr_i	  ;
			item.ic_ack_read_valid_en	 = intf.ic_ack_read_valid_en      ; 
			item.ic_eoi_valid_i		 = intf.ic_eoi_valid_i	       	  ;  
			item.ic_eoi_id_i		 = intf.ic_eoi_id_i	       	  ;  
			item.active_lvl_pr_i	 	 = intf.active_lvl_pr_i	   	  ; 
			item.global_int_enable_bit_i  	 = intf.global_int_enable_bit_i   ; 
			item.global_int_enable_valid_i	 = intf.global_int_enable_valid_i ; 
			item.ext_int0_i			 = intf.ext_int0_i	       ; 
			item.ext_int1_i			 = intf.ext_int1_i	       ; 
			item.ext_int2_i			 = intf.ext_int2_i	       ; 
			item.ext_int3_i			 = intf.ext_int3_i	       ; 
			item.ext_int4_i			 = intf.ext_int4_i	       ; 
			item.ext_int5_i			 = intf.ext_int5_i	       ; 
			item.ext_int6_i			 = intf.ext_int6_i	       ; 
			item.ext_int7_i			 = intf.ext_int7_i	       ; 
			item.ext_int8_i			 = intf.ext_int8_i	       ; 
			item.ext_int9_i			 = intf.ext_int9_i	       ; 
			item.ext_int10_i		 = intf.ext_int10_i	       ; 	 
			item.ext_int11_i		 = intf.ext_int11_i	       ;  	
			item.ext_int12_i		 = intf.ext_int12_i	       ;  	
			item.ext_int13_i		 = intf.ext_int13_i	       ;  	
			item.ext_int14_i		 = intf.ext_int14_i	       ;  
			item.ext_int15_i		 = intf.ext_int15_i	       ;  	
			item.ext_int16_i		 = intf.ext_int16_i	       ;  	
			item.ext_int17_i		 = intf.ext_int17_i	       ;  	
			item.ext_int18_i		 = intf.ext_int18_i	       ;  	
			item.ext_int19_i		 = intf.ext_int19_i	       ;  	
			item.ext_int20_i		 = intf.ext_int20_i	       ;  	
			item.ext_int21_i		 = intf.ext_int21_i	       ;  	
			item.ext_int22_i		 = intf.ext_int22_i	       ;  	
			item.ext_int23_i		 = intf.ext_int23_i	       ;  	
			item.ext_int24_i		 = intf.ext_int24_i	       ;  	
			item.ext_int25_i		 = intf.ext_int25_i	       ;  	
			item.ext_int26_i		 = intf.ext_int26_i	       ;  	
			item.ext_int27_i		 = intf.ext_int27_i	       ;  	
			item.ext_int28_i		 = intf.ext_int28_i	       ;  	
			item.ext_int29_i		 = intf.ext_int29_i	       ;  	
			item.ext_int30_i		 = intf.ext_int30_i	       ;  	
			item.ext_int31_i		 = intf.ext_int31_i	       ;  	
			item.ext_int32_i		 = intf.ext_int32_i	       ;  	
			item.ext_int33_i		 = intf.ext_int33_i	       ;  	
			item.ext_int34_i		 = intf.ext_int34_i	       ;  	
			item.ext_int35_i		 = intf.ext_int35_i	       ;  	
			item.ext_int36_i		 = intf.ext_int36_i	       ;  	
			item.ext_int37_i		 = intf.ext_int37_i	       ;  	
			item.ext_int38_i		 = intf.ext_int38_i	       ;  	
			item.ext_int39_i		 = intf.ext_int39_i	       ;  	
			item.ext_int40_i		 = intf.ext_int40_i	       ;  	
			item.ext_int41_i		 = intf.ext_int41_i	       ;  	
			item.ext_int42_i		 = intf.ext_int42_i	       ;  	
			item.ext_int43_i		 = intf.ext_int43_i	       ;  	
			item.ext_int44_i		 = intf.ext_int44_i	       ;  	
			item.ext_int45_i		 = intf.ext_int45_i	       ;  	
			item.ext_int46_i		 = intf.ext_int46_i	       ;  	
//			item.ext_int47_i		 = intf.ext_int47_i	       ; 
			item.dbg_mode_valid_i	         = intf.dbg_mode_valid_i       ;
	    
			item.print();
			mon_port.write(item);
		end
	endtask

endclass





/*
			item.ic_mmr_read_data_o	 	 = intf.ic_mmr_read_data_o	  ;
//			@(posedge intf.global_int_enable_bit_i);

			//@(negedge intf.ic_clk);
			//@(negedge intf.ic_clk);				
			item.interrupt_request_o	 = intf.interrupt_request_o       ; 	 
			item.highest_pending_lvl_pr_o	 = intf.highest_pending_lvl_pr_o  ; 
			item.ic_ack_read_valid_en	 = intf.ic_ack_read_valid_en      ;  

			//@(negedge intf.ic_clk);
			item.ic_ack_int_id_o		 = intf.ic_ack_int_id_o	   	  ;
 
			
			item.print();
			mon_port.write(item);


			@(posedge intf.ic_ack_read_valid_en);

			item.ic_mmr_read_data_o	 	 = intf.ic_mmr_read_data_o	  ;

			//@(negedge intf.ic_clk);
			//@(negedge intf.ic_clk);				
			item.interrupt_request_o	 = intf.interrupt_request_o       ; 	 
			item.highest_pending_lvl_pr_o	 = intf.highest_pending_lvl_pr_o  ; 
			item.ic_ack_read_valid_en	 = intf.ic_ack_read_valid_en      ;  

			//@(negedge intf.ic_clk);
			item.ic_ack_int_id_o		 = intf.ic_ack_int_id_o	   	  ;*/
