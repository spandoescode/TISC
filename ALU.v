module ALU (input reg [7:0] A, reg [7:0] B, reg [3:0] sel, clk, output reg [7:0] Y);

always @(posedge clk) begin

    case(sel)

    // A + B
    2'b00: Y<=A+B;

    // A - B
    2'b01: Y<=A-B;

    // Left Shift A
    2'b10: Y<=A<<1;

    // Compare A and B, generate a carry
    2'b11: Y<=(A==B)? 1'b1: 1'b0;

    endcase
end 

endmodule