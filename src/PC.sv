`include "./Type.sv"

module PC(
    input  wire rst,
    input  wire clk,
    input  bit  do_branch,
    input  addr branch_address,
    input  bit  do_jump,
    input  addr jump_address,
    input  bit  consumed_inst,
    output addr pc
);
    `include "./Parameter.sv"
    
    initial pc <= 0;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            pc <= 0;
        end else if (do_branch) begin
            pc <= branch_address;
        end else if (do_jump) begin
            pc <= jump_address;
        end else if (consumed_inst == 0) begin
            pc <= pc;
        end else begin
            pc <= pc + 1;
        end
    end
endmodule
