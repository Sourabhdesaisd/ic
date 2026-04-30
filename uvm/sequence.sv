class ic_base_seq extends uvm_sequence #(ic_txn);
  `uvm_object_utils(ic_base_seq)

  function new(string name = "ic_base_seq");
    super.new(name);
  endfunction

 task body();
  ic_txn txn;

  repeat (5) begin
    txn = ic_txn::type_id::create("txn");

    start_item(txn);
    assert(txn.randomize());

    //   PRINT HERE
    `uvm_info("SEQ", $sformatf("Generated txn: %s", txn.convert2string()), UVM_LOW)

    finish_item(txn);
  end
endtask

endclass
