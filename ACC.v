`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/03 20:25:15
// Design Name: 
// Module Name: ACC
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


module ACC(
    input clk,
    input rst_n,
    input en,
    input [7:0]acc_in,
    output reg [7:0]acc_out
    );
    
    always @(posedge clk) begin
        if(!rst_n)
            acc_out <= 8'h00;
        else if(en)
            acc_out <= acc_in;
        else
            acc_out <= acc_out;
    end
endmodule
