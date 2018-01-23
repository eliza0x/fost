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

    output bit       do_halt,
    output bit       do_branch,
    output addr      branch_address,

    output block     result,
    output bit       do_exe_reg_write,
    output bit [3:0] exe_reg_addr
);
    `include "./Parameter.sv"
    initial begin
        result         <= 0;
        do_branch      <= 0;
        branch_address <= 0; 
        do_halt        <= 1;
        exe_reg_addr   <= 0;

        do_exe_reg_write <= 0;
        exe_reg_addr     <= 0;
    
        result           <= 0;
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            do_branch      <= 0;
            branch_address <= 0; 
            do_halt        <= 1;
            result         <= 0;
            exe_reg_addr   <= 0;
            do_exe_reg_write <= 0;
        end else begin
            do_halt          <= is_halt;
            do_branch        <= is_branch && calc();
            branch_address   <= val3;
            result           <= calc();
            exe_reg_addr     <= val3;
            do_exe_reg_write <= is_reg_write;
        end
    end

    function block calc();
        unique case (1'b1)
            is_sub  : calc = val1 -  val2;
            is_and  : calc = val1 &  val2;
            is_or   : calc = val1 |  val2;
            is_gt   : calc = val1 >  val2;
            is_eq   : calc = val1 == val2;
            default : calc = val1 +  val2;
        endcase
    endfunction
endmodule
