module rptr_empty #(
    parameter WADDR = 4 // Num of address bits
) (
    input  logic             rclk,
    input  logic             rarst_n,

    input  logic             rinc,
    input  logic [WADDR:0]   rq2_wptr_sync,  // Synchronized address pointer from write clock domain

    output logic             r_empty,        // Empty flag
    output logic [WADDR:0]   r_ptr,          // Address pointer in read clock domain
    output logic [WADDR-1:0] r_addr          // Address in read clock domain
);

    logic [WADDR:0] rbin;       // Binary read pointer
    logic [WADDR:0] rgray_next; // Gray code read pointer
    logic [WADDR:0] rbin_next;  // Next binary read pointer
    
    // Address is lower bits of binary read pointer
    assign r_addr     = rbin[WADDR-1:0]; 

    // Increment read pointer if rinc is high and not empty
    assign rbin_next  = rbin + (rinc & ~r_empty);
    assign rgray_next = (rbin_next >> 1) ^ rbin_next; // Convert binary to Gray code

    always_ff @(posedge rclk or negedge rarst_n)
    begin
        if (!rarst_n) {r_ptr, rbin} <= '0;
        else          {r_ptr, rbin} <= {rgray_next, rbin_next};
    end

    // Empty flag is high when the next read pointer equals the synchronized write pointer
    always_ff @(posedge rclk or negedge rarst_n) 
    begin
        if (!rarst_n) r_empty <= 1'b1;
        else          r_empty <= (rgray_next == rq2_wptr_sync);
    end

endmodule