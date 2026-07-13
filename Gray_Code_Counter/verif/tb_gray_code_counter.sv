module tb ();
    
    parameter WIDTH = 4;

    logic             clk;
    logic             arst_n;

    logic [WIDTH-1:0] gray_code;

    // Instantiate the gray_code_counter
    gray_code_counter # (
        .WIDTH( WIDTH )
    ) dut (
        .clk      ( clk       ),
        .arst_n   ( arst_n    ),
        .gray_code( gray_code )
    );


    initial 
    begin
        clk = 0;
        forever 
        begin
            #5 clk = ~clk; // 100MHz clock
        end
    end

    initial
    begin
        arst_n <= 0;
        #6;
        arst_n <= 1;
    end

    initial 
    begin
        $dumpfile("tb_gray_code_counter.vcd");
        $dumpvars(0, tb);    
    end

    initial 
    begin

        repeat(20) @(posedge clk);
        $finish;

    end

endmodule