module tb;
 reg clk;
    reg rst_n;


wire [31:0] pc;
wire [31:0] instr;
wire [4:0]  rd;
wire [31:0] rd_data;
wire        we;
wire [6:0]opcode;
wire [31:0]a;
wire [31:0]b;
wire [31:0]result;
wire[3:0]aluop;
wire [31:0] mem_addr;
wire [31:0]   mem_data  ;
wire mem_we;
wire [31:0]mem_pc   ;
wire   mem_valid ;
wire branch;
wire jump;
wire [31:0]b_pc;
    // Instantiate DUT
    top_rvc dut (
        .clk(clk),
        .rst_n(rst_n),
        .dbg_pc(pc),
    .dbg_instr(instr),
    .dbg_rd(rd),
    .dbg_rd_data(rd_data),
    .dbg_we(we),
    .a(a),
    .b(b),
    .result(result),
    .aluop(aluop),
    .dbg_opcode(opcode),
    .dbg_valid_wb(valid_wb),
    .mem_addr(mem_addr),
    .mem_data(mem_data),
    .mem_we(mem_we),
    .mem_pc(mem_pc),
    .mem_valid(mem_valid),
    .dbg_branch(branch),
    .dbg_jump(jump),
    .b_pc(b_pc)

    );
    // Clock generation
    always #5 clk = ~clk;   
initial begin
        $shm_open("wavetop.shm");
        $shm_probe("ACTMF");
    end
    

integer f;

reg [1023:0] trace_file;

initial begin
  if (!$value$plusargs("trace_file=%s", trace_file)) begin
    trace_file = "rtl_trace.log";
  end

  $display("TRACE FILE = %s", trace_file);

  f = $fopen(trace_file, "w");

  if (f == 0) begin
    $display("ERROR: file open failed");
    $finish;
  end
end

always @(posedge clk) begin
  if (!rst_n) begin

    // Register write
    if (valid_wb  && we!=0 ) begin
      $fdisplay(f,
        "REG PC=%08h INSTR=%08h RD=x%0d DATA=%08h",
        pc, instr, rd, rd_data);
    end
    
    if (valid_wb && mem_we==0 && we==0) begin
        $fdisplay(f,
    "BRANCH PC=%08h  INSTR=%08h",pc,instr);
end

if (jump) begin
        $fdisplay(f,
    "jump PC=%08h  INSTR=%08h",pc,instr);
end


    // Store
    if (mem_valid && mem_we) begin
      $fdisplay(f,
        "MEM PC=%08h ADDR=%08h DATA=%08h",
        mem_pc, mem_addr, mem_data);
    end

  end
    end    

initial begin
        $display("====================================");
        $display("     RVC PIPELINE TOP TESTBENCH     ");
        $display("====================================");
        clk   = 1;
        rst_n = 1;
#10;
rst_n = 0;
#1000000;
$display("TIMEOUT: Program did NOT reach tohost");
$finish;
end

always @(posedge clk) begin
    #1;

    // Debug print (optional but useful)
    if (dut.mem_we) begin
        $display("WRITE DETECTED: ADDR=%h DATA=%h PC=%h",
            dut.mem_addr, dut.mem_data, dut.mem_pc);
    end

    // ? FINAL STOP CONDITION
    if (dut.mem_we && dut.mem_data == 32'd1) begin
    $display("PROGRAM PASSED (DATA=1 DETECTED)");
    #10;
    $finish;
end
end

endmodule
