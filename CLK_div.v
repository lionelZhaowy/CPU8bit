`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/18 18:01:34
// Design Name: 
// Module Name: CLK_div
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


module CLK_div #(
    parameter BAUD = 115200,
    parameter CLK_frq = 100000000
)(
    input sys_clk,//系统时钟
    input rst_n,//系统复位
    output reg baud_clk//波特率时钟
    );
    parameter DIV_MAX = CLK_frq/BAUD;//传输一位所需周期数
    parameter EDGE_NUM =DIV_MAX/2;//跳变周期

    reg [8:0]clk_cnt;//分频计数器
    //计数器控制逻辑
    always @(posedge sys_clk or negedge rst_n) begin
        if(!rst_n)begin
            clk_cnt <= 10'd0;
            baud_clk <= 1'b0;
        end
        else if(clk_cnt == EDGE_NUM)begin
            clk_cnt <= 10'd0;
            baud_clk <= ~baud_clk;
        end
        else begin
            clk_cnt <= clk_cnt + 10'd1;
            baud_clk <= baud_clk;
        end
    end
    
endmodule
