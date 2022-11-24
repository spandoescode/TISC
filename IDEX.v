module IDEX (
    input  clk,
    input  en,
    input  [3:0] ireg_write_addr,
    input  ireg_write_en,
    input  [7:0] ireg_read_data1,
    input  [7:0] ireg_read_data2,
    input  imem_to_reg,
    input  imem_write_en,
    input  [7:0] idata_write_addr,
    input  [7:0] idata_write_data,
    input  [7:0] idata_read_addr,
    input  [7:0] inextPC,
    output reg [3:0] oreg_write_addr,
    output reg oreg_write_en,
    output reg [7:0] oreg_read_data1,
    output reg [7:0] oreg_read_data2,
    output reg omem_to_reg,
    output reg omem_write_en,
    output reg [7:0] odata_write_addr,
    output reg [7:0] odata_write_data,
    output reg [7:0] odata_read_addr,
    output reg [7:0] onextPC
);

  always @(posedge (clk)) begin
    if (en) begin
      oreg_write_addr <= ireg_write_addr;
      oreg_write_en <= ireg_write_en;
      omem_to_reg <= ireg_write_en;
      omem_write_en <= imem_write_en;
      odata_write_addr <= idata_write_addr;
      odata_write_data <= idata_write_data;
      odata_read_addr <= idata_read_addr;
      omem_to_reg <= imem_to_reg;
      oreg_read_data1 <= ireg_read_data1;
      oreg_read_data2 <= ireg_read_data2;
      onextPC <= inextPC;
    end
  end


endmodule
