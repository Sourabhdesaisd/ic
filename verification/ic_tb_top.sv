//import user package (ic_pkg)
import ic_pkg::*;
//Include Interface
`include "ic_intf.sv"

module ic_tb_top;

	//clock generation
	logic clk;
	initial clk=0;
	always #5 clk = ~clk;

	

	//DUT instantiation
	  


	//Config_db for Interface set
	initial begin
		uvm_config_db#(virtual ic_intf)::set(null, "*","vif", intf);
	end
	
	//Test Intialization
	initial begin
		//run_test("ic_test");
		run_test("");
	end

	//Setting for Waveform/monitoring signals
  	initial begin

		$shm_open("waves.shm");
		$shm_probe("ACTMF");
	end

endmodule


