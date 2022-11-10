module datapath (input clk,
                 input alu_sel,
                 input datafromcu,
                 output opcode);
    
    reg [7:0] PC;
    wire [7:0] PC_next;
    wire [3:0] reg_write_addr;
    wire [7:0] reg_write_data;
    wire [3:0] reg_read_addr1;
    wire [3:0] reg_read_addr2;
    wire [7:0] reg_read_data1;
    wire [7:0] reg_read_data2;
    wire [7:0] data_write_addr;
    wire [7:0] data_write_data;
    wire [7:0] data_read_addr;
    wire [7:0] data_read_data;
    wire [15:0] instr;
    wire [7:0] alu_out;
    
    //Instantiate the memories and the register page
    registers GPR(.EN(reg_write_en), .clk(clk), .write_addr(reg_write_addr), .write_data(reg_write_data), .read_addr_1(reg_read_addr1), .read_data_1(reg_read_data1), .read_addr_2(reg_read_addr2), .read_data_2(reg_read_data2));
    progmem PROGMEM(.PC(PC), .instruction(instr));
    datamem DATAMEM(.EN(data_write_en), .clk(clk), .write_addr(data_write_addr), .write_data(data_write_data), .read_addr(data_read_addr) , .read_data(data_read_data));
    
    initial begin
        PC <= 8'd0;
    end
    
    always @(posedge(clk)) begin
        PC <= PC_next;
    end
    
    assign PC_next = PC + 8'd1;
    
    assign reg_write_addr = instr[11:8];
    
    // register read addresses
    assign reg_read_addr1 = instr[7:4];
    assign reg_read_addr2 = instr[3:0];
    
    assign data_read_addr     = {reg_read_addr1, reg_read_addr2};
    // assign data_write_addr = {reg_read_addr1, reg_read_addr2};
    
    ALU alu(.A(reg_read_data1), .B(reg_read_data2), .sel(alu_sel), .Y(alu_out), .clk(clk));
    
    assign reg_write_data = (mem_to_reg == 1'b1) ? data_read_data : ALU_out;
    assign opcode         = instr[15:12];
    
endmodule
