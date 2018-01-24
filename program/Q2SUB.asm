and  2 0    #        X = 8
addi 2 8
and  3 0    #        filter = 1
addi 3 1
and  4 0    #        I = 0
and  5 0    # WHILE: temp = filter & X
add  5 3
and  5 2
bgt  5 0 5  #        if (5 > 0) goto OUTER
add  3 3    #        filter = filter*double + 1 mulが無いので、$3 = $3 + $3
addi 3 1
addi 4 1    #        I++
jump -7     #        goto WH4LE

# FILTER
and  6 0    # OUTER: L = 0
and  7 0    #        filter2 = 0
add  7 7    # FOR:   filter2 += filter2
addi 7 1    #        filter2++
addi 6 1    #        L++
bgt  4 6 -3 #        if (I>L) goto FOR

halt
