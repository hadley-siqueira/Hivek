module barrel_shifter (
    input clock,

    input [63:0] value_i_r,
    input [1:0] kind,
    input [5:0] shift_value,
    output reg [63:0] value_o_r
);
    wire [63:0] sll0, sll1, sll2, sll3, sll4, sll5;
    wire [63:0] srl0, srl1, srl2, srl3, srl4, srl5;
    wire [63:0] sra0, sra1, sra2, sra3, sra4, sra5;
    wire [31:0] firstBit;
	 
	 reg[63:0] value_o;
	 reg[63:0] value_i;

    assign firstBit = value_i[63] ? 32'hFFFF : 32'h0;

    assign sll0 = shift_value[0] ? {value_i[63-1:0], 1'b0} : value_i; 
    assign sll1 = shift_value[1] ? {sll0[63-2:0], 2'b0}    : sll0; 
    assign sll2 = shift_value[2] ? {sll1[63-4:0], 4'b0}    : sll1; 
    assign sll3 = shift_value[3] ? {sll2[63-8:0], 8'b0}    : sll2; 
    assign sll4 = shift_value[4] ? {sll3[63-16:0], 16'b0}  : sll3;
    assign sll5 = shift_value[5] ? {sll4[63-32:0], 32'b0}  : sll4;

    assign srl0 = shift_value[0] ? {1'b0, value_i[63:1]} : value_i; 
    assign srl1 = shift_value[1] ? {2'b0, srl0[63:2]}    : srl0; 
    assign srl2 = shift_value[2] ? {4'b0, srl1[63:4]}    : srl1; 
    assign srl3 = shift_value[3] ? {8'b0, srl2[63:8]}    : srl2;
    assign srl4 = shift_value[4] ? {16'b0, srl3[63:16]}  : srl3;
    assign srl5 = shift_value[5] ? {32'b0, srl4[63:32]}  : srl4;

    assign sra0 = shift_value[0] ? {firstBit[0], value_i[63:1]}  : value_i; 
    assign sra1 = shift_value[1] ? {firstBit[1:0], sra0[63:2]}   : sra0; 
    assign sra2 = shift_value[2] ? {firstBit[3:0], sra1[63:4]}   : sra1; 
    assign sra3 = shift_value[3] ? {firstBit[7:0], sra2[63:8]}   : sra2; 
    assign sra4 = shift_value[4] ? {firstBit[15:0], sra3[63:16]} : sra3;
    assign sra5 = shift_value[5] ? {firstBit[31:0], sra4[63:32]} : sra4;

    always @(*)
    begin
        case (kind)
        2'b00: value_o = sll5;
        2'b01: value_o = srl5;
        2'b10: value_o = sra5;
        default: value_o = value_i;
        endcase
    end
	 
	 always @(posedge clock)
	 begin
        value_o_r <= value_o;
        value_i <= value_i_r;
	 end
endmodule
