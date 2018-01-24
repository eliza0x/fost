`include "src/PC.sv"
`include "src/Fetch.sv"
`include "src/Decode.sv"
`include "src/Memory.sv"
`include "src/Execute.sv"

`include "src/Type.sv"

module CPU(
    input  bit clk,
    input  bit CLK,
    input  bit rst,
    output bit do_halt,
    output logic [7:0] SEG,
    output logic [3:0] SEG_SEL
);
    
    `include "src/Parameter.sv"

    block result;
    addr  branch_address;
    bit   is_jump;
    addr  pc;
    wire  do_branch;
    inst stored_inst[2];
    bit   is_add;
    bit   is_sub;
    bit   is_and;
    bit   is_or;
    bit   is_gt;
    bit   is_eq;
    bit   is_mem_read;
    bit   is_mem_write;
    bit   is_reg_write;
    bit   is_halt;
    bit   is_branch;
    bit   do_reg_write;
    bit   do_mem_reg_write;
    bit   do_jump;
    addr  jump_address;
    block val1;
    block val2;
    block val3;
    bit is_mem_data_hazard;
    bit is_val1_data_hazard;
    bit is_val2_data_hazard; 
    block mem_value;
    bit [3:0] mem_reg_addr;
    bit [3:0] exe_reg_addr;
    bit       do_exe_reg_write;
    block exe_mem_result;
    bit   do_exe_mem_write;
    block exe_mem_addr;
    bit   is_datahazard_rd;
    bit   is_datahazard_rs;

    inst  inst_queue[5];
    PC      pc_module(.*);
    Fetch   fetch_module(
        .inst(inst_queue[0]),
        .*
    );
    Decode  decode_module(
        .from_inst(inst_queue[0]),
        .*
    );
    Memory  memory_module(.*);
    Execute execute_module(.*);

    `define DEBUG
    `ifdef DEBUG
    initial begin
        $display("do_halt: %d", do_halt);
        clk = 1'b0;
        rst = 1;

        fetch_module.memory[0] <= 16'h0000;
        fetch_module.memory[1] <= 16'b1000_0010_00000001; // $2 = 10
        fetch_module.memory[2] <= 16'b0101_0010_00001010; // $2 += 10
        fetch_module.memory[3] <= 16'b1010_0010_00000010; // $2 = 10
        fetch_module.memory[4] <= 16'b1111_1111_1111_1111;// halt
    end
    always #(one_clock*2) clk = ~clk;
    always @(negedge do_halt) begin
        $display("=================================");
        for (byte i=0; i<20; i++) begin
            $display("memory[%2d]: %d", i, memory_module.memory[i]);
        end
        $display("--------------------------------");
        for (byte i=0; i<16; i++) begin
            $display("regs[%2d]: %d", i, decode_module.regs[i]);
        end
        $display("=================================");
        $finish(1);
    end
    `endif
endmodule
