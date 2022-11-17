module DU (input clk,
           input  [1:0] alu_sel,
           input logic reg_write_en,
           input logic mem_write_en,
           input logic mem_to_reg,
           input logic mem_op,
           output [3:0] opcode);
    
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

    wire [3:0] reg_write_addrEX;
    wire [7:0] reg_write_dataEX;
    wire reg_write_enEX, mem_to_regEX;

    wire [3:0] reg_write_addrMEM;
    wire [7:0] reg_write_dataMEM;
    wire reg_write_enMEM, mem_to_regMEM;
    wire [7:0] alu_outMEM;

    wire [3:0] reg_write_addrWB;
    wire [7:0] reg_write_dataWB;
    wire reg_write_enWB, mem_to_regWB;
    wire [7:0] alu_outWB;

    wire [7:0] data_write_addrID;
    wire [7:0] data_read_addrID;

    wire mem_write_enEX;
    wire [7:0] data_write_addrEX;
    wire [7:0] data_write_dataEX;
    wire [7:0] data_read_addrEX;

    wire mem_write_enMEM;
    wire [7:0] data_write_addrMEM;
    wire [7:0] data_write_dataMEM;
    wire [7:0] data_read_addrMEM;



    


    initial begin
        PC <= 8'd0;
    end
    
    always @(posedge(clk)) begin
        @(posedge(clk));
        @(posedge(clk));
        @(posedge(clk));
        @(posedge(clk));
        PC <= PC_next;
    end

    
    assign PC_next = PC + 8'd1;
    
    assign reg_write_addr = instr[11:8];

    progmem PROGMEM(.PC(PC), .instruction(instr));

    // register read addresses
    assign reg_read_addr1 = (mem_op && ~mem_to_reg)?  instr[11:8] : instr[7:4];
    assign reg_read_addr2 = instr[3:0];

    
    //Instantiate the memories and the register page
    registers GPR(.EN(reg_write_enWB), .clk(clk), .write_addr(reg_write_addrWB), .write_data(reg_write_dataWB), .read_addr_1(reg_read_addr1), .read_data_1(reg_read_data1), .read_addr_2(reg_read_addr2), .read_data_2(reg_read_data2));
    
    datamem DATAMEM(.EN(mem_write_enMEM), .clk(clk), .write_addr(data_write_addrMEM), .write_data(data_write_dataMEM), .read_addr(data_read_addrMEM) , .read_data(data_read_data));
    
    assign data_write_data = reg_read_data1;
    // assign data_read_addr = 
    

    

    
    assign data_read_addr     = instr[7:0];
    assign data_write_addr = instr[7:0];
    
    ALU alu(.A(reg_read_data1), .B(reg_read_data2), .sel(alu_sel), .Y(alu_out), .clk(clk));

    // EXMEM exmem(.ialu_out(alu_outEX), .imem_to_reg(mem_to_regEX), oalu_out(alu_outMEM), omem_to_reg() );
    IFID ifid(clk, 1'b1,data_read_addr, data_write_addr, data_read_addrID,data_write_addrID);

    IDEX idex(clk, 1'b1, reg_write_addr, reg_write_en, mem_to_reg, mem_write_en, data_write_addrID, data_write_data, data_read_addrID, reg_write_addrEX, reg_write_enEX,  mem_to_regEX, mem_write_enEX, data_write_addrEX, data_write_dataEX, data_read_addrEX);
    
    EXMEM exmem(clk, 1'b1, reg_write_addrEX, reg_write_enEX, mem_to_regEX, alu_out, mem_write_enEX, data_write_addrEX, data_write_dataEX, data_read_addrEX, reg_write_addrMEM, reg_write_enMEM, mem_to_regMEM, alu_outMEM, mem_write_enMEM, data_write_addrMEM, data_write_dataMEM, data_read_addrMEM);

    MEMWB memwb(clk, 1'b1, reg_write_addrMEM, reg_write_data, reg_write_enMEM, mem_to_regMEM, alu_out, reg_write_addrWB, reg_write_dataWB, reg_write_enWB, mem_to_regWB, alu_outWB);

    assign reg_write_data = (mem_to_regMEM == 1'b1) ? data_read_data : alu_out;
    assign opcode         = instr[15:12];
    
endmodule
