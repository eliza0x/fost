`include "../CPU.sv"
`include "../src/Parameter.sv"

module Add1();
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
        for (byte i=0; i<10; i++) begin
            $display("memory[%2d]: %d", i, cpu.memory_module.memory[i]);
        end
        $display("--------------------------------");
        for (byte i=0; i<16; i++) begin
            $display("regs[%2d]: %d", i, cpu.decode_module.regs[i]);
        end
        $display("=================================");
        $finish(1);
    end

    initial begin
        $display("do_halt: %d", do_halt);
        board_ck = 1'b0;
        rst = 1;

        cpu.fetch_module.memory[ 0] <= 16'h0000;
        cpu.fetch_module.memory[ 1] <= 16'b0101_0001_00000001 ; // addi
        cpu.fetch_module.memory[ 2] <= 16'b1000_0010_00000000 ; // ldi
        cpu.fetch_module.memory[ 3] <= 16'b0011_0100_0000_0000; // and
        cpu.fetch_module.memory[ 4] <= 16'b0001_0100_0011_0000; // add
        cpu.fetch_module.memory[ 5] <= 16'b0001_0011_0001_0000; // add
        cpu.fetch_module.memory[ 6] <= 16'b0101_0001_00000001 ; // addi
        cpu.fetch_module.memory[ 7] <= 16'b1101_0010_0011_1100; // bgt
        cpu.fetch_module.memory[ 8] <= 16'b0110_0001_00000001 ; // subi
        cpu.fetch_module.memory[ 9] <= 16'b0011_0010_0000_0000; // and
        cpu.fetch_module.memory[10] <= 16'b0001_0010_0100_0000; // add
        cpu.fetch_module.memory[11] <= 16'b1111111111111111   ; // halt

        #100000 $finish(1);
    end
endmodule
