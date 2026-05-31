/*module data_mem_top (
    input         clk,
    input         mem_read,
    input         mem_write,
    input  [2:0]  load_type,   // 000 LB, 001 LH, 010 LW, 011 LBU, 100 LHU
    input  [1:0]  store_type,  // 00 SB, 01 SH, 10 SW
    input  [31:0] addr,        // ALU result (byte address)
    input  [31:0] rs2_data,    // data to store (from register file)
    output [31:0] read_data    // load result to register file
);
    wire [31:0] mem_write_data;
    wire [3:0]  byte_enable;
    wire [31:0] mem_data_out;

    // STORE DATAPATH
    store_datapath u_store (
        .store_type(store_type),
        .write_data(rs2_data),
        .addr(addr[1:0]),
        .mem_write_data(mem_write_data),
        .byte_enable(byte_enable)
    );

    // DATA MEMORY (byte-addressable)
    data_memory u_mem (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .addr(addr),
        .write_data(mem_write_data),
        .byte_enable(byte_enable),
        .mem_data_out(mem_data_out)
    );

    // LOAD DATAPATH
    load_datapath u_load (
        .load_type(load_type),
        .mem_data_in(mem_data_out),
        .addr(addr[1:0]),
        .read_data(read_data)
    );
endmodule

*/

module data_mem_top (
    input         clk,
    input         mem_read,
    input         mem_write,
    input  [2:0]  load_type,
    input  [1:0]  store_type,
    input  [31:0] addr,
    input  [31:0] rs2_data,
    output [31:0] read_data
);

    wire [31:0] mem_write_data;
    wire [3:0]  byte_enable;
    wire [31:0] mem_data_out;

    //---------------------------------------------------------
    // Store datapath
    //---------------------------------------------------------
    store_datapath u_store (
        .store_type(store_type),
        .write_data(rs2_data),
        .addr(addr[1:0]),
        .mem_write_data(mem_write_data),
        .byte_enable(byte_enable)
    );

    //---------------------------------------------------------
    // Data memory
    //---------------------------------------------------------
    data_memory u_mem (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .addr(addr),
        .write_data(mem_write_data),
        .byte_enable(byte_enable),
        .mem_data_out(mem_data_out)
    );

    //---------------------------------------------------------
    // Remember previous store
    //---------------------------------------------------------
    reg [31:0] prev_store_addr;
    reg [31:0] prev_store_data;
    reg [3:0]  prev_store_be;
    reg        prev_store_valid;

    always @(posedge clk) begin
        if(mem_write) begin
            prev_store_addr  <= addr;
            prev_store_data  <= mem_write_data;
            prev_store_be    <= byte_enable;
            prev_store_valid <= 1'b1;
        end
    end

    //---------------------------------------------------------
    // Store->Load Forwarding
    //---------------------------------------------------------
    wire store_load_fwd;

    assign store_load_fwd =
           prev_store_valid &&
           mem_read &&
           (prev_store_addr == addr);

    reg [31:0] forwarded_word;

    always @(*) begin
        forwarded_word = mem_data_out;

        if(prev_store_be[0])
            forwarded_word[7:0] = prev_store_data[7:0];

        if(prev_store_be[1])
            forwarded_word[15:8] = prev_store_data[15:8];

        if(prev_store_be[2])
            forwarded_word[23:16] = prev_store_data[23:16];

        if(prev_store_be[3])
            forwarded_word[31:24] = prev_store_data[31:24];
    end

    wire [31:0] load_mem_data;

    assign load_mem_data =
           store_load_fwd ?
           forwarded_word :
           mem_data_out;

    //---------------------------------------------------------
    // Load datapath
    //---------------------------------------------------------
    load_datapath u_load (
        .load_type(load_type),
        .mem_data_in(load_mem_data),
        .addr(addr[1:0]),
        .read_data(read_data)
    );

endmodule
