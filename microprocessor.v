module UP (input clk);
    wire [3:0] opcode;

    CU();
    datapath();
endmodule