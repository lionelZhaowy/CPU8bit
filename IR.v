`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/03 19:45:57
// Design Name: 
// Module Name: IR
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


module IR(
    input clk,
    input rst_n,
    input [1:0]fetch,//取指类型
    input [7:0]data, //数据总线
    output [3:0]ins,
    output [3:0]addr_reg,//寄存器寻址地址
    output [7:0]addr_mem //存储器寻址地址
    );
    reg [7:0] ins_p1,ins_p2;

    assign ins = ins_p1[7:4];//取指令
    assign addr_reg = ins_p1[3:0];//寄存器地址
    assign addr_mem = ins_p2;//存储器地址

    always @(posedge clk) begin
        if(!rst_n)begin
            ins_p1 <= 8'h00;
            ins_p2 <= 8'h00;
        end
        else begin
            if(fetch == 2'b01)begin//从REG取数据
                ins_p1 <= data;
                ins_p2 <= ins_p2;
            end
            else if(fetch == 2'b10)begin//从MEM取数据
                ins_p1 <= ins_p1;
                ins_p2 <= data;
            end
            else begin
                ins_p1 <= ins_p1;
                ins_p2 <= ins_p2;
            end
        end
    end

endmodule
