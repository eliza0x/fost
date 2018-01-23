`include "./Type.sv"

module Memory(
    input  wire  rst,
    input  wire  clk,
    input  bit   do_halt,
    input  bit   do_branch,
    input  block val1,
    input  block val2,
    input  block val3,
    input  bit   is_mem_read,
    input  bit   is_mem_write,
    input  bit   is_reg_write,

    output bit       do_reg_write,
    output block     mem_value,
    output bit [3:0] mem_reg_addr,

    input bit   do_exe_mem_write,
    input block exe_mem_result,
    input block exe_mem_addr
);
    `include "./Parameter.sv"
    
    block memory[64];

    initial begin
        do_reg_write <= 0;
        mem_value    <= 0;
        mem_reg_addr <= 0;
        /*
        for (byte i=0; i<64; i++) begin
            memory[i] <= 0;
        end
        */
        memory[1] <= 10;
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            do_reg_write <= 0;
            mem_value    <= 0;
            mem_reg_addr <= 0;
            for (byte i=0; i<64; i++) begin
                memory[i] <= 0;
            end
        end else if (do_branch) begin
            do_reg_write <= 0;
            mem_value    <= 0;
            mem_reg_addr <= 0;
        end else begin
            if (is_mem_read) begin
                do_reg_write <= is_reg_write;
                mem_value    <= memory[val1 + val2];
                mem_reg_addr <= val3;
            end
            if (is_mem_write) begin
                $display("!!!!!!!!!!!! val(%d+%d): %d", val1, val2, val3);
                memory[val1+val2] <= val3;
            end
        end
    end

    always @(negedge do_halt) begin
        $display("=================================");
        for (byte i=0; i<20; i++) begin
            $display("memory[%2d]: %d", i, memory[i]);
        end
        $display("=================================");
    end
endmodule

