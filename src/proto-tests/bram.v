module br (
	input reset,
	input clock,
	input wren,
	input[7:0] address,
	input[31:0] data_i,
	output reg[31:0] data_o
);

	reg[31:0] ram[0:255];
	integer i;
	
	always @(posedge clock)
	begin
		if (wren == 1)
			ram[address] <= data_i;
			
		data_o <= ram[address];
		
		 if (reset == 1'b1)
		 begin
				 for (i = 0; i < 256; i = i + 1)
				 begin
					  if (i == 4)
							ram[i] = 32'hffffffff;
					  else
							ram[i] = i;
				 end
		 end
	end
endmodule

module bram (
     input reset,
    input clock,
    input wren,
     input tb,
    input[7:0] b_addr,
    input[31:0] data_i,
    output [31:0] data_o
);

    reg[31:0] ram[0:255];
     wire[31:0] data_o_tmp;
     reg[7:0] pc_reg;
     wire[7:0] n_pc, n_pc_t;
     
     assign data_o = data_o_tmp;
     
     assign n_pc_t = data_o_tmp[31:30] == 2'b11 ? (pc_reg + 8'h04) : (pc_reg + 8'h02);
     assign n_pc = tb ? b_addr : n_pc_t;
 
    always @(posedge clock)
    begin
         if (reset == 1'b1)
                pc_reg <= 0;
          else
                pc_reg <= n_pc;
    end
	 
	 br brr(reset, clock, wren, n_pc, data_i, data_o_tmp);
endmodule
