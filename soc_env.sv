//==============================================================================
//========================================================
// File        : soc_env.sv
//========================================================
// Company     : Kyros-Semi Pvt Ltd.
// Project     : Pinaka SoC Verification
// Description : soc environment
//
// Author      : Ganesh K S(ganesh.ks@kyros-semi.com)
// Created On  : 29-May-2026
//
// Copyright (c) 2026 Kyros-Semi Pvt Ltd
// Confidential Proprietary Information
//==============================================================================
class soc_env extends uvm_env;

    `uvm_component_utils(soc_env)
    //axi_agent          axi_agent_soc;
    spi_agent          spi_agent_soc;
    i2c_agent    i2c_agent_soc;
    serial_agent    uart_agent_soc;
    serial_agt_config serial_agt_cfg;

    int_agent int_agent_h;

    
//   gpio_agent       gpio_agent_h;
//   uart_agent       uart_agent_h;
    function new(string name = "soc_env",uvm_component parent);
    super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      //axi_agent_soc = axi_agent::type_id::create("axi_agent_soc", this);
      spi_agent_soc = spi_agent::type_id::create("spi_agent_soc", this);
      i2c_agent_soc = i2c_agent::type_id::create("i2c_agent_soc", this);
      
      //serial_agt_cfg = serial_agt_config::type_id::create("serial_agt_cfg");
      //serial_agt_cfg.is_active = UVM_ACTIVE;
      //uvm_config_db #(serial_agt_config) :: set(this,"*","serial_agt_config",serial_agt_cfg);

      uart_agent_soc = serial_agent::type_id::create("uart_agent_soc", this);

        int_seqr = int_sequencer::type_id::create("int_seqr", this);

        int_drv  = int_driver::type_id::create("int_drv", this);

     //TODO update for uart and spi
        // gpio_agent_h =
     //    gpio_agent::type_id::create(
     //       "gpio_agent_h", this);
    endfunction

    function void connect_phase(uvm_phase phase);
       	super.connect_phase(phase);
        //TODO
    endfunction

endclass
