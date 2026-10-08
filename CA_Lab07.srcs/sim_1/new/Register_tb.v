`timescale 1ns / 1ps

module RegisterFile_tb;

    // =========================================================
    // TESTBENCH SIGNALS
    // =========================================================

    reg clk;
    reg rst;
    reg WriteEnable;

    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;

    reg [31:0] WriteData;

    wire [31:0] ReadData1;
    wire [31:0] ReadData2;


    // =========================================================
    // REGISTER FILE
    // =========================================================

    RegisterFile uut (
        .clk(clk),
        .rst(rst),
        .WriteEnable(WriteEnable),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );


    // =========================================================
    // CLOCK
    // Clock period = 10 ns
    // Rising edges = 5 ns, 15 ns, 25 ns, ...
    // =========================================================

    initial begin
        clk = 0;

        forever #5 clk = ~clk;
    end


    // =========================================================
    // TESTS
    // =========================================================

    initial begin

        // -----------------------------------------------------
        // INITIAL VALUES
        // -----------------------------------------------------

        rst = 0;
        WriteEnable = 0;

        rs1 = 0;
        rs2 = 0;
        rd = 0;

        WriteData = 0;


        // -----------------------------------------------------
        // TEST 1: RESET
        // -----------------------------------------------------

        $display("");
        $display("==========================================");
        $display("TEST 1: RESET");
        $display("==========================================");

        rst = 1;

        // Keep reset active for more than one clock edge
        #12;

        rst = 0;

        // Read x0 and x1
        rs1 = 0;
        rs2 = 1;

        #2;

        $display("x0 = %h", ReadData1);
        $display("x1 = %h", ReadData2);

        if ((ReadData1 == 32'h00000000) &&
            (ReadData2 == 32'h00000000))
            $display("RESET PASSED");
        else
            $display("RESET FAILED");


        // -----------------------------------------------------
        // TEST 2: WRITE x5
        // -----------------------------------------------------

        $display("");
        $display("==========================================");
        $display("TEST 2: WRITE x5");
        $display("==========================================");

        WriteEnable = 1;
        rd = 5;
        WriteData = 32'h12345678;

        // Wait for rising clock edge
        #10;

        WriteEnable = 0;

        // Select x5 for reading
        rs1 = 5;

        #2;

        $display("x5 = %h", ReadData1);

        if (ReadData1 == 32'h12345678)
            $display("WRITE x5 PASSED");
        else
            $display("WRITE x5 FAILED");


        // -----------------------------------------------------
        // TEST 3: READ-AFTER-WRITE
        // -----------------------------------------------------

        $display("");
        $display("==========================================");
        $display("TEST 3: READ-AFTER-WRITE");
        $display("==========================================");

        // x5 was written on previous clock edge
        rs1 = 5;

        #2;

        $display("ReadData1 = %h", ReadData1);

        if (ReadData1 == 32'h12345678)
            $display("READ-AFTER-WRITE PASSED");
        else
            $display("READ-AFTER-WRITE FAILED");


        // -----------------------------------------------------
        // TEST 4: TWO READ PORTS
        // -----------------------------------------------------

        $display("");
        $display("==========================================");
        $display("TEST 4: TWO SIMULTANEOUS READ PORTS");
        $display("==========================================");

        // Write x10
        WriteEnable = 1;
        rd = 10;
        WriteData = 32'hAAAAAAAA;

        #10;

        // Write x15
        rd = 15;
        WriteData = 32'h55555555;

        #10;

        WriteEnable = 0;

        // Read x10 using rs1
        // Read x15 using rs2
        rs1 = 10;
        rs2 = 15;

        #2;

        $display("ReadData1 (x10) = %h", ReadData1);
        $display("ReadData2 (x15) = %h", ReadData2);

        if ((ReadData1 == 32'hAAAAAAAA) &&
            (ReadData2 == 32'h55555555))
            $display("TWO READ PORTS PASSED");
        else
            $display("TWO READ PORTS FAILED");


        // -----------------------------------------------------
        // TEST 5: x0 PROTECTION
        // -----------------------------------------------------

        $display("");
        $display("==========================================");
        $display("TEST 5: x0 PROTECTION");
        $display("==========================================");

        WriteEnable = 1;
        rd = 0;
        WriteData = 32'hFFFFFFFF;

        // Try to write to x0
        #10;

        WriteEnable = 0;

        // Read x0
        rs1 = 0;

        #2;

        $display("Attempted write to x0 = %h", WriteData);
        $display("Actual x0 value      = %h", ReadData1);

        if (ReadData1 == 32'h00000000)
            $display("x0 PROTECTION PASSED");
        else
            $display("x0 PROTECTION FAILED");


        // -----------------------------------------------------
        // TEST 6: OVERWRITE x5
        // -----------------------------------------------------

        $display("");
        $display("==========================================");
        $display("TEST 6: OVERWRITE x5");
        $display("==========================================");

        WriteEnable = 1;
        rd = 5;
        WriteData = 32'hDEADBEEF;

        #10;

        WriteEnable = 0;

        // Read x5
        rs1 = 5;

        #2;

        $display("New x5 value = %h", ReadData1);

        if (ReadData1 == 32'hDEADBEEF)
            $display("OVERWRITE PASSED");
        else
            $display("OVERWRITE FAILED");


        // -----------------------------------------------------
        // END
        // -----------------------------------------------------

        $display("");
        $display("==========================================");
        $display("ALL REGISTER FILE TESTS COMPLETED");
        $display("==========================================");

        #10;

        $finish;

    end

endmodule