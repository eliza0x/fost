`include "./Type.sv"

module Fetch(
    input  wire  rst,
    input  wire  clk,
    input  bit   do_branch,
    input  bit   do_jump,
    input  addr  pc,
    output inst  inst
);
    `include "./Parameter.sv"
    
    block memory[64];

    initial begin
        inst = 25'b0;
        /*
        for (byte i=0; i<64; i++) begin
            memory[i] <= 0;
        end
        memory[0] <= 16'h0000;
        memory[1] <= 16'b1000_0001_00000001;
        memory[2] <= 16'h0000;
        memory[3] <= 16'h0000;
        memory[4] <= 16'b1010_0001_0000_1010;
        memory[5] <= 16'hffff;
        */

        memory[0] <= 16'h0000;
        memory[1] <= 16'b0101_0001_00011000;
        memory[2] <= 16'b0101_0010_00001100;
        memory[3] <= 16'b0101_0001_00011000;
        memory[4] <= 16'h0000;
        memory[5] <= 16'h0000;
        memory[6] <= 16'hffff;
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            inst <= 25'b0;
        end else if (do_branch | do_jump) begin
            inst <= 25'b0;
        end else begin
            inst <= {pc, memory[pc]};
        end
    end
endmodule

