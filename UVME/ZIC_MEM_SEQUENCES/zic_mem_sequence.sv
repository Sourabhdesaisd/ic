class zic_mem_sequence extends uvm_sequence#(zic_mem_seq_item);

  `uvm_object_utils(zic_mem_sequence)

  zic_mem_seq_item zic_item;
  
  int scenario;
  int count;
  logic [15:0] zic_mem[];

  function new(string name = "zic_mem_sequence");
    super.new(name);
  endfunction

  task body();
     
     zic_mem=new[5];
     zic_mem='{16'h0000,16'h0004,16'h0800,16'h0804,16'h0808};

    if(scenario==1)begin
         repeat(count)begin//write
      `uvm_do_with(zic_item,{zic_item.zic_mmr_write_en_i == 1;zic_item.zic_mmr_read_en_i == 0; zic_item.zic_mmr_write_addr_i inside {zic_mem};zic_item.zic_mmr_read_addr_i inside {zic_mem};zic_item.zic_ack_write_valid_i==0;zic_item.zic_ack_read_valid_en==0;zic_item.zic_eoi_valid_i==0;zic_item.zic_nxtp_valid_i==0;zic_item.zic_int_pending_valid_i==0;zic_item.global_int_enable_valid_i==0;});
        end
        end

      if(scenario==2)begin
         repeat(count)begin//read
      `uvm_do_with(zic_item,{zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 1; zic_item.zic_mmr_write_addr_i inside {zic_mem};zic_item.zic_mmr_read_addr_i inside{zic_mem};zic_item.zic_ack_write_valid_i==0;zic_item.zic_ack_read_valid_en==0;zic_item.zic_eoi_valid_i==0;zic_item.zic_nxtp_valid_i==0;zic_item.zic_int_pending_valid_i==0;zic_item.global_int_enable_valid_i==0;});
        end
        end

 if(scenario==3)begin
         repeat(count)begin//read-zic_ack_write_valid_i
      `uvm_do_with(zic_item,{zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 1; zic_item.zic_mmr_write_addr_i inside {zic_mem};zic_item.zic_mmr_read_addr_i inside{zic_mem};zic_item.zic_ack_write_valid_i==1;zic_item.zic_ack_read_valid_en==0;zic_item.zic_eoi_valid_i==0;zic_item.zic_nxtp_valid_i==0;zic_item.zic_int_pending_valid_i==0;zic_item.global_int_enable_valid_i==0;});
        end
        end
  

 if(scenario==4)begin
         repeat(count)begin//read-zic_ack_read_valid_en
      `uvm_do_with(zic_item,{zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 1; zic_item.zic_mmr_write_addr_i inside {zic_mem};zic_item.zic_mmr_read_addr_i inside{zic_mem};zic_item.zic_ack_write_valid_i==0;zic_item.zic_ack_read_valid_en==1;zic_item.zic_eoi_valid_i==0;zic_item.zic_nxtp_valid_i==0;zic_item.zic_int_pending_valid_i==0;zic_item.global_int_enable_valid_i==0;});
        end
        end

 if(scenario==5)begin
         repeat(count)begin//read-zic_eoi_valid_i
      `uvm_do_with(zic_item,{zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 1; zic_item.zic_mmr_write_addr_i inside {zic_mem};zic_item.zic_mmr_read_addr_i inside{zic_mem};zic_item.zic_ack_write_valid_i==0;zic_item.zic_ack_read_valid_en==0;zic_item.zic_eoi_valid_i==1;zic_item.zic_nxtp_valid_i==0;zic_item.zic_int_pending_valid_i==0;zic_item.global_int_enable_valid_i==0;});
        end
        end

 if(scenario==6)begin
         repeat(count)begin//read-zic_nxtp_valid_i
      `uvm_do_with(zic_item,{zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 1; zic_item.zic_mmr_write_addr_i inside {zic_mem};zic_item.zic_mmr_read_addr_i inside{zic_mem};zic_item.zic_ack_write_valid_i==0;zic_item.zic_ack_read_valid_en==0;zic_item.zic_eoi_valid_i==0;zic_item.zic_nxtp_valid_i==1;zic_item.zic_int_pending_valid_i==0;zic_item.global_int_enable_valid_i==0;});
        end
        end

    if(scenario==7)begin
         repeat(count)begin//write-zic_ack_read_valid_en
      `uvm_do_with(zic_item,{zic_item.zic_mmr_write_en_i == 1;zic_item.zic_mmr_read_en_i == 0; zic_item.zic_mmr_write_addr_i inside {zic_mem};zic_item.zic_mmr_read_addr_i inside{zic_mem};zic_item.zic_ack_write_valid_i==0;zic_item.zic_ack_read_valid_en==1;zic_item.zic_eoi_valid_i==0;zic_item.zic_nxtp_valid_i==0;zic_item.zic_int_pending_valid_i==0;zic_item.global_int_enable_valid_i==0;});
        end
        end

    if(scenario==8)begin
         repeat(count)begin//write-zic_mmr_read_en_i
      `uvm_do_with(zic_item,{zic_item.zic_mmr_write_en_i == 1;zic_item.zic_mmr_read_en_i == 1; zic_item.zic_mmr_write_addr_i inside {zic_mem};zic_item.zic_mmr_read_addr_i inside{zic_mem};zic_item.zic_ack_write_valid_i==0;zic_item.zic_ack_read_valid_en==0;zic_item.zic_eoi_valid_i==0;zic_item.zic_nxtp_valid_i==0;zic_item.zic_int_pending_valid_i==0;zic_item.global_int_enable_valid_i==0;});
        end
        end

if(scenario==9)begin
         repeat(count)begin//write-zic_ack_write_valid_i
      `uvm_do_with(zic_item,{zic_item.zic_mmr_write_en_i == 1;zic_item.zic_mmr_read_en_i == 0; zic_item.zic_mmr_write_addr_i inside {zic_mem};zic_item.zic_mmr_read_addr_i inside{zic_mem};zic_item.zic_ack_write_valid_i==1;zic_item.zic_ack_read_valid_en==0;zic_item.zic_eoi_valid_i==0;zic_item.zic_nxtp_valid_i==0;zic_item.zic_int_pending_valid_i==0;zic_item.global_int_enable_valid_i==0;});
        end
        end

