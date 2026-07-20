module sync_r2w #(
    parameter WADDR = 4 // Num of address bits
) (
    input  logic            wclk,
    input  logic            warst_n,

    input  logic [WADDR:0]  r_ptr,        // Address pointer from read clock domain 
                                          // with addr + 1 bit bus
    output logic [WADDR:0]  wq2_rptr_sync // Synchronized address pointer to write clock domain
);

    logic [WADDR:0] wq1_rptr_sync;

    // Synchronize the read pointer to the write clock domain
    always_ff @(posedge wclk or negedge warst_n) 
    begin
        if (!warst_n) {wq2_rptr_sync, wq1_rptr_sync} <= '0;
        else          {wq2_rptr_sync, wq1_rptr_sync} <= {wq1_rptr_sync, r_ptr};
    end
    
endmodule