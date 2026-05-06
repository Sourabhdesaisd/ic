class int_driver extends uvm_driver #(int_seq_item);

  `uvm_component_utils(int_driver)

  virtual intf vif;

  function new(string name = "int_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif)) begin
      `uvm_fatal("DRV", "Virtual interface not found")
    end
  endfunction


  task drive_idle();

    vif.ic_rst                    <= 1'b0;
    vif.ic_rst_ack                <= 1'b0;

    vif.ext_int                   <= '0;
    vif.threshold                 <= '0;

    vif.zic_mmr_write_en_i        <= 1'b0;
    vif.zic_mmr_write_addr_i      <= '0;
    vif.zic_mmr_write_data_i      <= '0;

    vif.zic_mmr_read_en_i         <= 1'b0;
    vif.zic_mmr_read_addr_i       <= '0;

    vif.zic_ack_read_valid_en     <= 1'b0;

    vif.zic_eoi_valid_i           <= 1'b0;
    vif.zic_eoi_id_i              <= '0;

    vif.global_int_enable_bit_i   <= '0;
    vif.global_int_enable_valid_i <= 1'b0;

  endtask


  task drive_normal(int_seq_item tr);

    vif.ic_rst                    <= 1'b0;
    vif.ic_rst_ack                <= 1'b0;

    vif.ext_int                   <= tr.ext_int;
    vif.threshold                 <= tr.threshold;

    vif.zic_mmr_write_en_i        <= tr.zic_mmr_write_en_i;
    vif.zic_mmr_write_addr_i      <= tr.zic_mmr_write_addr_i;
    vif.zic_mmr_write_data_i      <= tr.zic_mmr_write_data_i;

    vif.zic_mmr_read_en_i         <= tr.zic_mmr_read_en_i;
    vif.zic_mmr_read_addr_i       <= tr.zic_mmr_read_addr_i;

    vif.zic_ack_read_valid_en     <= tr.zic_ack_read_valid_en;

    vif.zic_eoi_valid_i           <= tr.zic_eoi_valid_i;
    vif.zic_eoi_id_i              <= tr.zic_eoi_id_i;

    vif.global_int_enable_bit_i   <= tr.global_int_enable_bit_i;
    vif.global_int_enable_valid_i <= tr.global_int_enable_valid_i;

    @(posedge vif.ic_clk);

  endtask


  task drive_reset();

    `uvm_info("DRV", "RESET transaction received", UVM_LOW)

    drive_idle();

    @(posedge vif.ic_clk);
    vif.ic_rst <= 1'b1;

    repeat (5) @(posedge vif.ic_clk);

    vif.ic_rst <= 1'b0;

    repeat (2) @(posedge vif.ic_clk);

    `uvm_info("DRV", "RESET done", UVM_LOW)

  endtask


  task run_phase(uvm_phase phase);

    `uvm_info("DRV", "Driver run_phase started", UVM_LOW)

    drive_idle();

    forever begin

      seq_item_port.get_next_item(req);

      if (req.do_reset) begin
        drive_reset();
      end
      else begin
        `uvm_info("DRV", "Normal transaction received", UVM_LOW)
        drive_normal(req);
      end

      seq_item_port.item_done();

    end

  endtask

endclass
