module axi_datamem_wrapper #(

parameter 	DATA_MEMORY_ADDR_WIDTH = 20 

)(

input  wire                        ACLK,
input  wire                        ARESETN,

// Write Address Channel
input  wire [31:0]       AWADDR,
input  wire                        AWVALID,
output wire                        AWREADY,

// Write Data Channel
input  wire [31:0]       WDATA,
input  wire [3:0]   WSTRB,
input  wire                        WVALID,
output wire                        WREADY,

// Write Response Channel
output wire [1:0]                  BRESP,
output wire                        BVALID,
input  wire                        BREADY,

// Read Address Channel
input  wire [31:0]       ARADDR,
input  wire                        ARVALID,
output wire                        ARREADY,

// Read Data Channel
output wire [31:0]       RDATA,
output wire [1:0]                  RRESP,
output wire                        RVALID,
input  wire                        RREADY
);


//  internal memory interface
wire                          mem_we;
wire [31:0]  mem_wr_addr;
wire [31:0]         mem_wdata;
wire [3:0]     mem_wstrb;
wire [31:0]  mem_rd_addr;
wire [31:0]         mem_rdata;
wire [DATA_MEMORY_ADDR_WIDTH-1:0] mem_addr;

// shared address 

assign mem_addr = mem_we ? mem_wr_addr[DATA_MEMORY_ADDR_WIDTH-1:0]
                         : mem_rd_addr[DATA_MEMORY_ADDR_WIDTH-1:0];



//  AXI4-Lite Slave 
axi_4lite_slave #(
.DATA_WIDTH (32),
.ADDR_WIDTH (32)
) u_axi_slave (
.ACLK        (ACLK),
.ARESETN     (ARESETN),
.AWADDR      (AWADDR),
.AWVALID     (AWVALID),
.AWREADY     (AWREADY),
.WDATA       (WDATA),
.WSTRB       (WSTRB),
.WVALID      (WVALID),
.WREADY      (WREADY),
.BRESP       (BRESP),
.BVALID      (BVALID),
.BREADY      (BREADY),
.ARADDR      (ARADDR),
.ARVALID     (ARVALID),
.ARREADY     (ARREADY),
.RDATA       (RDATA),
.RRESP       (RRESP),
.RVALID      (RVALID),
.RREADY      (RREADY),
.mem_we      (mem_we),
.mem_wr_addr (mem_wr_addr),
.mem_wdata   (mem_wdata),
.mem_wstrb   (mem_wstrb),
.mem_rd_addr (mem_rd_addr),
.mem_rdata   (mem_rdata)
);

//  Data Memory 
data_mem #(
 .DATA_MEMORY_ADDR_WIDTH(DATA_MEMORY_ADDR_WIDTH)
     
) u_data_mem (
.clk     (ACLK),
.rst_n  (ARESETN),
.write_en  (mem_we),
.address (mem_addr),
.data_in   (mem_wdata),
.byte_enable (mem_wstrb),
//.address (mem_rd_addr),
.data_out   (mem_rdata)
);



endmodule
