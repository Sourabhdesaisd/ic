class int_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(int_scoreboard)

  uvm_analysis_imp #(int_seq_item, int_scoreboard) sb_imp;


  // ============================================================
  // MMR READ
  // ============================================================

  int mmr_compare_count;
  int mmr_pass_count;
  int mmr_fail_count;


  // ============================================================
  // IRQ
  // ============================================================

  int irq_compare_count;
  int irq_pass_count;
  int irq_fail_count;


  // ============================================================
  // READ RESPONSE
  // ============================================================

  int read_rsp_count;
  int read_rsp_pass_count;
  int read_rsp_fail_count;


  function new(
    string name = "int_scoreboard",
    uvm_component parent
  );

    super.new(name, parent);

    sb_imp = new("sb_imp", this);

  endfunction


  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    mmr_compare_count = 0;
    mmr_pass_count    = 0;
    mmr_fail_count    = 0;

    irq_compare_count = 0;
    irq_pass_count    = 0;
    irq_fail_count    = 0;

    read_rsp_count      = 0;
    read_rsp_pass_count = 0;
    read_rsp_fail_count = 0;

  endfunction


  function void write(int_seq_item tr);

    // ==========================================================
    // MMR READ CHECK
    // ==========================================================

    if (tr.exp_mmr_read_valid &&
        tr.soc_read_rsp_o) begin

      read_rsp_count++;

      if (tr.soc_mmr_read_data_o ===
          tr.exp_mmr_read_data) begin

        read_rsp_pass_count++;

        `uvm_info(
          "MMR_READ_SCB",
          $sformatf(
            "PASS addr=0x%04h exp=0x%02h act=0x%02h",
            tr.soc_mmr_read_addr_i,
            tr.exp_mmr_read_data,
            tr.soc_mmr_read_data_o
          ),
          UVM_LOW
        );

      end
      else begin

        read_rsp_fail_count++;

        `uvm_error(
          "MMR_READ_SCB",
          $sformatf(
            "\nMMR READ FAIL"
            "\nADDR     = 0x%04h"
            "\nEXPECTED = 0x%02h"
            "\nACTUAL   = 0x%02h"
            "\nRSP      = %0b",
            tr.soc_mmr_read_addr_i,
            tr.exp_mmr_read_data,
            tr.soc_mmr_read_data_o,
            tr.soc_read_rsp_o
          )
        );

      end

    end


    // ==========================================================
    // IRQ REQUEST CHECK
    // ==========================================================

    if (tr.exp_irq_req) begin

      irq_compare_count++;

      if (tr.interrupt_request_o ===
          tr.exp_irq_req) begin

        irq_pass_count++;

        `uvm_info(
          "IRQ_SCB",
          $sformatf(
            "PASS IRQ exp=%0b act=%0b",
            tr.exp_irq_req,
            tr.interrupt_request_o
          ),
          UVM_LOW
        );

      end
      else begin

        irq_fail_count++;

        `uvm_error(
          "IRQ_SCB",
          $sformatf(
            "IRQ FAIL exp=%0b act=%0b",
            tr.exp_irq_req,
            tr.interrupt_request_o
          )
        )  ;

      end

    end

  endfunction


  function void extract_phase(uvm_phase phase);

    super.extract_phase(phase);


`uvm_info("SCB_REPORT",
  $sformatf(
    "\n========================================"
    "\n INTERRUPT CONTROLLER SCOREBOARD"
    "\n========================================"
    "\n"
    "\n MMR READ"
    "\n   COMPARE : %0d"
    "\n   PASS    : %0d"
    "\n   FAIL    : %0d"
    "\n"
    "\n IRQ"
    "\n   COMPARE : %0d"
    "\n   PASS    : %0d"
    "\n   FAIL    : %0d"
    "\n"
    "\n========================================",
    read_rsp_count,
    read_rsp_pass_count,
    read_rsp_fail_count,
    irq_compare_count,
    irq_pass_count,
    irq_fail_count
  ),
  UVM_LOW
)

  endfunction

endclass
