class int_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(int_seq)

  int_seq_item req;

  function new(string name = "int_seq");
    super.new(name);
  endfunction

  task body();

    //----------------------------------------------------------
    // Create Transaction
    //----------------------------------------------------------
    req = int_seq_item::type_id::create("req");

    //----------------------------------------------------------
    // Drive Idle Values
    //----------------------------------------------------------
    start_item(req);

    req.soc_rst             = 1'b1;
    req.ext_int             = 16'h0000;
    req.debug_mode_valid_i  = 1'b0;

    finish_item(req);

  endtask

endclass


class int_reset_seq extends uvm_sequence #(int_seq_item);

  `uvm_object_utils(int_reset_seq)

  int_seq_item req;

  function new(string name="int_reset_seq");
    super.new(name);
  endfunction

  task body();

    req = int_seq_item::type_id::create("req");

    start_item(req);

    req.soc_rst            = 1'b0;
    req.ext_int            = 16'h0000;
    req.debug_mode_valid_i = 1'b0;

    finish_item(req);

  endtask

endclass
