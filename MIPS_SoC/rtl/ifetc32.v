`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module Ifetc32(Instruction,PC_plus_4_out,Add_result,Read_data_1,Branch,nBranch,Jmp,Jal,Jrn,Zero,clock,reset,opcplus4);
    output[31:0] Instruction;			// 输出指令
    output[31:0] PC_plus_4_out;
    input[31:0]  Add_result;
    input[31:0]  Read_data_1;
    input        Branch;
    input        nBranch;
    input        Jmp;
    input        Jal;
    input        Jrn;
    input        Zero;
    input        clock,reset;
    output[31:0] opcplus4;

    
    wire[31:0]   PC_plus_4;
    reg[31:0]	  PC;
    reg[31:0]    next_PC; 
    wire[31:0]   Jpadr;
    reg[31:0]    opcplus4;
    
   //分配64KB ROM，编译器实际只用 64KB ROM
    prgrom instmem(
        .clka(clock),         // input wire clka
        .addra(PC[15:2]),     // input wire [13 : 0] addra
        .douta(Jpadr)         // output wire [31 : 0] douta
    );
    assign PC_plus_4[31:2] = PC[31:2]+30'd1;
    assign PC_plus_4[1:0] = 2'b0;
    assign PC_plus_4_out = PC_plus_4;

    assign Instruction = Jpadr;              //  取出指令

    always @* begin                          // beq $n ,$m if $n=$m branch   bne if $n /=$m branch jr
        if (reset==1'b1)
            next_PC=32'd0;
        else if ((Branch && Zero)||(nBranch && (!Zero)))
            next_PC=Add_result<<2;
        else if (Jrn)
            next_PC=Read_data_1<<2;
        else next_PC=PC_plus_4;
    end
    
   always @(negedge clock) begin
    if (reset==1'b1)
    begin
        opcplus4 = opcplus4;
        PC = 32'd0;
    end
    else if (Jal || Jmp)
    begin
        if (Jal)
            opcplus4 = PC_plus_4>>2;
        else opcplus4 = opcplus4;
        PC = {6'd0,Instruction[25:0]}<<2;
    end
    else if ((Branch && Zero)||(nBranch && (!Zero))|| Jrn)
    begin
        opcplus4 = opcplus4;
        PC = next_PC;
    end
    else begin
        opcplus4 = opcplus4;
        PC = PC_plus_4;
    end
   end
endmodule
