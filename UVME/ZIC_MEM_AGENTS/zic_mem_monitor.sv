class zic_mem_monitor extends uvm_monitor;

  `uvm_component_utils(zic_mem_monitor)

  zic_mem_seq_item zic_item;

  virtual zic_mem_intf zic_vif;          /////////

  uvm_analysis_port#(zic_mem_seq_item) analysis_port_monitor;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);

    analysis_port_monitor = new("analysis_port_monitor",this);
    if(!uvm_config_db#(virtual zic_mem_intf)::get(this,"","vif",zic_vif))        /////////
      `uvm_error("Monitor","No resource found")

  endfunction

  task run_phase(uvm_phase phase);
     wait(zic_vif.rst==0); 
  
  fork

    forever begin

      @(posedge zic_vif.clk )
       zic_item = zic_mem_seq_item :: type_id :: create("zic_item");
       begin
     
       zic_item.zic_mmr_write_en_i        =  zic_vif.zic_mmr_write_en_i;       
       zic_item.zic_ack_write_valid_i      =  zic_vif.zic_ack_write_valid_i;
       zic_item.zic_mmr_write_addr_i      =  zic_vif.zic_mmr_write_addr_i;    
       zic_item.zic_mmr_write_data_i      =  zic_vif.zic_mmr_write_data_i;   
       zic_item.zic_mmr_read_en_i         =  zic_vif.zic_mmr_read_en_i;     
       zic_item.zic_mmr_read_addr_i       =  zic_vif.zic_mmr_read_addr_i;      
	   zic_item.zic_ack_int_id_i          =  zic_vif.zic_ack_int_id_i;     
	   zic_item.zic_ack_read_valid_en     =  zic_vif.zic_ack_read_valid_en;    
	   zic_item.zic_eoi_valid_i           =  zic_vif.zic_eoi_valid_i;   
	   zic_item.zic_eoi_id_i              =  zic_vif.zic_eoi_id_i;             
	   zic_item.zic_nxtp_valid_i          =  zic_vif.zic_nxtp_valid_i;         
	   zic_item.zic_nxtp_id_i             =  zic_vif.zic_nxtp_id_i;            
	   zic_item.zic_int_pending_valid_i   =  zic_vif.zic_int_pending_valid_i;  
	   zic_item.zic_int_pending_bit_i     =  zic_vif.zic_int_pending_bit_i;    
	   zic_item.global_int_enable_bit_i   =  zic_vif.global_int_enable_bit_i;  
	   zic_item.global_int_enable_valid_i =  zic_vif.global_int_enable_valid_i;
	   zic_item.zic_mmr_read_data_o       =  zic_vif.zic_mmr_read_data_o;     
	   zic_item.zic_ack_int_id_o          =  zic_vif.zic_ack_int_id_o;        
	   zic_item.zic_ack_o                 =  zic_vif.zic_ack_o;               
	   zic_item.zic_eoi_o                 =  zic_vif.zic_eoi_o;               
	   zic_item.irq0_ctrl_o               =  zic_vif.irq0_ctrl_o;            
	   zic_item.irq1_ctrl_o               =  zic_vif.irq1_ctrl_o;            
	   zic_item.irq2_ctrl_o               =  zic_vif.irq2_ctrl_o;            
	   zic_item.irq3_ctrl_o               =  zic_vif.irq3_ctrl_o;            
	   zic_item.irq4_ctrl_o               =  zic_vif.irq4_ctrl_o;            
	   zic_item.irq5_ctrl_o               =  zic_vif.irq5_ctrl_o;            
	   zic_item.irq6_ctrl_o               =  zic_vif.irq6_ctrl_o;            
	   zic_item.irq7_ctrl_o               =  zic_vif.irq7_ctrl_o;            
	   zic_item.irq8_ctrl_o               =  zic_vif.irq8_ctrl_o;            
	   zic_item.irq9_ctrl_o               =  zic_vif.irq9_ctrl_o;            
	   zic_item.irq10_ctrl_o              =  zic_vif.irq10_ctrl_o;           
	   zic_item.irq11_ctrl_o              =  zic_vif.irq11_ctrl_o;           
	   zic_item.irq12_ctrl_o              =  zic_vif.irq12_ctrl_o;           
	   zic_item.irq13_ctrl_o              =  zic_vif.irq13_ctrl_o;           
	   zic_item.irq14_ctrl_o              =  zic_vif.irq14_ctrl_o;           
	   zic_item.irq15_ctrl_o              =  zic_vif.irq15_ctrl_o;           
	   zic_item.irq16_ctrl_o              =  zic_vif.irq16_ctrl_o;           
	   zic_item.irq17_ctrl_o              =  zic_vif.irq17_ctrl_o;           
	   zic_item.irq18_ctrl_o              =  zic_vif.irq18_ctrl_o;           
	   zic_item.irq19_ctrl_o              =  zic_vif.irq19_ctrl_o;           
	   zic_item.irq20_ctrl_o              =  zic_vif.irq20_ctrl_o;           
	   zic_item.irq21_ctrl_o              =  zic_vif.irq21_ctrl_o;           
	   zic_item.irq22_ctrl_o              =  zic_vif.irq22_ctrl_o;           
	   zic_item.irq23_ctrl_o              =  zic_vif.irq23_ctrl_o;           
	   zic_item.irq24_ctrl_o              =  zic_vif.irq24_ctrl_o;           
	   zic_item.irq25_ctrl_o              =  zic_vif.irq25_ctrl_o;           
	   zic_item.irq26_ctrl_o              =  zic_vif.irq26_ctrl_o;           
	   zic_item.irq27_ctrl_o              =  zic_vif.irq27_ctrl_o;           
	   zic_item.irq28_ctrl_o              =  zic_vif.irq28_ctrl_o;           
	   zic_item.irq29_ctrl_o              =  zic_vif.irq29_ctrl_o;           
	   zic_item.irq30_ctrl_o              =  zic_vif.irq30_ctrl_o;           
	   zic_item.irq31_ctrl_o              =  zic_vif.irq31_ctrl_o;           
	   zic_item.irq32_ctrl_o              =  zic_vif.irq32_ctrl_o;           
	   zic_item.irq33_ctrl_o              =  zic_vif.irq33_ctrl_o;           
	   zic_item.irq34_ctrl_o              =  zic_vif.irq34_ctrl_o;           
	   zic_item.irq35_ctrl_o              =  zic_vif.irq35_ctrl_o;           
	   zic_item.irq36_ctrl_o              =  zic_vif.irq36_ctrl_o;           
	   zic_item.irq37_ctrl_o              =  zic_vif.irq37_ctrl_o;           
	   zic_item.irq38_ctrl_o              =  zic_vif.irq38_ctrl_o;           
	   zic_item.irq39_ctrl_o              =  zic_vif.irq39_ctrl_o;           
	   zic_item.irq40_ctrl_o              =  zic_vif.irq40_ctrl_o;           
	   zic_item.irq41_ctrl_o              =  zic_vif.irq41_ctrl_o;           
	   zic_item.irq42_ctrl_o              =  zic_vif.irq42_ctrl_o;           
	   zic_item.irq43_ctrl_o              =  zic_vif.irq43_ctrl_o;           
	   zic_item.irq44_ctrl_o              =  zic_vif.irq44_ctrl_o;           
	   zic_item.irq45_ctrl_o              =  zic_vif.irq45_ctrl_o;           
	   zic_item.irq46_ctrl_o              =  zic_vif.irq46_ctrl_o;           
	   zic_item.irq47_ctrl_o              =  zic_vif.irq47_ctrl_o;
	     
      analysis_port_monitor.write(zic_item);
      $display($time,"monitor clk");
    end
   end

 forever begin

      @(negedge zic_vif.rst )

       zic_item = zic_mem_seq_item :: type_id :: create("zic_item");
       begin

       zic_item.zic_mmr_write_en_i        =  zic_vif.zic_mmr_write_en_i;       
       zic_item.zic_mmr_write_addr_i      =  zic_vif.zic_mmr_write_addr_i;    
       zic_item.zic_ack_write_valid_i     =  zic_vif.zic_ack_write_valid_i;
       zic_item.zic_mmr_write_data_i      =  zic_vif.zic_mmr_write_data_i;   
       zic_item.zic_mmr_read_en_i         =  zic_vif.zic_mmr_read_en_i;     
       zic_item.zic_mmr_read_addr_i       =  zic_vif.zic_mmr_read_addr_i;      
	   zic_item.zic_ack_int_id_i          =  zic_vif.zic_ack_int_id_i;     
	   zic_item.zic_ack_read_valid_en     =  zic_vif.zic_ack_read_valid_en;    
	   zic_item.zic_eoi_valid_i           =  zic_vif.zic_eoi_valid_i;   
	   zic_item.zic_eoi_id_i              =  zic_vif.zic_eoi_id_i;             
	   zic_item.zic_nxtp_valid_i          =  zic_vif.zic_nxtp_valid_i;         
	   zic_item.zic_nxtp_id_i             =  zic_vif.zic_nxtp_id_i;            
	   zic_item.zic_int_pending_valid_i   =  zic_vif.zic_int_pending_valid_i;  
	   zic_item.zic_int_pending_bit_i     =  zic_vif.zic_int_pending_bit_i;    
	   zic_item.global_int_enable_bit_i   =  zic_vif.global_int_enable_bit_i;  
	   zic_item.global_int_enable_valid_i =  zic_vif.global_int_enable_valid_i;
	   zic_item.zic_mmr_read_data_o       =  zic_vif.zic_mmr_read_data_o;     
	   zic_item.zic_ack_int_id_o          =  zic_vif.zic_ack_int_id_o;        
	   zic_item.zic_ack_o                 =  zic_vif.zic_ack_o;               
	   zic_item.zic_eoi_o                 =  zic_vif.zic_eoi_o;               
	   zic_item.irq0_ctrl_o               =  zic_vif.irq0_ctrl_o;            
	   zic_item.irq1_ctrl_o               =  zic_vif.irq1_ctrl_o;            
	   zic_item.irq2_ctrl_o               =  zic_vif.irq2_ctrl_o;            
	   zic_item.irq3_ctrl_o               =  zic_vif.irq3_ctrl_o;            
	   zic_item.irq4_ctrl_o               =  zic_vif.irq4_ctrl_o;            
	   zic_item.irq5_ctrl_o               =  zic_vif.irq5_ctrl_o;            
	   zic_item.irq6_ctrl_o               =  zic_vif.irq6_ctrl_o;            
	   zic_item.irq7_ctrl_o               =  zic_vif.irq7_ctrl_o;            
	   zic_item.irq8_ctrl_o               =  zic_vif.irq8_ctrl_o;            
	   zic_item.irq9_ctrl_o               =  zic_vif.irq9_ctrl_o;            
	   zic_item.irq10_ctrl_o              =  zic_vif.irq10_ctrl_o;           
	   zic_item.irq11_ctrl_o              =  zic_vif.irq11_ctrl_o;           
	   zic_item.irq12_ctrl_o              =  zic_vif.irq12_ctrl_o;           
	   zic_item.irq13_ctrl_o              =  zic_vif.irq13_ctrl_o;           
	   zic_item.irq14_ctrl_o              =  zic_vif.irq14_ctrl_o;           
	   zic_item.irq15_ctrl_o              =  zic_vif.irq15_ctrl_o;           
	   zic_item.irq16_ctrl_o              =  zic_vif.irq16_ctrl_o;           
	   zic_item.irq17_ctrl_o              =  zic_vif.irq17_ctrl_o;           
	   zic_item.irq18_ctrl_o              =  zic_vif.irq18_ctrl_o;           
	   zic_item.irq19_ctrl_o              =  zic_vif.irq19_ctrl_o;           
	   zic_item.irq20_ctrl_o              =  zic_vif.irq20_ctrl_o;           
	   zic_item.irq21_ctrl_o              =  zic_vif.irq21_ctrl_o;           
	   zic_item.irq22_ctrl_o              =  zic_vif.irq22_ctrl_o;           
	   zic_item.irq23_ctrl_o              =  zic_vif.irq23_ctrl_o;           
	   zic_item.irq24_ctrl_o              =  zic_vif.irq24_ctrl_o;           
	   zic_item.irq25_ctrl_o              =  zic_vif.irq25_ctrl_o;           
	   zic_item.irq26_ctrl_o              =  zic_vif.irq26_ctrl_o;           
	   zic_item.irq27_ctrl_o              =  zic_vif.irq27_ctrl_o;           
	   zic_item.irq28_ctrl_o              =  zic_vif.irq28_ctrl_o;           
	   zic_item.irq29_ctrl_o              =  zic_vif.irq29_ctrl_o;           
	   zic_item.irq30_ctrl_o              =  zic_vif.irq30_ctrl_o;           
	   zic_item.irq31_ctrl_o              =  zic_vif.irq31_ctrl_o;           
	   zic_item.irq32_ctrl_o              =  zic_vif.irq32_ctrl_o;           
	   zic_item.irq33_ctrl_o              =  zic_vif.irq33_ctrl_o;           
	   zic_item.irq34_ctrl_o              =  zic_vif.irq34_ctrl_o;           
	   zic_item.irq35_ctrl_o              =  zic_vif.irq35_ctrl_o;           
	   zic_item.irq36_ctrl_o              =  zic_vif.irq36_ctrl_o;           
	   zic_item.irq37_ctrl_o              =  zic_vif.irq37_ctrl_o;           
	   zic_item.irq38_ctrl_o              =  zic_vif.irq38_ctrl_o;           
	   zic_item.irq39_ctrl_o              =  zic_vif.irq39_ctrl_o;           
	   zic_item.irq40_ctrl_o              =  zic_vif.irq40_ctrl_o;           
	   zic_item.irq41_ctrl_o              =  zic_vif.irq41_ctrl_o;           
	   zic_item.irq42_ctrl_o              =  zic_vif.irq42_ctrl_o;           
	   zic_item.irq43_ctrl_o              =  zic_vif.irq43_ctrl_o;           
	   zic_item.irq44_ctrl_o              =  zic_vif.irq44_ctrl_o;           
	   zic_item.irq45_ctrl_o              =  zic_vif.irq45_ctrl_o;           
	   zic_item.irq46_ctrl_o              =  zic_vif.irq46_ctrl_o;           
	   zic_item.irq47_ctrl_o              =  zic_vif.irq47_ctrl_o;
	     
      analysis_port_monitor.write(zic_item);
      $display($time,"monitor reset");
    end
   end
join_none

  endtask

endclass
