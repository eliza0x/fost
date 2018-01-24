
module dynamic_displayIK_8(CLK,RST,
                      SEG_0,SEG_1,
		      SEG_2,SEG_3,
                      SEG_4,SEG_5,
		      SEG_6,SEG_7,
		      SEG_A,SEG_B,
		      SEG_C,SEG_D,
                      SEG_E,SEG_F,
		      SEG_G,SEG_H,
                      SEG_SEL);

  input CLK,RST;
  input [31:0] SEG_0,SEG_1,SEG_2,SEG_3,SEG_4,SEG_5,SEG_6,SEG_7;

  output [7:0] SEG_A,SEG_B,SEG_C,SEG_D,SEG_E,SEG_F,SEG_G,SEG_H;
  output [8:0] SEG_SEL;

  reg [7:0] SEG_A,SEG_B,SEG_C,SEG_D,SEG_E,SEG_F,SEG_G,SEG_H;
  reg [8:0] SEG_SEL;

  reg [1:0] COUNTER;
  reg [15:0] DEF_COUNTER;
  parameter DEF_MAX = 16'hFFFF;
  parameter COUNT_MAX = 2'b11;

  always @(posedge CLK or negedge RST) begin
       if(!RST) begin
          SEG_A <= 8'hFC;
          SEG_B <= 8'hFC;
          SEG_C <= 8'hFC;
          SEG_D <= 8'hFC;
          SEG_E <= 8'hFC;
          SEG_F <= 8'hFC;
          SEG_G <= 8'hFC;
          SEG_H <= 8'hFC;
          SEG_SEL <=9'h1FF;
          COUNTER <= 2'h0;
          DEF_COUNTER <= 16'h0000;
       end
       else begin
          if(DEF_COUNTER != DEF_MAX) begin
			DEF_COUNTER <= DEF_COUNTER + 16'd1;
			SEG_SEL <=9'h000;
		  end 
		  else begin
		    DEF_COUNTER <= 16'h0000;
			
			case(COUNTER)
              2'd0: begin
				SEG_A <= SEG_0[31:24];
				SEG_B <= SEG_0[23:16];
              	SEG_C <= SEG_0[15:8];
              	SEG_D <= SEG_0[7:0];
              	SEG_E <= SEG_1[31:24];
              	SEG_F <= SEG_1[23:16];
              	SEG_G <= SEG_1[15:8];
              	SEG_H <= SEG_1[7:0];
                SEG_SEL <= 9'h001;
              end
              2'd1: begin
                SEG_A <= SEG_2[31:24];
				SEG_B <= SEG_2[23:16];
              	SEG_C <= SEG_2[15:8];
              	SEG_D <= SEG_2[7:0];
              	SEG_E <= SEG_3[31:24];
              	SEG_F <= SEG_3[23:16];
              	SEG_G <= SEG_3[15:8];
              	SEG_H <= SEG_3[7:0];
                SEG_SEL <= 9'h002;
              end
              2'd2: begin
                SEG_A <= SEG_4[31:24];
				SEG_B <= SEG_4[23:16];
              	SEG_C <= SEG_4[15:8];
              	SEG_D <= SEG_4[7:0];
              	SEG_E <= SEG_5[31:24];
              	SEG_F <= SEG_5[23:16];
              	SEG_G <= SEG_5[15:8];
              	SEG_H <= SEG_5[7:0];
                SEG_SEL <= 9'h004;
              end
              2'd3: begin
				SEG_A <= SEG_6[31:24];
				SEG_B <= SEG_6[23:16];
              	SEG_C <= SEG_6[15:8];
              	SEG_D <= SEG_6[7:0];
              	SEG_E <= SEG_7[31:24];
              	SEG_F <= SEG_7[23:16];
              	SEG_G <= SEG_7[15:8];
              	SEG_H <= SEG_7[7:0];
                SEG_SEL <= 9'h008;
              end  
          endcase
		if(COUNTER == COUNT_MAX) begin
             COUNTER <= 2'd0;
        end
        else begin
             COUNTER <= COUNTER + 2'd1;             
          end         
       end
  end 
  end
 endmodule