`include "../CPU.sv"
`include "../src/Parameter.sv"

module Q2SUB();
    bit board_ck;
    bit CLK;
    bit rst;
    bit do_halt;
    logic [7:0] SEG;
    logic [3:0] SEG_SEL;

    CPU cpu(.*);

    always #(one_clock*2) board_ck = ~board_ck;

    initial #100000 begin
        $display("#################################");
        for (byte i=0; i<16; i++) begin
            $display("memory[%2d]: %d", i, cpu.memory_module.memory[i]);
        end
        $display("--------------------------------");
        for (byte i=0; i<10; i++) begin
            $display("regs[%2d]: %d", i, cpu.decode_module.regs[i]);
        end
        $display("#################################");
        $finish(1);

    end

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

        assert(cpu.decode_module.regs[7] == 16'b0000000000000_111);
        $display("regs[7]: %d", cpu.decode_module.regs[7]);

        $finish(1);
    end

    initial begin
        $display("do_halt: %d", do_halt);
        board_ck = 1'b0;
        rst = 1;
        cpu.fetch_module.memory[ 0] <= 16'h0000;
        cpu.fetch_module.memory[ 1] <= 16'b0011_0010_0000_0000; // and: X = 8
        cpu.fetch_module.memory[ 2] <= 16'b0101_0010_00001000 ; // addi
        cpu.fetch_module.memory[ 3] <= 16'b0011_0011_0000_0000; // and: filter = 1
        cpu.fetch_module.memory[ 4] <= 16'b0101_0011_00000001 ; // addi
        cpu.fetch_module.memory[ 5] <= 16'b0011_0100_0000_0000; // and: I = 0
        cpu.fetch_module.memory[ 6] <= 16'h0000;
        cpu.fetch_module.memory[ 7] <= 16'b0011_0101_0000_0000; // and: WHILE: temp = filter & X
        cpu.fetch_module.memory[ 8] <= 16'b0001_0101_0011_0000; // add
        cpu.fetch_module.memory[ 9] <= 16'b0011_0101_0010_0000; // and
        cpu.fetch_module.memory[10] <= 16'b1101_0101_0000_0101; // bgt: if (5 > 0) goto OUTER
        cpu.fetch_module.memory[11] <= 16'b0001_0011_0011_0000; // add: $3 = $3 + $3
        cpu.fetch_module.memory[12] <= 16'b0101_0011_00000001 ; // addi $3 = $3 + 1
        cpu.fetch_module.memory[13] <= 16'b0101_0100_00000001 ; // addi: I++
        cpu.fetch_module.memory[14] <= 16'b1110_000_111111001 ; // jump: goto WHILE
        // cpu.fetch_module.memory[14] <= 16'b0011_0110_0000_0000; // and: OUTER: L = 0
        // cpu.fetch_module.memory[15] <= 16'b0011_0111_0000_0000; // and: filter2 = 0
        // cpu.fetch_module.memory[16] <= 16'b0001_0111_0111_0000; // add: FOR:   filter2 += filter2
        // cpu.fetch_module.memory[17] <= 16'b0101_0111_00000001 ; // addi: filter2++
        // cpu.fetch_module.memory[18] <= 16'b0101_0110_00000001 ; // addi: L++
        // cpu.fetch_module.memory[19] <= 16'b1101_0100_0110_1101; // bgt: if (I>L) goto FOR
        cpu.fetch_module.memory[20] <= 16'b1111111111111111   ; // halt
    end
    always @(cpu.decode_module.regs[4]) begin
        $display("regs[4]: %d", cpu.decode_module.regs[4]);
    end
endmodule

