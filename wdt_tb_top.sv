`include "../monitor/wdt_monitor.sv"
`include "../scoreboard/wdt_scb.sv"




module wdt_tb_top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // -----------------------------------------
  // Clocks and resets
  // -----------------------------------------
  bit pclk;
  bit preset_n;

  bit wdt_clk;
//  bit wdt_rstn;

  // -----------------------------------------
  // APB interface
  // -----------------------------------------
  apb_if apb_vif (
    .pclk    (pclk),
    .preset_n(preset_n)
  );

   // -----------------------------------------
  // APB VIP master BFM
  // -----------------------------------------
  apb_master_agent_bfm apb_master_bfm_h (
    .intf(apb_vif)
  );


  // -----------------------------------------

  // -----------------------------------------
wdt_intf wdt_vintf(wdt_clk);

  // -----------------------------------------
  // Clock generation
  // -----------------------------------------
  initial begin
    pclk = 1'b0;
    forever #5 pclk = ~pclk;
  end

  initial begin
    wdt_clk = 1'b0;
    forever #10 wdt_clk = ~wdt_clk;
  end

  // -----------------------------------------
  // Reset generation
  // -----------------------------------------
  initial begin
    preset_n = 1'b1;
   wdt_vintf.wdt_rstn = 1'b1;

    #1;
    preset_n = 1'b0;
    wdt_vintf.wdt_rstn = 1'b0;

    repeat (5) @(posedge pclk);

    preset_n = 1'b1;
    wdt_vintf.wdt_rstn = 1'b1;
  end

 
  // -----------------------------------------
  // Watchdog DUT
  // -----------------------------------------
  watchdog_timer #(
    .ADDR_WIDTH(32),
    .DATA_WIDTH(32),
    .XLEN      (32)
  ) dut (
    .pclk     (pclk),
    .presetn  (preset_n),

    .psel     (apb_vif.pselx[0]),
    .penable  (apb_vif.penable),
    .pwrite   (apb_vif.pwrite),
    .paddr    (apb_vif.paddr),
    .pwdata   (apb_vif.pwdata),
    .prdata   (apb_vif.prdata),
    .pready   (apb_vif.pready),
    .pslverr  (apb_vif.pslverr),

    .wdt_clk  (wdt_clk),
    .wdt_rstn (wdt_vintf.wdt_rstn),

    .cpu_dbg_halt     (wdt_vintf.cpu_dbg_halt),
    .dbg_freeze       (wdt_vintf.dbg_freeze),
    .cpu_commit_pc    (wdt_vintf.cpu_commit_pc),
    .cpu_commit_valid (wdt_vintf.cpu_commit_valid),

    .wdt_reset   (wdt_vintf.wdt_reset),
    .wdt_timeout (wdt_vintf.wdt_timeout),
    .reset_scope (wdt_vintf.reset_scope)
  );


initial begin
  uvm_config_db#(virtual wdt_intf)::set(
    null,
    "*",
    "wdt_vintf",
    wdt_vintf
  );
end
  

  // -----------------------------------------
  // -----------------------------------------
  initial begin
    $shm_open("wave.shm");
    $shm_probe("ACTMF");
  end

  // -----------------------------------------
  // -----------------------------------------
  initial begin
    run_test();
  end

  initial begin
  
  wdt_vintf.cpu_dbg_halt = 1'b0;
  wdt_vintf.dbg_freeze   = 1'b0;

  wdt_vintf.cpu_commit_pc=0;
  wdt_vintf.cpu_commit_valid =0 ;

  end


  assign wdt_vintf.watchdog_counter = dut.watchdog_counter;
assign wdt_vintf.timeout_value     = dut.timeout_value;
assign wdt_vintf.window_value      = dut.window_value;
assign wdt_vintf.reset_cycles      = dut.reset_cycles;
assign wdt_vintf.reset_counter     = dut.reset_counter;

assign wdt_vintf.enable            = dut.enable;
assign wdt_vintf.dbg_freeze_en     = dut.dbg_freeze_en;
assign wdt_vintf.refresh_valid     = dut.refresh_valid;
assign wdt_vintf.refresh_error     = dut.refresh_error;
assign wdt_vintf.window_violation  = dut.window_violation_wdt;
assign wdt_vintf.timeout_flag      = dut.timeout_flag_wdt;
assign wdt_vintf.last_pc           = dut.last_pc;

assign wdt_vintf.window_en = dut.window_en;


wdt_monitor    wdt_mon_h;
wdt_scb wdt_scb_h;

initial begin
  wdt_mon_h = new(wdt_vintf);
  wdt_scb_h = new(wdt_vintf);

  fork
    wdt_mon_h.run();
    wdt_scb_h.run();
  join_none
end

final begin
  wdt_mon_h.report();
  wdt_scb_h.report();
end

    

  

endmodule
