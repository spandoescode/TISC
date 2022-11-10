module UP (input clk);
    wire [3:0] opcode;
    wire [1:0] alu_sel;
    wire reg_write_en;
    wire mem_write_en;
    wire mem_to_reg;
    wire mem_op;
    
    CU control(.opcode(opcode), .clk(clk), .reg_write_en(reg_write_en), .mem_write_en(mem_write_en), .mem_to_reg(mem_to_reg), .mem_op(mem_op), .ALU_select(alu_sel));
    DU datapath(.clk(clk), .opcode(opcode), .reg_write_en(reg_write_en), .mem_write_en(mem_write_en), .mem_to_reg(mem_to_reg), .mem_op(mem_op), .alu_sel(alu_sel));
endmodule
