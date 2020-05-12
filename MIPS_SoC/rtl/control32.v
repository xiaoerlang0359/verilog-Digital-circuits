`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module control32(Opcode,Function_opcode,Alu_resultHigh,Jrn,RegDST,ALUSrc,MemorIOtoReg,RegWrite,MemRead,MemWrite,IORead,IOWrite,Branch,nBranch,Jmp,Jal,I_format,Sftmd,ALUOp);
    input[5:0]   Opcode;            // 来自取指单元instruction[31..26]
    input[5:0]   Function_opcode;  	// r-form instructions[5..0]
    output       Jrn;
    output       RegDST;
    output       ALUSrc;            // 决定第二个操作数是寄存器还是立即数
    output       MemorIOtoReg;
    output       RegWrite;
    output       MemWrite;
    output       Branch;
    output       nBranch;
    output       Jmp;
    output       Jal;
    output       I_format;
    output       Sftmd;
    output[1:0]  ALUOp;
    input[21:0] Alu_resultHigh;
    output MemRead;
    output IOWrite;
    output IORead;
     
    wire Jmp,I_format,Jal,Branch,nBranch;
    wire R_format,Lw,Sw;
    
   
    assign R_format = (Opcode==6'b000000)? 1'b1:1'b0;    	//--00h 
    assign RegDST = R_format;                               //说明目标是rd，否则是rt
    assign Jal = (Opcode==6'b000011)? 1'b1:1'b0;
    assign Jmp = (Opcode==6'b000010)? 1'b1:1'b0;
    assign Jrn = (R_format && Function_opcode==6'b001000)? 1'b1:1'b0;
    assign Lw = (Opcode==6'b100011)? 1'b1:1'b0;
    assign Sw = (Opcode==6'b101011)? 1'b1:1'b0;
    assign MemorIOtoReg = Lw;
    assign MemWrite = ((Sw==1'b1)&&(Alu_resultHigh[21:0]!=22'b1111111111111111111111))? 1'b1:1'b0;
    assign I_format = (Opcode[5:3]==3'b001)? 1'b1:1'b0;
    assign Branch = (Opcode==6'b000100)? 1'b1:1'b0;
    assign nBranch = (Opcode==6'b000101)? 1'b1:1'b0;
    assign ALUSrc = I_format | Lw | Sw;
    assign RegWrite = ~(Jrn | Sw | Branch | nBranch | Jmp);
    assign Sftmd = R_format & (Function_opcode[5:3]==3'b000);
    assign ALUOp = {(R_format | I_format),(Branch | nBranch)};
    assign MemRead = ((Lw==1'b1)&&(Alu_resultHigh[21:0]!=22'b1111111111111111111111))? 1'b1:1'b0;
    assign IOWrite = ((Sw==1'b1)&&(Alu_resultHigh[21:0]==22'b1111111111111111111111))? 1'b1:1'b0;
    assign IORead = ((Lw==1'b1)&&(Alu_resultHigh[21:0]==22'b1111111111111111111111))? 1'b1:1'b0;    

endmodule