`timescale 1 ns/10 ps

module fetch_tb;
    reg reset, clock, wren, tb;
    reg[63:0] b_addr;
    reg[31:0] data_i;
    wire[31:0] instruction;

    fetch b(clock, reset, wren, tb, b_addr, data_i, instruction);
    
    initial
    begin
        clock = 0;
        reset = 0;
        wren = 0;
        tb = 0;
        b_addr = 0;
        data_i = 0;
        #10;
        reset = 1;
        #40;
        reset = 0;
        # 20;
        tb = 1;
        wren = 1;
        # 40;
        tb = 0;
        wren = 0;
        # 100;
        tb = 1;
        # 25;
        tb = 0;
    end 

    initial
    begin
        $dumpfile("counter.vcd"); 
        $dumpvars; 
    end 

    always
        #10 clock = !clock;

    initial
        #1000 $finish;
endmodule
