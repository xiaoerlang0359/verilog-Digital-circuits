`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Idecode32(read_data_1,read_data_2,Instruction,read_data,ALU_result,
                 Jal,RegWrite,MemorIOtoReg,RegDst,Sign_extend,clock,reset,
                 opcplus4,read_register_1_address);
    output[31:0] read_data_1;
    output[31:0] read_data_2;
    input[31:0]  Instruction;
    input[31:0]  read_data;   				//  ��DATA RAM or I/O portȡ��������
    input[31:0]  ALU_result;   				//  ��Ҫ��չ��������32λ
    input        Jal; 
    input        RegWrite;
    input        MemorIOtoReg;
    input        RegDst;
    output[31:0] Sign_extend;
    input		 clock,reset;
    input[31:0]  opcplus4;                 // ����ȡָ��Ԫ��JAL����
    output[4:0] read_register_1_address;
    
    wire[31:0] read_data_1;
    wire[31:0] read_data_2;
    reg[31:0] register[0:31];			   //�Ĵ����鹲32��32λ�Ĵ���
    reg[4:0] write_register_address;
    reg[31:0] write_data;
    wire[4:0] read_register_2_address;
    wire[4:0] write_register_address_1;
    wire[4:0] write_register_address_0;
    wire[15:0] Instruction_immediate_value;
    wire[5:0] opcode;
    

    wire sign;
    assign opcode = Instruction[31:26];
    assign read_register_1_address = Instruction[25:21];
    assign read_register_2_address = Instruction[20:16];
    assign write_register_address_1 = Instruction[15:11];
    assign write_register_address_0 = Instruction[20:16];
    assign Instruction_immediate_value = Instruction[15:0];
    
    assign read_data_1 = register[read_register_1_address];
    assign read_data_2 = register[read_register_2_address];
    assign sign = Instruction_immediate_value[15];
    assign Sign_extend = (opcode[5:2]==4'b0011 || opcode==6'b001011)? {16'h0000,Instruction_immediate_value}:{{16{sign}},Instruction_immediate_value};
    always @* begin                                            //�������ָ����ָͬ���µ�Ŀ��Ĵ���
        if (reset==1'b1)
            write_register_address<=5'd0;
        else
        if (Jal)
            write_register_address<=5'd31;
        else
        if (RegDst)
            write_register_address<=write_register_address_1;
        else 
            write_register_address<=write_register_address_0;         
    end
    
    always @* begin  //������̻�������ʵ�ֽṹͼ�����µĶ�·ѡ����,׼��Ҫд������
        if (reset==1'b1)
            write_data<=32'd0;
        else
        if (Jal)
            write_data<=opcplus4;
        else
        if (MemorIOtoReg)
            write_data<=read_data;
        else write_data<=ALU_result;
     end
    
    integer i;
    always @(posedge clock) begin       // ������дĿ��Ĵ���
        if(reset==1) begin              // ��ʼ���Ĵ�����
            for(i=0;i<32;i=i+1) register[i] <= i;
        end else if(RegWrite==1) begin  // ע��Ĵ���0�����0
            for (i=0;i<32;i=i+1) 
                if (i==write_register_address)
                    register[i]<=write_data;
                else 
                    register[i]<=register[i];

        end
    end
endmodule
