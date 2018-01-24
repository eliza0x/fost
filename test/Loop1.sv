`include "../CPU.sv"
`include "../src/Parameter.sv"

module Loop1();
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
        for (byte i=0; i<8; i++) begin
            $display("regs[%2d]: %d", i, cpu.decode_module.regs[i]);
        end
        $display("=================================");
        $finish(1);
    end

    initial begin
        $display("do_halt: %d", do_halt);
        board_ck = 1'b0;
        rst = 1;

        cpu.fetch_module.memory[0] <= 16'h0000;
        cpu.fetch_module.memory[1] <= 16'b0101_0001_00000010 ; // addi
        cpu.fetch_module.memory[2] <= 16'b0101_0010_00001010 ; // addi
        cpu.fetch_module.memory[3] <= 16'b0101_0011_00000111 ; // addi
        cpu.fetch_module.memory[4] <= 16'b1001_0100_0001_0000; // ld
        cpu.fetch_module.memory[5] <= 16'b1010_0100_0010_0000; // st
        cpu.fetch_module.memory[6] <= 16'b0101_0001_00000001 ; // addi
        cpu.fetch_module.memory[7] <= 16'b0101_0010_00000001 ; // addi
        cpu.fetch_module.memory[8] <= 16'b1101_0011_0001_1100; // bgt
        cpu.fetch_module.memory[10] <= 16'b1111111111111111   ; // halt

        assert(cpu.memory_module.memory[10] == 6);
        assert(cpu.memory_module.memory[11] == 4);
        assert(cpu.memory_module.memory[12] == 3);
        assert(cpu.memory_module.memory[13] == 2);
        assert(cpu.memory_module.memory[14] == 5);
        #100000 $finish(1);
    end
endmodule
