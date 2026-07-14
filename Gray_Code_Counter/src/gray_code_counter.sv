module gray_code_counter #(
    parameter WIDTH = 4
) (
    input  logic             clk,
    input  logic             arst_n,

    output logic [WIDTH-1:0] gray_code
);

    logic [WIDTH-1:0] binary_count;
    logic [WIDTH-1:0] binary_count_next;


    logic [WIDTH-1:0] gray_code_reg;
    logic [WIDTH-1:0] gray_code_next;

    assign binary_count_next = binary_count + 1;
    assign gray_code_next    = (binary_count_next >> 1) ^ binary_count_next;

    // Binary counter
    always_ff @(posedge clk or negedge arst_n) 
    begin
        if (!arst_n) 
            {gray_code, binary_count} <= '0;
        else 
            {gray_code, binary_count} <= {gray_code_next, binary_count_next};
    end

endmodule