module sync_w2r #(
    parameter WADDR = 4 // Num of address bits
) (
    input  logic            rclk,
    input  logic            rarst_n,

    input  logic [WADDR:0]  w_ptr,        // Address pointer from write clock domain 
                                          // with addr + 1 bit bus
    output logic [WADDR:0]  rq2_wptr_sync // Synchronized address pointer to read clock domain
);

    logic [WADDR:0] rq1_wptr_sync;

    // Synchronize the write pointer to the read clock domain
    always_ff @(posedge rclk or negedge rarst_n) 
    begin
        if (!rarst_n) {rq2_wptr_sync, rq1_wptr_sync} <= '0;
        else          {rq2_wptr_sync, rq1_wptr_sync} <= {rq1_wptr_sync, w_ptr};
    end
    
endmodule