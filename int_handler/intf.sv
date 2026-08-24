
interface intf(input logic soc_clk);

    logic soc_rst;

    //----------------------------------------------------------
    // Only external interrupts that TB drives
    //----------------------------------------------------------

    logic [5:0] gpio_pad_in;
    
endinterface
