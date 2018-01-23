`include "./Type.sv"

module Schedule(
    input  wire  rst,
    input  wire  clk,
    input  bit   do_branch,
    input  bit   do_jump,
    input  inst  from_inst,
    output inst  to_inst,
    output bit   is_datahazard_rd,
    output bit   is_datahazard_rs,
    output bit   consumed_inst
);
    `include "./Parameter.sv"
    
    inst prev2_inst;

    inst stored_inst;

    assign is_datahazard_rd =
           (from_inst.inst[op_begin:op_end] != 4'b0000)
        && (from_inst.inst[rd_begin:rd_end] == to_inst.inst[rd_begin:rd_end]);

    assign is_datahazard_rs = 
           (from_inst.inst[op_begin:op_end] != 4'b0000)
        && (from_inst.inst[rs_begin:rs_end] == to_inst.inst[rd_begin:rd_end]);

    initial begin
        to_inst     <= 0;
        stored_inst <= 0;
        prev2_inst  <= 0;
        consumed_inst <= 1;
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            to_inst     <= 0;
            stored_inst <= 0;
            prev2_inst  <= 0;
            consumed_inst <= 1;
        end else if (do_branch | do_jump) begin
            to_inst     <= 0;
            stored_inst <= 0;
            prev2_inst  <= 0;
            consumed_inst <= 1;
        end else begin
            to_inst <= from_inst;
            consumed_inst <= 1;
        end
    end
endmodule

