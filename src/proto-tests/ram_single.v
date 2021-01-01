module ram_single(q, a, d, we, clk);
   output[7:0] q;
   input [7:0] d;
   input [6:0] a;
   input we, clk;
   reg [7:0] mem [127:0];
    always @(posedge clk) begin
        if (we)
            mem[a] <= d;
        q <= mem[a];
   end
endmodule
