module assync_fifo #(
    parameter WDATA = 16, // Num of data bits
    parameter WADDR = 4   // Num of address bits
) (
    input  logic             wclk,
    input  logic             warst_n,

    input  logic             rclk,
    input  logic             rarst_n,

    input  logic             winc,
    input  logic [WDATA-1:0] w_data,
 
    input  logic             rinc,

    output logic [WDATA-1:0] r_data,
    output logic             w_full,
    output logic             r_empty
);

    logic [WADDR:0] w_ptr;
    logic [WADDR:0] r_ptr;

    logic [WADDR:0] wq2_rptr_sync;
    logic [WADDR:0] rq2_wptr_sync;

    logic [WADDR-1:0] w_addr;
    logic [WADDR-1:0] r_addr;

    // Memory block for FIFO storage
    fifo_mem #(
        .WDATA ( WDATA ),
        .WADDR ( WADDR )
    ) u_fifo_mem_inst (
        .wclk  ( wclk   ),
        .w_en  ( winc   ),
        .w_full( w_full ),
        .w_addr( w_addr ),
        .w_data( w_data ),
        .r_addr( r_addr ),
        .r_data( r_data )
    );

    // Read pointer/addr and empty flag logic
    rptr_empty #(
        .WADDR ( WADDR )
    ) u_rptr_empty_inst (
        .rclk          ( rclk          ),
        .rarst_n       ( rarst_n       ),
        .rinc          ( rinc          ),
        .rq2_wptr_sync ( rq2_wptr_sync ),
        .r_empty       ( r_empty       ),
        .r_ptr         ( r_ptr         ),
        .r_addr        ( r_addr        )
    );

    // Read pointer synchronization to write clock domain
    sync_r2w #(
        .WADDR ( WADDR )
    ) u_sync_r2w_inst (
        .wclk          ( wclk          ),
        .warst_n       ( warst_n       ),
        .r_ptr         ( r_ptr         ),
        .wq2_rptr_sync ( wq2_rptr_sync )
    );

    // Write pointer/addr and full flag logic
    wptr_full #(
        .WADDR ( WADDR )
    ) u_wptr_full_inst (
        .wclk          ( wclk          ),
        .warst_n       ( warst_n       ),
        .winc          ( winc          ),
        .wq2_rptr_sync ( wq2_rptr_sync ),
        .w_full        ( w_full        ),
        .w_ptr         ( w_ptr         ),
        .w_addr        ( w_addr        )
    );

    // Write pointer synchronization to read clock domain
    sync_w2r #(
        .WADDR ( WADDR )
    ) u_sync_w2r_inst (
        .rclk          ( rclk          ),
        .rarst_n       ( rarst_n       ),
        .w_ptr         ( w_ptr         ),
        .rq2_wptr_sync ( rq2_wptr_sync )
    );

endmodule