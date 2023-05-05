`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/03 19:45:57
// Design Name: 
// Module Name: ADDR_MUX
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


module ADDR_MUX(
    input [7:0]IR_addr,
    input [7:0]PC_addr,
    input sel,
    output [7:0]addr
    );
    assign addr = sel?IR_addr:PC_addr;//1 寄存器寻址 0 存储器寻址
endmodule
