`include "../CPU.sv"
`include "../src/Parameter.sv"

module Q1();
    bit board_ck;
    bit CLK;
    bit rst;
    bit do_halt;
    logic [7:0] SEG_A,SEG_B,SEG_C,SEG_D,SEG_E,SEG_F,SEG_G,SEG_H;
    logic [8:0] SEG_SEL_IK;
    logic [7:0] SEG;
    logic [3:0] SEG_SEL;

    CPU cpu(.*);

    always #(one_clock*2) board_ck = ~board_ck;

    always @(negedge do_halt) begin
        $display("=================================");
        for (byte i=0; i<16; i++) begin
            $display("memory[%2d]: %d", i, cpu.memory_module.memory[i]);
        end
        $display("--------------------------------");
        for (byte i=0; i<8; i++) begin
            $display("regs[%2d]: %d", i, cpu.decode_module.regs[i]);
        end
        $display("=================================");

        // sum: 2
        // a:   1
        // n:   3
        assert(cpu.decode_module.regs[1] == 245);
        assert(cpu.decode_module.regs[2] == 29890);
        $display("regs[1]: %d", cpu.decode_module.regs[1]);
        $display("regs[2]: %d", cpu.decode_module.regs[2]);
        // $display("regs[3]: %d", cpu.decode_module.regs[3]);

        $finish(1);
    end

    initial begin
        $display("do_halt: %d", do_halt);
        board_ck = 1'b0;
        rst = 1;
        cpu.memory_module.memory[0] <= 30000;
        cpu.memory_module.memory[1] <= 10;

        cpu.fetch_module.memory[ 0] <= 16'h0000;
        cpu.fetch_module.memory[ 1] <= 16'b0101_0001_00000001 ; // addi
        // cpu.fetch_module.memory[ 2] <= 16'b1000_0010_00000000 ; // ldi
        cpu.fetch_module.memory[ 2]  <= 16'b0101_0010_01111111 ; // ldi
        cpu.fetch_module.memory[ 3] <= 16'b0001_0010_0010_0000 ; // ldi
        cpu.fetch_module.memory[ 4] <= 16'b0001_0010_0010_0000 ; // ldi
        cpu.fetch_module.memory[ 5] <= 16'b0001_0010_0010_0000 ; // ldi
        cpu.fetch_module.memory[ 6] <= 16'b0001_0010_0010_0000 ; // ldi
        cpu.fetch_module.memory[ 7] <= 16'b0001_0010_0010_0000 ; // ldi
        cpu.fetch_module.memory[ 8] <= 16'b0001_0010_0010_0000 ; // ldi
        cpu.fetch_module.memory[ 9] <= 16'b0001_0010_0010_0000 ; // ldi
        cpu.fetch_module.memory[10] <= 16'b0001_0010_0010_0000 ; // ldi
        cpu.fetch_module.memory[11] <= 16'b0001_0010_0010_0000 ; // ldi
        cpu.fetch_module.memory[12] <= 16'b0001_0010_0010_0000 ; // ldi
        cpu.fetch_module.memory[13] <= 16'b0001_0010_0010_0000 ; // ldi
        cpu.fetch_module.memory[14] <= 16'b0001_0010_0010_0000 ; // ldi
        cpu.fetch_module.memory[15] <= 16'b0101_0010_01111111 ; // ldi
        cpu.fetch_module.memory[16] <= 16'b0101_0010_01111111 ; // ldi
        cpu.fetch_module.memory[17] <= 16'b0101_0010_01111111 ; // ldi
        cpu.fetch_module.memory[18] <= 16'b0101_0010_00011100 ; // ldi

        cpu.fetch_module.memory[19] <= 16'b0011_0100_0000_0000; // and
        cpu.fetch_module.memory[20] <= 16'b0001_0100_0011_0000; // add
        cpu.fetch_module.memory[21] <= 16'b0001_0011_0001_0000; // add
        cpu.fetch_module.memory[22] <= 16'b0101_0001_00000001 ; // addi
        cpu.fetch_module.memory[23] <= 16'b1101_0010_0011_1100; // bgt
        cpu.fetch_module.memory[24] <= 16'b0110_0001_00000001 ; // subi
        cpu.fetch_module.memory[25] <= 16'b0011_0010_0000_0000; // and
        cpu.fetch_module.memory[26] <= 16'b0001_0010_0100_0000; // add
        cpu.fetch_module.memory[27] <= 16'b1111111111111111   ; // halt
    end
endmodule
