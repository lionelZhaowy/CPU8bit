# CPU8bit
设计了一个单核顺序执行支持16条指令的简易8位CPU，无中断和异常处理、无流水线并行、无乱序执行等高效计算技术。该处理器支持内存读写、寄存器读写、跳转指令及常见的算数、逻辑运算，片上集成了16Byte的寄存器组，可拓展为GPIO用于控制常见的外设。
##1、设计概述
设计了一个单核顺序执行支持16条指令的简易8位CPU，无中断和异常处理、无流水线并行、无乱序执行等高效计算技术。该处理器支持内存读写、寄存器读写、跳转指令及常见的算数、逻辑运算，片上集成了16Byte的寄存器组，可拓展为GPIO用于控制常见的外设。
##2、指令集
该处理器所支持的指令集长度类型有两种，分别为短指令和长指令。短指令8位，包含指令编码和寄存器地址；长指令16位，包含指令编码、寄存器地址和存储器地址，由于总线为8位，因此需要两次取指操作才能读取完整的指令。长指令和短指令的格式如下图所示：
![image](https://user-images.githubusercontent.com/109258098/236453898-caf26a08-6d44-4bfb-b251-0d9ddc820041.png)
指令编码采用四位二进制表示，定义了16种指令，如下表所示：
![image](https://user-images.githubusercontent.com/109258098/236453977-d87d241e-3906-41eb-82c5-38263a31b9ec.png)
##3、系统组成
根据冯诺依曼架构，计算机由运算器、存储器、控制器、输入和输出组成，整个处理器系统由CPU核和存储器两部分组成，CPU包含了运算器和控制器；由于输入输出种类多样且需要外设控制、中断和异常控制等功能，这在本设计中并未实现，因此本设计不包含输入输出接口。整个CPU系统如下图所示：
![image](https://user-images.githubusercontent.com/109258098/236454029-8c16a036-72cd-4baf-9fd8-6e9269927dd9.png)
CPU核由程序计数器PC、指令寄存器IR、累加器ACC、通用寄存器REG、地址选择器ADDR_MUX、算数逻辑单元ALU和控制器CTRL组成；存储器由ROM和RAM组成，ROM中存放程序和数据，RAM中存放数据。CPU核的结构框图如下所示：
![image](https://user-images.githubusercontent.com/109258098/236454056-c475741c-3dba-4ac7-b226-c33385b2728c.png)
存储器部分
①只读存储器ROM
![image](https://user-images.githubusercontent.com/109258098/236454089-9e6b7ad9-a744-4c9b-8d37-220785d111fd.png)
②随机读写存储器RAM
![image](https://user-images.githubusercontent.com/109258098/236454109-cab71a11-b497-412f-8c7d-e1787eb3adb1.png)
处理器核部分
①程序计数器PC
![image](https://user-images.githubusercontent.com/109258098/236454202-95661b99-9289-4eaa-89d5-dcfc3520d057.png)
②指令寄存器IR
![image](https://user-images.githubusercontent.com/109258098/236454229-f45026f4-64f4-47ab-b5ec-950291e60dce.png)
③累加器ACC
![image](https://user-images.githubusercontent.com/109258098/236454268-1923fd53-12fe-4b20-8990-fa4a7c9ec3a2.png)
④通用寄存器REG
![image](https://user-images.githubusercontent.com/109258098/236454285-1da39c65-f7d2-4717-a7cd-8946cb22b07b.png)
⑤地址选择器ADDR_MUX
![image](https://user-images.githubusercontent.com/109258098/236454306-0af3104d-5ed4-4d2d-8a54-a58d8021b420.png)
⑥算数逻辑单元ALU
![image](https://user-images.githubusercontent.com/109258098/236454337-d495a090-e64b-4fa5-a216-3cbfb569f6d9.png)
⑦控制器CTRL
![image](https://user-images.githubusercontent.com/109258098/236454366-a089c0dd-766d-481a-9f5d-848bb6de85a6.png)


