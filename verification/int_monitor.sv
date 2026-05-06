class int_monitor extends uvm_monitor;

  `uvm_component_utils(int_monitor)

  virtual intf vif;

  function new(string name = "int_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif)) begin
      `uvm_fatal("MON", "Virtual interface not found")
    end
  endfunction

  task run_phase(uvm_phase phase);

  `uvm_info("MON", "Monitor run_phase started", UVM_LOW)

  forever begin
    @(posedge vif.ic_clk);

    `uvm_info("MON",
      $sformatf("rst=%0b ext_int=%h global_en=%h threshold=%0d irq_request=%0b ack_id=%0d interrupt_out=%0d",
        vif.ic_rst,
        vif.ext_int,
        vif.global_int_enable_bit_i,
        vif.threshold,
        vif.irq_request,
        vif.zic_ack_int_id_o,
        vif.interrupt_out),
      UVM_LOW)
  end

endtask

endclass
