
module wdt_tb_top;

  import uvm_pkg::*;

  
  
  `include "uvm_macros.svh"

  // -----------------------------------------
  // Clocks and resets
  // -----------------------------------------
  bit pclk;
  bit preset_n;

  bit wdt_clk;
  bit wdt_rstn;

  // -----------------------------------------
  // WDT extra signals
  // -----------------------------------------
  logic        cpu_dbg_halt;
  logic        dbg_freeze;
  logic [31:0] cpu_commit_pc;
  logic        cpu_commit_valid;

  logic        wdt_reset;
  logic        wdt_timeout;
  logic [1:0]  reset_scope;

  // -----------------------------------------
  // Clock generation
  // -----------------------------------------
  initial begin
    pclk = 0;
    forever #5 pclk = ~pclk;       
  end

  initial begin
    wdt_clk = 0;
    forever #10 wdt_clk = ~wdt_clk;
    end

  // -----------------------------------------
  // Reset generation
  // -----------------------------------------
 initial begin
  preset_n = 1'b1;
  wdt_rstn = 1'b1;

  #1;
  preset_n = 1'b0;
  wdt_rstn = 1'b0;

  repeat(5) @(posedge pclk);

  preset_n = 1'b1;
  wdt_rstn = 1'b1;
end
  // -----------------------------------------
  // Instantiate APB interface
  // -----------------------------------------
  apb_if apb_vif (
    .pclk    (pclk),
    .preset_n(preset_n)
  );

  // -----------------------------------------
  // Instantiate APB master agent BFM
  // This connects APB VIP HDL side to interface
  // -----------------------------------------
  apb_master_agent_bfm apb_master_bfm_h (
    .intf(apb_vif)
  );

  // -----------------------------------------
  // Instantiate Watchdog DUT
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
    .wdt_rstn (wdt_rstn),

    .cpu_dbg_halt    (cpu_dbg_halt),
    .dbg_freeze      (dbg_freeze),
    .cpu_commit_pc   (cpu_commit_pc),
    .cpu_commit_valid(cpu_commit_valid),

    .wdt_reset  (wdt_reset),
    .wdt_timeout(wdt_timeout),
    .reset_scope(reset_scope)
  );

 
   initial begin
    $shm_open("wave.shm");
    $shm_probe("ACTMF");
  end
initial begin
run_test();
end
endmodule
