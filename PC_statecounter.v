module PCSC (
    input  clk,
    input [7:0] PC_next,
    input [7:0] PC_nextID,
    input [7:0] PC_nextEX,
    input [7:0] PC_nextMEM,
    input [7:0] PC_nextWB,
    output reg [2:0] state

);

  always @(posedge (clk)) begin
    if (PC_next == PC_nextWB)
        state <= 3'b100;
    else if (PC_next == PC_nextMEM)
        state <= 3'b011;
    else if (PC_next == PC_nextEX)
        state <= 3'b010;
    else if (PC_next == PC_nextID)
        state <= 3'b001;
    else
        state <= 3'b000;
  end


endmodule