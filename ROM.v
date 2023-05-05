`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/03 19:44:50
// Design Name: 
// Module Name: ROM
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


module ROM(
    input read,
    input en,
    input [7:0]addr,
    output [7:0]data
    );
    reg [7:0] mem [255:0];

    //输出
    assign data = (read&&en)?mem[addr]:8'hzz;

    //ROM初始化 待运行程序的机器码
    initial begin
        mem[0] = 8'b0000_0000;	//NOP

        mem[1] = 8'b0001_0001;	//LDO s1
        mem[2] = 8'b01000001;   //rom(65)	//rom[65] -> reg[1]
        mem[3] = 8'b0001_0010;	//LDO s2
        mem[4] = 8'b01000010;   //rom(66)
        mem[5] = 8'b0001_0011;	//LDO s3
        mem[6] = 8'b01000011;   //rom(67)

        mem[7] = 8'b0100_0001;	//PRE s1
        mem[8] = 8'b0110_0010;	//ADD s2
        mem[9] = 8'b0011_0001;	//LDM s1
        
        mem[10] = 8'b0101_0011;	//STO s3
        mem[11] = 8'b0000_0001; //ram(1)
        mem[12] = 8'b0010_0010;	//LDA s2
        mem[13] = 8'b0000_0001; //ram(1)
        
        mem[14] = 8'b0100_0011;	//PRE s3
        mem[15] = 8'b0110_0010;	//ADD s2
        mem[16] = 8'b0011_0011;	//LDM s3
        
        mem[17] = 8'b0101_0011;	//STO s3
        mem[18] = 8'b0000_0010; //ram(2)

        mem[19] = 8'b1110_0000; //JMP
        mem[20] = 8'b00100001;  //跳转地址33
        mem[21] = 8'b1111_0000;	//HLT

        mem[33] = 8'b0100_0001;	//PRE s1
        mem[34] = 8'b1011_0010;	//AND s2
        mem[35] = 8'b0011_0100;	//LDM s4

        mem[36] = 8'b0100_0100;	//PRE s4
        mem[37] = 8'b1011_0011;	//AND s3
        mem[38] = 8'b0011_0101;	//LDM s5

        mem[39] = 8'b0100_0101;	//PRE s5
        mem[40] = 8'b1100_0010;	//OR  s2
        mem[41] = 8'b0011_0110;	//LDM s6

        mem[42] = 8'b0100_0110;	//PRE s6
        mem[43] = 8'b1101_0100;	//XOR s4
        mem[44] = 8'b0011_0111;	//LDM s7

        mem[45] = 8'b0100_0111;	//PRE s7
        mem[46] = 8'b1101_0011;	//XOR s3
        mem[47] = 8'b0011_1000;	//LDM s8

        mem[48] = 8'b1010_0001; //INV s1
        mem[49] = 8'b0011_1001;	//LDM s9
        mem[50] = 8'b0111_0001; //SHL s1
        mem[51] = 8'b1000_0001; //SHR s1
        mem[52] = 8'b1001_1001; //SAR s9

        mem[53] = 8'b1110_0000; //JMP
        mem[54] = 8'b00010101;  //跳转地址21
        
        mem[65] = 8'b00100101;  //37
        mem[66] = 8'b01011001;  //89
        mem[67] = 8'b00110101;  //53
        // mem[68] = 8'b00100001;  //33
        // mem[69] = 8'b00010101;  //21
    end
    
endmodule
