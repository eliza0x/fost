`include "./Type.sv"

module Decode(
    input  wire  rst,
    input  wire  clk,
    input  wire  do_branch,
    output inst stored_inst[2],
    input  inst  inst,
    input  bit   do_halt,
    input  bit   is_datahazard_rd,
    input  bit   is_datahazard_rs,
    output bit   is_add,
    output bit   is_sub,
    output bit   is_and,
    output bit   is_or,
    output bit   is_gt,
    output bit   is_eq,
    output bit   is_mem_read,
    output bit   is_mem_write,
    output bit   is_reg_write,
    output bit   is_halt,
    output bit   is_branch,
    output bit   do_jump,
    output addr  jump_address,
    output block val1,
    output block val2,
    output block val3,

    input bit       do_reg_write,
    input block     mem_value,
    input bit [3:0] mem_reg_addr,

    input bit       do_exe_reg_write,
    input bit [3:0] exe_reg_addr,
    input block     result
);
    `include "./Parameter.sv"

    block regs[16];

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
            stored_inst[0] <= 0;
            stored_inst[1] <= 0;
            for (byte i=0; i<16; i++) begin
                regs[i] <= 0;
            end
        end else if (do_branch) begin
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
            for (byte i=0; i<16; i++) begin
                regs[i] <= 0;
            end
            stored_inst[0] <= 0;
            stored_inst[1] <= 0;
        end else begin
            // $display("pc: %d, inst: %b", inst.pc, inst.inst);
            unique case (inst.inst[op_begin:op_end])
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
            if (do_reg_write) begin
                regs[mem_reg_addr] <= mem_value;
            end else if (do_exe_reg_write) begin
                regs[exe_reg_addr] <= result;
            end
            stored_inst[0] <= inst;
            stored_inst[1] <= stored_inst[0];
            $display("pc: %d, inst: %b", inst.pc, inst.inst);
        end
    end

    function block forwarding_rd();
        if (is_datahazard_rd) begin
            if          (do_reg_write) begin
                forwarding_rd = mem_value;
            end else if (do_exe_reg_write) begin
                forwarding_rd = result;
            end else begin
                $display("[ERROR %s]: %3d", `__FILE__, `__LINE__);
            end
        end else begin
            forwarding_rd = regs[inst.inst[rd_begin:rd_end]];
        end
    endfunction

    function block forwarding_rs();
        if (is_datahazard_rs) begin
            if          (is_mem_read) begin
                forwarding_rs = mem_value;
            end else if (is_reg_write) begin
                forwarding_rs = result;
            end else begin
                $display("[ERROR %d]: ", `__LINE__);
            end
        end else begin
            forwarding_rs = regs[inst.inst[rs_begin:rs_end]];
        end
    endfunction

    function void nop();
        is_add        = 1;
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
    endfunction

    function void add();
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
        val1 = forwarding_rd();
        val2 = forwarding_rs();
        val3 = inst.inst[rd_begin:rd_end];
    endfunction

    function void sub();
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
        val1 = forwarding_rd();
        val2 = forwarding_rs();
        val3 = inst.inst[rd_begin:rd_end];
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
        val1 = forwarding_rd();
        val2 = forwarding_rs();
        val3 = inst.inst[rd_begin:rd_end];
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
        val1 = forwarding_rd();
        val2 = forwarding_rs();
        val3 = inst.inst[rd_begin:rd_end];
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
        `define h inst.inst[rs_begin]
        $display("pc: %d, val1: %d", inst.pc, forwarding_rd());
        $display("pc: %d, val2: %d", inst.pc, 
            {`h,`h,`h,`h,`h,`h,`h,`h, inst.inst[rs_begin:rt_end]});
        val1 = forwarding_rd();
        val2 = {`h,`h,`h,`h,`h,`h,`h,`h,
               inst.inst[rs_begin:rt_end]};
        `undef h
        val3 = inst.inst[rd_begin:rd_end];
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
        val1 = forwarding_rd();
        `define h inst.inst[rt_begin]
        val2 = {`h,`h,`h,`h,`h,`h,`h,`h,
               inst.inst[rs_begin:rt_end]};
        `undef h
        val3 = inst.inst[rd_begin:rd_end];
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
        val1 = forwarding_rd();
        val2 = 16'd1;
        val3 = inst.inst[rd_begin:rd_end];
    endfunction

    function void ldi();
        is_add        = 1;
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
        val1 = inst.inst[rs_begin:rt_end];
        val2 = 16'd0;
        val3 = inst.inst[rd_begin:rd_end];
    endfunction

    function void ld();
        is_add        = 1;
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
        val1 = forwarding_rs();
        val2 = inst.inst[rt_begin:rt_end];
        val3 = inst.inst[rd_begin:rd_end];
    endfunction

    function void st();
        is_add        = 1;
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
        val1 = forwarding_rs();
        val2 = inst.inst[rt_begin:rt_end];
        val3 = forwarding_rd();
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
        val1 = forwarding_rd();
        val2 = forwarding_rs();
        `define h inst.inst[rt_begin]
        val3 = {`h,`h,`h,`h,`h,`h,`h,`h,`h,`h,`h,`h,
                inst.inst[rt_begin:rt_end]} + inst.pc;
        `undef h
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
        val1 = forwarding_rd();
        val2 = forwarding_rs();
        `define h inst.inst[rt_begin]
        val3 = {`h,`h,`h,`h,`h,inst.inst[rt_begin:rt_end]} 
             + inst.pc;
        `undef h
    endfunction

    function void jump();
        is_add        = 1;
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
        `define h regs[inst.inst[i9_begin:i9_end]]
        jump_address  = {`h,`h,`h,`h,`h,`h,`h,
            regs[inst.inst[i9_begin:i9_end]]};
        `undef h
        val1          = 0;
        val2          = 0;
        val3          = 0;
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
    endfunction

    always @(negedge do_halt) begin
        $display("=================================");
        for (byte i=0; i<16; i++) begin
            $display("regs[%2d]: %d", i, regs[i]);
        end
        $display("=================================");
    end
endmodule
