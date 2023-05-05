`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/05 09:24:41
// Design Name: 
// Module Name: SoC
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


module SoC(
    input clk,
    input rst_n,
    output [7:0]DB,
    output [7:0]AB
    );
    wire ROM_en,ROM_read,RAM_en,RAM_read,RAM_write;
    CORE CORE_0 (
        .clk (clk),
        .rst_n (rst_n),
        .DB (DB),
        .AB (AB),
        .ROM_en (ROM_en),
        .ROM_read (ROM_read),
        .RAM_en (RAM_en),
        .RAM_read (RAM_read),
        .RAM_write (RAM_write)
    );

    RAM RAM_0 (
        .read (RAM_read),
        .write (RAM_write),
        .en (RAM_en),
        .data (DB),
        .addr (AB)
    );

    ROM ROM_0 (
        .read (ROM_read),
        .en (ROM_en),
        .addr (AB),
        .data (DB)
    );

endmodule
