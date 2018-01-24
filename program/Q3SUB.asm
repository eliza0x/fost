// START:    index       =  31
//           min_iter    =  index
//           min         =  memory[index]
//           index       += 1
// SELECT:   temp        =  memory[index]
//           bgt temp min SWAPPED
//           min_iter    = index
//           min         = temp
// SWAPPED:  index       += 1
//           bgt upper_index index SELECT
//           halt

addi 1  31
addi 2  36
and  3   0
add  3   1
ld   4   1  0
addi 1   1
ld   5   1  0
bgt  5   4  5
and  3   0
add  3   1
and  4   0
add  4   5
addi 1   1
bgt  2   1 -7
halt

// min_iter(3): 34
// min(4):      2

