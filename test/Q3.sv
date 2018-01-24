`include "../CPU.sv"
`include "../src/Parameter.sv"

module Q3();
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
        for (byte i=30; i<40; i++) begin
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

        for (byte i=31; i<(31+5); i++)
            $display("memory[%2d]: %d", i, cpu.memory_module.memory[i]);

        assert(cpu.memory_module.memory[31] == 2);
        assert(cpu.memory_module.memory[32] == 3);
        assert(cpu.memory_module.memory[33] == 4);
        assert(cpu.memory_module.memory[34] == 5);
        assert(cpu.memory_module.memory[35] == 6);


        $finish(1);
    end

    initial begin
        $display("do_halt: %d", do_halt);
        board_ck = 1'b0;
        rst = 1;

        cpu.memory_module.memory[31]= 5;
        cpu.memory_module.memory[32]= 2;
        cpu.memory_module.memory[33]= 4;
        cpu.memory_module.memory[34]= 3;
        cpu.memory_module.memory[35]= 6;
        cpu.memory_module.memory[36]= 100;


        cpu.fetch_module.memory[0] <=  16'b0101_1010_00011111  ;// addi
        cpu.fetch_module.memory[1] <=  16'b0101_0010_00100100  ;// addi
        cpu.fetch_module.memory[2] <=  16'b0101_1011_00100011  ;// addi
        cpu.fetch_module.memory[3] <=  16'b0011_0001_0000_0000 ;// and
        cpu.fetch_module.memory[4] <=  16'b0001_0001_1010_0000 ;// add
        cpu.fetch_module.memory[5] <=  16'b0011_0011_0000_0000 ;// and
        cpu.fetch_module.memory[6] <=  16'b0001_0011_0001_0000 ;// add
        cpu.fetch_module.memory[7] <=  16'b1001_0100_0001_0000 ;// ld
        cpu.fetch_module.memory[8] <=  16'b0101_0001_00000001  ;// addi
        cpu.fetch_module.memory[9] <=  16'b1001_0101_0001_0000 ;// ld
        cpu.fetch_module.memory[10] <= 16'b1101_0101_0100_0101; // bgt
        cpu.fetch_module.memory[11] <= 16'b0011_0011_0000_0000; // and
        cpu.fetch_module.memory[12] <= 16'b0001_0011_0001_0000; // add
        cpu.fetch_module.memory[13] <= 16'b0011_0100_0000_0000; // and
        cpu.fetch_module.memory[14] <= 16'b0001_0100_0101_0000; // add
        cpu.fetch_module.memory[15] <= 16'b0101_0001_00000001 ; // addi
        cpu.fetch_module.memory[16] <= 16'b1101_0010_0001_1001; // bgt
        cpu.fetch_module.memory[17] <= 16'b1101_1011_1010_0010; // bgt
        cpu.fetch_module.memory[18] <= 16'b1111111111111111   ; // halt
        cpu.fetch_module.memory[19] <= 16'b1001_0110_1010_0000; // ld
        cpu.fetch_module.memory[20] <= 16'b1010_0100_1010_0000; // st
        cpu.fetch_module.memory[21] <= 16'b1010_0110_0011_0000; // st
        cpu.fetch_module.memory[22] <= 16'b0101_1010_00000001 ; // addi
        cpu.fetch_module.memory[23] <= 16'b1110_000_111101100 ; // jump
    end
endmodule

