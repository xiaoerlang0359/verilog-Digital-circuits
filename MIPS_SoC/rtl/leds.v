`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module leds(led_clk,ledrst,ledwrite,ledaddrcs,ledwdata,ledout);
    input led_clk,ledrst;
    input ledwrite;
    input ledaddrcs;
    input[15:0] ledwdata;
    output[15:0] ledout;
    
    reg [15:0] ledout;
    
    always@(posedge led_clk or posedge ledrst) begin
        if (ledrst==1'b1) ledout<=16'd0;
        else
            if (ledaddrcs && ledwrite)
                ledout<=ledwdata;
            else ledout<=ledout;
    end
endmodule
