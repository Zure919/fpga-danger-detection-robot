module led_8x8 (
    input  wire clk,
    input  wire rst,
    input  wire load,
    input  wire [5:0] lfsr_in,
    output reg  [7:0] row,
    output reg  [7:0] col
);
    reg [2:0] latched_row;
    reg [2:0] latched_col;

    wire [2:0] row_index = lfsr_in[5:3];
    wire [2:0] col_index = lfsr_in[2:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            latched_row <= 3'b000;
            latched_col <= 3'b000;
        end else if (load) begin
            latched_row <= row_index;
            latched_col <= col_index;
        end
    end

    always @(*) begin
        row = 8'b0;
        col = 8'b0;
        if (latched_row < 8)
            row[latched_row] = 1'b1;
        if (latched_col < 8)
            col[latched_col] = 1'b1;
    end
endmodule