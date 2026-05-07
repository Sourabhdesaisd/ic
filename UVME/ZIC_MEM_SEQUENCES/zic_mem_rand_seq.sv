class zic_mem_rand_seq extends uvm_sequence#(zic_mem_seq_item);

  `uvm_object_utils(zic_mem_rand_seq)

  zic_mem_seq_item zic_item;
  
  int count;
  //logic [15:0] zic_mem[];

  function new(string name = "zic_mem_rand_seq");
    super.new(name);
  endfunction

  task body();
       repeat(count)begin
      `uvm_do(zic_item);
       end
  endtask
  
endclass

