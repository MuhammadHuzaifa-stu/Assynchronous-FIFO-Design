// Non-synthesizable Async-FIFO

module beh_fifo #(
    parameter DSIZE = 8,
    parameter ASIZE = 4
) (
    input  logic             wclk,
    input  logic             warst_n,

    input  logic             rclk,
    input  logic             rarst_n,

    input  logic             winc,
    input  logic [DSIZE-1:0] w_data,

    input  logic             rinc,

    output logic [DSIZE-1:0] r_data,
    output logic             w_full,
    output logic             r_empty
);

    logic [DSIZE-1:0] mem [0:2**ASIZE-1];
    
    logic [ASIZE  :0] wptr;
    logic [ASIZE  :0] rptr;

    logic [ASIZE  :0] wrptr1;
    logic [ASIZE  :0] wrptr2;
    logic [ASIZE  :0] wrptr3;

    logic [ASIZE  :0] rwptr1;
    logic [ASIZE  :0] rwptr2;
    logic [ASIZE  :0] rwptr3;

    always @(posedge wclk or negedge warst_n) 
    begin
        if (!warst_n) 
        begin
            wptr <= 0;
        end 
        else if (winc && !w_full) 
        begin
            mem[wptr[ASIZE-1:0]] <= w_data;
            wptr                 <= wptr + 1;
        end
    end

    always @(posedge wclk or negedge warst_n) 
    begin
        if (!warst_n) 
        begin
            wrptr1 <= 0;
            wrptr2 <= 0;
            wrptr3 <= 0;
        end 
        else 
        begin
            wrptr1 <= rptr;
            wrptr2 <= wrptr1;
            wrptr3 <= wrptr2;
        end
    end

    always @(posedge rclk or negedge rarst_n)
    begin
        if (!rarst_n) 
        begin
            rptr <= 0;
        end 
        else if (rinc && !r_empty) 
        begin
            rptr <= rptr + 1;
        end
    end

    always @(posedge rclk or negedge rarst_n)
    begin
        if (!rarst_n) 
        begin
            rwptr1 <= 0;
            rwptr2 <= 0;
            rwptr3 <= 0;
        end 
        else 
        begin
            rwptr1 <= wptr;
            rwptr2 <= rwptr1;
            rwptr3 <= rwptr2;
        end
    end

    assign w_full  = (wptr[ASIZE] != rwptr3[ASIZE]) && (wptr[ASIZE-1:0] == rwptr3[ASIZE-1:0]);
    assign r_empty = (rptr == wrptr3);
    assign r_data  = mem[rptr[ASIZE-1:0]];

endmodule