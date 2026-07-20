module fifo_mem #(
    parameter WDATA = 16, // Num of data bits
    parameter WADDR = 4   // Num of address bits
) (
    input  logic             wclk,
    
    input  logic             w_en,
    input  logic             w_full,

    input  logic [WADDR-1:0] w_addr,
    input  logic [WDATA-1:0] w_data,

    input  logic [WADDR-1:0] r_addr,
    output logic [WDATA-1:0] r_data
);

    localparam MEM_SIZE = 1 << WADDR;

    logic [WDATA-1:0] mem [0:MEM_SIZE-1];

    assign r_data = mem[r_addr];

    always_ff @(posedge wclk) 
        if (w_en && !w_full) mem[w_addr] <= w_data;

endmodule