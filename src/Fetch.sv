`include "./Type.sv"

module Fetch(
    input  bit   rst,
    input  bit   clk,
    input  bit   do_branch,
    input  bit   do_jump,
    input  addr  pc,
    output Inst  inst
);
    `include "./Parameter.sv"
    
    block memory[512];

    initial begin

        /* Fetch
        memory[ 0] <= 16'h0000;
        memory[ 1] <= 16'b0101_0011_00010000 ; // addi
        memory[ 2] <= 16'b0101_0001_00000001 ; // addi
        memory[ 3] <= 16'b0101_0010_00000001 ; // addi
        memory[ 4] <= 16'b0011_0100_0000_0000; // and
        memory[ 5] <= 16'b0001_0100_0010_0000; // add
        memory[ 6] <= 16'b0001_0010_0001_0000; // add
        memory[ 7] <= 16'b0011_0001_0000_0000; // and
        memory[ 8] <= 16'b0001_0001_0100_0000; // add
        memory[ 9] <= 16'b0110_0011_00000001 ; // subi
        memory[10] <= 16'b1101_0011_0000_1010; // bgt
        memory[11] <= 16'b1111111111111111   ; // halt
        */

        /* Q1
        memory[ 0] <= 16'h0000;
        memory[ 1] <= 16'b0101_0001_00000001 ; // addi
        memory[ 2] <= 16'b0101_0010_01111111 ; // ldi
        memory[ 3] <= 16'b0001_0010_0010_0000 ; // ldi
        memory[ 4] <= 16'b0001_0010_0010_0000 ; // ldi
        memory[ 5] <= 16'b0001_0010_0010_0000 ; // ldi
        memory[ 6] <= 16'b0001_0010_0010_0000 ; // ldi
        memory[ 7] <= 16'b0001_0010_0010_0000 ; // ldi
        memory[ 8] <= 16'b0001_0010_0010_0000 ; // ldi
        memory[ 9] <= 16'b0001_0010_0010_0000 ; // ldi
        memory[10] <= 16'b0001_0010_0010_0000 ; // ldi
        memory[11] <= 16'b0001_0010_0010_0000 ; // ldi
        memory[12] <= 16'b0001_0010_0010_0000 ; // ldi
        memory[13] <= 16'b0001_0010_0010_0000 ; // ldi
        memory[14] <= 16'b0001_0010_0010_0000 ; // ldi
        memory[15] <= 16'b0101_0010_01111111 ; // ldi
        memory[16] <= 16'b0101_0010_01111111 ; // ldi
        memory[17] <= 16'b0101_0010_01111111 ; // ldi
        memory[18] <= 16'b0101_0010_00011100 ; // ldi
        memory[19] <= 16'b0011_0100_0000_0000; // and
        memory[20] <= 16'b0001_0100_0011_0000; // add
        memory[21] <= 16'b0001_0011_0001_0000; // add
        memory[22] <= 16'b0101_0001_00000001 ; // addi
        memory[23] <= 16'b1101_0010_0011_1100; // bgt
        memory[24] <= 16'b0110_0001_00000001 ; // subi
        memory[25] <= 16'b0011_0010_0000_0000; // and
        memory[26] <= 16'b0001_0010_0100_0000; // add
        memory[27] <= 16'b1111111111111111   ; // halt
        */
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

