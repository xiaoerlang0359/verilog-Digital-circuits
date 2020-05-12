`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/22 22:20:28
// Design Name: 
// Module Name: control
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


module control(
        input [5:0]Op_Code,
        input [5:0]Function_Code,
        output Beq,
        output Bne,
        output MemtoReg,
        output MemWrite,
        output [3:0]AluOP,
        output AluSrcB,
        output RegWrite,
        output Jal,
        output RegDst,
        output Syscall,
        output Jmp,
        output Jr,
        output SignedExt
    );
    wire OP1,OP2,OP3,OP0,OP4,OP5;
    wire F0,F1,F2,F3,F4,F5;
    wire S0,S1,S2,S3;
    assign OP0=Op_Code[0];
    assign OP1=Op_Code[1];
    assign OP2=Op_Code[2];
    assign OP3=Op_Code[3];
    assign OP4=Op_Code[4];
    assign OP5=Op_Code[5];
    assign F0=Function_Code[0];
    assign F1=Function_Code[1];
    assign F2=Function_Code[2];
    assign F3=Function_Code[3];
    assign F4=Function_Code[4];
    assign F5=Function_Code[5];
    assign S0=~OP0 & ~OP1& ~OP2& ~OP4& ~OP5& ~F0& ~F1& ~F3& ~F4& F5 | 
               ~OP0& ~OP1& ~OP2& ~OP4& ~OP5& ~F1& ~F2& ~F3& ~F4& F5 |
               ~OP0& ~OP1& ~OP2& ~OP4& ~OP5& ~F0& F1& ~F2& F3& ~F4& F5 |
               ~OP0& ~OP1& ~OP2& ~OP4& ~OP5& F0& F1& ~F2& ~F3& ~F4& ~F5 |
               ~OP0& ~OP1& OP3& ~OP4& ~OP5 | ~OP0& ~OP2& OP3& ~OP4& ~OP5|
               ~OP1& ~OP2& OP3& ~OP4& ~OP5 | OP0& OP1& ~OP2& ~OP4& OP5;
    assign S1=~OP0& ~OP1& ~OP2& ~OP3& ~OP4& ~OP5& ~F0& ~F1& F2& ~F3& ~F4& F5 |
              ~OP0& ~OP1& ~OP2& ~OP3& ~OP4& ~OP5& ~F0& F1& ~F2& ~F3& ~F4 |
              ~OP0& ~OP1& ~OP2& ~OP3& ~OP4& ~OP5& ~F0& F1& ~F2& ~F4& F5 |
              ~OP0& ~OP1& ~OP2& ~OP3& ~OP4& ~OP5& F0& F1& F2& ~F3& ~F4& F5 | 
              ~OP0& ~OP1& OP2& OP3& ~OP4& ~OP5 | ~OP0& OP1& ~OP2& OP3& ~OP4& ~OP5;
    assign S2=~OP0& ~OP1& ~OP2& ~OP4& ~OP5& ~F0& ~F1& ~F3& ~F4& F5 |
            ~OP0& ~OP1& ~OP2& ~OP4& ~OP5& ~F0& ~F2& ~F3& ~F4& F5 |
            ~OP0& ~OP1& ~OP2& ~OP4& ~OP5& ~F1& ~F2& ~F3& ~F4& F5 |
            ~OP0& ~OP1& ~OP2& ~OP4& ~OP5& F0& F1& ~F2& F3& ~F4& F5 |
            ~OP0& ~OP1& OP3& ~OP4& ~OP5 | ~OP1& ~OP2& OP3& ~OP4& ~OP5 | OP0& OP1& ~OP2& ~OP4& OP5;
    assign S3=~OP0& ~OP1& ~OP2& ~OP3& ~OP4& ~OP5& F1& ~F2& F3& ~F4& F5 |
            ~OP0& ~OP1& ~OP2& ~OP3& ~OP4& ~OP5& F0& F2& ~F3& ~F4& F5 |
            ~OP0& OP1& ~OP2& OP3& ~OP4& ~OP5 | OP0& ~OP1& OP2& OP3& ~OP4& ~OP5;
    assign AluOP={S3,S2,S1,S0};
    assign Beq = (Op_Code==6'b000100)? 1'b1:1'b0;
    assign Bne = (Op_Code==6'b000101)? 1'b1:1'b0;
    assign Syscall = ~OP0& ~OP1& ~OP2& ~OP3& ~OP4& ~OP5& ~F0& ~F1& F2& F3& ~F4& ~F5;
    assign MemWrite = (Op_Code==6'b101011)? 1'b1:1'b0;
    assign MemtoReg = (Op_Code==6'b100011)? 1'b1:1'b0;
    assign Jal = (Op_Code==6'b000011)? 1'b1:1'b0;
    assign Jmp = (Op_Code==6'b000010)? 1'b1:1'b0;
    assign Jr = (Op_Code==6'd0 && Function_Code==6'b001000)? 1'b1:1'b0;
    assign RegDst = (Op_Code==6'b000000)? 1'b1:1'b0;
    assign AluSrcB = ~OP0& ~OP2& OP3& ~OP4& ~OP5 | ~OP1& OP3& ~OP4& ~OP5 | OP0& OP1& ~OP2& ~OP4& OP5;
    assign RegWrite = ~OP0& ~OP1& ~OP2& ~OP4& ~OP5& ~F0& ~F2& ~F3& ~F4 |
                    ~OP0& ~OP1& ~OP2& ~OP4& ~OP5& ~F1& ~F3& ~F4& F5 | 
                    ~OP0& ~OP1& ~OP2& ~OP4& ~OP5& F1& ~F2& ~F3& ~F4& ~F5 | 
                    ~OP0& ~OP1& ~OP2& ~OP4& ~OP5& F1& ~F2& F3& ~F4& F5 | 
                    ~OP0& ~OP1& ~OP2& ~OP4& ~OP5& F0& F2& ~F3& ~F4& F5 | 
                    ~OP0& ~OP2& OP3& ~OP4& ~OP5 | ~OP1& OP3& ~OP4& ~OP5 | OP0& OP1& ~OP2& ~OP3& ~OP4;
    assign SignedExt = ~OP0& ~OP2& OP3& ~OP4& ~OP5 | ~OP1& ~OP2& OP3& ~OP4& ~OP5 | ~OP1& OP2& ~OP3& ~OP4& ~OP5 | OP0& OP1& ~OP2& ~OP4& OP5;
endmodule
