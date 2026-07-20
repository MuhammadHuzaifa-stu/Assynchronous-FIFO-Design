module wptr_full #(
    parameter WADDR = 4 // Num of address bits
) (
    input  logic             wclk,
    input  logic             warst_n,

    input  logic             winc,
    input  logic [WADDR:0]   wq2_rptr_sync, // Synchronized address pointer from read clock domain

    output logic             w_full,        // Full flag
    output logic [WADDR:0]   w_ptr,         // Address pointer in write clock domain
    output logic [WADDR-1:0] w_addr         // Address in write clock domain
);
    
    logic [WADDR:0] wbin;       // Binary write pointer
    logic [WADDR:0] wgray_next; // Gray code write pointer
    logic [WADDR:0] wbin_next;  // Next binary write pointer
    
    // Address is lower bits of binary write pointer
    assign w_addr     = wbin[WADDR-1:0]; 

    // Increment write pointer if winc is high and not full
    assign wbin_next  = wbin + (winc & ~w_full);
    assign wgray_next = (wbin_next >> 1) ^ wbin_next; // Convert binary to Gray code

    always_ff @(posedge wclk or negedge warst_n)
    begin
        if (!warst_n) {w_ptr, wbin} <= '0;
        else          {w_ptr, wbin} <= {wgray_next, wbin_next};
    end

    // Full flag is high when the next write pointer equals the synchronized read pointer
    always_ff @(posedge wclk or negedge warst_n) 
    begin
        if (!warst_n) w_full <= 1'b0;
        else          w_full <= (wgray_next == {~wq2_rptr_sync[WADDR : WADDR - 1], wq2_rptr_sync[WADDR-2:0]});
    end

endmodule