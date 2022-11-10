module registers (input EN,
                  input clk,
                  input reg [3:0] write_addr,
                  input reg [7:0] write_data,
                  input reg [3:0] read_addr_1,
                  output reg [7:0] read_data_1,
                  input reg [3:0] read_addr_2,
                  output reg [7:0] read_data_2,
                  );
    
    reg [7:0] regs [7:0];
    
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
            assign regs[write_addr] <= write_data;
        end
    end
    
    assign read_data_1 = regs[read_addr1];
    assign read_data_2 = regs[read_addr2];
    
endmodule
