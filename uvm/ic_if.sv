interface ic_if;

  logic ic_clk;
  logic ic_rst;

  logic [47:0] ext_int;
  logic [7:0] threshold;

  logic        irq_request;
  logic [7:0]  interrupt_out;
endinterface
