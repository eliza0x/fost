and  2 0    //        X = 8
addi 2 8
and  3 0    //        filter = 1
addi 3 1
and  4 0    //        I = 0
and  5 0    // WHILE: temp = filter & X
add  5 3
and  5 2
bgt  5 0 5  //        if (5 > 0) goto OUTER
add  3 3    //        filter = filter*double + 1 mulが無いので、$3 = $3 + $3
addi 3 1
addi 4 1    //        I++
jump -7     //        goto WH4LE

// FILTER
and  6 0    // OUTER: L = 0
and  7 0    //        filter2 = 0
add  7 7    // FOR:   filter2 += filter2
addi 7 1    //        filter2++
addi 6 1    //        L++
bgt  4 6 -3 //        if (I>L) goto FOR

// SUM
ldi  8   50    // A    = memory[50]
ldi  9   51    // B    = memory[51]

and  10   0    // sum  = 0
addi 9    1    // B++
and  11   0    // FOR2: tmp2 = 0
add  11   8    //       tmp2 += A
and  11   7    //       tmp2 &= filter2
bgt  11   0 2  //       bgt tmp2 $0 2
add  10   8    //       sum += A  
addi 8    1    //       A++
bgt  9    8 -6 // RET:  bgt B A FOR2

// HALT
halt        //        halt

// filter2: '1'*$4
// answer: X=2^I, $4 == I

