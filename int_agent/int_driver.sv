class int_driver extends uvm_driver #(int_seq_item);

    `uvm_component_utils(int_driver)

    virtual intf vif;

    function new(string name,uvm_component parent);

        super.new(name,parent);

    endfunction


    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        if(!uvm_config_db #(virtual intf)::get(this,"","vif",vif))
            `uvm_fatal("DRV","No Interface");

    endfunction


    task drive_idle();

        vif.ext_int10_i <= 0;
        vif.ext_int11_i <= 0;
        vif.ext_int12_i <= 0;
        vif.ext_int13_i <= 0;
        vif.ext_int14_i <= 0;
        vif.ext_int15_i <= 0;

    endtask


    task run_phase(uvm_phase phase);

        drive_idle();

        forever begin

            seq_item_port.get_next_item(req);

            @(posedge vif.soc_clk);

            vif.ext_int10_i <= req.ext_int10_i;
            vif.ext_int11_i <= req.ext_int11_i;
            vif.ext_int12_i <= req.ext_int12_i;
            vif.ext_int13_i <= req.ext_int13_i;
            vif.ext_int14_i <= req.ext_int14_i;
            vif.ext_int15_i <= req.ext_int15_i;

            @(posedge vif.soc_clk);

            drive_idle();

            seq_item_port.item_done();

        end

    endtask

endclass
