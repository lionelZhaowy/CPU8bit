`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/03 19:45:57
// Design Name: 
// Module Name: RAM
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


module RAM(
    input read,
    input write,
    input en,
    input [7:0]addr,
    inout [7:0]data
    );
    reg [7:0] memory[255:0];
    //读操作
    assign data = (read&en)?memory[addr]:8'hzz;
    //写操作
    always @(posedge write) begin
        if(en)
            memory[addr] <= data;
    end
endmodule
