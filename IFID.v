module IFID (
    input  clk,
    input  en,
    input  [7:0] idata_write_addr,
    input  [7:0] idata_read_addr,
    output reg [7:0] odata_write_addr,
    output reg [7:0] odata_read_addr
);

  always @(posedge (clk)) begin
    if (en) begin
      odata_write_addr <= idata_write_addr;
      odata_read_addr <= idata_read_addr;
    end
  end


endmodule