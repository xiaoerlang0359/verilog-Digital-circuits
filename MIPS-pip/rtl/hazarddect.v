`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/26 14:30:00
// Design Name: 
// Module Name: hazarddect
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


module hazarddect(
    input [4:0] r1_num,
    input [4:0] r2_num,
    input [5:0] Op_Code,
    input [5:0] Function_Code,
    input RegWrite_ID,
    input RegWrite_EX,
    input [4:0] w1_num_EX,
    input [4:0] w1_num_MEM,
    output Hazard
    );
    wire OP0,OP1,OP2,OP3,OP4,OP5;
    wire F0,F1,F2,F3,F4,F5;
    wire r1_used,r2_used;
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
    assign r1_used = ~OP0& ~OP1& ~OP4& ~OP5& ~F0& ~F2& ~F3& ~F4& F5 |
                    ~OP0& ~OP1& ~OP4& ~OP5& ~F1& ~F3& ~F4& F5 | 
                    ~OP0& ~OP1& ~OP4& ~OP5& ~F0& ~F1& F3& ~F4& ~F5 | 
                    ~OP0& ~OP1& ~OP4& ~OP5& F1& ~F2& F3& ~F4& F5 | 
                    ~OP0& ~OP1& ~OP4& ~OP5& F0& F2& ~F3& ~F4& F5 | 
                    ~OP0& ~OP2& OP3& ~OP4& ~OP5 | ~OP1& OP3& ~OP4& ~OP5 | ~OP1& OP2& ~OP4& ~OP5 | OP0& OP1& ~OP2& ~OP4& OP5;
    assign r2_used = ~OP0& ~OP1& ~OP3& ~OP4& ~OP5& ~F0& ~F2& ~F3& ~F4 | 
                    ~OP0& ~OP1& ~OP3& ~OP4& ~OP5& ~F1& ~F3& ~F4& F5 | 
                    ~OP0& ~OP1& ~OP3& ~OP4& ~OP5& ~F0& ~F1& F2& F3& ~F4& ~F5 | 
                    ~OP0& ~OP1& ~OP3& ~OP4& ~OP5& F1& ~F2& ~F3& ~F4& ~F5 | 
                    ~OP0& ~OP1& ~OP3& ~OP4& ~OP5& F1& ~F2& F3& ~F4& F5 | 
                    ~OP0& ~OP1& ~OP3& ~OP4& ~OP5& F0& F2& ~F3& ~F4& F5 | 
                    ~OP1& OP2& ~OP3& ~OP4& ~OP5 | OP0& OP1& ~OP2& OP3& ~OP4& OP5;
    assign Hazard = (r1_used & (r1_num==w1_num_EX) & RegWrite_ID & (r1_num!=5'd0))|(r1_used & (r1_num==w1_num_MEM) & RegWrite_EX & (r1_num!=5'd0))|
                    (r2_used & (r2_num==w1_num_EX) & RegWrite_ID & (r2_num!=5'd0))|(r2_used & (r2_num==w1_num_MEM) & RegWrite_EX & (r2_num!=5'd0));
endmodule
