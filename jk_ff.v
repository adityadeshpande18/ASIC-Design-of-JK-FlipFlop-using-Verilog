Implementation of JK Flip-Flop

RTL Design Code:
module jk_ff (
    input  preset,   // Asynchronous reset (active high)
    input  clk,
    input  j,
    input  k,
    output reg q,
    output qn
);
assign qn = ~q;
always @(posedge clk or posedge preset) begin
    if (preset)
        q <= 1'b0;        // Reset
    else begin
        case ({j, k})
            2'b00: q <= q;      // Hold
            2'b01: q <= 1'b0;   // Reset
            2'b10: q <= 1'b1;   // Set
            2'b11: q <= ~q;     // Toggle
        endcase
    end
end
endmodule


2.2:	 Save the file using command- :wq!

Step 3: Create Testbench file
3.1: 	Open gvim editor for testbench with command: gvim jk_ff_tb.v
Testbench:

Testbench:
module jk_ff_tb;
    reg preset;      // Asynchronous reset (active high)
    reg clk;
    reg j, k;
    wire q, qn;
    // DUT instantiation
    jk_ff dut (
        .preset(preset),
        .clk   (clk),
        .j     (j),
        .k     (k),
        .q     (q),
        .qn    (qn)
    );
    // Clock generation: 10 ns period
    always #5 clk = ~clk;
    // Monitor the input and output
    initial begin
        $monitor("%0t | preset=%b j=%b k=%b| q=%b qn=%b",
                 $time, preset, j, k,q, qn);
    end

    // Stimulus
    initial begin
        // Initial values
        clk    = 0;
        preset = 1;   // Assert async reset
        j      = 0;
        k      = 0;
        // Hold reset for a while
        #7;           // NOT aligned with clock edge
        preset = 0;   // Deassert reset (async)
        // Apply JK combinations
        #10 j = 0; k = 0;   // Hold
        #10 j = 0; k = 1;   // Reset
        #10 j = 1; k = 0;   // Set
        #10 j = 1; k = 1;   // Toggle
        #10 j = 1; k = 1;   // Toggle again
        // Assert async reset in middle of clock cycle
        #3 preset = 1;
        #4 preset = 0;
        #20 $finish;
    end
    // Dump waves
    initial begin
        $dumpfile("jk_ff_async.vcd");
        $dumpvars(0, jk_ff_tb);
    end
endmodule

// Simulate the Design with Verilator
1: Use the following command to simulate:
verilator --binary -j 0 -Wall jk_ff.v jk_ff_tb.v --top jk_ff_tb --timing --CFLAGS "-std=c++20" --trace
2: If any error is available, resolve it.
3: After simulation a new directory obj_dir will be created by tool, check it by using command ls
4: Open obj_dir: cd obj_dir
5: Use command make -f Vjk_ff_tb.mk Vjk_ff_tb
6: A new directory with name Vjk_ff_tb will be created
7: Use command ./Vjk_ff_tb to compile
8: Check output at terminal