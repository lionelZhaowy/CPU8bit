`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/03 19:45:57
// Design Name: 
// Module Name: CORE
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


module CORE(
    input clk,
    input rst_n,
    output [7:0]DB,
    output [7:0]AB,
    output ROM_en,
    output ROM_read,
    output RAM_en,
    output RAM_read,
    output RAM_write
    );
    //声明信号线
    wire [1:0] fetch;
    wire [3:0] ins;
    wire [3:0] REG_addr;
    wire [7:0] IR_addr,PC_addr;
    wire [7:0] acc_out,alu_out;
    wire REG_write,REG_read,PC_en,PC_chg_en,ACC_en,ADDR_sel;
    // reg rst_n = 1'b1;

    //子模块实例化
    CTRL CTRL_0 (
        .clk (clk),
        .rst_n (rst_n),
        .ins (ins),
        .REG_write (REG_write),
        .REG_read (REG_read),
        .ROM_en (ROM_en),
        .ROM_read (ROM_read),
        .RAM_en (RAM_en),
        .RAM_write (RAM_write),
        .RAM_read (RAM_read),
        .PC_en (PC_en),
        .PC_chg_en(PC_chg_en),
        .ACC_en (ACC_en),
        .fetch (fetch),
        .ADDR_sel (ADDR_sel)
    );

    PC PC_0 (
        .clk (clk),
        .rst_n (rst_n),
        .en (PC_en),
        .chg_en(PC_chg_en),
        .chg_addr(DB),
        .PC_addr(PC_addr)
    );

    ACC ACC_0 (
        .clk (clk),
        .rst_n (rst_n),
        .en (ACC_en),
        .acc_in (alu_out),
        .acc_out (acc_out)
    );

    REG REG_0 (
        .clk (clk),
        .write (REG_write),
        .read (REG_read),
        .addr ({ins,REG_addr}),
        .reg_in (alu_out),
        .reg_out (DB)
    );

    ALU ALU_0 (
        .ins (ins),
        .alu_in (DB),
        .accum (acc_out),
        .alu_out (alu_out)
    );

    IR IR_0 (
        .clk (clk),
        .rst_n (rst_n),
        .fetch (fetch),
        .data (DB),
        .ins (ins),
        .addr_reg (REG_addr),
        .addr_mem(IR_addr)
    );

    ADDR_MUX ADDR_MUX_0 (
        .IR_addr (IR_addr),
        .PC_addr (PC_addr),
        .sel (ADDR_sel),
        .addr (AB)
    );

endmodule
