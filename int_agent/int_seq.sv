class ext_interrupt_seq extends uvm_sequence #(int_seq_item);

    `uvm_object_utils(ext_interrupt_seq)

    int_seq_item req;

    function new(string name="ext_interrupt_seq");
        super.new(name);
    endfunction

    task body();

        req=int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst=1;

        req.ext_int10_i=1;
        req.ext_int11_i=0;
        req.ext_int12_i=0;
        req.ext_int13_i=0;
        req.ext_int14_i=0;
        req.ext_int15_i=0;

        finish_item(req);

    endtask

endclass
