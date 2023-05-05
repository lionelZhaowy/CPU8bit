`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/03 19:45:57
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [3:0]ins,
    input [7:0]alu_in,
    input [7:0]accum,
    output [3:0]flags,
    output reg [7:0]alu_out
    );
    localparam NOP = 4'b0000;//空指令 short
    localparam LDO = 4'b0001;//从ROM取数据 long
    localparam LDA = 4'b0010;//从RAM取数据 long
    localparam LDR = 4'b0011;//从ACC取数据 short
    localparam PRE = 4'b0100;//从REG取数据 short
    localparam STO = 4'b0101;//向RAM写数据 long
    localparam ADD = 4'b0110;//操作数相加 short
    localparam SHL = 4'b0111;//逻辑左移 short
    localparam SHR = 4'b1000;//逻辑右移 short
    localparam SAR = 4'b1001;//算数右移 short
    localparam INV = 4'b1010;//按位取反 short
    localparam AND = 4'b1011;//按位与 short
    localparam  OR = 4'b1100;//按位或 short
    localparam XOR = 4'b1101;//按位异或 short
    localparam JMP = 4'b1110;//跳转 long
    localparam HLT = 4'b1111;//停机指令 short

    wire OF,ZF,PF,SF;//溢出、零、奇偶、符号位标志位
    assign OF = ((~alu_in[7])&(~accum[7])&alu_out[7])|(alu_in[7]&accum[7]&(~alu_out[7]));
    assign ZF = ~(|alu_out);//1为零 0非零
    assign PF = ^alu_out;   //1奇数 0偶数
    assign SF = alu_out[7]; //1负数 0正数(补码运算)
    assign flags = {OF,ZF,SF,PF};

    always @(*) begin
        case(ins)
            NOP:alu_out = accum;
            LDO:alu_out = alu_in;
            LDA:alu_out = alu_in;
            LDR:alu_out = accum;
            PRE:alu_out = alu_in;
            STO:alu_out = accum;
            ADD:alu_out = accum + alu_in;
            SHL:alu_out = alu_in<<1;
            SHR:alu_out = alu_in>>1;
            SAR:alu_out = {alu_in[7],alu_in[7:1]};
            INV:alu_out = ~alu_in;
            AND:alu_out = accum & alu_in;
            OR :alu_out = accum | alu_in;
            XOR:alu_out = accum ^ alu_in;
            JMP:alu_out = alu_in;
            HLT:alu_out = accum;
            default:alu_out = accum;
        endcase
    end
    
endmodule
