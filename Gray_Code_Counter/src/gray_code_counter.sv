module gray_code_counter #(
    parameter WIDTH = 4
) (
    input  logic             clk,
    input  logic             arst_n,

    output logic [WIDTH-1:0] gray_code
);

    logic [WIDTH-1:0] binary_count;

    // Convert binary count to Gray code
    assign gray_code = (binary_count >> 1) ^ binary_count;

    // Binary counter
    always_ff @(posedge clk or negedge arst_n) 
    begin
        if (!arst_n) 
        begin
            binary_count <= '0;
        end 
        else 
        begin
            binary_count <= binary_count + 1;
        end
    end

endmodule