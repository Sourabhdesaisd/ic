class ext_interrupt_seq extends uvm_sequence #(int_seq_item);

   `uvm_object_utils(ext_interrupt_seq)

   int_seq_item req;

   function new(string name="ext_interrupt_seq");

      super.new(name);

   endfunction

   task body();

      req = int_seq_item::type_id::create("req");

      start_item(req);

      req.soc_rst = 1;

      req.gpio_pad_in = 6'b111111;
       finish_item(req);

   endtask

endclass
