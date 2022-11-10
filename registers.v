module registers (input EN,
                  input clk,
                  input [3:0] write_addr,
                  input [7:0] write_data,
                  input [3:0] read_addr_1,
                  output [7:0] read_data_1,
                  input [3:0] read_addr_2,
                  output [7:0] read_data_2
                  );
    
    reg [7:0] regs [7:0];
    // wire [3:0] read_addr_1;
    // wire [3:0] read_addr_2;
    
    initial begin
        regs[0] = 8'd0;
        regs[1] = 8'd0;
        regs[2] = 8'd0;
        regs[3] = 8'd0;
        regs[4] = 8'd0;
        regs[5] = 8'd0;
        regs[6] = 8'd0;
        regs[7] = 8'd0;
    end
    
    always @(posedge(clk)) begin
        
        if (EN) begin
            regs[write_addr] <= write_data;
        end
    end
    
    // wire [2:0] addr_1, addr_2;
    // // assign addr_1 = read_addr_1[2:0];
    // // assign addr_2 = read_addr_2[2:0];


    assign read_data_1 = regs[read_addr_1];
    assign read_data_2 = regs[read_addr_2];
    
endmodule
