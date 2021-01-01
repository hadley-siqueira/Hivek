module icache(
	input clock,
	input reset,
	input wren,
	input[7:0] address,
	input[31:0] data_i,
	output reg[31:0] data_o
);

	reg[31:0] ram[0:255];
	integer i;
	
	initial
	begin
		 for (i = 0; i < 256; i = i + 1)
		 begin
			  if (i == 4)
					ram[i] = 32'hffffffff;
			  else
					ram[i] = i;
		 end
	end
	
	always @(posedge clock)
	begin
		if (wren == 1)
			ram[address] <= data_i;
		else
		begin
		end
			
		data_o <= ram[address];
	end
endmodule

module next_pc_calc (
    input tb,
    input wire[63:0] pc,
    input wire[63:0] branch_address,
    input wire[1:0] instruction_bits,
    output [63:0] next_pc
);

    wire[63:0] next_pc_t;

    assign next_pc_t = instruction_bits == 2'b11 ? (pc + 64'h04) : (pc + 64'h02);
    assign next_pc = tb ? branch_address : next_pc_t;
endmodule

module fetch (
    input clock,
    input reset,
    input wren,
    input take_branch,
    input[63:0] branch_address,
    input[31:0] data_i,
    output[31:0] instruction
);
    wire[63:0] next_pc;
    reg[63:0]  pc;
    wire[31:0]  instruction_o;
    wire[1:0] ibits;

    assign instruction = instruction_o;
    assign ibits = instruction_o[31:30];

    next_pc_calc npcc(take_branch, pc, branch_address, ibits, next_pc);

    icache ic(clock, reset, wren, next_pc[7:0], data_i, instruction_o); 

    always @(posedge clock)
    begin
        if (reset == 1'b1)
            pc <= 0;
        else
            pc <= next_pc;
    end
endmodule
