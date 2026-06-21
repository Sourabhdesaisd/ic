`ifndef WDT_SCB_SV
`define WDT_SCB_SV

class wdt_scb;

  virtual wdt_intf vif;

  int pass_count;
  int fail_count;

  bit [31:0] prev_counter;
  bit [31:0] prev_cpu_commit_pc;
  bit        prev_cpu_commit_valid;
  bit        prev_wdt_reset;

  bit timeout_pending;
  int timeout_wait_count;

  int max_reset_counter;

  bit [31:0] freeze_ref_counter;
  int        freeze_stable_count;
  bit        freeze_active;

  bit        refresh_violation_pending;
  int        refresh_violation_wait;
  bit [31:0] refresh_counter_sample;
  bit [31:0] refresh_window_sample;

  function new(virtual wdt_intf vif);
    this.vif = vif;

    pass_count = 0;
    fail_count = 0;

    prev_counter          = 32'h0;
    prev_cpu_commit_pc    = 32'h0;
    prev_cpu_commit_valid = 1'b0;
    prev_wdt_reset        = 1'b0;

    timeout_pending    = 1'b0;
    timeout_wait_count = 0;

    max_reset_counter = 0;

    freeze_ref_counter  = 32'h0;
    freeze_stable_count = 0;
    freeze_active       = 1'b0;

    refresh_violation_pending = 1'b0;
    refresh_violation_wait    = 0;
    refresh_counter_sample    = 32'h0;
    refresh_window_sample     = 32'h0;
  endfunction


  task run();

    forever begin
      @(posedge vif.wdt_clk);

      if (vif.wdt_rstn) begin

        //=====================================================
        // LAST_PC CHECK
        //=====================================================
        if (prev_cpu_commit_valid) begin
          if (vif.last_pc !== prev_cpu_commit_pc) begin
            fail_count++;
            `uvm_error("WDT_SCB",
              $sformatf("LAST_PC FAIL expected=0x%08h actual=0x%08h",
                        prev_cpu_commit_pc, vif.last_pc))
          end
          else begin
            pass_count++;
            `uvm_info("WDT_SCB",
              $sformatf("LAST_PC PASS expected=0x%08h actual=0x%08h",
                        prev_cpu_commit_pc, vif.last_pc),
              UVM_LOW)
          end
        end


        //=====================================================
        // DEBUG FREEZE CHECK
        //=====================================================
        freeze_active = vif.enable &&
                        vif.dbg_freeze_en &&
                        (vif.cpu_dbg_halt || vif.dbg_freeze);

        if (freeze_active) begin

          if (freeze_stable_count == 0) begin
            freeze_ref_counter  = vif.watchdog_counter;
            freeze_stable_count = 1;

            `uvm_info("WDT_SCB",
              $sformatf("DEBUG_FREEZE START halt=%0b dbg_freeze=%0b counter=%0d",
                        vif.cpu_dbg_halt,
                        vif.dbg_freeze,
                        vif.watchdog_counter),
              UVM_LOW)
          end
          else if (freeze_stable_count < 3) begin
            freeze_ref_counter  = vif.watchdog_counter;
            freeze_stable_count++;
          end
          else begin
            if (vif.watchdog_counter !== freeze_ref_counter) begin
              fail_count++;

              `uvm_error("WDT_SCB",
                $sformatf("DEBUG_FREEZE FAIL expected_counter=%0d actual_counter=%0d halt=%0b dbg_freeze=%0b",
                          freeze_ref_counter,
                          vif.watchdog_counter,
                          vif.cpu_dbg_halt,
                          vif.dbg_freeze))
            end
            else begin
              pass_count++;

              `uvm_info("WDT_SCB",
                $sformatf("DEBUG_FREEZE PASS expected_counter=%0d actual_counter=%0d halt=%0b dbg_freeze=%0b",
                          freeze_ref_counter,
                          vif.watchdog_counter,
                          vif.cpu_dbg_halt,
                          vif.dbg_freeze),
                UVM_LOW)
            end
          end
        end
        else begin
          freeze_stable_count = 0;
          freeze_ref_counter  = vif.watchdog_counter;
        end


        //=====================================================
        // TIMEOUT CHECK
        //=====================================================
        if (prev_counter == 1 && vif.watchdog_counter == 0) begin
          timeout_pending    = 1'b1;
          timeout_wait_count = 0;
        end

        if (timeout_pending) begin
          if (vif.timeout_flag || vif.wdt_timeout) begin
            pass_count++;

            `uvm_info("WDT_SCB",
              $sformatf("TIMEOUT PASS expected_timeout=1 actual_timeout=%0b timeout_flag=%0b",
                        vif.wdt_timeout,
                        vif.timeout_flag),
              UVM_LOW)

            timeout_pending    = 1'b0;
            timeout_wait_count = 0;
          end
          else begin
            timeout_wait_count++;

            if (timeout_wait_count > 1) begin
              fail_count++;

              `uvm_error("WDT_SCB",
                $sformatf("TIMEOUT FAIL expected_timeout=1 actual_timeout=%0b timeout_flag=%0b",
                          vif.wdt_timeout,
                          vif.timeout_flag))

              timeout_pending    = 1'b0;
              timeout_wait_count = 0;
            end
          end
        end


        //=====================================================
        // REFRESH CHECK
        //
        // Case 1: refresh_valid + window_en + counter > window
        //         Expected: delayed window_violation.
        //
        // Case 2: legal refresh
        //         Expected: counter reloads to timeout_value.
        //=====================================================
        if (vif.refresh_valid) begin

          if (vif.window_en &&
              (vif.watchdog_counter > vif.window_value)) begin

            refresh_violation_pending = 1'b1;
            refresh_violation_wait    = 0;
            refresh_counter_sample    = vif.watchdog_counter;
            refresh_window_sample     = vif.window_value;

            `uvm_info("WDT_SCB",
              $sformatf("REFRESH_VALID observed expected_refresh_valid=1 actual_refresh_valid=%0b expected_counter_greater_than_window=1 actual_counter_greater_than_window=%0b expected_counter=%0d actual_counter=%0d expected_window=%0d actual_window=%0d ",
                        vif.refresh_valid,
                        (vif.watchdog_counter > vif.window_value),
                        refresh_counter_sample,
                        vif.watchdog_counter,
                        refresh_window_sample,
                        vif.window_value),
              UVM_LOW)

          end
          else begin

            if ((vif.watchdog_counter == vif.timeout_value) ||
                (vif.watchdog_counter == vif.timeout_value - 1)) begin
              pass_count++;

              `uvm_info("WDT_SCB",
                $sformatf("REFRESH PASS expected=%0d actual=%0d",
                          vif.timeout_value,
                          vif.watchdog_counter),
                UVM_LOW)
            end
            else begin
              fail_count++;

              `uvm_error("WDT_SCB",
                $sformatf("REFRESH FAIL expected=%0d actual=%0d",
                          vif.timeout_value,
                          vif.watchdog_counter))
            end
          end
        end


        //=====================================================
        // DELAYED WINDOW VIOLATION CHECK
        //=====================================================
        if (refresh_violation_pending) begin

          if (vif.window_violation) begin
            pass_count++;

            `uvm_info("WDT_SCB",
              $sformatf("REFRESH WINDOW_VIOLATION PASS expected_refresh_valid=1 actual_refresh_valid=1 expected_window_violation=1 actual_window_violation=%0b expected_counter=%0d actual_counter=%0d expected_window=%0d actual_window=%0d",
                        vif.window_violation,
                        refresh_counter_sample,
                        vif.watchdog_counter,
                        refresh_window_sample,
                        vif.window_value),
              UVM_LOW)

            refresh_violation_pending = 1'b0;
            refresh_violation_wait    = 0;
          end
          else begin
            refresh_violation_wait++;

            if (refresh_violation_wait > 3) begin
              fail_count++;

              `uvm_error("WDT_SCB",
                $sformatf("REFRESH WINDOW_VIOLATION FAIL expected_refresh_valid=1 actual_refresh_valid=1 expected_window_violation=1 actual_window_violation=%0b expected_counter=%0d actual_counter=%0d expected_window=%0d actual_window=%0d",
                          vif.window_violation,
                          refresh_counter_sample,
                          vif.watchdog_counter,
                          refresh_window_sample,
                          vif.window_value))

              refresh_violation_pending = 1'b0;
              refresh_violation_wait    = 0;
            end
          end
        end


        //=====================================================
        // RESET WIDTH CHECK
        // kept same as your working code
        //=====================================================
        if (!prev_wdt_reset && vif.wdt_reset) begin
          max_reset_counter = vif.reset_counter;
        end
        else if (vif.wdt_reset) begin
          if (vif.reset_counter > max_reset_counter)
            max_reset_counter = vif.reset_counter;
        end
        else if (prev_wdt_reset && !vif.wdt_reset) begin

          if (max_reset_counter == vif.reset_cycles) begin
            pass_count++;

            `uvm_info("WDT_SCB",
              $sformatf("RESET_WIDTH PASS expected=%0d actual=%0d",
                        vif.reset_cycles,
                        max_reset_counter),
              UVM_LOW)
          end
          else begin
            fail_count++;

            `uvm_error("WDT_SCB",
              $sformatf("RESET_WIDTH FAIL expected=%0d actual=%0d",
                        vif.reset_cycles,
                        max_reset_counter))
          end

          max_reset_counter = 0;
        end


        //=====================================================
        // UPDATE PREVIOUS VALUES
        //=====================================================
        prev_counter          = vif.watchdog_counter;
        prev_cpu_commit_pc    = vif.cpu_commit_pc;
        prev_cpu_commit_valid = vif.cpu_commit_valid;
        prev_wdt_reset        = vif.wdt_reset;

      end
      else begin

        prev_counter          = 32'h0;
        prev_cpu_commit_pc    = 32'h0;
        prev_cpu_commit_valid = 1'b0;
        prev_wdt_reset        = 1'b0;

        timeout_pending       = 1'b0;
        timeout_wait_count    = 0;

        max_reset_counter     = 0;

        freeze_ref_counter    = 32'h0;
        freeze_stable_count   = 0;
        freeze_active         = 1'b0;

        refresh_violation_pending = 1'b0;
        refresh_violation_wait    = 0;
        refresh_counter_sample    = 32'h0;
        refresh_window_sample     = 32'h0;

      end
    end

  endtask


  function void report();

    `uvm_info("WDT_SCB",
      $sformatf("FINAL SCOREBOARD: PASS=%0d FAIL=%0d",
                pass_count, fail_count),
      UVM_LOW)

    if (fail_count == 0)
      `uvm_info("WDT_SCB", "WDT SCOREBOARD RESULT: PASS", UVM_LOW)
    else
      `uvm_error("WDT_SCB", "WDT SCOREBOARD RESULT: FAIL")

  endfunction

endclass

`endif
