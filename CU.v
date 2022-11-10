
module CU(input [15:0] instr, 
        input clk, 
        output logic reg_write_en, 
        output logic mem_write_en);
    wire [3:0] opcode;
    assign opcode = instr[3:0];
    always @(posedge clk) begin


        case(opcode)

            // Load
            // Write to reg, read from mem
            4'b0000: 
            begin
                reg_write_en <= 1;
                mem_write_en <= 0;
            end
            
            // Store
            // Write to mem, read from reg
            4'b0001: 
            begin
                reg_write_en <= 0;
                mem_write_en <= 1;
            end
        endcase
    end
endmodule

