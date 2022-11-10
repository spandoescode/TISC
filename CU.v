module CU(input [3:0] opcode,
          input clk,
          output logic reg_write_en,
          output logic mem_write_en,
          output logic mem_to_reg,
          output logic mem_op,
          output reg [1:0] ALU_select
          );

// initial begin
//     ALU_select <= 2'b00;
// end

always @(posedge clk) begin
    
    case(opcode)
        
        // Load
        // Write to reg, read from mem
        4'b0000:
        begin
            mem_op       <= 1;
            mem_to_reg   <= 1;
            reg_write_en <= 1;
            mem_write_en <= 0;
        end
        
        // Store
        // Write to mem, read from reg
        4'b0001:
        begin
            mem_op       <= 1;
            mem_to_reg   <= 0;
            reg_write_en <= 0;
            mem_write_en <= 1;
        end
        
        // Add
        // Write to reg, ALU_select = 0
        4'b0010:
        begin
            mem_op       <= 0;
            mem_to_reg   <= 0;
            reg_write_en <= 1;
            mem_write_en <= 0;
            ALU_select      <= 2'b00;
        end
        
        // Subtract
        // No memory operation, ALU_select = 1
        4'b0011:
        begin
            mem_op       <= 0;
            mem_to_reg   <= 0;
            reg_write_en <= 1;
            mem_write_en <= 0;
            ALU_select      <= 2'b01;
        end
        
        // LS
        // No memory operation, ALU_select = 2
        4'b0100:
        begin
            mem_op       <= 0;
            mem_to_reg   <= 0;
            reg_write_en <= 1;
            mem_write_en <= 0;
            ALU_select      <= 2'b10;
            
        end
        
        // Compare
        // No memory operation, ALU_select = 3
        4'b0101:
        begin
            mem_op       <= 0;
            mem_to_reg   <= 0;
            reg_write_en <= 1;
            mem_write_en <= 0;
            ALU_select      <= 2'b11;
        end
    endcase
end
endmodule

