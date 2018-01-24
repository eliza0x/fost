addi 10  31
addi  2  35
and   1   0
add   1  10
and   3   0
add   3   1
ld    4   1  0
addi  1   1
ld    5   1  0
bgt   5   4  5
and   3   0
add   3   1
and   4   0
add   4   5
addi  1   1
bgt   2   1 -7
bgt   2  10 2
halt
ld  6 10 0
st  6  3 0
st  4 10 0
addi 10 1
jump -20

// min_iter(3): 34
// min(4):      2
//           loop_index  = 31
//           upper_index = 35
//           index       = loop_index
// START:    min_iter    =  index
//           min         =  memory[index]
//           index       += 1
// SELECT:   temp        =  memory[index]
//           bgt temp min SWAPPED
//           min_iter    = index
//           min         = temp
// SWAPPED:  index       += 1
//           bgt upper_index index SELECT
//           bgt upper_index loop_index RETURN
//           halt
// RETURN:   loop_index  += 1
//           jump START


