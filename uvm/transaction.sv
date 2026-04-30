class ic_txn extends uvm_sequence_item;
  `uvm_object_utils(ic_txn)

  rand bit [47:0] intr;
  rand bit [7:0]  threshold;

  constraint single_interrupt {
    $countones(intr) == 1;
  }

  function new(string name = "ic_txn");
    super.new(name);
  endfunction

  function int get_intr_index();
  for (int i = 0; i < 48; i++) begin
    if (intr[i]) return i;
  end
  return -1;
  endfunction

  function string convert2string();
  return $sformatf("intr_idx=%0d threshold=%0d", 
                   get_intr_index(), threshold);
   endfunction

endclass
