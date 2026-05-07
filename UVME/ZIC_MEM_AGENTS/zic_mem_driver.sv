class zic_mem_driver extends uvm_driver#(zic_mem_seq_item);

  `uvm_component_utils(zic_mem_driver)

  virtual zic_mem_intf zic_vif;    
  zic_mem_seq_item zic_item;

  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);

    if(!uvm_config_db#(virtual zic_mem_intf)::get(this,"","vif",zic_vif))        ////////
      `uvm_error("Driver","No resource found")

  endfunction

  task run_phase(uvm_phase phase);

      wait(zic_vif.rst == 0);
        zic_vif.zic_mmr_write_en_i        = 0;
        zic_vif.zic_mmr_write_addr_i      = 0;
        zic_vif.zic_mmr_write_data_i      = 0;
        zic_vif.zic_ack_write_valid_i     = 0;
        zic_vif.zic_mmr_read_en_i         = 0;
        zic_vif.zic_mmr_read_addr_i       = 0;
        zic_vif.zic_ack_int_id_i          = 0;
        zic_vif.zic_ack_read_valid_en     = 0;
        zic_vif.zic_eoi_valid_i           = 0; 
        zic_vif.zic_eoi_id_i              = 0;
        zic_vif.zic_nxtp_valid_i          = 0;
        zic_vif.zic_nxtp_id_i             = 0;
        zic_vif.zic_int_pending_valid_i   = 0;
        zic_vif.zic_int_pending_bit_i     = 0;
        zic_vif.global_int_enable_bit_i   = 0;
        zic_vif.global_int_enable_valid_i = 0;
      
	  
	  wait(zic_vif.rst == 1);
		forever  
		begin
        @(posedge zic_vif.clk);
		 begin
			seq_item_port.get_next_item(zic_item);
			
				if(zic_vif.rst == 1)
                    begin
        zic_vif.zic_mmr_write_en_i        =  zic_item.zic_mmr_write_en_i;       
        zic_vif.zic_mmr_write_addr_i      =  zic_item.zic_mmr_write_addr_i;    
        zic_vif.zic_ack_write_valid_i     =  zic_item.zic_ack_write_valid_i; 
        zic_vif.zic_mmr_write_data_i      =  zic_item.zic_mmr_write_data_i;   
        zic_vif.zic_mmr_read_en_i         =  zic_item.zic_mmr_read_en_i;     
        zic_vif.zic_mmr_read_addr_i       =  zic_item.zic_mmr_read_addr_i;      
		zic_vif.zic_ack_int_id_i          =  zic_item.zic_ack_int_id_i;     
		zic_vif.zic_ack_read_valid_en     =  zic_item.zic_ack_read_valid_en;    
		zic_vif.zic_eoi_valid_i           =  zic_item.zic_eoi_valid_i;   
		zic_vif.zic_eoi_id_i              =  zic_item.zic_eoi_id_i;             
		zic_vif.zic_nxtp_valid_i          =  zic_item.zic_nxtp_valid_i;         
		zic_vif.zic_nxtp_id_i             =  zic_item.zic_nxtp_id_i;            
		zic_vif.zic_int_pending_valid_i   =  zic_item.zic_int_pending_valid_i;  
		zic_vif.zic_int_pending_bit_i     =  zic_item.zic_int_pending_bit_i;    
		zic_vif.global_int_enable_bit_i   =  zic_item.global_int_enable_bit_i;  
		zic_vif.global_int_enable_valid_i =  zic_item.global_int_enable_valid_i;
                    end

         else
           begin
			   zic_vif.zic_mmr_write_en_i        = 0;
			   zic_vif.zic_mmr_write_addr_i      = 0;
			   zic_vif.zic_mmr_write_data_i      = 0;
               zic_vif.zic_ack_write_valid_i     = 0;
			   zic_vif.zic_mmr_read_en_i         = 0;
			   zic_vif.zic_mmr_read_addr_i       = 0;
			   zic_vif.zic_ack_int_id_i          = 0;
			   zic_vif.zic_ack_read_valid_en     = 0;
			   zic_vif.zic_eoi_valid_i           = 0; 
			   zic_vif.zic_eoi_id_i              = 0;
			   zic_vif.zic_nxtp_valid_i          = 0;
			   zic_vif.zic_nxtp_id_i             = 0;
			   zic_vif.zic_int_pending_valid_i   = 0;
			   zic_vif.zic_int_pending_bit_i     = 0;
			   zic_vif.global_int_enable_bit_i   = 0;
			   zic_vif.global_int_enable_valid_i = 0;
			 end

      seq_item_port.item_done();
  
		end
		end
	
	endtask
endclass
	

       
