`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/18 18:01:34
// Design Name: 
// Module Name: UART_RX
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


module UART_RX #(
    parameter BAUD = 115200,//bps
    parameter CLK_frq = 100000000,//Hz
    parameter VERIFY_MODE = 0//默认不校验
)(
    input sys_clk,//系统时钟
    input rst_n,//系统复位
    input uart_rxd,//UART传输端
    output reg uart_rx_done,//接收完成标志
    output reg [7:0]uart_rx_data//接收到的数据
    );
    //校验参数定义
    parameter VERIFY_NONE = 2'b00;//无校验
    parameter VERIFY_ODD  = 2'b01;//奇校验
    parameter VERIFY_EVEN = 2'b11;//偶校验
     //FSM状态编码
    localparam IDLE = 4'b0001;
    localparam DATA = 4'b0010;
    localparam VERI = 4'b0100;
    localparam STOP = 4'b1000;
    //FSM状态寄存器
    reg [3:0] cstate,nstate;//状态寄存器
    reg uart_rxd_d0,uart_rxd_d1;//打两拍同步化
    reg [2:0] data_cnt;//接收数据位数寄存器
    wire baud_clk;//波特率时钟
    wire odd_verify_flag;//奇校验成功标志
    wire even_verify_flag;//偶校验成功标志
    //产生波特率时钟
    CLK_div #(
        .BAUD(BAUD),
        .CLK_frq(CLK_frq)
    )CLK_div(
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .baud_clk (baud_clk)
    );

    //uart_rxd异步信号同步化 减少亚稳态影响
    always @(posedge sys_clk or negedge rst_n) begin
        if(!rst_n)begin
            uart_rxd_d0 <= 1'b0;
            uart_rxd_d1 <= 1'b0;
        end
        else begin
            uart_rxd_d0 <= uart_rxd;
            uart_rxd_d1 <= uart_rxd_d0;
        end
    end

    //接收bit数计数器
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
    //状态转移同步逻辑
    always @(posedge baud_clk or negedge rst_n) begin
        if(!rst_n)begin
            cstate <= IDLE;
        end
        else begin
            cstate <= nstate;
        end
    end
    //产生下一个状态组合逻辑
    always @(*) begin
        case (cstate)
            IDLE: nstate = uart_rxd_d1?IDLE:DATA;
            DATA: nstate = (&data_cnt)?((VERIFY_MODE==VERIFY_NONE)?STOP:VERI):DATA;
            VERI: nstate = STOP;
            STOP: nstate = IDLE;
            default:nstate = IDLE;
        endcase
    end
    //产生输出逻辑 下降沿采样数据稳定
    always @(negedge baud_clk or negedge rst_n) begin
        if(!rst_n)begin
            uart_rx_data <= 8'd0;
        end
        else begin
            case (cstate)
                DATA:uart_rx_data <= {uart_rxd_d1,uart_rx_data[7:1]};
                VERI,STOP:uart_rx_data <= uart_rx_data;
                default:uart_rx_data <= 8'd0;
            endcase
        end
    end
    //产生校验位
    assign odd_verify_flag = (VERIFY_MODE == VERIFY_ODD) && (uart_rxd_d1 == ~(^uart_rx_data))?1'b1:1'b0;
    assign even_verify_flag = (VERIFY_MODE == VERIFY_EVEN) && (uart_rxd_d1 == ^uart_rx_data)?1'b1:1'b0;
    
    always @(posedge baud_clk or negedge rst_n) begin
        if(!rst_n)begin
            uart_rx_done <= 1'b0;
        end
        else begin
            case (nstate)
                VERI:uart_rx_done <= (odd_verify_flag||even_verify_flag)?1'b1:1'b0;
                STOP:uart_rx_done <= 1'b1;
                default:uart_rx_done <= 1'b0;
            endcase
        end
    end

endmodule
