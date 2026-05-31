module 	atomic_32_tb ;

reg clk ;
reg rst ;
reg rst_inst_mem ;
reg rst_data_mem ;
reg rst_reg_mem ;

reg instruction_write ;
reg [14:0] instruction_write_address ;
reg [31:0] instruction_in ;

atomic_32_top    dut (

				.clk(clk) ,
				.rst(rst) ,
				.rst_inst_mem(rst_inst_mem) ,
				.rst_data_mem(rst_data_mem) ,
				.rst_reg_mem(rst_reg_mem) ,
				.instruction_write(instruction_write) ,
				.instruction_write_address(instruction_write_address) ,
				.instruction_in(instruction_in)  
				

				) ;


initial begin
$shm_open("wave.shm") ;
$shm_probe("ACTMF") ;
end



integer fd;
reg [1023:0] trace_file;

initial begin
  if (!$value$plusargs("trace_file=%s", trace_file)) begin
    trace_file = "rtl_trace.log";
  end

  $display("TRACE FILE = %s", trace_file);

  fd = $fopen(trace_file, "w");

  if (fd == 0) begin
    $display("ERROR: file open failed");
    $finish;
  end
end


always @(posedge clk) begin
    if (!rst) begin
        $fdisplay(fd,
            "PC=%08h INSTR=%08h RD=%0d DATA=%08h  MEM_ADDR=%08h MEM_DATA=%08h",
            dut.EXE_WR_pc,
            dut.EXE_WR_instruction,
            dut.EXE_WR_rd_address,
            dut.EXE_WR_data_in_for_reg,

           // dut.EXE_WR_write_mem_en,        
            dut.EXE_WR_data_memory_write_address,   
            dut.EXE_WR_data_in_for_mem        
        );
    end
end

initial begin
clk = 1;
forever #5 clk = ~clk ;
end

initial begin

rst_inst_mem = 0 ;
rst_data_mem = 0 ;
rst_reg_mem = 0 ;

instruction_write = 0 ;
instruction_write_address = 0 ;
instruction_in = 0 ;

end

initial begin
    
rst = 1 ;#10
//rst_reg_mem = 0 ;

rst = 0 ;
instruction_write = 1 ;



#1000000 $finish;
end

// =====================================================
// ? TOHOST DETECTION (CORE FIX)
// =====================================================
/*
// 0x8000ecc0 ? lower 12 bits used ? 0xCC0
localparam TOHOST_ADDR = 12'hCC0;

reg test_done;
reg [31:0] test_result;

initial begin
    test_done = 0;
    test_result = 0;
end

always @(posedge clk) begin
    if (!rst) begin
        if (dut.top_mem_en) begin
            if (dut.top_mem_address[11:0] == TOHOST_ADDR) begin
                test_done   <= 1;
                test_result <= dut.top_mem_out;
            end
        end
    end
end

// =====================================================
//  CONTROLLED STOP (NO TIMEOUT, NO LOOP)
// =====================================================

always @(posedge clk) begin
    if (test_done) begin
        if (test_result == 32'd1)
            $display("\n? TEST PASS\n");
        else
            $display("\n? TEST FAIL\n");

        repeat (10) @(posedge clk);  // pipeline flush

        $fclose(fd);
        $finish;
    end
end
*/

endmodule
