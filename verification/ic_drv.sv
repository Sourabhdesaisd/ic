class ic_drv extends uvm_driver #(ic_seq_item);
	//Factory registration
	`uvm_component_utils(ic_drv)

	//Declare seq_item & interface handles
	ic_seq_item seq_item;
	virtual ic_intf intf;

	//Constructor new()
	function new(string name="ic_drv", uvm_component parent);
		super.new(name,parent);
	endfunction

	//Build_phase for getting interface
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual ic_intf)::get(this,"","vif",intf))
		`uvm_fatal(get_type_name(),"DRV_INTERFACE IS NOT SET")
	endfunction

	//Run_phase to drive stimulus
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
	
		forever begin
			seq_item_port.get_next_item(seq_item);
			driver_logic(seq_item);
			seq_item_port.item_done();
		end
	endtask

	//Driver logic

	

endclass
	
