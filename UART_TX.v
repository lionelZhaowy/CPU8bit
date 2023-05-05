`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/18 18:01:34
// Design Name: 
// Module Name: UART_TX
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


module UART_TX #(
    parameter BAUD = 115200,
    parameter CLK_frq = 100000000
)(
    input sys_clk,//系统时钟
    input rst_n,//系统复位
    input uart_en,//UART发送使能端 异步信号
    input [7:0]data,//即将输出的BYTE
    output reg uart_txd//UART发送端
    );
    wire baud_clk;
    //产生波特率时钟
    CLK_div #(
        .BAUD(BAUD),
        .CLK_frq(CLK_frq)
    )CLK_div_dut(
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .baud_clk (baud_clk)
    );

    //uart_en异步信号同步化
    reg uart_en_d0,uart_en_d1;
    always @(posedge baud_clk or negedge rst_n) begin
        if(!rst_n)begin
            uart_en_d0 <= 1'b0;
            uart_en_d1 <= 1'b0;
        end
        else begin
            uart_en_d0 <= uart_en;
            uart_en_d1 <= uart_en_d0;
        end
    end

    //FSM状态编码
    localparam IDLE = 4'b0001;
    localparam START= 4'b0010;
    localparam DATA = 4'b0100;
    localparam STOP = 4'b1000;
    //FSM状态寄存器
    reg [3:0] cstate,nstate;
    //发送数据寄存器
    reg [7:0] data_reg;
    
    //发送bit计数器
    reg [2:0] data_cnt;
    always @(posedge baud_clk or negedge rst_n) begin
        if(!rst_n)begin
            data_cnt <= 3'd0;
        end
        else if(cstate == DATA)begin
            data_cnt <= data_cnt + 3'd1;
        end
        else begin
            data_cnt <= 3'd0;
        end
    end
    //FSM状态转移同步逻辑
    always @(posedge baud_clk or negedge rst_n) begin
        if(!rst_n)begin
            cstate <= IDLE;
        end
        else begin
            cstate <= nstate;
        end
    end
    //FSM产生下一个状态组合逻辑
    always @(*) begin
        case (cstate)
            IDLE,STOP:begin
                nstate = uart_en_d1?START:IDLE;
            end
            START:begin
                nstate = DATA;
            end
            DATA:begin//记满0~7则发送BYTE完毕
                nstate = (&data_cnt)?STOP:DATA;
            end
            default:nstate = IDLE;
        endcase
    end
    //FSM产生输出逻辑
    always @(posedge baud_clk or negedge rst_n) begin
        if(!rst_n)begin
            data_reg <= 8'h00;
            uart_txd <= 1'b1;
        end
        else begin
            case (nstate)
                START:begin
                    data_reg <= data;
                    uart_txd <= 1'b0;
                end
                DATA:begin
                    data_reg <= data_reg>>1;
                    uart_txd <= data_reg[0];
                end
                STOP:begin
                    data_reg <= 8'h00;
                    uart_txd <= 1'b1;
                end
                default:begin
                    data_reg <= 8'h00;
                    uart_txd <= 1'b1;
                end
            endcase
        end
    end

endmodule
