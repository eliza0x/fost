`include "display_module_async_16b.v"
`include "dynamic_displayik_8.v"

module displayIK_7seg_8(CLK,RSTN,
			data0,data1,
			data2,data3,
			data4,data5,
			data6,data7,
			SEG_A,SEG_B,
		    SEG_C,SEG_D,
            SEG_E,SEG_F,
		    SEG_G,SEG_H,
            SEG_SEL);
    input CLK,RSTN;
    input [15:0] data0,data1,data2,data3,data4,data5,data6,data7;
   
    wire [31:0] SEG_0,SEG_1,SEG_2,SEG_3,SEG_4,SEG_5,SEG_6,SEG_7;

    output [7:0] SEG_A,SEG_B,SEG_C,SEG_D,SEG_E,SEG_F,SEG_G,SEG_H;
    output [8:0] SEG_SEL;

    display_module_async_16b i0 (.data(data0),.SEG_32(SEG_0));
    display_module_async_16b i1 (.data(data1),.SEG_32(SEG_1));
    display_module_async_16b i2 (.data(data2),.SEG_32(SEG_2));
    display_module_async_16b i3 (.data(data3),.SEG_32(SEG_3));
    display_module_async_16b i4 (.data(data4),.SEG_32(SEG_4));
    display_module_async_16b i5 (.data(data5),.SEG_32(SEG_5));
    display_module_async_16b i6 (.data(data6),.SEG_32(SEG_6));
    display_module_async_16b i7 (.data(data7),.SEG_32(SEG_7));

    dynamic_displayIK_8 i8 (.CLK(CLK),.RST(RSTN),.SEG_0(SEG_0),.SEG_1(SEG_1),.SEG_2(SEG_2),.SEG_3(SEG_3),
                            .SEG_4(SEG_4),.SEG_5(SEG_5),.SEG_6(SEG_6),.SEG_7(SEG_7),
			    .SEG_A(SEG_A),.SEG_B(SEG_B),.SEG_C(SEG_C),.SEG_D(SEG_D),
			    .SEG_E(SEG_E),.SEG_F(SEG_F),.SEG_G(SEG_G),.SEG_H(SEG_H),.SEG_SEL(SEG_SEL));
endmodule
