from time import gmtime, strftime
import argparse

def cutoff9(source_txt):
    source = int(source_txt)
    binary = '{0:09b}'.format(abs(source))[-9:]
    output_bin = ''
    for digit in binary:
        if source >= 0:
            output_bin = output_bin + digit
        else:
            if digit == '0':
                digit = '1'
            else:
                digit = '0'
            output_bin = output_bin + digit
    if source < 0:
        output_bin = '{0:09b}'.format(int(output_bin, 2) + 1)
    return output_bin

def cutoff8(source_txt):
    source = int(source_txt)
    binary = '{0:08b}'.format(abs(source))[-8:]
    output_bin = ''
    for digit in binary:
        if source >= 0:
            output_bin = output_bin + digit
        else:
            if digit == '0':
                digit = '1'
            else:
                digit = '0'
            output_bin = output_bin + digit
    if source < 0:
        output_bin = '{0:08b}'.format(int(output_bin, 2) + 1)
    return output_bin

def cutoff4(source_txt):
    source = int(source_txt)
    binary = '{0:04b}'.format(abs(source))[-4:]
    output_bin = ''
    for digit in binary:
        if source >= 0:
            output_bin = output_bin + digit
        else:
            if digit == '0':
                digit = '1'
            else:
                digit = '0'
            output_bin = output_bin + digit
    if source < 0:
        output_bin = '{0:04b}'.format(int(output_bin, 2) + 1)
    return output_bin

def emit(source):
    sourceLines     = source.split('\n')
    removeComment   = [line.split('#')[0].strip() for line in sourceLines]
    removeBlangLine = [line for line in removeComment if line != '']

    for inst in removeBlangLine:
        token = inst.split(' ')
        op    = token[0]

        if   op == 'nop':
            print('0'*16 + ' # nop')    
        elif op == 'add':
            print('0001' + cutoff4(token[1]))    

def emit(source):
    sourceLines = filter(lambda line: line!='', source.strip().split('\n'))
    
    for commentAndInst in sourceLines:
        expandSharp = commentAndInst.split('#')
        inst = expandSharp[0].strip()
        token = list(filter(lambda x: x!='', inst.split(' ')))
        
        if len(token) > 0:
            op    = token[0]
        else:
            op    = ''
    
        if len(expandSharp) >= 2:
            comment = ': ' + expandSharp[1].strip()
        else: 
            comment = ''

        if   op == 'nop':
            print('0'*16 + '    // nop: {}'.format(commentAndInst[1:])) 
        elif op == 'add':
            print('0001_'+cutoff4(token[1])+'_'+cutoff4(token[2])+'_'+'0'*4+' // add{}'.format(comment))
        elif op == 'sub':
            print('0010_'+cutoff4(token[1])+'_'+cutoff4(token[2])+'_'+'0'*4+' // sub{}'.format(comment))
        elif op == 'and':
            print('0011_'+cutoff4(token[1])+'_'+cutoff4(token[2])+'_'+'0'*4+' // and{}'.format(comment))
        elif op == 'or':
            print('0100_'+cutoff4(token[1])+'_'+cutoff4(token[2])+'_'+'0'*4+' // or{}'.format(comment))
        elif op == 'addi':
            print('0101_'+cutoff4(token[1])+'_'+cutoff8(token[2])+'  // addi{}'.format(comment))
        elif op == 'subi':
            print('0110_'+cutoff4(token[1])+'_'+cutoff8(token[2])+'     // subi{}'.format(comment))
        elif op == 'incr':
            print('0111_'+cutoff4(token[1])+'_'+'0'*8+'     // incr{}'.format(comment))
        elif op == 'ldi':
            print('1000_'+cutoff4(token[1])+'_'+cutoff8(token[2])+'     // ldi{}'.format(comment))
        elif op == 'ld':
            print('1001_'+cutoff4(token[1])+'_'+cutoff4(token[2])+'_'+cutoff4(token[3])+' // ld{}'.format(comment))
        elif op == 'st':
            print('1010_'+cutoff4(token[1])+'_'+cutoff4(token[2])+'_'+cutoff4(token[3])+' // st{}'.format(comment))
        elif op == 'beq':
            print('1100_'+cutoff4(token[1])+'_'+cutoff4(token[2])+'_'+cutoff4(token[3])+' // beq{}'.format(comment))
        elif op == 'bgt':
            print('1101_'+cutoff4(token[1])+'_'+cutoff4(token[2])+'_'+cutoff4(token[3])+' // bgt{}'.format(comment))
        elif op == 'jump':
            print('1110_000_'+cutoff9(token[1])+' // jump{}'.format(comment))
        elif op == 'halt':
            print('1'*16+'    // halt{}'.format(comment))
        else:
            if comment != '':
                print('//{}'.format(comment))
            else:
                print('')

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("file")
    args = parser.parse_args()

    print(strftime("// Start: %H:%M:%S", gmtime()))
    with open(args.file, "r") as file:
        emit(file.read())
    print(strftime("// End: %H:%M:%S", gmtime()))

