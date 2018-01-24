`include "./Type.sv"

module Decode(
    input  wire  rst,
    input  wire  clk,
    input  wire  do_branch,
    input  inst  from_inst,
    input  bit   do_halt,
    output bit   is_add,
    output bit   is_sub,
    output bit   is_and,
    output bit   is_or,
    output bit   is_gt,
    output bit   is_eq,
    output bit   is_mem_read,
    output bit   is_mem_write,
    output bit   is_reg_write,
    output bit   is_halt = 1,
    output bit   is_branch,
    output bit   do_jump,
    output addr  jump_address,
    output block val1,
    output block val2,
    output block val3,
    output bit is_mem_data_hazard,
    output bit is_val1_data_hazard,
    output bit is_val2_data_hazard, 
    input bit       do_mem_reg_write,
    input block     mem_value,
    input bit [3:0] mem_reg_addr,

    input bit       do_exe_reg_write,
    input bit [3:0] exe_reg_addr,
    input block     result
);
    `include "./Parameter.sv"

    block regs[16];

    bit   is_datahazard_rd;
    bit   is_datahazard_rs;

    inst to_inst;
    assign is_datahazard_rd =
           (from_inst.inst[op_begin:op_end] != 4'b0000)
        && (from_inst.inst[rd_begin:rd_end] == to_inst.inst[rd_begin:rd_end]);

    assign is_datahazard_rs = 
           (from_inst.inst[op_begin:op_end] == 4'b0000)
        && (from_inst.inst[rs_begin:rs_end] == to_inst.inst[rd_begin:rd_end]);

    initial begin
        is_add       <= 1;
        is_sub       <= 0;
        is_and       <= 0;
        is_or        <= 0;
        is_gt        <= 0;
        is_eq        <= 0;
        is_mem_read  <= 0;
        is_mem_write <= 0;
        is_reg_write <= 0;
        is_halt      <= 1;
        is_branch    <= 0;
        do_jump      <= 0;
        jump_address <= 0;
        val1         <= 0;
        val2         <= 0;
        val3         <= 0;
        to_inst      <= 0;
        for (byte i=0; i<16; i++) begin
            regs[i] <= 0;
        end
    end
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            is_add       <= 1;
            is_sub       <= 0;
            is_and       <= 0;
            is_or        <= 0;
            is_gt        <= 0;
            is_eq        <= 0;
            is_mem_read  <= 0;
            is_mem_write <= 0;
            is_reg_write <= 0;
            is_halt      <= 1;
            is_branch    <= 0;
            do_jump      <= 0;
            jump_address <= 0;
            val1         <= 0;
            val2         <= 0;
            val3         <= 0;
            to_inst      <= 0;
            for (byte i=0; i<16; i++) begin
                regs[i] <= 0;
            end
        end else if (do_branch || do_jump) begin
            is_add       <= 1;
            is_sub       <= 0;
            is_and       <= 0;
            is_or        <= 0;
            is_gt        <= 0;
            is_eq        <= 0;
            is_mem_read  <= 0;
            is_mem_write <= 0;
            is_reg_write <= 0;
            is_halt      <= 1;
            is_branch    <= 0;
            do_jump      <= 0;
            jump_address <= 0;
            val1         <= 0;
            val2         <= 0;
            val3         <= 0;
            to_inst      <= 0;
        end else begin
            unique case (from_inst.inst[op_begin:op_end])
                4'b0001: add();
                4'b0010: sub();
                4'b0011: and_op();
                4'b0100: or_op();
                4'b0101: addi();
                4'b0110: subi();
                4'b0111: incr();
                4'b1000: ldi();
                4'b1001: ld();
                4'b1010: st();
                4'b1100: beq();
                4'b1101: bgt();
                4'b1110: jump();
                4'b1111: halt();
                default: nop();
            endcase
            if (do_mem_reg_write) begin
                regs[mem_reg_addr] <= mem_value;
            end else if (do_exe_reg_write) begin
                if (exe_reg_addr == 4) $display(":::::::::: %d", result);
                regs[exe_reg_addr] <= result;
            end
            to_inst <= from_inst;
            is_mem_data_hazard = (to_inst.inst[op_begin:op_end]==4'b1000) 
                              || (to_inst.inst[op_begin:op_end]==4'b1001);
            $display("pc: %d", from_inst.pc);
        end
    end

    function block rd();
        if      (do_exe_reg_write && from_inst.inst[rd_begin:rd_end] == exe_reg_addr)
            rd = result;
        else if (do_mem_reg_write && from_inst.inst[rd_begin:rd_end] == mem_reg_addr)
            rd = mem_value;
        else 
            rd = regs[from_inst.inst[rd_begin:rd_end]];
    endfunction

    function block rs();
        if      (do_exe_reg_write && from_inst.inst[rs_begin:rs_end] == exe_reg_addr)
            rs = result;
        else if (do_mem_reg_write && from_inst.inst[rs_begin:rs_end] == mem_reg_addr)
            rs = mem_value;
        else 
            rs = regs[from_inst.inst[rs_begin:rs_end]];
    endfunction

    function void nop();
        is_add        = 0;
        is_sub        = 0;
        is_and        = 0;
        is_or         = 0;
        is_gt         = 0;
        is_eq         = 0;
        is_mem_read   = 0;
        is_mem_write  = 0;
        is_reg_write  = 0;
        is_halt       = 1;
        do_jump       = 0;
        is_branch     = 0;
        jump_address  = 0;
        val1          = 0;
        val2          = 0;
        val3          = 0;
        is_val1_data_hazard = 0;
        is_val2_data_hazard = 0;

    endfunction

    function void add();
        is_add       = 1;
        is_sub       = 0;
        is_and       = 0;
        is_or        = 0;
        is_gt        = 0;
        is_eq        = 0;
        is_mem_read  = 0;
        is_mem_write = 0;
        is_reg_write = 1;
        is_halt      = 1;
        do_jump      = 0;
        is_branch    = 0;
        jump_address = 0;
        is_val1_data_hazard = is_datahazard_rd;
        is_val2_data_hazard = is_datahazard_rs;
        val1 = rd();
        val2 = rs();
        val3 = from_inst.inst[rd_begin:rd_end];
    endfunction

    function void sub();
        is_add       = 0;
        is_sub       = 1;
        is_and       = 0;
        is_or        = 0;
        is_gt        = 0;
        is_eq        = 0;
        is_mem_read  = 0;
        is_mem_write = 0;
        is_reg_write = 1;
        is_halt      = 1;
        do_jump      = 0;
        is_branch    = 0;
        jump_address = 0;
        is_val1_data_hazard = is_datahazard_rd;
        is_val2_data_hazard = is_datahazard_rs;
        val1 = rd();
        val2 = rs();
        val3 = from_inst.inst[rd_begin:rd_end];
    endfunction

    function void and_op();
        is_add        = 0;
        is_sub        = 0;
        is_and        = 1;
        is_or         = 0;
        is_gt         = 0;
        is_eq         = 0;
        is_mem_read   = 0;
        is_mem_write  = 0;
        is_reg_write  = 1;
        is_halt       = 1;
        do_jump       = 0;
        is_branch     = 0;
        jump_address  = 0;
        val1 = rd();
        val2 = rs();
        val3 = from_inst.inst[rd_begin:rd_end];
        is_val1_data_hazard = is_datahazard_rd;
        is_val2_data_hazard = is_datahazard_rs;
    endfunction

    function void or_op();
        is_add        = 0;
        is_sub        = 0;
        is_and        = 0;
        is_or         = 1;
        is_gt         = 0;
        is_eq         = 0;
        is_mem_read   = 0;
        is_mem_write  = 0;
        is_reg_write  = 1;
        is_halt       = 1;
        do_jump       = 0;
        is_branch     = 0;
        jump_address  = 0;
        val1 = rd();
        val2 = rs();
        val3 = from_inst.inst[rd_begin:rd_end];
        is_val1_data_hazard = is_datahazard_rd;
        is_val2_data_hazard = is_datahazard_rs;
    endfunction

    function void addi();
        is_add        = 1;
        is_sub        = 0;
        is_and        = 0;
        is_or         = 0;
        is_gt         = 0;
        is_eq         = 0;
        is_mem_read   = 0;
        is_mem_write  = 0;
        is_reg_write  = 1;
        is_halt       = 1;
        do_jump       = 0;
        is_branch     = 0;
        jump_address  = 0;
        `define h from_inst.inst[rs_begin]
        val1 = rd();
        val2 = {`h,`h,`h,`h,`h,`h,`h,`h,
               from_inst.inst[rs_begin:rt_end]};
        `undef h
        val3 = from_inst.inst[rd_begin:rd_end];
        is_val1_data_hazard = is_datahazard_rd;
        is_val2_data_hazard = 0;
    endfunction

    function void subi();
        is_add        = 0;
        is_sub        = 1;
        is_and        = 0;
        is_or         = 0;
        is_gt         = 0;
        is_eq         = 0;
        is_mem_read   = 0;
        is_mem_write  = 0;
        is_reg_write  = 1;
        is_halt       = 1;
        do_jump       = 0;
        is_branch     = 0;
        jump_address  = 0;
        val1 = rd();
        `define h from_inst.inst[rt_begin]
        val2 = {`h,`h,`h,`h,`h,`h,`h,`h,
               from_inst.inst[rs_begin:rt_end]};
        `undef h
        val3 = from_inst.inst[rd_begin:rd_end];
        is_val1_data_hazard = is_datahazard_rd;
        is_val2_data_hazard = 0;
    endfunction

    function void incr();
        is_add        = 1;
        is_sub        = 0;
        is_and        = 0;
        is_or         = 0;
        is_gt         = 0;
        is_eq         = 0;
        is_mem_read   = 0;
        is_mem_write  = 0;
        is_reg_write  = 1;
        is_halt       = 1;
        do_jump       = 0;
        is_branch     = 0;
        jump_address  = 0;
        val1 = rd();
        val2 = 16'd1;
        val3 = from_inst.inst[rd_begin:rd_end];
        is_val1_data_hazard = is_datahazard_rd;
        is_val2_data_hazard = 0;
    endfunction

    function void ldi();
        is_add        = 0;
        is_sub        = 0;
        is_and        = 0;
        is_or         = 0;
        is_gt         = 0;
        is_eq         = 0;
        is_mem_read   = 1;
        is_mem_write  = 0;
        is_reg_write  = 1;
        is_halt       = 1;
        do_jump       = 0;
        is_branch     = 0;
        jump_address  = 0;
        val1 = from_inst.inst[rs_begin:rt_end];
        val2 = 16'd0;
        val3 = from_inst.inst[rd_begin:rd_end];
        is_val1_data_hazard = 0;
        is_val2_data_hazard = 0;
    endfunction

    function void ld();
        is_add        = 0;
        is_sub        = 0;
        is_and        = 0;
        is_or         = 0;
        is_gt         = 0;
        is_eq         = 0;
        is_mem_read   = 1;
        is_mem_write  = 0;
        is_reg_write  = 1;
        is_halt       = 1;
        do_jump       = 0;
        is_branch     = 0;
        jump_address  = 0;
        val1 = rs();
        val2 = from_inst.inst[rt_begin:rt_end];
        val3 = from_inst.inst[rd_begin:rd_end];
        is_val1_data_hazard = 0;
        is_val2_data_hazard = 0;
    endfunction

    function void st();
        is_add        = 0;
        is_sub        = 0;
        is_and        = 0;
        is_or         = 0;
        is_gt         = 0;
        is_eq         = 0;
        is_mem_read   = 0;
        is_mem_write  = 1;
        is_reg_write  = 0;
        is_halt       = 1;
        do_jump       = 0;
        is_branch     = 0;
        jump_address  = 0;
        val1 = rs();
        val2 = rd();
        val3 = from_inst.inst[rt_begin:rt_end];
        is_val1_data_hazard = is_datahazard_rs;
        is_val2_data_hazard = is_datahazard_rd;
    endfunction

    function void beq();
        is_add        = 0;
        is_sub        = 0;
        is_and        = 0;
        is_or         = 0;
        is_gt         = 0;
        is_eq         = 1;
        is_mem_read   = 0;
        is_mem_write  = 0;
        is_reg_write  = 0;
        is_halt       = 1;
        do_jump       = 0;
        is_branch     = 1;
        jump_address  = 0;
        val1 = rd();
        val2 = rs();
        `define h from_inst.inst[rt_begin]
        val3 = {`h,`h,`h,`h,`h,`h,`h,`h,`h,`h,`h,`h,
                from_inst.inst[rt_begin:rt_end]} + from_inst.pc;
        `undef h
        is_val1_data_hazard = is_datahazard_rd;
        is_val2_data_hazard = is_datahazard_rs;
    endfunction

    function void bgt();
        is_add        = 0;
        is_sub        = 0;
        is_and        = 0;
        is_or         = 0;
        is_gt         = 1;
        is_eq         = 0;
        is_mem_read   = 0;
        is_mem_write  = 0;
        is_reg_write  = 0;
        is_halt       = 1;
        do_jump       = 0;
        is_branch     = 1;
        jump_address  = 0;
        val1 = rd();
        val2 = rs();
        `define h from_inst.inst[rt_begin]
        val3 = {`h,`h,`h,`h,`h,from_inst.inst[rt_begin:rt_end]} 
             + from_inst.pc;
        `undef h
        is_val1_data_hazard = is_datahazard_rd;
        is_val2_data_hazard = is_datahazard_rs;
    endfunction

    function void jump();
        is_add        = 0;
        is_sub        = 0;
        is_and        = 0;
        is_or         = 0;
        is_gt         = 0;
        is_eq         = 0;
        is_mem_read   = 0;
        is_mem_write  = 0;
        is_reg_write  = 0;
        is_halt       = 1;
        is_branch     = 0;
        do_jump       = 1;
        `define h from_inst.inst[i9_begin]
        jump_address  = {`h,`h,`h,`h,`h,`h,`h,
            from_inst.inst[i9_begin:i9_end]} + from_inst.pc;
        `undef h
        val1          = 0;
        val2          = 0;
        val3          = 0;
        is_val1_data_hazard = 0;
        is_val2_data_hazard = 0;
    endfunction

    function void halt();
        is_add        = 0;
        is_sub        = 0;
        is_and        = 0;
        is_or         = 0;
        is_gt         = 0;
        is_eq         = 0;
        is_mem_read   = 0;
        is_mem_write  = 0;
        is_reg_write  = 0;
        is_halt       = 0;
        is_branch     = 0;
        do_jump       = 0;
        jump_address  = 0;
        val1          = 0;
        val2          = 0;
        val3          = 0;
        is_val1_data_hazard = 0;
        is_val2_data_hazard = 0;
    endfunction
endmodule
