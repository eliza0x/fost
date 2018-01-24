addi 1 1    // iter  = 1
ldi  2 0    // upper = 30000
and  4 0    // tmp   &= 0
add  4 3    // tmp   += sum
add  3 1    // sum   += iter
addi 1 1    // iter  += 1
bgt  2 3 -4 // bgt iter upper -2
subi 1 1    // iter  -= 1
and  2 0
add  2 4
halt        // halt

