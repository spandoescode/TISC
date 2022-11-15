module Mypip (
    input clk
);
  wire [31:0] ctrlSignals;
  wire [31:0] instrWireID, nextPCID;
  wire [31:0] instrWireEX, nextPCEX, readData1EX, readData2EX, NPC1EX, outSignEXTEX;
  wire [4:0] writeRegWireEX;
  wire [31:0] instrWireMEM, readData2MEM, ALUResultMEM, nextPCBranchMEM, NPC1MEM, nextPCMEM;
  wire [4:0] writeRegWireMEM;
  wire ZeroOutMEM;
  wire [31:0] instrWireWB, ALUResultWB, outputDataWB;
  wire [4:0] writeRegWireWB;
  //
  wire RegDestEX, RegWriteEX, ALUSrcEX, MemReadEX, MemWriteEX, MemToRegEX, BranchEX, JumpEX;
  wire [3:0] ALUCtrlEX;
  wire RegDestMEM, RegWriteMEM, ALUSrcMEM, MemReadMEM, MemWriteMEM, MemToRegMEM, BranchMEM, JumpMEM;
  wire [3:0] ALUCtrlMEM;
  wire RegDestWB, RegWriteWB, ALUSrcWB, MemReadWB, MemWriteWB, MemToRegWB, BranchWB, JumpWB;
  wire [3:0] ALUCtrlWB;
  //
  wire dataStall;
  wire controlStall;

  wire [31:0] PC;
  wire [31:0] nextPC;
  wire [31:0] instrWire;
  wire [2:0] ALUOp;
  wire RegDest, RegWrite, ALUSrc, MemRead, MemWrite, MemToReg, Branch, Jump;
  wire [31:0] instrWireIDhazard, instrWireHazard;
  IMemBank mem_bank (
      1'b1,
      PC,
      instrWire
  );  /*IF*/

  adder32bit adder (
      32'b100,
      PC,
      nextPC
  );  /*IF*/

  stallUnit stall_unit (
      clk,
      instrWireID[25:21],
      instrWireID[20:16],
      instrWireID[31:26]  /*opcode*/,
      instrWireID,
      instrWireEX,
      instrWireMEM,
      writeRegWireWB,
      RegWriteWB,
      instrWireWB,
      dataStall
  );

  Controlstall stall_control (
      clk,
      instrWireID[31:26],
      instrWireEX[31:26],
      instrWireMEM[31:26],  /*instrWireWB[31:26],*/
      controlStall
  );  //agar Dstall 0 nop be vorodi midim

  //////////////////////////////////////////////////////
  nopSet nop_set (
      clk,
      dataStall,
      controlStall,
      instrWire,
      instrWireID,
      instrWireHazard,
      instrWireIDhazard
  );

  //////////////////////////////////////////////////////////
  controlUnit control_unit (
      clk,
      instrWireIDhazard[31:26],
      instrWireIDhazard[5:0],  //age enable 0bashe stall darim
      ALUOp,
      RegDest,
      RegWrite,
      ALUSrc,
      MemRead,
      MemWrite,
      MemToReg,
      Branch,
      Jump,
      instrWireIDhazard
  );  /*ID*/
  /////////////////////////////////////////////////////

  wire [4:0] writeRegWire;
  mux2A mux_instr (
      RegDest,
      instrWireID[20:16],
      instrWireID[15:11],
      writeRegWire
  );  /*ID*/

  wire [31:0] readData1, readData2;
  wire [31:0] WBData;
  RegFile reg_file (
      clk,
      instrWireID[25:21],
      instrWireID[20:16],
      writeRegWireWB,
      WBData,
      RegWriteWB,
      readData1,
      readData2
  );  /*ID*/  /*WB*/

  wire [31:0] ALUSrc1;
  wire [31:0] outSignEXT;
  signExt u2 (
      instrWireID[15:0],
      outSignEXT
  );  /*ID*/
  mux2 mux_ALU (
      ALUSrcEX,
      readData2EX,
      outSignEXTEX,
      ALUSrc1
  );  /*EX*/

  wire [3:0] ALUCtrl;
  ALUcontrol alu_control (
      clk,
      instrWireID[5:0],
      ALUOp,
      ALUCtrl
  );  /*ID*/

  wire [31:0] ALUResult;
  wire ZeroOut;
  ALU alu (
      readData1EX,
      ALUSrc1,
      ALUCtrlEX,
      ALUResult,
      ZeroOut,,
  );  /*EX*/

  wire [31:0] outputData;
  DMemBank memorybank (
      MemReadMEM,
      MemWriteMEM,
      ALUResultMEM,
      readData2MEM,
      outputData
  );  /*MEM*/

  mux2 writeback_mux (
      MemToRegWB,
      ALUResultWB,
      outputDataWB,
      WBData
  );  /*WB*/
  ////////////////////////////////////////////////////////////
  wire [31:0] outputSLL;
  shiftLeft32bitLeft exec_SL (
      outSignEXTEX,
      outputSLL
  );  /*EX*/

  wire [31:0] nextPCBranch;
  adder32bit exec_adder (
      nextPCEX,
      outputSLL,
      nextPCBranch
  );  /*EX*/

  wire branchEnable;
  assign branchEnable = ZeroOutMEM & BranchMEM;  /*MEM*/

  wire [31:0] NPC0;
  mux2 mem_mux (
      branchEnable,
      nextPCMEM,
      nextPCBranchMEM,
      NPC0
  );  /*MEM*/

  wire [27:0] nextPCJump;
  shiftLeftForJump u7 (
      instrWireID[25:0],
      nextPCJump
  );  /*ID*/

  wire [31:0] NPC1;
  concatForJump u20 (
      nextPC[31:28],
      nextPCJump,
      NPC1
  );  /*ID*/

  wire [31:0] NPCValue;
  mux2 u8 (
      JumpMEM,
      NPC0,
      NPC1MEM,
      NPCValue
  );  /*MEM*/

  PCRegWrite u9 (
      clk,
      NPCValue,
      PC,
      dataStall
  );  /*MEM*/

  ////////////////////////////////////////////////////////////
  IFID p1 (
      clk,
      instrWireHazard,
      nextPC,
      instrWireID,
      nextPCID,
      dataStall
  );
  IDEX p2 (
      clk,
      RegDest,
      RegWrite,
      ALUSrc,
      MemRead,
      MemWrite,
      MemToReg,
      Branch,
      Jump,
      ALUCtrl,
      instrWireID,
      nextPCID,
      readData1,
      readData2,
      writeRegWire,
      outSignEXT,
      NPC1,
      RegDestEX,
      RegWriteEX,
      ALUSrcEX,
      MemReadEX,
      MemWriteEX,
      MemToRegEX,
      BranchEX,
      JumpEX,
      ALUCtrlEX,
      instrWireEX,
      nextPCEX,
      readData1EX,
      readData2EX,
      writeRegWireEX,
      outSignEXTEX,
      NPC1EX,
      1'b1
  );

  EXMEM p3 (
      clk,
      RegDestEX,
      RegWriteEX,
      ALUSrcEX,
      MemReadEX,
      MemWriteEX,
      MemToRegEX,
      BranchEX,
      JumpEX,
      ALUCtrlEX,
      instrWireEX,
      nextPCEX,
      readData2EX,
      ALUResult,
      writeRegWireEX,
      nextPCBranch,
      NPC1EX,
      ZeroOut,
      RegDestMEM,
      RegWriteMEM,
      ALUSrcMEM,
      MemReadMEM,
      MemWriteMEM,
      MemToRegMEM,
      BranchMEM,
      JumpMEM,
      ALUCtrlMEM,
      instrWireMEM,
      nextPCMEM,
      readData2MEM,
      ALUResultMEM,
      writeRegWireMEM,
      nextPCBranchMEM,
      NPC1MEM,
      ZeroOutMEM,
      1'b1
  );

  MEMWB p4 (
      clk,
      RegDestMEM,
      RegWriteMEM,
      ALUSrcMEM,
      MemReadMEM,
      MemWriteMEM,
      MemToRegMEM,
      BranchMEM,
      JumpMEM,
      ALUCtrlMEM,
      instrWireMEM,
      outputData,
      ALUResultMEM,
      writeRegWireMEM,
      RegDestWB,
      RegWriteWB,
      ALUSrcWB,
      MemReadWB,
      MemWriteWB,
      MemToRegWB,
      BranchWB,
      JumpWB,
      ALUCtrlWB,
      instrWireWB,
      outputDataWB,
      ALUResultWB,
      writeRegWireWB,
      1'b1
  );

endmodule