if(scenario==10)begin
         repeat(count)begin//write-zic_ack_read_valid_en-zic_eoi_valid_i
      `uvm_do_with(zic_item,{zic_item.zic_mmr_write_en_i == 1;zic_item.zic_mmr_read_en_i == 0; zic_item.zic_mmr_write_addr_i inside {zic_mem};zic_item.zic_mmr_read_addr_i inside{zic_mem};zic_item.zic_ack_write_valid_i==0;zic_item.zic_ack_read_valid_en==1;zic_item.zic_eoi_valid_i==1;zic_item.zic_nxtp_valid_i==0;zic_item.zic_int_pending_valid_i==0;zic_item.global_int_enable_valid_i==0;});
        end
        end

if(scenario==11)begin
         repeat(count)begin//write-zic_int_pending_valid_i
      `uvm_do_with(zic_item,{zic_item.zic_mmr_write_en_i == 1;zic_item.zic_mmr_read_en_i == 0; zic_item.zic_mmr_write_addr_i inside {zic_mem};zic_item.zic_mmr_read_addr_i inside{zic_mem};zic_item.zic_ack_write_valid_i==0;zic_item.zic_ack_read_valid_en==0;zic_item.zic_eoi_valid_i==0;zic_item.zic_nxtp_valid_i==0;zic_item.zic_int_pending_valid_i==1;zic_item.global_int_enable_valid_i==0;});
        end
        end

if(scenario==12)begin
         repeat(count)begin//write-zic_global_int_enable_vaid_i
      `uvm_do_with(zic_item,{zic_item.zic_mmr_write_en_i == 1;zic_item.zic_mmr_read_en_i == 0; zic_item.zic_mmr_write_addr_i inside {zic_mem};zic_item.zic_mmr_read_addr_i inside{zic_mem};zic_item.zic_ack_write_valid_i==0;zic_item.zic_ack_read_valid_en==0;zic_item.zic_eoi_valid_i==1;zic_item.zic_nxtp_valid_i==0;zic_item.zic_int_pending_valid_i==0;zic_item.global_int_enable_valid_i==0;});
        end
        end

if(scenario==13)begin
         repeat(count)begin//read-zic_int_pending_valid_i
      `uvm_do_with(zic_item,{zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 1; zic_item.zic_mmr_write_addr_i inside {zic_mem};zic_item.zic_mmr_read_addr_i inside{zic_mem};zic_item.zic_ack_write_valid_i==0;zic_item.zic_ack_read_valid_en==0;zic_item.zic_eoi_valid_i==0;zic_item.zic_nxtp_valid_i==0;zic_item.zic_int_pending_valid_i==1;zic_item.global_int_enable_valid_i==0;});
        end
        end

if(scenario==14)begin
         repeat(count)begin//read-global_int_enable_valid_i
      `uvm_do_with(zic_item,{zic_item.zic_mmr_write_en_i == 0;zic_item.zic_mmr_read_en_i == 1; zic_item.zic_mmr_write_addr_i inside {zic_mem};zic_item.zic_mmr_read_addr_i inside{zic_mem};zic_item.zic_ack_write_valid_i==0;zic_item.zic_ack_read_valid_en==0;zic_item.zic_eoi_valid_i==0;zic_item.zic_nxtp_valid_i==0;zic_item.zic_int_pending_valid_i==0;zic_item.global_int_enable_valid_i==1;});
        end
        end
  endtask
endclass

