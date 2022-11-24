module MEMWB (
    input  clk,
    input  en,
    input  [3:0] ireg_write_addr,
    input  [7:0] ireg_write_data,
    input  ireg_write_en,
    input  imem_to_reg,
    input  [7:0] ialu_out,
    input  [7:0] inextPC,
    output reg [3:0] oreg_write_addr,
    output reg [7:0] oreg_write_data,
    output reg oreg_write_en,
    output reg omem_to_reg,
    output reg [7:0] oalu_out,
    output reg [7:0] onextPC
);

  always @(posedge (clk)) begin
    if (en) begin
      oreg_write_addr <= ireg_write_addr;
      oreg_write_data <= ireg_write_data;
      oreg_write_en <= ireg_write_en;
      omem_to_reg <= ireg_write_en;
      oalu_out <= ialu_out;
      onextPC <= inextPC;
    end
  end


endmodule