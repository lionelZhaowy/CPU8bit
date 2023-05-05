`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/03 19:45:57
// Design Name: 
// Module Name: REG
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


module REG(
    input clk,
    input write,
    input read,
    input [7:0]addr,
    input [7:0]reg_in,
    output [7:0]reg_out
    );
    //片上集成一个16Byte的通用寄存器
    reg [7:0] Register [15:0];
    //取地址 为指令的低四位
    wire [3:0]addr_r;
    assign addr_r = addr[3:0];
    assign reg_out = read?Register[addr_r]:8'hzz;

    always @(posedge clk) begin
        if(write)
            Register[addr_r] <= reg_in;
    end

endmodule
