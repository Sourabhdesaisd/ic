`ifndef WDT_INTF_SV
`define WDT_INTF_SV

interface wdt_intf(input logic wdt_clk);

  logic wdt_rstn;

  logic        cpu_dbg_halt;
  logic        dbg_freeze;
  logic [31:0] cpu_commit_pc;
  logic        cpu_commit_valid;

  logic        wdt_reset;
  logic        wdt_timeout;
  logic [1:0]  reset_scope;

  logic [31:0] watchdog_counter;
  logic [31:0] timeout_value;
  logic [31:0] window_value;
  logic [15:0] reset_cycles;
  logic [15:0] reset_counter;

  logic        enable;
  logic        dbg_freeze_en;
  logic        refresh_valid;
  logic        refresh_error;
  logic        window_violation;
  logic        timeout_flag;
  logic [31:0] last_pc;

  logic window_en;

endinterface

`endif
