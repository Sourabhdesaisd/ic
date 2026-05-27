`timescale 1ns/1ps

module tb_zic_top;

  
  reg zic_clk;
  reg zic_rst;
  reg wdt_reset_i;

  reg [47:0] interrupt_enable_i;

  
  reg ext_int0_i,  ext_int1_i,  ext_int2_i,  ext_int3_i;
  reg ext_int4_i,  ext_int5_i,  ext_int6_i,  ext_int7_i;
  reg ext_int8_i,  ext_int9_i,  ext_int10_i, ext_int11_i;
  reg ext_int12_i, ext_int13_i, ext_int14_i, ext_int15_i;
  reg ext_int16_i, ext_int17_i, ext_int18_i, ext_int19_i;
  reg ext_int20_i, ext_int21_i, ext_int22_i, ext_int23_i;
  reg ext_int24_i, ext_int25_i, ext_int26_i, ext_int27_i;
  reg ext_int28_i, ext_int29_i, ext_int30_i, ext_int31_i;
  reg ext_int32_i, ext_int33_i, ext_int34_i, ext_int35_i;
  reg ext_int36_i, ext_int37_i, ext_int38_i, ext_int39_i;
  reg ext_int40_i, ext_int41_i, ext_int42_i, ext_int43_i;
  reg ext_int44_i, ext_int45_i, ext_int46_i, ext_int47_i;

  
  // Priority inputs
  
  reg [7:0] int0_lp_i,  int1_lp_i,  int2_lp_i,  int3_lp_i;
  reg [7:0] int4_lp_i,  int5_lp_i,  int6_lp_i,  int7_lp_i;
  reg [7:0] int8_lp_i,  int9_lp_i,  int10_lp_i, int11_lp_i;
  reg [7:0] int12_lp_i, int13_lp_i, int14_lp_i, int15_lp_i;
  reg [7:0] int16_lp_i, int17_lp_i, int18_lp_i, int19_lp_i;
  reg [7:0] int20_lp_i, int21_lp_i, int22_lp_i, int23_lp_i;
  reg [7:0] int24_lp_i, int25_lp_i, int26_lp_i, int27_lp_i;
  reg [7:0] int28_lp_i, int29_lp_i, int30_lp_i, int31_lp_i;
  reg [7:0] int32_lp_i, int33_lp_i, int34_lp_i, int35_lp_i;
  reg [7:0] int36_lp_i, int37_lp_i, int38_lp_i, int39_lp_i;
  reg [7:0] int40_lp_i, int41_lp_i, int42_lp_i, int43_lp_i;
  reg [7:0] int44_lp_i, int45_lp_i, int46_lp_i, int47_lp_i;

  reg [7:0] active_lvl_pr_i;

  
  reg        zic_eoi_valid_i;
  reg        zic_ack_in;
  reg [7:0]  zic_ack_id_in;
  reg        debug_mode_valid_i;
  reg        debug_mode_reset_i;
  reg        debug_ndm_reset_i;

  
  // Outputs
  
  wire        interrupt_request_o;
  wire [7:0]  interrupt_id_o;
  wire        interrupt_id_valid_o;
  wire [47:0] interrupt_pending_o;
  wire        interrupt_pending_valid_o;
  wire        zic_nxtp_valid_o;
  wire [7:0]  highest_pending_lvl_pr_o;
  wire [7:0]  zic_nxtp_id_o;

  
  initial begin
    zic_clk = 1'b0;
    forever #5 zic_clk = ~zic_clk;
  end
initial begin 
      $shm_open("top.shm");
      $shm_probe("ACTMF");
  end


  
  zic_top dut (
    .zic_clk(zic_clk),
    .zic_rst(zic_rst),
    .wdt_reset_i(wdt_reset_i),
    .interrupt_enable_i(interrupt_enable_i),

    .ext_int0_i(ext_int0_i),   .ext_int1_i(ext_int1_i),
    .ext_int2_i(ext_int2_i),   .ext_int3_i(ext_int3_i),
    .ext_int4_i(ext_int4_i),   .ext_int5_i(ext_int5_i),
    .ext_int6_i(ext_int6_i),   .ext_int7_i(ext_int7_i),
    .ext_int8_i(ext_int8_i),   .ext_int9_i(ext_int9_i),
    .ext_int10_i(ext_int10_i), .ext_int11_i(ext_int11_i),
    .ext_int12_i(ext_int12_i), .ext_int13_i(ext_int13_i),
    .ext_int14_i(ext_int14_i), .ext_int15_i(ext_int15_i),
    .ext_int16_i(ext_int16_i), .ext_int17_i(ext_int17_i),
    .ext_int18_i(ext_int18_i), .ext_int19_i(ext_int19_i),
    .ext_int20_i(ext_int20_i), .ext_int21_i(ext_int21_i),
    .ext_int22_i(ext_int22_i), .ext_int23_i(ext_int23_i),
    .ext_int24_i(ext_int24_i), .ext_int25_i(ext_int25_i),
    .ext_int26_i(ext_int26_i), .ext_int27_i(ext_int27_i),
    .ext_int28_i(ext_int28_i), .ext_int29_i(ext_int29_i),
    .ext_int30_i(ext_int30_i), .ext_int31_i(ext_int31_i),
    .ext_int32_i(ext_int32_i), .ext_int33_i(ext_int33_i),
    .ext_int34_i(ext_int34_i), .ext_int35_i(ext_int35_i),
    .ext_int36_i(ext_int36_i), .ext_int37_i(ext_int37_i),
    .ext_int38_i(ext_int38_i), .ext_int39_i(ext_int39_i),
    .ext_int40_i(ext_int40_i), .ext_int41_i(ext_int41_i),
    .ext_int42_i(ext_int42_i), .ext_int43_i(ext_int43_i),
    .ext_int44_i(ext_int44_i), .ext_int45_i(ext_int45_i),
    .ext_int46_i(ext_int46_i), .ext_int47_i(ext_int47_i),

    .int0_lp_i(int0_lp_i),   .int1_lp_i(int1_lp_i),
    .int2_lp_i(int2_lp_i),   .int3_lp_i(int3_lp_i),
    .int4_lp_i(int4_lp_i),   .int5_lp_i(int5_lp_i),
    .int6_lp_i(int6_lp_i),   .int7_lp_i(int7_lp_i),
    .int8_lp_i(int8_lp_i),   .int9_lp_i(int9_lp_i),
    .int10_lp_i(int10_lp_i), .int11_lp_i(int11_lp_i),
    .int12_lp_i(int12_lp_i), .int13_lp_i(int13_lp_i),
    .int14_lp_i(int14_lp_i), .int15_lp_i(int15_lp_i),
    .int16_lp_i(int16_lp_i), .int17_lp_i(int17_lp_i),
    .int18_lp_i(int18_lp_i), .int19_lp_i(int19_lp_i),
    .int20_lp_i(int20_lp_i), .int21_lp_i(int21_lp_i),
    .int22_lp_i(int22_lp_i), .int23_lp_i(int23_lp_i),
    .int24_lp_i(int24_lp_i), .int25_lp_i(int25_lp_i),
    .int26_lp_i(int26_lp_i), .int27_lp_i(int27_lp_i),
    .int28_lp_i(int28_lp_i), .int29_lp_i(int29_lp_i),
    .int30_lp_i(int30_lp_i), .int31_lp_i(int31_lp_i),
    .int32_lp_i(int32_lp_i), .int33_lp_i(int33_lp_i),
    .int34_lp_i(int34_lp_i), .int35_lp_i(int35_lp_i),
    .int36_lp_i(int36_lp_i), .int37_lp_i(int37_lp_i),
    .int38_lp_i(int38_lp_i), .int39_lp_i(int39_lp_i),
    .int40_lp_i(int40_lp_i), .int41_lp_i(int41_lp_i),
    .int42_lp_i(int42_lp_i), .int43_lp_i(int43_lp_i),
    .int44_lp_i(int44_lp_i), .int45_lp_i(int45_lp_i),
    .int46_lp_i(int46_lp_i), .int47_lp_i(int47_lp_i),

    .active_lvl_pr_i(active_lvl_pr_i),
    .zic_eoi_valid_i(zic_eoi_valid_i),
    .zic_ack_in(zic_ack_in),
    .zic_ack_id_in(zic_ack_id_in),

    .interrupt_request_o(interrupt_request_o),
    .interrupt_id_o(interrupt_id_o),
    .interrupt_id_valid_o(interrupt_id_valid_o),
    .interrupt_pending_o(interrupt_pending_o),
    .interrupt_pending_valid_o(interrupt_pending_valid_o),
    .zic_nxtp_valid_o(zic_nxtp_valid_o),
    .highest_pending_lvl_pr_o(highest_pending_lvl_pr_o),
    .zic_nxtp_id_o(zic_nxtp_id_o),

    .debug_mode_valid_i(debug_mode_valid_i),
    .debug_mode_reset_i(debug_mode_reset_i),
    .debug_ndm_reset_i(debug_ndm_reset_i)
  );

  
  initial begin
    
    zic_rst = 0;
    wdt_reset_i = 0;
    interrupt_enable_i = 48'd0;
    active_lvl_pr_i = 8'd0;

    zic_ack_in = 0;
    zic_ack_id_in = 0;
    zic_eoi_valid_i = 0;

    debug_mode_valid_i = 0;
    debug_mode_reset_i = 0;
    debug_ndm_reset_i = 0;

    
    {ext_int0_i,ext_int1_i,ext_int2_i,ext_int3_i,ext_int4_i,ext_int5_i,
     ext_int6_i,ext_int7_i,ext_int8_i,ext_int9_i,ext_int10_i,ext_int11_i,
     ext_int12_i,ext_int13_i,ext_int14_i,ext_int15_i,ext_int16_i,ext_int17_i,
     ext_int18_i,ext_int19_i,ext_int20_i,ext_int21_i,ext_int22_i,ext_int23_i,
     ext_int24_i,ext_int25_i,ext_int26_i,ext_int27_i,ext_int28_i,ext_int29_i,
     ext_int30_i,ext_int31_i,ext_int32_i,ext_int33_i,ext_int34_i,ext_int35_i,
     ext_int36_i,ext_int37_i,ext_int38_i,ext_int39_i,ext_int40_i,ext_int41_i,
     ext_int42_i,ext_int43_i,ext_int44_i,ext_int45_i,ext_int46_i,ext_int47_i} = 48'd0;

    // priorities 
    
    
    #5 zic_rst = 1;
    #10 interrupt_enable_i = 48'hFFFF_FFFF_FFFF;
    #20 active_lvl_pr_i = 8'd4;
int0_lp_i=81;  int1_lp_i=2;  int2_lp_i=3;  int3_lp_i=4;
    int4_lp_i=5;  int5_lp_i=6;  int6_lp_i=7;  int7_lp_i=8;
    int8_lp_i=1;  int9_lp_i=2;  int10_lp_i=3; int11_lp_i=4;
    int12_lp_i=5; int13_lp_i=6; int14_lp_i=7; int15_lp_i=8;
    int16_lp_i=1; int17_lp_i=87; int18_lp_i=3; int19_lp_i=4;
    int20_lp_i=5; int21_lp_i=6; int22_lp_i=7; int23_lp_i=8;
    int24_lp_i=1; int25_lp_i=12; int26_lp_i=3; int27_lp_i=4;
    int28_lp_i=5; int29_lp_i=6; int30_lp_i=7; int31_lp_i=38;
    int32_lp_i=1; int33_lp_i=22; int34_lp_i=3; int35_lp_i=14;
    int36_lp_i=85; int37_lp_i=6; int38_lp_i=7; int39_lp_i=8;
    int40_lp_i=1; int41_lp_i=2; int42_lp_i=3; int43_lp_i=14;
    int44_lp_i=5; int45_lp_i=6; int46_lp_i=7; int47_lp_i=88;

    #20 active_lvl_pr_i = 8'd57;
    // ---------- interrupt tests ----------
    #20 ext_int3_i = 1;
     ext_int4_i = 1;
     ext_int9_i = 1;       
    #20 ext_int35_i = 1;
    #10 ext_int13_i = 1;  
    #10 ext_int17_i = 1; 
    #10 ext_int25_i = 1;
#20 active_lvl_pr_i = 8'd87;

    #20 zic_ack_id_in = 8'd7;  
        zic_ack_in = 1;
    #10 zic_ack_in = 0;

     #20 zic_ack_id_in = 8'd35;
        zic_ack_in = 1;
    #10 zic_ack_in = 0;
#20 active_lvl_pr_i = 8'd8;
    #10 zic_eoi_valid_i = 1;
    #10 zic_eoi_valid_i = 0;

    #100 $finish;
  end

endmodule

