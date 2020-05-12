`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/24 09:38:09
// Design Name: 
// Module Name: MIPS_1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MIPS_1(
        input clk,
        input rst
    );
    wire [31:0] Instruction;
    wire [31:0] Instruction_IF;
    wire [31:0] Instruction_ID;
    wire [31:0] Instruction_EX;
    wire [31:0] Instruction_MEM;
    wire en,Jmp,Jal,Jr,Branch;
    wire [31:0] Addr_Beq;
    wire [31:0] Addr_Jmp;
    wire [31:0] Read_data_1;
    wire [31:0] Read_data_1_ID;
    wire [31:0] PC_plus_4;
    wire [31:0] PC_plus_4_IF;
    wire [31:0] PC_plus_4_ID;
    wire [31:0] PC_plus_4_EX;
    wire [31:0] PC_plus_4_MEM;
    wire [5:0] Op_Code;
    wire [5:0] Function_Code;
    wire Syscall,RegDst,RegWrite,MemtoReg,SignedExt;
    wire [31:0] Read_data_2;
    wire [31:0] Read_data_2_ID;
    wire [31:0] Read_data_2_EX;
    wire [31:0] SignedExt_imm;
    wire [31:0] SignedExt_imm_ID;
    wire [31:0] Alu_result;
    wire [31:0] Alu_result_EX;
    wire [31:0] Alu_result_MEM;
    wire [31:0] Mem_read_data;
    wire [31:0] Mem_read_data_MEM;
    wire [4:0] Shamt;
    wire [4:0] w1_num;
    wire [4:0] w1_num_EX;
    wire [4:0] w1_num_MEM;
    wire [4:0] r1_num;
    wire [4:0] r2_num;
    wire MemWrite,AluSrcB,Beq,Bne;
    wire [3:0] AluOP;
    wire Hazard,clear;
    wire [31:0] Reg_write_data;
    wire MemtoReg_ID,MemWrite_ID,AluSrcB_ID,RegWrite_ID,Jal_ID,RegDst_ID;
    wire MemWrite_EX,Jal_EX,RegDst_EX,RegWrite_EX,MemtoReg_EX;
    wire Jal_MEM,MemtoReg_MEM,RegWrite_MEM,RegDst_MEM;
    wire [3:0] AluOP_ID;
    assign clear = Jmp | Jal | Jr | Branch;
    assign en=1'b1;
ifetch ifetch0(
        .Instruction(Instruction),.rst(rst),.clk(clk),.en(~Hazard),.Jmp(Jmp),.Jal(Jal),
        .Jr(Jr),.Branch(Branch),.Addr_Beq(Addr_Beq),.Addr_Jmp(Addr_Jmp),.Addr_Jr(Read_data_1),
        .PC_plus_4(PC_plus_4)
);
IF_ID IF_ID0(
    .Instruction(Instruction),.Instruction_IF(Instruction_IF),
    .PC_plus_4(PC_plus_4),.PC_plus_4_IF(PC_plus_4_IF),
    .stall(~Hazard),.clear(clear),.clk(clk),.rst(rst)
    );
idecode idecode0(
        .Instruction(Instruction_IF),.Op_Code(Op_Code),.Function_Code(Function_Code),.Syscall(Syscall),
        .RegDst(RegDst),.Jal(Jal),.RegWrite(RegWrite_MEM),.MemtoReg(MemtoReg),.clk(clk),.rst(rst),
        .SignedExt(SignedExt),.Beq(Beq),.Bne(Bne),.Addr_Jmp(Addr_Jmp),.Addr_Beq(Addr_Beq),.Read_data_1(Read_data_1),
        .Read_data_2(Read_data_2),.SignedExt_imm(SignedExt_imm),.PC_plus_4(PC_plus_4_IF),
        .Reg_write_data(Reg_write_data),.w1_num(w1_num),.Shamt(Shamt),.Branch(Branch),.r1_num(r1_num),.r2_num(r2_num),.Hazard(Hazard)
);
control control0(
        .Op_Code(Op_Code),.Function_Code(Function_Code),.Beq(Beq),.Bne(Bne),.MemtoReg(MemtoReg),
        .MemWrite(MemWrite),.AluOP(AluOP),.AluSrcB(AluSrcB),.RegWrite(RegWrite),.Jal(Jal),
        .RegDst(RegDst),.Syscall(Syscall),.Jmp(Jmp),.Jr(Jr),.SignedExt(SignedExt)
);
hazarddect hazarddect0(
    .r1_num(r1_num),.r2_num(r2_num),
    .Op_Code(Instruction_IF[31:26]),.Function_Code(Instruction_IF[5:0]),
    .RegWrite_ID(RegWrite_ID),.RegWrite_EX(RegWrite_EX),
    .w1_num_EX(w1_num_EX),.w1_num_MEM(w1_num_MEM),.Hazard(Hazard)
    );
ID_EX ID_EX0(
    .Instruction_IF(Instruction_IF),.PC_plus_4_IF(PC_plus_4_IF),.Read_data_1(Read_data_1),
    .Read_data_2(Read_data_2),.SignedExt_imm(SignedExt_imm),.Instruction_ID(Instruction_ID),
    .PC_plus_4_ID(PC_plus_4_ID),.Read_data_1_ID(Read_data_1_ID),.Read_data_2_ID(Read_data_2_ID),
    .SignedExt_imm_ID(SignedExt_imm_ID),.MemtoReg(MemtoReg),.MemWrite(MemWrite),.AluOP(AluOP),
    .AluSrcB(AluSrcB),.RegWrite(RegWrite),.Jal(Jal),.RegDst(RegDst),.MemtoReg_ID(MemtoReg_ID),
    .MemWrite_ID(MemWrite_ID),.AluOP_ID(AluOP_ID),.AluSrcB_ID(AluSrcB_ID),.RegWrite_ID(RegWrite_ID),
    .Jal_ID(Jal_ID),.RegDst_ID(RegDst_ID),.clk(clk),.rst(rst),.clear(Hazard),.stall(1'b1)
    );
exe exe0(
        .Instruction(Instruction_ID),.Read_data_1(Read_data_1_ID),.Read_data_2(Read_data_2_ID),.SignedExt_imm(SignedExt_imm_ID),.AluOP(AluOP_ID),
        .AluSrcB(AluSrcB_ID),.Jal(Jal_ID),.RegDst(RegDst_ID),.Shamt(Instruction_ID[10:6]),.Alu_result(Alu_result),.w1_num_EX(w1_num_EX)
);
EX_MEM EX_MEM0(
        .PC_plus_4_ID(PC_plus_4_ID),.Alu_result(Alu_result),.Instruction_ID(Instruction_ID),.Read_data_2_ID(Read_data_2_ID),
        .PC_plus_4_EX(PC_plus_4_EX),.Alu_result_EX(Alu_result_EX),.Instruction_EX(Instruction_EX),.Read_data_2_EX(Read_data_2_EX),
        .MemWrite_ID(MemWrite_ID),.Jal_ID(Jal_ID),.RegDst_ID(RegDst_ID),.RegWrite_ID(RegWrite_ID),
        .MemtoReg_ID(MemtoReg_ID),.MemWrite_EX(MemWrite_EX),.Jal_EX(Jal_EX),.RegDst_EX(RegDst_EX),
        .RegWrite_EX(RegWrite_EX),.MemtoReg_EX(MemtoReg_EX),
        .clk(clk),.rst(rst),.clear(1'b0),.stall(1'b1)
    );  
dmem dmem0(
        .Instruction(Instruction_EX),.address(Alu_result_EX),.Store_data(Read_data_2_EX),
        .MemWrite(MemWrite_EX),.Jal(Jal_EX),.RegDst(RegDst_EX),.w1_num_MEM(w1_num_MEM),.clk(clk),.Mem_read_data(Mem_read_data)
    );  
MEM_WB MEM_WB0(
        .Alu_result_EX(Alu_result_EX),.Mem_read_data(Mem_read_data),.PC_plus_4_EX(PC_plus_4_EX),.Instruction_EX(Instruction_EX),
        .Alu_result_MEM(Alu_result_MEM),.Mem_read_data_MEM(Mem_read_data_MEM),.PC_plus_4_MEM(PC_plus_4_MEM),.Instruction_MEM(Instruction_MEM),
        .Jal_EX(Jal_EX),.MemtoReg_EX(MemtoReg_EX),.RegWrite_EX(RegWrite_EX),.RegDst_EX(RegDst_EX),
        .Jal_MEM(Jal_MEM),.MemtoReg_MEM(MemtoReg_MEM),.RegWrite_MEM(RegWrite_MEM),.RegDst_MEM(RegDst_MEM),
        .clk(clk),.rst(rst),.clear(1'b0),.stall(1'b1)
    ); 
writeback writeback0(
        .Instruction(Instruction_MEM),.PC_plus_4(PC_plus_4_MEM),.Mem_read_data(Mem_read_data_MEM),.Alu_result(Alu_result_MEM),
        .Jal(Jal_MEM),.MemtoReg(MemtoReg_MEM),.RegDst(RegDst_MEM),.w1_num(w1_num),.Reg_write_data(Reg_write_data)
    );
endmodule
