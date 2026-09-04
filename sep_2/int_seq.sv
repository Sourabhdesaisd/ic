class ext_interrupt_seq extends uvm_sequence #(int_seq_item);

   `uvm_object_utils(ext_interrupt_seq)

   int_seq_item req;
    string c_test;
   

   function new(string name="ext_interrupt_seq");

      super.new(name);

   endfunction

    task body();

    if (!$value$plusargs("C_TEST=%s", c_test)) begin
        c_test = "";
    end

    $display("%0t: C_TEST = %s", $time, c_test);


    // =========================================================
    // Special case: int_back_to_back_priority_test
    // =========================================================
    if (c_test == "int_back_to_back_priority_test") begin

        // -----------------------------------------------------
        // 1. First drive all interrupt sources HIGH
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b111111;

        $display("%0t: BACK-TO-BACK PRIORITY TEST -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);

        #10;

        // -----------------------------------------------------
        // 3. Drive 000001
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000000;

        $display("%0t: BACK-TO-BACK PRIORITY TEST -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);


        // -----------------------------------------------------
        // Wait 50 time units
        // -----------------------------------------------------
        #600;

        $display("%0t: After #50, changing GPIO pattern",
                 $time);


        // -----------------------------------------------------
        // 2. Drive 000100
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000100;

        $display("%0t: BACK-TO-BACK PRIORITY TEST -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);

        #10;

        // -----------------------------------------------------
        // 3. Drive 000001
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000000;

        $display("%0t: BACK-TO-BACK PRIORITY TEST -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);


        #600;

        // -----------------------------------------------------
        // 3. Drive 000001
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000001;

        $display("%0t: BACK-TO-BACK PRIORITY TEST -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);

        #100;

        // -----------------------------------------------------
        // 3. Drive 000001
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000000;

        $display("%0t: BACK-TO-BACK PRIORITY TEST -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);


    end

    
     else if (c_test == "int_config_retention_test") begin

        // -----------------------------------------------------
        // 1. First drive all interrupt sources HIGH
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b111111;

        $display("%0t: int_config_retention_test -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);

        #10;
        // -----------------------------------------------------
        // 3. Drive 000001
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000000;

        $display("%0t: int_config_retention_test -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);


        // -----------------------------------------------------
        // Wait 50 time units
        // -----------------------------------------------------
        #600;

        $display("%0t: After #50, changing GPIO pattern",
                 $time);


        // -----------------------------------------------------
        // 2. Drive 000100
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000100;

        $display("%0t: int_config_retention_test -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);

        #10;

        // -----------------------------------------------------
        // 3. Drive 000001
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000000;

        $display("%0t: int_config_retention_test -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);


        #600;

        // -----------------------------------------------------
        // 3. Drive 000001
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000001;

        $display("%0t: int_config_retention_test -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);

        #100;

        // -----------------------------------------------------
        // 3. Drive 000001
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000000;

        $display("%0t: int_config_retention_test -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);

    end

    else if (c_test == "int_priority_update_test") begin

        // -----------------------------------------------------
        // 1. First drive all interrupt sources HIGH
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b111111;

        $display("%0t: int_priority_update_test -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);

        #10;
        // -----------------------------------------------------
        // 3. Drive 000001
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000000;

        $display("%0t: int_priority_update_test -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);


        // -----------------------------------------------------
        // Wait 50 time units
        // -----------------------------------------------------
        #600;

        $display("%0t: After #50, changing GPIO pattern",
                 $time);


        // -----------------------------------------------------
        // 2. Drive 000100
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000001;

        $display("%0t: int_priority_update_test -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);

        #10;

        // -----------------------------------------------------
        // 3. Drive 000001
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000000;

        $display("%0t: int_priority_update_test -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);

      end


    
    
    // =========================================================
    // Multiple ISR Test
    // IRQ11, IRQ12 and IRQ10 should be active
    // Priority:
    //     IRQ11 = 13
    //     IRQ12 = 9
    //     IRQ10 = 5
    // =========================================================
    else if (c_test == "int_multiple_isr_test") begin

        // -----------------------------------------------------
        // 1. First drive all interrupt sources HIGH
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b111111;

        $display("%0t: int_multiple_isr_test -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);

        #10;
        // -----------------------------------------------------
        // 3. Drive 000001
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000000;

        $display("%0t: int_multiple_isr_test -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);


        // -----------------------------------------------------
        // Wait 50 time units
        // -----------------------------------------------------
        #600;

        $display("%0t: After #50, changing GPIO pattern",
                 $time);


        // -----------------------------------------------------
        // 2. Drive 000100
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000100;

        $display("%0t: int_multiple_isr_test -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);

        #10;

        // -----------------------------------------------------
        // 3. Drive 000001
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000000;

        $display("%0t: int_multiple_isr_test -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);


        #600;

        // -----------------------------------------------------
        // 3. Drive 000001
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000001;

        $display("%0t: int_multiple_isr_test -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);

        #100;

        // -----------------------------------------------------
        // 3. Drive 000001
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000000;

        $display("%0t: int_multiple_isr_test -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);

    end
   

    else if (c_test == "int_repeated_irq_test") begin

           // =========================================================
        // EVENT 1
        // Generate IRQ10
        // =========================================================

        $display("====================================================");
        $display("%0t: REPEATED IRQ TEST -> EVENT 1",
                 $time);
        $display("====================================================");


        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst      = 1'b1;
        req.gpio_pad_in  = 6'b000001;

        $display("%0t: EVENT 1 -> IRQ10 ASSERT -> gpio_pad_in = %06b",
                 $time,
                 req.gpio_pad_in);

        finish_item(req);


        // ---------------------------------------------------------
        // Deassert IRQ10 source
        // ---------------------------------------------------------

        #50;

        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst      = 1'b1;
        req.gpio_pad_in  = 6'b000000;

        $display("%0t: EVENT 1 -> IRQ10 DEASSERT -> gpio_pad_in = %06b",
                 $time,
                 req.gpio_pad_in);

        finish_item(req);


        // =========================================================
        // EVENT 2
        // Generate IRQ10 again
        // =========================================================

        #700;

        $display("====================================================");
        $display("%0t: REPEATED IRQ TEST -> EVENT 2",
                 $time);
        $display("====================================================");


        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst      = 1'b1;
        req.gpio_pad_in  = 6'b000001;

        $display("%0t: EVENT 2 -> IRQ10 ASSERT -> gpio_pad_in = %06b",
                 $time,
                 req.gpio_pad_in);

        finish_item(req);


        // ---------------------------------------------------------
        // Deassert IRQ10 source
        // ---------------------------------------------------------

        #50;

        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst      = 1'b1;
        req.gpio_pad_in  = 6'b000000;

        $display("%0t: EVENT 2 -> IRQ10 DEASSERT -> gpio_pad_in = %06b",
                 $time,
                 req.gpio_pad_in);

        finish_item(req);


        // =========================================================
        // EVENT 3
        // Generate IRQ10 again
        // =========================================================

        #900;

        $display("====================================================");
        $display("%0t: REPEATED IRQ TEST -> EVENT 3",
                 $time);
        $display("====================================================");


        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst      = 1'b1;
        req.gpio_pad_in  = 6'b000001;

        $display("%0t: EVENT 3 -> IRQ10 ASSERT -> gpio_pad_in = %06b",
                 $time,
                 req.gpio_pad_in);

        finish_item(req);


        // ---------------------------------------------------------
        // Deassert IRQ10 source
        // ---------------------------------------------------------

        #50;

        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst      = 1'b1;
        req.gpio_pad_in  = 6'b000000;

        $display("%0t: EVENT 3 -> IRQ10 DEASSERT -> gpio_pad_in = %06b",
                 $time,
                 req.gpio_pad_in);

        finish_item(req);


        end


    // =========================================================
    // Masked high priority test
    // =========================================================
    else if (c_test == "int_masked_high_priority_test") begin

        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000010;

        $display("%0t: MASKED HIGH PRIORITY TEST -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);

        #50;

        // -----------------------------------------------------
        // 3. Drive 000000
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000000;

        $display("%0t: DEFAULT INTERRUPT TEST -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);


    end


    // =========================================================
    // Default interrupt tests
    // =========================================================
    else begin

        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b111111;

        $display("%0t: DEFAULT INTERRUPT TEST -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);

        #50;

        // -----------------------------------------------------
        // 3. Drive 000000
        // -----------------------------------------------------
        req = int_seq_item::type_id::create("req");

        start_item(req);

        req.soc_rst     = 1'b1;
        req.gpio_pad_in = 6'b000000;

        $display("%0t: DEFAULT INTERRUPT TEST -> gpio_pad_in = %06b",
                 $time, req.gpio_pad_in);

        finish_item(req);

    end



endtask
endclass

