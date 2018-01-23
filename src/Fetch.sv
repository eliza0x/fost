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

