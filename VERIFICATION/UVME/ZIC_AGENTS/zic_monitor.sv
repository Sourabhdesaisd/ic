class zic_monitor extends uvm_monitor;

  `uvm_component_utils(zic_monitor)

  zic_seq_item zic_item;

  virtual zic_intf zic_vif;       

  uvm_analysis_port#(zic_seq_item) analysis_port_monitor;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);

    analysis_port_monitor = new("analysis_port_monitor",this);
    if(!uvm_config_db#(virtual zic_intf)::get(this,"","vif",zic_vif))      
      `uvm_error("Monitor","No resource found")

  endfunction

  task run_phase(uvm_phase phase);
    
    
    forever begin

      @(negedge zic_vif.clk )
       zic_item = zic_seq_item :: type_id :: create("zic_item");
       zic_item.zic_rst                   = zic_vif.zic_rst;
	   zic_item.zic_mmr_write_en_i	      = zic_vif.zic_mmr_write_en_i;  	        
       zic_item.zic_mmr_write_addr_i	  = zic_vif.zic_mmr_write_addr_i;	      
       zic_item.zic_mmr_write_data_i	  = zic_vif.zic_mmr_write_data_i;	     
       zic_item.zic_mmr_read_en_i	      = zic_vif.zic_mmr_read_en_i;		       
       zic_item.zic_mmr_read_addr_i 	  = zic_vif.zic_mmr_read_addr_i; 	        
	   zic_item.zic_ack_read_valid_en     = zic_vif.zic_ack_read_valid_en;	       
	   zic_item.zic_eoi_valid_i		      = zic_vif.zic_eoi_valid_i; 		      
	   zic_item.zic_eoi_id_i			  = zic_vif.zic_eoi_id_i;			     
	   zic_item.active_lvl_pr_i		      = zic_vif.active_lvl_pr_i; 		              
	   zic_item.global_int_enable_bit_i   = zic_vif.global_int_enable_bit_i;            
	   zic_item.global_int_enable_valid_i = zic_vif.global_int_enable_valid_i;             
	   zic_item.ext_int0_i			      = zic_vif.ext_int0_i;				   
	   zic_item.ext_int1_i			      = zic_vif.ext_int1_i;				         
	   zic_item.ext_int2_i			      = zic_vif.ext_int2_i;				       
	   zic_item.ext_int3_i			      = zic_vif.ext_int3_i;				     
	   zic_item.ext_int4_i			      = zic_vif.ext_int4_i;				          
	   zic_item.ext_int5_i			      = zic_vif.ext_int5_i;				          
	   zic_item.ext_int6_i			      = zic_vif.ext_int6_i;				             
	   zic_item.ext_int7_i			      = zic_vif.ext_int7_i;				             
	   zic_item.ext_int8_i			      = zic_vif.ext_int8_i;				            
	   zic_item.ext_int9_i			      = zic_vif.ext_int9_i;				            
	   zic_item.ext_int10_i			      = zic_vif.ext_int10_i;				            
	   zic_item.ext_int11_i			      = zic_vif.ext_int11_i;				            
	   zic_item.ext_int12_i			      = zic_vif.ext_int12_i;				            
	   zic_item.ext_int13_i			      = zic_vif.ext_int13_i;				            
	   zic_item.ext_int14_i			      = zic_vif.ext_int14_i;				            
	   zic_item.ext_int15_i			      = zic_vif.ext_int15_i;				            
	   zic_item.ext_int16_i			      = zic_vif.ext_int16_i;				            
	   zic_item.ext_int17_i			      = zic_vif.ext_int17_i;				            
	   zic_item.ext_int18_i			      = zic_vif.ext_int18_i;				            
	   zic_item.ext_int19_i			      = zic_vif.ext_int19_i;				            
	   zic_item.ext_int20_i			      = zic_vif.ext_int20_i;				            
	   zic_item.ext_int21_i			      = zic_vif.ext_int21_i;				            
	   zic_item.ext_int22_i			      = zic_vif.ext_int22_i;				            
	   zic_item.ext_int23_i			      = zic_vif.ext_int23_i;				            
	   zic_item.ext_int24_i			      = zic_vif.ext_int24_i;				            
	   zic_item.ext_int25_i			      = zic_vif.ext_int25_i;				            
	   zic_item.ext_int26_i			      = zic_vif.ext_int26_i;				            
	   zic_item.ext_int27_i			      = zic_vif.ext_int27_i;				            
	   zic_item.ext_int28_i			      = zic_vif.ext_int28_i;				            
	   zic_item.ext_int29_i			      = zic_vif.ext_int29_i;				            
	   zic_item.ext_int30_i			      = zic_vif.ext_int30_i;				            
	   zic_item.ext_int31_i			      = zic_vif.ext_int31_i;				            
	   zic_item.ext_int32_i			      = zic_vif.ext_int32_i;				            
	   zic_item.ext_int33_i			      = zic_vif.ext_int33_i;				            
	   zic_item.ext_int34_i			      = zic_vif.ext_int34_i;				            
	   zic_item.ext_int35_i			      = zic_vif.ext_int35_i;				            
	   zic_item.ext_int36_i			      = zic_vif.ext_int36_i;				            
	   zic_item.ext_int37_i			      = zic_vif.ext_int37_i;				            
	   zic_item.ext_int38_i			      = zic_vif.ext_int38_i;				           
	   zic_item.ext_int39_i			      = zic_vif.ext_int39_i;				           
	   zic_item.ext_int40_i			      = zic_vif.ext_int40_i;				           
	   zic_item.ext_int41_i			      = zic_vif.ext_int41_i;				           
	   zic_item.ext_int42_i			      = zic_vif.ext_int42_i;				           
	   zic_item.ext_int43_i			      = zic_vif.ext_int43_i;				           
	   zic_item.ext_int44_i			      = zic_vif.ext_int44_i;				           
	   zic_item.ext_int45_i			      = zic_vif.ext_int45_i;				           
	   zic_item.ext_int46_i			      = zic_vif.ext_int46_i;				           
	   zic_item.ext_int47_i               = zic_vif.ext_int47_i;
       zic_item.zic_mmr_read_data_o       = zic_vif.zic_mmr_read_data_o;
       zic_item.zic_ack_int_id_o          = zic_vif.zic_ack_int_id_o;
       zic_item.interrupt_request_o       = zic_vif.interrupt_request_o;
       zic_item.highest_pending_lvl_pr_o  = zic_vif.highest_pending_lvl_pr_o; 
       
      analysis_port_monitor.write(zic_item);
    end

  endtask

endclass
