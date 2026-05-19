`timescale 1ns/1ps

module tb_interrupt_controller;

// ============================================================
//  DUT Signal Declarations
// ============================================================

reg          zic_clk;
reg          zic_rst;

// MMR Write Interface
reg          zic_mmr_write_en_i;
reg  [15:0]  zic_mmr_write_addr_i;
reg  [31:0]  zic_mmr_write_data_i;

// MMR Read Interface
reg          zic_mmr_read_en_i;
reg  [15:0]  zic_mmr_read_addr_i;
wire [31:0]  zic_mmr_read_data_o;

// ACK / EOI
reg          zic_ack_read_valid_en;
wire [7:0]   zic_ack_int_id_o;
reg          zic_eoi_valid_i;
reg  [7:0]   zic_eoi_id_i;

// CSR / Global enables
reg  [7:0]   active_lvl_pr_i;
wire         interrupt_request_o;
reg  [47:0]  global_int_enable_bit_i;
reg          global_int_enable_valid_i;
wire [7:0]   highest_pending_lvl_pr_o;

// External Interrupts (046)
reg          ext_int0_i,  ext_int1_i,  ext_int2_i,  ext_int3_i;
reg          ext_int4_i,  ext_int5_i,  ext_int6_i,  ext_int7_i;
reg          ext_int8_i,  ext_int9_i,  ext_int10_i, ext_int11_i;
reg          ext_int12_i, ext_int13_i, ext_int14_i, ext_int15_i;
reg          ext_int16_i, ext_int17_i, ext_int18_i, ext_int19_i;
reg          ext_int20_i, ext_int21_i, ext_int22_i, ext_int23_i;
reg          ext_int24_i, ext_int25_i, ext_int26_i, ext_int27_i;
reg          ext_int28_i, ext_int29_i, ext_int30_i, ext_int31_i;
reg          ext_int32_i, ext_int33_i, ext_int34_i, ext_int35_i;
reg          ext_int36_i, ext_int37_i, ext_int38_i, ext_int39_i;
reg          ext_int40_i, ext_int41_i, ext_int42_i, ext_int43_i;
reg          ext_int44_i, ext_int45_i, ext_int46_i;

// Debug / WDT
reg          debug_mode_valid_i;
reg          debug_mode_reset_i;
reg          debug_ndm_reset_i;
wire         wdt_reset_o;

// ============================================================
//  DUT Instantiation
// ============================================================

zilla_interrupt_control DUT (
    .zic_clk                 (zic_clk),
    .zic_rst                 (zic_rst),
    .zic_mmr_write_en_i      (zic_mmr_write_en_i),
    .zic_mmr_write_addr_i    (zic_mmr_write_addr_i),
    .zic_mmr_write_data_i    (zic_mmr_write_data_i),
    .zic_mmr_read_en_i       (zic_mmr_read_en_i),
    .zic_mmr_read_addr_i     (zic_mmr_read_addr_i),
    .zic_mmr_read_data_o     (zic_mmr_read_data_o),
    .zic_ack_read_valid_en   (zic_ack_read_valid_en),
    .zic_ack_int_id_o        (zic_ack_int_id_o),
    .zic_eoi_valid_i         (zic_eoi_valid_i),
    .zic_eoi_id_i            (zic_eoi_id_i),
    .active_lvl_pr_i         (active_lvl_pr_i),
    .interrupt_request_o     (interrupt_request_o),
    .global_int_enable_bit_i (global_int_enable_bit_i),
    .global_int_enable_valid_i(global_int_enable_valid_i),
    .highest_pending_lvl_pr_o(highest_pending_lvl_pr_o),
    .ext_int0_i              (ext_int0_i),
    .ext_int1_i              (ext_int1_i),
    .ext_int2_i              (ext_int2_i),
    .ext_int3_i              (ext_int3_i),
    .ext_int4_i              (ext_int4_i),
    .ext_int5_i              (ext_int5_i),
    .ext_int6_i              (ext_int6_i),
    .ext_int7_i              (ext_int7_i),
    .ext_int8_i              (ext_int8_i),
    .ext_int9_i              (ext_int9_i),
    .ext_int10_i             (ext_int10_i),
    .ext_int11_i             (ext_int11_i),
    .ext_int12_i             (ext_int12_i),
    .ext_int13_i             (ext_int13_i),
    .ext_int14_i             (ext_int14_i),
    .ext_int15_i             (ext_int15_i),
    .ext_int16_i             (ext_int16_i),
    .ext_int17_i             (ext_int17_i),
    .ext_int18_i             (ext_int18_i),
    .ext_int19_i             (ext_int19_i),
    .ext_int20_i             (ext_int20_i),
    .ext_int21_i             (ext_int21_i),
    .ext_int22_i             (ext_int22_i),
    .ext_int23_i             (ext_int23_i),
    .ext_int24_i             (ext_int24_i),
    .ext_int25_i             (ext_int25_i),
    .ext_int26_i             (ext_int26_i),
    .ext_int27_i             (ext_int27_i),
    .ext_int28_i             (ext_int28_i),
    .ext_int29_i             (ext_int29_i),
    .ext_int30_i             (ext_int30_i),
    .ext_int31_i             (ext_int31_i),
    .ext_int32_i             (ext_int32_i),
    .ext_int33_i             (ext_int33_i),
    .ext_int34_i             (ext_int34_i),
    .ext_int35_i             (ext_int35_i),
    .ext_int36_i             (ext_int36_i),
    .ext_int37_i             (ext_int37_i),
    .ext_int38_i             (ext_int38_i),
    .ext_int39_i             (ext_int39_i),
    .ext_int40_i             (ext_int40_i),
    .ext_int41_i             (ext_int41_i),
    .ext_int42_i             (ext_int42_i),
    .ext_int43_i             (ext_int43_i),
    .ext_int44_i             (ext_int44_i),
    .ext_int45_i             (ext_int45_i),
    .ext_int46_i             (ext_int46_i),
    .debug_mode_valid_i      (debug_mode_valid_i),
    .debug_mode_reset_i      (debug_mode_reset_i),
    .debug_ndm_reset_i       (debug_ndm_reset_i),
    .wdt_reset_o             (wdt_reset_o)
);

// ============================================================
//  Clock Generation  (10 ns period ? 100 MHz)
// ============================================================

initial zic_clk = 1'b0;
always #5 zic_clk = ~zic_clk;

// ============================================================
//  Helper Task  apply a few clock cycles
// ============================================================

task wait_clk;
    input integer n;
    integer i;
    begin
        for (i = 0; i < n; i = i + 1)
            @(posedge zic_clk);
        #1; // small skew so we sample after clock edge
    end
endtask

// ============================================================
//  Helper Task  MMR Write
// ============================================================

task mmr_write;
    input [15:0] addr;
    input [31:0] data;
    begin
        @(posedge zic_clk); #1;
        zic_mmr_write_en_i   = 1'b1;
        zic_mmr_write_addr_i = addr;
        zic_mmr_write_data_i = data;
        @(posedge zic_clk); #1;
        zic_mmr_write_en_i   = 1'b0;
    end
endtask

// ============================================================
//  Helper Task  MMR Read
// ============================================================

task mmr_read;
    input  [15:0] addr;
    output [31:0] rdata;
    begin
        @(posedge zic_clk); #1;
        zic_mmr_read_en_i   = 1'b1;
        zic_mmr_read_addr_i = addr;
        @(posedge zic_clk);
        //@(posedge zic_clk);
        @(posedge zic_clk); #1;
        rdata = zic_mmr_read_data_o;
        zic_mmr_read_en_i   = 1'b0;
    end
endtask

// ============================================================
//  Initialise all inputs to 0
// ============================================================

task init_inputs;
    begin
        zic_rst                  = 1'b0;
        zic_mmr_write_en_i       = 1'b0;
        zic_mmr_write_addr_i     = 16'h0;
        zic_mmr_write_data_i     = 32'h0;
        zic_mmr_read_en_i        = 1'b0;
        zic_mmr_read_addr_i      = 16'h0;
        zic_ack_read_valid_en    = 1'b0;
        zic_eoi_valid_i          = 1'b0;
        zic_eoi_id_i             = 8'h0;
        active_lvl_pr_i          = 8'hFF; // lowest priority threshold
        global_int_enable_bit_i  = 48'h0;
        global_int_enable_valid_i= 1'b0;
        debug_mode_valid_i       = 1'b0;
        debug_mode_reset_i       = 1'b0;
        debug_ndm_reset_i        = 1'b0;

        // De-assert all external interrupts
        {ext_int46_i, ext_int45_i, ext_int44_i, ext_int43_i,
         ext_int42_i, ext_int41_i, ext_int40_i, ext_int39_i,
         ext_int38_i, ext_int37_i, ext_int36_i, ext_int35_i,
         ext_int34_i, ext_int33_i, ext_int32_i, ext_int31_i,
         ext_int30_i, ext_int29_i, ext_int28_i, ext_int27_i,
         ext_int26_i, ext_int25_i, ext_int24_i, ext_int23_i,
         ext_int22_i, ext_int21_i, ext_int20_i, ext_int19_i,
         ext_int18_i, ext_int17_i, ext_int16_i, ext_int15_i,
         ext_int14_i, ext_int13_i, ext_int12_i, ext_int11_i,
         ext_int10_i, ext_int9_i,  ext_int8_i,  ext_int7_i,
         ext_int6_i,  ext_int5_i,  ext_int4_i,  ext_int3_i,
         ext_int2_i,  ext_int1_i,  ext_int0_i} = 47'h0;
    end
endtask

// ============================================================
//  Waveform Dump
// ============================================================

	initial begin
		$shm_open("waves.shm");
		$shm_probe("ACTMF");
	end


// ============================================================
//  Shared read-data variable
// ============================================================

reg [31:0] rd_data;

// ============================================================
//  MAIN TEST SEQUENCE
// ============================================================

initial begin

    $display("===========================================================");
    $display(" Interrupt Controller Testbench  Starting");
    $display("===========================================================");

    init_inputs;

    // --------------------------------------------------------
    // TC-1 : Reset Behaviour
    // --------------------------------------------------------
    $display("\n[TC-1] Reset Behaviour");

    zic_rst = 1'b1;
    wait_clk(5);

    // Check key outputs are inactive during reset
    if (interrupt_request_o !== 1'b0)
        $display("  FAIL  interrupt_request_o should be 0 during reset, got %b", interrupt_request_o);
    else
        $display("  PASS  interrupt_request_o = 0 during reset");

    if (zic_ack_int_id_o !== 8'h00)
        $display("  FAIL  zic_ack_int_id_o should be 0x00 during reset, got 0x%0h", zic_ack_int_id_o);
    else
        $display("  PASS  zic_ack_int_id_o = 0x00 during reset");

    // De-assert reset
    @(posedge zic_clk); #1;
    zic_rst = 1'b0;
    wait_clk(3);
    $display("  INFO  Reset de-asserted");
    zic_rst = 1'b1;

    // --------------------------------------------------------
    // TC-2 : MMR Write then Read-back
    // --------------------------------------------------------
    $display("\n[TC-2] MMR Write / Read-back");
    ext_int1_i = 1'b1;

    mmr_write(16'h1007, 32'h0000_000A);
    wait_clk(2);
    mmr_read (16'h1004, rd_data);
    mmr_read (16'h1005, rd_data);
    mmr_read (16'h1006, rd_data);
    mmr_read (16'h1007, rd_data);

    if (rd_data === 32'h0000_005A)
        $display("  PASS  Read-back data matches written value 0x%08h", rd_data);
    else
        $display("  FAIL  Expected 0xA5A55A5A, got 0x%08h", rd_data);

    // Write a second register with a different pattern
    mmr_write(16'h0004, 32'hDEAD_BEEF);
    wait_clk(2);
    mmr_read (16'h0004, rd_data);

    if (rd_data === 32'hDEAD_BEEF)
        $display("  PASS  Second read-back matches 0x%08h", rd_data);
    else
        $display("  FAIL  Expected 0xDEADBEEF, got 0x%08h", rd_data);

    // --------------------------------------------------------
    // TC-3 : Global Interrupt Enable + Single External Interrupt
    // --------------------------------------------------------
    $display("\n[TC-3] Global Int Enable + ext_int0 assertion");

    // Enable all 47 interrupt sources via the global enable bus
    @(posedge zic_clk); #1;
    global_int_enable_bit_i   = 48'hFFFF_FFFF_FFFF;
    global_int_enable_valid_i = 1'b1;
    @(posedge zic_clk); #1;
    global_int_enable_valid_i = 1'b0;

    // Set active priority threshold low so any interrupt passes
    active_lvl_pr_i = 8'h00;
    wait_clk(2);

    // Assert ext_int0
    @(posedge zic_clk); #1;
    ext_int0_i = 1'b1;
    wait_clk(5);

    if (interrupt_request_o === 1'b1)
        $display("  PASS  interrupt_request_o asserted after ext_int0_i");
    else
        $display("  FAIL  interrupt_request_o not asserted after ext_int0_i (got %b)", interrupt_request_o);

    // --------------------------------------------------------
    // TC-4 : ACK Read (processor reads interrupt ID)
    // --------------------------------------------------------
    $display("\n[TC-4] ACK  Processor reads pending interrupt ID");

    @(posedge zic_clk); #1;
    zic_ack_read_valid_en = 1'b1;
    @(posedge zic_clk); #1;
    zic_ack_read_valid_en = 1'b0;
    wait_clk(2);

    $display("  INFO  zic_ack_int_id_o = 0x%02h (interrupt ID presented to core)", zic_ack_int_id_o);

    // De-assert ext_int0 after ACK
    @(posedge zic_clk); #1;
    ext_int0_i = 1'b0;
    wait_clk(2);

    // --------------------------------------------------------
    // TC-5 : EOI Clears the Interrupt
    // --------------------------------------------------------
    $display("\n[TC-5] EOI  End of Interrupt clears pending request");

    // Send EOI for the previously acknowledged interrupt ID
    @(posedge zic_clk); #1;
    zic_eoi_valid_i = 1'b1;
    zic_eoi_id_i    = zic_ack_int_id_o;   // match the ID that was ACKed
    @(posedge zic_clk); #1;
    zic_eoi_valid_i = 1'b0;
    zic_eoi_id_i    = 8'h00;
    wait_clk(5);

    if (interrupt_request_o === 1'b0)
        $display("  PASS  interrupt_request_o de-asserted after EOI");
    else
        $display("  FAIL  interrupt_request_o still asserted after EOI (got %b)", interrupt_request_o);

    // --------------------------------------------------------
    //  Done
    // --------------------------------------------------------
    wait_clk(10);
    $display("\n===========================================================");
    $display(" Testbench Complete");
    $display("===========================================================");
    $finish;
end

// ============================================================
//  Timeout Watchdog
// ============================================================

initial begin
    #500000;
    $display("WATCHDOG TIMEOUT  simulation aborted at %0t ns", $time);
    $finish;
end

endmodule
