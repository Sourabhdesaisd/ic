//==============================================================================
//========================================================
// File        : soc_base_test.sv
//========================================================
// Company     : Kyros-Semi Pvt Ltd.
// Project     : Pinaka SoC Verification
// Description : Base test which enables I2C,SPI, UART VIP's
//
// Author      : Ganesh K S(ganesh.ks@kyros-semi.com)
// Created On  : 29-May-2026
//
// Copyright (c) 2026 Kyros-Semi Pvt Ltd
// Confidential Proprietary Information
//==============================================================================
import tb_sync_pkg::*;
class soc_base_test extends uvm_test;

    `uvm_component_utils(soc_base_test)
      i2c_cfg cfg;
    soc_env env_h;
    serial_agt_config serial_agt_cfg;
    jtag_env env;

    int_config int_cfg;
    ext_interrupt_seq int_seq;

    //virtual uart_if vif;

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        cfg = i2c_cfg::type_id::create("cfg");
        uvm_config_db#(i2c_cfg)::set(this,"*","cfg",cfg);
        env = jtag_env::type_id::create("env",this);

        int_cfg = int_config::type_id::create("int_cfg");

        uvm_config_db#(int_config)::set(this,"*","int_cfg",int_cfg);
        


        //env_h =soc_env::type_id::create("env_h",this);
         env_h = soc_env::type_id::create("env_h", this);
         serial_agt_cfg = serial_agt_config::type_id::create("serial_agt_cfg");
         serial_agt_cfg.is_active = UVM_ACTIVE;
         uvm_config_db #(serial_agt_config) :: set(this,"*","serial_agt_config",serial_agt_cfg);
         

         if(!uvm_config_db#(virtual uart_if)::get(this," ","uart_vif",serial_agt_cfg.vif))
             `uvm_fatal(get_full_name(),"unable to get agt_cfg.vif");
    endfunction

    task boot_flow();
        boot_flow_seq seq;
        seq = boot_flow_seq::type_id::create("seq");
        seq.start(env.agent.seqr);
    endtask

    task run_phase(uvm_phase phase);
        //boot_flow_seq seq;
        phase.raise_objection(this);
        //seq = boot_flow_seq::type_id::create("seq");
        //seq.start(env.agent.seqr);
        boot_flow();
        #1ms;
        //Send handshake to C
        //handshake_from_sv_to_c=1;

        //wait_for_handshake();
        wait(handshake_from_c_to_sv==1);
        handshake_from_c_to_sv=0;
        //$display("Handshake Reeived from C to SV\n");
        phase.drop_objection(this);
    endtask

endclass


class soc_i2c_test extends soc_base_test;

    `uvm_component_utils(soc_i2c_test)
    i2c_cfg cfg;
 //   soc_env env_h;
   
    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
          cfg = i2c_cfg::type_id::create("cfg");

        // Add multiple slave addresses here
        
         `ifdef SLV_AD_ER 
            for(int i=0;i<5;i++) 
                cfg.addr.push_back(i);
         `else
            for(int i=0;i<128;i++) 
                cfg.addr.push_back(i);
         `endif

        uvm_config_db#(i2c_cfg)::set(this,"*","cfg",cfg);


    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #1ms;
        //Send handshake to C
        handshake_from_sv_to_c=1;
        $display($time,"sent handshake from sv to c");
        //wait_for_handshake();
        wait(handshake_from_c_to_sv==1);
        handshake_from_c_to_sv=0;
        $display("Handshake Reeived from C to SV\n");
        phase.drop_objection(this);
    endtask

endclass


//******** Added by Selvakumar *************************\\

class soc_mmu_pte_test extends uvm_test;
//class soc_mmu_pte_test extends soc_base_test;
    `uvm_component_utils(soc_mmu_pte_test)

    //soc_env env_h;
    jtag_env env;

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env  = jtag_env::type_id::create("env"  , this);
        //env_h = soc_env::type_id::create("env_h", this);

    endfunction

    task boot_flow();
        boot_flow_seq seq;
        seq = boot_flow_seq::type_id::create("seq");
        seq.start(env.agent.seqr);
    endtask

    task halt_cpu_write_pte();
	cpu_halt_seq   halt_seq;
	pte_write_seq  pte_mem_seq;
	cpu_resume_seq resume_seq;
//	dmstatus_read_seq  status_seq;

	// Check DMSTATUS
//	status_seq = dmstatus_read_seq::type_id::create("status_seq");
//	status_seq.start(env.agent.seqr);

	// Halt running CPU
	halt_seq = cpu_halt_seq::type_id::create("halt_seq");
	halt_seq.start(env.agent.seqr);
	
	//write_pte
	pte_mem_seq = pte_write_seq::type_id::create("pte_mem_seq");
	pte_mem_seq.start(env.agent.seqr);


 	//  Resume CPU
	resume_seq = cpu_resume_seq::type_id::create("resume_seq");
	resume_seq.start(env.agent.seqr);

	// Halt running CPU
	//halt_seq = cpu_halt_seq::type_id::create("halt_seq");
	//halt_seq.start(env.agent.seqr);

    endtask

    task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	        boot_flow();

    		//repeat (1000) #20ns;
		halt_cpu_write_pte();

        	//Send handshake to C
	        handshake_from_sv_to_c=1;
		$display("Handshake Send to C from SV\n");

	        //wait_for_handshake();
	        wait(handshake_from_c_to_sv==1);
	        handshake_from_c_to_sv=0;
	        $display("Handshake Received from C to SV\n");
	phase.drop_objection(this);
    endtask

endclass

