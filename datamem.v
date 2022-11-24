module datamem (input clk,
                input EN,
                input  [7:0] write_addr,
                input  [7:0] write_data,
                input  [7:0] read_addr,
                output  [7:0] read_data
                );
    
    reg [7:0] MEM [255:0];
    integer f;
    
    initial
    begin
        $readmemb("data.txt", MEM);

        f = $fopen("mem_content.txt");
        $fdisplay(f,"time = %d\n", $time, 
        "\tmemory[0] = %b\n", MEM[0],   
        "\tmemory[1] = %b\n", MEM[1],
        "\tmemory[2] = %b\n", MEM[2],
        "\tmemory[3] = %b\n", MEM[3]);
        // $fmonitor(f, "time = %d\n", $time, 
        // "\tmemory[0] = %b\n", MEM[0],   
        // "\tmemory[1] = %b\n", MEM[1],
        // "\tmemory[2] = %b\n", MEM[2],
        // "\tmemory[3] = %b\n", MEM[3],);
        #210;
        $fdisplay(f,"time = %d\n", $time, 
        "\tmemory[0] = %b\n", MEM[0],   
        "\tmemory[1] = %b\n", MEM[1],
        "\tmemory[2] = %b\n", MEM[2],
        "\tmemory[3] = %b\n", MEM[3]);
  $fclose(f);
    end

    always @(posedge clk)
    begin
        if (EN) begin
            MEM[write_addr] <= write_data;
        end
    end

    assign read_data = MEM[read_addr];
    
endmodule
