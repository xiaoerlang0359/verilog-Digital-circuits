`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/13 22:15:24
// Design Name: 
// Module Name: myadd_sim
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


module myadd_sim(    
    );
    reg [3:0] a,b;
    reg cin;
    wire [3:0] sum;
    wire cout;
    reg clk;
    initial
    begin
        clk=0;
        repeat(2)@(posedge clk); #1;
        for (a=0;a<4'hf;a=a+1)
            for (b=0;b<4'hf;b=b+1) begin
                cin=0;
                @(posedge clk); #1;
            end 
        for (a=0;a<4'hf;a=a+1)
            for (b=0;b<4'hf;b=b+1) begin
                cin=0;
                @(posedge clk); #1;
            end
        repeat(2) @(posedge clk);
        $display("sim over");
        $finish();    
    end
    always #5 clk = ~clk;
    myadd myadd0(.sum(sum),.cout(cout),.cin(cin),.a(a),.b(b));
endmodule
