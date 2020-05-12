# 关于SRAM的一点建议
1. 尽量使用SP-SRAM，相对而言更省面积。
2. SRAM的输入是DFF的输出，SRAM的输出直接接DFF，对时序有利。
3. 对于双口sram，addra和addrb在一个时钟周期尽量不要相等。
4. 在读sram的时候，要保证在下一个时钟周期把数取走，有的工厂的memory没有保持数据的功能。