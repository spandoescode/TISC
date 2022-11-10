module datamem (input clk,
                input EN,
                input reg [7:0] write_addr,
                input reg [7:0] write_data,
                input reg [7:0] read_addr,
                output reg [7:0] read_data,
                );
    
    reg [255:0] MEM [7:0];
    
    initial
    begin
        $readmemb("data.txt", MEM);
    end

    assign read_data = MEM[read_addr]
    
endmodule
