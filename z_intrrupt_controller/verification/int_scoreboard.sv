/*class int_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(int_scoreboard)

  function new(string name = "int_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction


endclass*/

class int_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(int_scoreboard)

  uvm_analysis_imp #(int_seq_item, int_scoreboard) sb_imp;

  int pass_count;
  int fail_count;

  function new(string name = "int_scoreboard", uvm_component parent);
    super.new(name, parent);
    sb_imp = new("sb_imp", this);
  endfunction

  function void write(int_seq_item tr);

    if (!tr.exp_valid)
      return;

    if (tr.zic_ack_int_id_o !== tr.exp_ack_id) begin
      fail_count++;

      `uvm_error("ZIC_SCB",
        $sformatf("FAIL ACK_ID: exp_ack=0x%0h act_ack=0x%0h exp_lvl_pr=0x%0h act_lvl_pr=0x%0h ack_read_valid=%0b",
                  tr.exp_ack_id,
                  tr.zic_ack_int_id_o,
                  tr.exp_highest_lvl_pr,
                  tr.highest_pending_lvl_pr_o,
                  tr.zic_ack_read_valid_en))
    end
    else begin
      pass_count++;

      `uvm_info("ZIC_SCB",
        $sformatf("PASS ACK_ID: ack=0x%0h exp_lvl_pr=0x%0h act_lvl_pr=0x%0h",
                  tr.zic_ack_int_id_o,
                  tr.exp_highest_lvl_pr,
                  tr.highest_pending_lvl_pr_o),
        UVM_LOW)
    end

  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    `uvm_info("ZIC_SCB_REPORT",
      $sformatf("PASS_COUNT=%0d FAIL_COUNT=%0d",
                pass_count,
                fail_count),
      UVM_NONE)
  endfunction

endclass

