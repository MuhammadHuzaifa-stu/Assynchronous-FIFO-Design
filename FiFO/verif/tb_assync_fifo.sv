module tb ();
    
    localparam WDATA = 16;  // Num of data bits
    localparam WADDR = 4;   // Num of address bits

    logic             wclk;
    logic             warst_n;

    logic             rclk;
    logic             rarst_n;

    logic             winc;
    logic [WDATA-1:0] w_data;

    logic             rinc;

    logic [WDATA-1:0] r_data;
    logic             w_full;
    logic             r_empty;

    assync_fifo #(
        .WDATA ( WDATA ),
        .WADDR ( WADDR )
    ) u_dut (
        .wclk   ( wclk    ),
        .warst_n( warst_n ),
        .rclk   ( rclk    ),
        .rarst_n( rarst_n ),
        .winc   ( winc    ),
        .w_data ( w_data  ),
        .rinc   ( rinc    ),
        .r_data ( r_data  ),
        .w_full ( w_full  ),
        .r_empty( r_empty )
    );

    initial 
    begin
        wclk = 0;
        rclk = 0;
        forever 
        begin
            #5  wclk  = ~wclk;
            #10 rclk = ~rclk;
        end
    end

    initial 
    begin
        warst_n = 0;
        rarst_n = 0;

        #1 warst_n = 1;
        #1 rarst_n = 1;
    end

    initial
    begin
        winc = 0;
        rinc = 0;
        w_data = 0;

        #20 winc = 1; w_data = 16'hAAAA;
        #10 winc = 1; w_data = 16'hBBBB;
        #10 winc = 1; w_data = 16'hCCCC;
        #10 winc = 1; w_data = 16'hDDDD;
        #10 winc = 1; w_data = 16'hEEEE;
        #10 winc = 0;

        #40 rinc = 1;
        #20 rinc = 1;
        #20 rinc = 1;
        #20 rinc = 1;
        #20 rinc = 0;

        #200 $finish;
    end

    initial
    begin
        $dumpfile("tb_assync_fifo.vcd");
        $dumpvars(0, tb);
    end

endmodule