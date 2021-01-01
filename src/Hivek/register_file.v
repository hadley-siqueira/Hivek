module register_file (
    input clock,
    input wren,
    input[4:0] ra,
    input[4:0] rb,
    input[4:0] rc,
    input[63:0] cv,
    output reg[63:0] va,
    output reg[63:0] vb
);

    reg[63:0] registers[0:31];

    always @(posedge clock)
    begin
        if (wren == 1'b1)
            registers[rc] <= cv;

        va <= registers[ra];
        vb <= registers[rb];
    end
endmodule
