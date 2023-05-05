`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/03 19:45:57
// Design Name: 
// Module Name: PC
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


module PC(
    input clk,
    input rst_n,
    input en,
    input chg_en,//修改PC计数器数值使能
    input [7:0]chg_addr,//修改PC计数器数值
    output reg [7:0]PC_addr
    );
    initial begin
        PC_addr = 0;
    end
    always @(posedge clk) begin
        if(!rst_n)
            PC_addr <= 8'h00;
        else if(en)
            if(chg_en)
                PC_addr <= chg_addr;
            else
                PC_addr <= PC_addr + 8'h01;
        else
            PC_addr <= PC_addr;
    end

endmodule
