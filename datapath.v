module datapath (input clk,
                 input opcode,
                 input datafromcu);
    
    reg [7:0] PC;
    wire [7:0] PC_next;
    wire [2:0] reg_write_addr;
    wire [7:0] reg_write_data;
    wire [2:0] reg_read_addr1;
    wire [2:0] reg_read_addr2;
    wire [7:0] reg_read_data1;
    wire [7:0] reg_read_data2;
    wire [2:0] data_write_addr;
    wire [7:0] data_write_data;
    wire [2:0] data_read_addr;
    wire [7:0] data_read_data;
    wire [15:0] instr;
    
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
    
    
endmodule
