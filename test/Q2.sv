`include "../CPU.sv"
`include "../src/Parameter.sv"

module Q2();
    bit board_ck;
    bit CLK;
    bit rst;
    bit do_halt;
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
        for (byte i=0; i<10; i++) begin
            $display("regs[%2d]: %d", i, cpu.decode_module.regs[i]);
        end
        $display("=================================");

        assert(cpu.decode_module.regs[10] == 624);
        assert(cpu.decode_module.regs[7] == 16'b0000000000000_111);
        $display("regs[ 7]: %d", cpu.decode_module.regs[7]);
        $display("regs[10]: %d", cpu.decode_module.regs[10]);
        $display("regs[ 8]: %d", cpu.decode_module.regs[ 8]);
        $display("regs[ 9]: %d", cpu.decode_module.regs[ 9]);
        $finish(1);
    end

    initial begin
        $display("do_halt: %d", do_halt);
        board_ck = 1'b0;
        rst = 1;
        cpu.memory_module.memory[50] <= 1;
        cpu.memory_module.memory[51] <= 100;

        cpu.fetch_module.memory[ 0] <= 16'b0011_0010_0000_0000; // and
        cpu.fetch_module.memory[ 1] <= 16'b0101_0010_00001000 ; // addi
        cpu.fetch_module.memory[ 2] <= 16'b0011_0011_0000_0000; // and
        cpu.fetch_module.memory[ 3] <= 16'b0101_0011_00000001 ; // addi
        cpu.fetch_module.memory[ 4] <= 16'b0011_0100_0000_0000; // and
        cpu.fetch_module.memory[ 5] <= 16'b0011_0101_0000_0000; // and
        cpu.fetch_module.memory[ 6] <= 16'b0001_0101_0011_0000; // add
        cpu.fetch_module.memory[ 7] <= 16'b0011_0101_0010_0000; // and
        cpu.fetch_module.memory[ 8] <= 16'b1101_0101_0000_0101; // bgt
        cpu.fetch_module.memory[ 9] <= 16'b0001_0011_0011_0000; // add
        cpu.fetch_module.memory[10] <= 16'b0101_0011_00000001 ; // addi
        cpu.fetch_module.memory[11] <= 16'b0101_0100_00000001 ; // addi
        cpu.fetch_module.memory[12] <= 16'b1110_000_111111001 ;// jump
        cpu.fetch_module.memory[13] <= 16'b0011_0110_0000_0000; // and
        cpu.fetch_module.memory[14] <= 16'b0011_0111_0000_0000; // and
        cpu.fetch_module.memory[15] <= 16'b0001_0111_0111_0000; // add
        cpu.fetch_module.memory[16] <= 16'b0101_0111_00000001 ; // addi
        cpu.fetch_module.memory[17] <= 16'b0101_0110_00000001 ; // addi
        cpu.fetch_module.memory[18] <= 16'b1101_0100_0110_1101; // bgt
        cpu.fetch_module.memory[19] <= 16'b1000_1000_00110010 ;    // ldi
        cpu.fetch_module.memory[20] <= 16'b1000_1001_00110011 ;    // ldi
        cpu.fetch_module.memory[21] <= 16'b0011_1010_0000_0000; // and
        cpu.fetch_module.memory[22] <= 16'b0101_1001_00000001 ; // addi
        cpu.fetch_module.memory[23] <= 16'b0011_1011_0000_0000; // and
        cpu.fetch_module.memory[24] <= 16'b0001_1011_1000_0000; // add
        cpu.fetch_module.memory[25] <= 16'b0011_1011_0111_0000; // and
        cpu.fetch_module.memory[26] <= 16'b1101_1011_0000_0010; // bgt
        cpu.fetch_module.memory[27] <= 16'b0001_1010_1000_0000; // add
        cpu.fetch_module.memory[28] <= 16'b0101_1000_00000001 ; // addi
        cpu.fetch_module.memory[29] <= 16'b1101_1001_1000_1010; // bgt
        cpu.fetch_module.memory[30] <= 16'b1111111111111111   ; // halt
    end
endmodule

