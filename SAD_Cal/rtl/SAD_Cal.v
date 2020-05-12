`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/14 22:26:08
// Design Name: 
// Module Name: SAD_Cal
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


module SAD_Cal(
    output [15:0] sad,
    output sad_vld,
    input [2047:0] dina,
    input [2047:0] refi,
    input cal_en,
    input rst_n,clk
    );
    reg [2047:0] out_reg1;
    reg [8:0] count1;
    reg sad_vld1;
    always @(posedge clk or negedge rst_n)
    begin
        if (rst_n==1'b0)begin
            count1<=9'd0;
            out_reg1<=2048'd0;
            sad_vld1<=1'b0;
        end else begin
            sad_vld1<=cal_en;
            if (cal_en)begin
            for (count1=0;count1<9'd256;count1=count1+1)begin
                if (dina[count1*8+:8]>refi[count1*8+:8])
                    out_reg1[count1*8+:8]<=dina[count1*8+:8]-refi[count1*8+:8];
                else
                    out_reg1[count1*8+:8]<=refi[count1*8+:8]-dina[count1*8+:8];
            end
        end
        end
    end
    reg [1151:0] out_reg2;
    reg [8:0] count2;
    reg sad_vld2;
    always @(posedge clk or negedge rst_n)
    begin
        if (rst_n==1'b0)begin
            count2<=9'd0;
            out_reg2<=1052'd0;
            sad_vld2<=1'b0;
        end else begin
            sad_vld2<=sad_vld1; 
            if (sad_vld1)begin
            for (count2=0;count2<9'd128;count2=count2+1)begin
                out_reg2[count2*9+:9]<=out_reg1[count2*16+:8]+out_reg1[count2*16+8+:8];
            end
        end
        end
    end
    reg [639:0] out_reg3;
    reg [8:0] count3;
    reg sad_vld3;
    always @(posedge clk or negedge rst_n)
    begin
        if (rst_n==1'b0)begin
            count3<=9'd0;
            out_reg3<=640'd0;
            sad_vld3<=1'b0;
        end else begin
            sad_vld3<=sad_vld2;
            if (sad_vld2)begin
            for (count3=0;count3<9'd64;count3=count3+1)begin
                out_reg3[count3*10+:10]<=out_reg2[count3*18+:9]+out_reg2[count3*18+9+:9];
            end
        end
        end
    end
    reg [351:0] out_reg4;
    reg [8:0] count4;
    reg sad_vld4;
    always @(posedge clk or negedge rst_n)
    begin
        if (rst_n==1'b0)begin
            count4<=9'd0;
            out_reg4<=352'd0;
            sad_vld4<=1'b0;
        end else begin
            sad_vld4<=sad_vld3;
            if (sad_vld3)begin
            for (count4=0;count4<9'd32;count4=count4+1)begin
                out_reg4[count4*11+:11]<=out_reg3[count4*20+:10]+out_reg3[count4*20+10+:10];
            end
        end
        end
    end
    reg [191:0] out_reg5;
    reg [8:0] count5;
    reg sad_vld5;
    always @(posedge clk or negedge rst_n)
    begin
        if (rst_n==1'b0)begin
            count5<=9'd0;
            out_reg5<=192'd0;
            sad_vld5<=1'b0;
        end else begin
            sad_vld5<=sad_vld4;
            if (sad_vld4)begin
            for (count5=0;count5<9'd16;count5=count5+1)begin
                out_reg5[count5*12+:12]<=out_reg4[count5*22+:11]+out_reg4[count5*22+11+:11];
            end
        end
        end
    end
    reg [103:0] out_reg6;
    reg [8:0] count6;
    reg sad_vld6;
    always @(posedge clk or negedge rst_n)
    begin
        if (rst_n==1'b0)begin
            count6<=9'd0;
            out_reg6<=104'd0;
            sad_vld6<=1'b0;
        end else begin
            sad_vld6<=sad_vld5;
            if (sad_vld5)begin
            for (count6=0;count6<9'd8;count6=count6+1)begin
                out_reg6[count6*13+:13]<=out_reg5[count6*24+:12]+out_reg5[count6*24+12+:12];
            end
        end
        end
    end
    reg [55:0] out_reg7;
    reg [8:0] count7;
    reg sad_vld7;
    always @(posedge clk or negedge rst_n)
    begin
        if (rst_n==1'b0)begin
            count7<=9'd0;
            out_reg7<=56'd0;
            sad_vld7<=1'b0;
        end else begin
            sad_vld7<=sad_vld6;
            if (sad_vld6)begin
            for (count7=0;count7<9'd4;count7=count7+1)begin
                out_reg7[count7*14+:14]<=out_reg6[count7*26+:13]+out_reg6[count7*26+13+:13];
            end
        end
        end
    end
    reg [29:0] out_reg8;
    reg [2:0] count8;
    reg sad_vld8;
    always @(posedge clk or negedge rst_n)
    begin
        if (rst_n==1'b0)begin
            count8<=3'd0;
            out_reg8<=30'd0;
            sad_vld8<=1'b0;
        end else begin
            sad_vld8<=sad_vld7;
            if (sad_vld7)begin
            for (count8=0;count8<3'd2;count8=count8+1)begin
                out_reg8[count8*15+:15]<=out_reg7[count8*28+:14]+out_reg7[count8*28+14+:14];
            end
        end
        end
    end
    reg [15:0] out_reg9;
    reg [2:0] count9;
    reg sad_vld9;
    assign sad=(sad_vld9)? out_reg9:16'd0;
    assign sad_vld = sad_vld9;
    always @(posedge clk or negedge rst_n)
    begin
        if (rst_n==1'b0)begin
            count9<=3'd0;
            out_reg9<=16'd0;
            sad_vld9<=1'b0;
        end else begin
            sad_vld9<=sad_vld8;
            if (sad_vld8) begin
            out_reg9<=out_reg8[14:0]+out_reg8[29:15];
        end
        end
    end 
endmodule
