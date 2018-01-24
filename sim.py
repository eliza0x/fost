from time import gmtime, strftime
import argparse

def tohex(n):
    return int('1'*16, 2) & n

class CPU:
    def __init__(self, program):
        self.pc = 0
        self.program = [None] * 256

        lines = filter(
            lambda line: line != '',
            [line.strip().replace('_', '').split('//')[0] for line in program.split('\n')])

        for n, inst in enumerate(lines):
            print('inst: {}'.format(inst))
            self.program[n] = inst
        self.memory = [None] * 256
        self.regs   = [0] * 16
        self.is_halt = False

    def one_step(self):
        if self.is_halt == False:
            inst  = self.program[self.pc]

            if inst == None:
                print("ERROR: pc: {}, inst == None".format(self.pc))
                self.pc = self.pc + 1
                return None

            op    = inst[0:4]
            rd    = int(inst[4:8]  , 2)
            rs    = int(inst[8:12] , 2)
            rt    = int(inst[12:16], 2)
            imm8  = int(inst[8]*8+inst[8:16], 2)
            disp4 = int(inst[12]*12+inst[12:16], 2)
            disp9 = int(inst[7]*7+inst[7:16], 2)

            if   op == '0000': # nop
                self.pc = self.pc + 1
            elif op == '0001': # add
                self.regs[rd] = tohex(self.regs[rd] + self.regs[rs])
                self.pc = self.pc + 1
            elif op == '0010': # sub
                self.regs[rd] = tohex(self.regs[rd] - self.regs[rs])
                self.pc = self.pc + 1
            elif op == '0011': # and
                self.regs[rd] = tohex(self.regs[rd] & self.regs[rs])
                self.pc = self.pc + 1
            elif op == '0100': # or
                self.regs[rd] = tohex(self.regs[rd] | self.regs[rs])
                self.pc = self.pc + 1
            elif op == '0101': # addi
                self.regs[rd] = tohex(self.regs[rd] + imm8)
                self.pc = self.pc + 1
            elif op == '0110': # subi
                self.regs[rd] = tohex(self.regs[rd] - imm8)
                self.pc = self.pc + 1
            elif op == '0111': # incr
                self.regs[rd] = tohex(self.regs[rd] + 1)
                self.pc = self.pc + 1
            elif op == '1000': # ldi
                self.regs[rd] = tohex(self.memory[imm8])
                self.pc = self.pc + 1
            elif op == '1001': # ld
                # print('pc: {}, adddr: {}, upper: {}'.format(self.pc, disp4+self.regs[rs], self.regs[2]))
                print('pc: {}, regs[{}] <= mempry[{}]'.format(self.pc, rd, disp4+self.regs[rs]))
                self.regs[rd] = tohex(self.memory[disp4+self.regs[rs]])
                self.pc = self.pc + 1
            elif op == '1010': # st
                print('pc: {}, mempry[{}] <= {}'.format(self.pc, disp4+self.regs[rs], tohex(self.regs[rd])))
                self.memory[disp4+self.regs[rs]] = tohex(self.regs[rd])
                self.pc = self.pc + 1
                for n, reg in enumerate(self.regs):
                    print('[{}]: {}'.format(n, self.regs[n]), end=', ')
                print()
            elif op == '1100': # beq
                if self.regs[rd] == self.regs[rs]:
                    self.pc = tohex(self.pc + disp4)
                else:
                    self.pc = tohex(self.pc + 1)
            elif op == '1101': # bgt
                # print('rd: {} > rs: {} -> {}'.format(self.regs[rd], self.regs[rs], self.regs[rd] > self.regs[rs]))
                if self.regs[rd] > self.regs[rs]:
                    self.pc = tohex(self.pc + disp4)
                else:
                    self.pc = tohex(self.pc + 1)
            elif op == '1110': # jump
                self.pc = tohex(self.pc + disp9)
            elif op == '1111': # halt
                self.is_halt = True
                self.pc = self.pc + 1
                print('HALT')
            else:
                print("ERROR: pc: {}, invalid instruction".format(self.pc))
        # print("pc: {}".format(self.pc))

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("file")
    args = parser.parse_args()
    print(strftime("\\\\ Start: %H:%M:%S", gmtime()))
    with open(args.file, "r") as file:
        program = file.read()
        cpu = CPU(program)
        cpu.memory[0]  = 30000;
        cpu.memory[31] = 6;
        cpu.memory[32] = 4;
        cpu.memory[33] = 3;
        cpu.memory[34] = 2;
        cpu.memory[35] = 5;
        cpu.memory[36] = 0;
        cpu.memory[50] = 1;
        cpu.memory[51] = 100;
        cnt = 0
        try:
            print('----------')
            while not cpu.is_halt:
                cpu.one_step()
                cnt = cnt + 1
            print('----------')
        except:
            print()
            print('!!!!!!!!!!!!RUNTIME ERROR!!!!!!!!!!!!')
            print()
        finally:
            for n, reg in enumerate(cpu.regs):
                print('regs[{:>2}]: {}'.format(n, reg))
            for n in range(31, 36):
                print('memory[{:>2}]: {}'.format(n, cpu.memory[n]))
            print('ck cnt: {}'.format(cnt))
    print(strftime("\\\\ End: %H:%M:%S", gmtime()))

