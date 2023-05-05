`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/03 19:45:57
// Design Name: 
// Module Name: CTRL
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


module CTRL(
    input clk,
    input rst_n,
    input [3:0]ins,
    output reg REG_write,
    output reg REG_read,
    output reg ROM_en,
    output reg ROM_read,
    output reg RAM_en,
    output reg RAM_write,
    output reg RAM_read,
    output reg PC_en,
    output reg PC_chg_en,
    output reg ACC_en,
    output reg [1:0]fetch,
    output reg ADDR_sel
    );
    //定义指令编码
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
    //定义状态机编码
    localparam IDLE = 4'hf;//初始状态
    localparam S0   = 4'h0;//取指0
    localparam S1   = 4'h1;//译码 PC+1
    localparam S2   = 4'h2;//HLT停机
    localparam S3   = 4'h3;//Long0 取指1 RAM/ROM寻址地址
    localparam S4   = 4'h4;//Long1 PC+1
    localparam S5   = 4'h5;//Long2 LDO/LDA访存取数
    localparam S6   = 4'h6;//Long2 STO_0读REG
    localparam S7   = 4'h7;//Long3 STO_1写RAM
    localparam S8   = 4'h8;//Short0 PRE/ADD读REG
    localparam S9   = 4'h9;//Short0 LDR_0 ACC写REG
    localparam S10  = 4'ha;
    //定义状态寄存器
    reg [3:0] cstate = IDLE;
    reg [3:0] nstate = IDLE;

    //状态转移同步逻辑
    always @(posedge clk) begin
        if(!rst_n)
            cstate <= IDLE;
        else
            cstate <= nstate;
    end
    //产生下一个状态组合逻辑
    always @(*) begin
        case(cstate)
            IDLE:begin
                nstate = S0;
            end
            S0:begin
                nstate = S1;
            end
            S1:begin
                if(ins == NOP)nstate = S0;
                else if(ins == HLT)nstate = S2;
                // else if((ins == PRE)|(ins == ADD)|(ins == AND)|(ins == OR)|(ins == XOR)|(ins == INV)|(ins == SHL)|(ins == SHR)|(ins == SAR))nstate = S8;
                else if(ins == LDR)nstate = S9;
                else if((ins == LDO)|(ins == LDA)|(ins == STO)|(ins == JMP)) nstate = S3;
                else nstate = S8;
            end
            S2:begin
                nstate = S2;
            end
            S3:begin
                if((ins == LDA)|(ins == LDO))nstate = S4;
                else if(ins == JMP)nstate = S10;
                else nstate = S6;//STO指令
            end
            S4:begin
                nstate = S5;
            end
            S5:begin
                nstate = S0;
            end
            S6:begin
                nstate = S7;
            end
            S7:begin
                nstate = S0;
            end
            S8:begin
                nstate = S0;
            end
            S9:begin
                nstate = S0;
            end
            S10:begin
                nstate = S0;
            end

            default:nstate = IDLE;
        endcase
    end
    //产生输出组合逻辑
    always @(*) begin
        case(cstate)
            IDLE:begin//初始状态
                REG_write= 1'b0;
                REG_read = 1'b0;
                ROM_en   = 1'b0;
                ROM_read = 1'b0;
                RAM_en   = 1'b0;
                RAM_write= 1'b0;
                RAM_read = 1'b0;
                PC_en    = 1'b0;
                PC_chg_en= 1'b0;
                ACC_en   = 1'b0;
                fetch    = 2'b00;
                ADDR_sel = 1'b0;
            end
            S0:begin//取指0
                REG_write= 1'b0;
                REG_read = 1'b0;
                ROM_en   = 1'b1;
                ROM_read = 1'b1;
                RAM_en   = 1'b0;
                RAM_write= 1'b0;
                RAM_read = 1'b0;
                PC_en    = 1'b0;
                PC_chg_en= 1'b0;
                ACC_en   = 1'b0;
                fetch    = 2'b01;
                ADDR_sel = 1'b0;
            end
            S1:begin//译码 PC+1
                REG_write= 1'b0;
                REG_read = 1'b0;
                ROM_en   = 1'b1;
                ROM_read = 1'b1;
                RAM_en   = 1'b0;
                RAM_write= 1'b0;
                RAM_read = 1'b0;
                PC_en    = 1'b1;
                PC_chg_en= 1'b0;
                ACC_en   = 1'b0;
                fetch    = 2'b00;
                ADDR_sel = 1'b0;
            end
            S2:begin//HLT停机
                REG_write= 1'b0;
                REG_read = 1'b0;
                ROM_en   = 1'b0;
                ROM_read = 1'b0;
                RAM_en   = 1'b0;
                RAM_write= 1'b0;
                RAM_read = 1'b0;
                PC_en    = 1'b0;
                PC_chg_en= 1'b0;
                ACC_en   = 1'b0;
                fetch    = 2'b00;
                ADDR_sel = 1'b0;
            end
            S3:begin//Long0 取指1
                REG_write= 1'b0;
                REG_read = 1'b0;
                ROM_en   = 1'b1;
                ROM_read = 1'b1;
                RAM_en   = 1'b0;
                RAM_write= 1'b0;
                RAM_read = 1'b0;
                PC_en    = 1'b0;
                PC_chg_en= 1'b0;
                ACC_en   = 1'b0;
                fetch    = 2'b10;
                ADDR_sel = 1'b0;
            end
            S4:begin//Long1 PC+1
                if(ins == LDO)begin
                    REG_write= 1'b1;
                    REG_read = 1'b0;
                    ROM_en   = 1'b1;
                    ROM_read = 1'b1;
                    RAM_en   = 1'b0;
                    RAM_write= 1'b0;
                    RAM_read = 1'b0;
                    PC_en    = 1'b0;
                    PC_chg_en= 1'b0;
                    ACC_en   = 1'b0;
                    fetch    = 2'b00;
                    ADDR_sel = 1'b1;
                end
                else begin//LDA
                    REG_write= 1'b1;
                    REG_read = 1'b0;
                    ROM_en   = 1'b0;
                    ROM_read = 1'b0;
                    RAM_en   = 1'b1;
                    RAM_write= 1'b0;
                    RAM_read = 1'b1;
                    PC_en    = 1'b0;
                    PC_chg_en= 1'b0;
                    ACC_en   = 1'b0;
                    fetch    = 2'b00;
                    ADDR_sel = 1'b1;
                end
            end
            S5:begin//Long2 LDO访存取数
                if(ins == LDO)begin
                    REG_write= 1'b1;
                    REG_read = 1'b0;
                    ROM_en   = 1'b1;
                    ROM_read = 1'b1;
                    RAM_en   = 1'b0;
                    RAM_write= 1'b0;
                    RAM_read = 1'b0;
                    PC_en    = 1'b1;
                    PC_chg_en= 1'b0;
                    ACC_en   = 1'b0;
                    fetch    = 2'b00;
                    ADDR_sel = 1'b1;
                end
                else begin//LDA
                    REG_write= 1'b1;
                    REG_read = 1'b0;
                    ROM_en   = 1'b0;
                    ROM_read = 1'b0;
                    RAM_en   = 1'b1;
                    RAM_write= 1'b0;
                    RAM_read = 1'b1;
                    PC_en    = 1'b1;
                    PC_chg_en= 1'b0;
                    ACC_en   = 1'b0;
                    fetch    = 2'b00;
                    ADDR_sel = 1'b1;
                end
            end
            S6:begin//Long2 STO_0读REG
                REG_write= 1'b0;
                REG_read = 1'b1;
                ROM_en   = 1'b0;
                ROM_read = 1'b0;
                RAM_en   = 1'b0;
                RAM_write= 1'b0;
                RAM_read = 1'b0;
                PC_en    = 1'b1;
                PC_chg_en= 1'b0;
                ACC_en   = 1'b0;
                fetch    = 2'b00;
                ADDR_sel = 1'b0;
            end
            S7:begin//Long3 STO_1写RAM
                REG_write= 1'b0;
                REG_read = 1'b1;
                ROM_en   = 1'b0;
                ROM_read = 1'b0;
                RAM_en   = 1'b1;
                RAM_write= 1'b1;
                RAM_read = 1'b0;
                PC_en    = 1'b0;
                PC_chg_en= 1'b0;
                ACC_en   = 1'b0;
                fetch    = 2'b00;
                ADDR_sel = 1'b1;
            end
            S8:begin//Short0 PRE读REG
                if(ins == PRE)begin
                    REG_write= 1'b0;
                    REG_read = 1'b1;
                    ROM_en   = 1'b0;
                    ROM_read = 1'b0;
                    RAM_en   = 1'b0;
                    RAM_write= 1'b0;
                    RAM_read = 1'b0;
                    PC_en    = 1'b0;
                    PC_chg_en= 1'b0;
                    ACC_en   = 1'b1;
                    fetch    = 2'b00;
                    ADDR_sel = 1'b0;
                end
                else begin//ADD读REG
                    REG_write= 1'b0;
                    REG_read = 1'b1;
                    ROM_en   = 1'b0;
                    ROM_read = 1'b0;
                    RAM_en   = 1'b0;
                    RAM_write= 1'b0;
                    RAM_read = 1'b0;
                    PC_en    = 1'b0;
                    PC_chg_en= 1'b0;
                    ACC_en   = 1'b1;
                    fetch    = 2'b00;
                    ADDR_sel = 1'b0;
                end
            end
            S9:begin//Short0 LDR_0 ACC写寄存器
                REG_write= 1'b1;
                REG_read = 1'b0;
                ROM_en   = 1'b0;
                ROM_read = 1'b0;
                RAM_en   = 1'b0;
                RAM_write= 1'b0;
                RAM_read = 1'b0;
                PC_en    = 1'b0;
                PC_chg_en= 1'b0;
                ACC_en   = 1'b1;
                fetch    = 2'b00;
                ADDR_sel = 1'b0;
            end
            S10:begin//JMP 修改PC
                REG_write= 1'b0;
                REG_read = 1'b0;
                ROM_en   = 1'b1;
                ROM_read = 1'b1;
                RAM_en   = 1'b0;
                RAM_write= 1'b0;
                RAM_read = 1'b0;
                PC_en    = 1'b1;
                PC_chg_en= 1'b1;
                ACC_en   = 1'b0;
                fetch    = 2'b10;
                ADDR_sel = 1'b0;
            end
            default:begin
                REG_write= 1'b0;
                REG_read = 1'b0;
                ROM_en   = 1'b0;
                ROM_read = 1'b0;
                RAM_en   = 1'b0;
                RAM_write= 1'b0;
                RAM_read = 1'b0;
                PC_en    = 1'b0;
                PC_chg_en= 1'b0;
                ACC_en   = 1'b0;
                fetch    = 2'b00;
                ADDR_sel = 1'b0;
            end
        endcase
    end

endmodule
