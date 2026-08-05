
interface intf(input logic soc_clk);

    logic soc_rst;

    //----------------------------------------------------------
    // Only external interrupts that TB drives
    //----------------------------------------------------------

    logic ext_int10_i;
    logic ext_int11_i;
    logic ext_int12_i;
    logic ext_int13_i;
    logic ext_int14_i;
    logic ext_int15_i;

endinterface
