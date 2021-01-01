module Alu (
    input[3:0] alu_sel,
    input[63:0] src1,
    input[63:0] src2,
    output reg[63:0] dst
);

    always @(*)
    begin
        case (alu_sel)
        0:
            dst = src1 + src2;
        1:
            dst = src1 - src2;
        2:
            dst = src1 & src2;
        3:
            dst = src1 | src2;
        4:
            dst = src1 ^ src2;
        5:
            dst = $signed(src1) < $signed(src2) ? 1 : 0;
        6:
            dst = src1 < src2 ? 1 : 0;
        default:
            dst = src1;
        endcase
    end
endmodule
