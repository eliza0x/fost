`ifdef  TYPE_IS_LOADED
`else
`define TYPE_IS_LOADED

typedef logic [15:0] block;
typedef bit [8:0] addr;

typedef struct packed {
    addr  pc;
    block inst;
} inst;
`endif

