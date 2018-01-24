`include "./Type.sv"

module Execute(
    input wire  rst,
    input wire  clk,
    input bit   is_add,
    input bit   is_sub,
    input bit   is_and,
    input bit   is_or,
    input bit   is_gt,
    input bit   is_eq,
    input bit   is_mem_write,
    input bit   is_reg_write,
    input bit   is_halt,
    input bit   is_branch,
    input block val1,
    input block val2,
    input block val3,
    input bit is_mem_data_hazard,
    input bit is_val1_data_hazard,
    input bit is_val2_data_hazard, 
    
    input block     mem_value,

    output bit       do_halt,
    output bit       do_branch,
    output addr      branch_address,

    output block     result,
    output bit       do_exe_reg_write,
    output bit [3:0] exe_reg_addr
);
    `include "./Parameter.sv"
    bit   store_is_halt = 1;
    initial begin
        result         <= 0;
        do_branch      <= 0;
        branch_address <= 0; 
        do_halt        <= 1;
        exe_reg_addr   <= 0;

        do_exe_reg_write <= 0;
        exe_reg_addr     <= 0;
    
        result           <= 0;
        store_is_halt    <= 1;
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            do_branch      <= 0;
            branch_address <= 0; 
            do_halt        <= 1;
            result         <= 0;
            exe_reg_addr   <= 0;
            do_exe_reg_write <= 0;
            store_is_halt    <= 1;
        end else if (do_branch) begin
            do_branch      <= 0;
            branch_address <= 0; 
            do_halt        <= 1;
            result         <= 0;
            exe_reg_addr   <= 0;
            do_exe_reg_write <= 0;
            store_is_halt    <= 1;
        end else begin
            store_is_halt    <= is_halt;
            do_halt          <= store_is_halt;
            do_branch        <= is_branch && calc();
            branch_address   <= val3;
            result           <= calc();
            exe_reg_addr     <= val3;
            do_exe_reg_write <= is_reg_write;
            if (is_branch) begin
                $display("do branch? calc(): %d", calc());
            end
        end
    end

    block fval1;
    block fval2;
    function block calc();
        if          (is_val1_data_hazard && is_mem_data_hazard) begin
            fval1 = mem_value;
        end else if (is_val1_data_hazard && !is_mem_data_hazard) begin
            fval1 = result;
        end else begin
            fval1 = val1;
        end

        if          (is_val2_data_hazard && is_mem_data_hazard) begin
            fval2 = mem_value;
        end else if (is_val2_data_hazard && !is_mem_data_hazard) begin
            fval2 = result;
        end else begin
            fval2 = val2;
        end

        case (1'b1)
            is_add : calc = fval1 +  fval2;
            is_sub : calc = fval1 -  fval2;
            is_and : calc = fval1 &  fval2;
            is_or  : calc = fval1 |  fval2;
            is_gt  : calc = fval1 >  fval2;
            is_eq  : calc = fval1 == fval2;
        endcase
    endfunction
endmodule
