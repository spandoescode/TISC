module IFID (
    input clock,
    input [31:0] iinstrWire,
    input [31:0] inextPC,
    output reg [31:0] oinstrWire,
    output reg [31:0] onextPC,
    input enable
);
//   input [31:0] inextPC, iinstrWire;
//   output [31:0] onextPC, oinstrWire;
//   input clock, enable;
  // input dataStall;

  initial begin
    //  oPC=32'b0;
    //  oIR=32'b0;
  end

  always @(posedge clock) begin
    if (enable) begin
      onextPC <= inextPC;
      oinstrWire <= iinstrWire;
    end
  end
endmodule
