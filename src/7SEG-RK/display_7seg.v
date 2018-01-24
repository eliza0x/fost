`timescale 1ps/1ps

`include "display_module_async.v"
`include "dynamic_display.v"

module display_7seg(CLK,RSTN,data,SEG,SEG_SEL);
    input CLK,RSTN;
    input [15:0] data;
   
    output [7:0] SEG;
    output [3:0] SEG_SEL;

    wire [7:0] SEG_A,SEG_B,SEG_C,SEG_D;

    display_module_async i0 (.SEG_VAL(data[3:0]),.SEG(SEG_D));
    display_module_async i1 (.SEG_VAL(data[7:4]),.SEG(SEG_C));
    display_module_async i2 (.SEG_VAL(data[11:8]),.SEG(SEG_B));
    display_module_async i3 (.SEG_VAL(data[15:12]),.SEG(SEG_A));
    dynamic_display i4 (.CLK(CLK),.RSTN(RSTN),.SEG_A_0(SEG_A),.SEG_B_0(SEG_B),.SEG_C_0(SEG_C),.SEG_D_0(SEG_D),
		    .SEG_A(SEG),.SEG_SEL(SEG_SEL));
endmodule
