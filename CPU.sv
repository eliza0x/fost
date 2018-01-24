`include "src/7SEG-RK/display_7seg.v"
`include "src/7SEG-IK/displayik_7seg_8.v"

`include "src/PC.sv"
`include "src/Fetch.sv"
`include "src/Decode.sv"
`include "src/Memory.sv"
`include "src/Execute.sv"

`include "src/Type.sv"

module CPU(
    input  bit board_ck,
    input  wire CLK,
    input  bit rst,
    output bit do_halt,
    output logic [7:0] SEG_A,SEG_B,SEG_C,SEG_D,SEG_E,SEG_F,SEG_G,SEG_H,
    output logic [8:0] SEG_SEL_IK,
    output logic [7:0] SEG,
    output logic [3:0] SEG_SEL
);
    wire RSTN;
    bit clk;
    assign RSTN = rst;
    assign clk = board_ck & do_halt;
    always @(do_halt) $display("do_halt: %d", do_halt);
    
    `include "src/Parameter.sv"

    block cnt = 0;
    block data;
    block data0, data1, data2, data3, data4, data5, data6, data7;
    block result;
    addr  branch_address;
    bit   is_jump;
    addr  pc;
    bit  do_branch;
    Inst stored_inst[2];
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

    Inst  inst_queue[5];

    PC pc_module(.*);
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
    display_7seg display_module(.*);
    displayIK_7seg_8 displayik_module(
        .SEG_SEL(SEG_SEL_IK),
        .*
    );

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
    end
    assign data = cnt;
endmodule
