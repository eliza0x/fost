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

    input  bit is_mem_data_hazard,
    input  bit   is_val2_data_hazard,
    input  block result,

    output bit       do_mem_reg_write,
    output block     mem_value,
    output bit [3:0] mem_reg_addr,

    input bit   do_exe_mem_write,
    input block exe_mem_result,
    input block exe_mem_addr
);
    `include "./Parameter.sv"
    
    block memory[64];

    initial begin
        do_mem_reg_write <= 0;
        mem_value        <= 0;
        mem_reg_addr     <= 0;
        /*
        for (byte i=0; i<64; i++) begin
            memory[i] <= 0;
        end
        */
        memory[0] <= 30000;
        memory[1] <= 10;
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            do_mem_reg_write <= 0;
            mem_value        <= 0;
            mem_reg_addr     <= 0;
            for (byte i=0; i<64; i++) begin
                memory[i] <= 0;
            end
        end else if (do_branch) begin
            do_mem_reg_write <= 0;
            mem_value        <= 0;
            mem_reg_addr     <= 0;
        end else begin
            if (is_mem_read) begin
                $display("rrrrrrrrrrrrrrrrrrrr: %d(%d)",memory[val1+val2], val1+val2);
                $display("is_reg_write: %d",is_reg_write);
                do_mem_reg_write <= is_reg_write;
                mem_value    <= memory[val1 + val2];
                mem_reg_addr <= val3;
            end else begin
                do_mem_reg_write <= 0;
                mem_value        <= 0;
                mem_reg_addr     <= 0;
            end
            if (is_mem_write) begin
                if          (is_val2_data_hazard && is_mem_data_hazard) begin
                    memory[val1+val3] <= mem_value;
                end else if (is_val2_data_hazard && !is_mem_data_hazard) begin
                    memory[val1+val3] <= result;
                end else begin
                    memory[val1+val3] <= val2;
                end
            end
        end
    end

endmodule

