`ifndef WDT_MONITOR_SV
`define WDT_MONITOR_SV

class wdt_monitor;

  virtual wdt_intf vif;

  int timeout_seen;
  int reset_seen;
  int refresh_valid_seen;
  int refresh_error_seen;
  int window_violation_seen;

  function new(virtual wdt_intf vif);
    this.vif = vif;
  endfunction

  task run();
    forever begin
      @(posedge vif.wdt_clk);

      if (vif.wdt_rstn) begin

        if (vif.wdt_timeout) begin
          timeout_seen++;
          `uvm_info("WDT_MON", "wdt_timeout observed", UVM_LOW)
        end

        if (vif.wdt_reset) begin
          reset_seen++;
        end

        if (vif.refresh_valid) begin
          refresh_valid_seen++;
          `uvm_info("WDT_MON", "refresh_valid observed", UVM_LOW)
        end

        if (vif.refresh_error) begin
          refresh_error_seen++;
          `uvm_info("WDT_MON", "refresh_error observed", UVM_LOW)
        end

        if (vif.window_violation) begin
          window_violation_seen++;
          `uvm_info("WDT_MON", "window_violation observed", UVM_LOW)
        end

      end
    end
  endtask

  function void report();
    `uvm_info("WDT_MON",
      $sformatf("MON SUMMARY: timeout=%0d reset=%0d refresh_valid=%0d refresh_error=%0d window_violation=%0d",
                timeout_seen,
                reset_seen,
                refresh_valid_seen,
                refresh_error_seen,
                window_violation_seen),
      UVM_LOW)
  endfunction

endclass

`endif
