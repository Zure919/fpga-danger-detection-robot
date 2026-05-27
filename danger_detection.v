module danger_detection (
    input clk,
    input danger,                   // Danger signal from danger_chance module
    input [2:0] robot_row,          // Current robot row position (0-7)
    input [2:0] robot_col,          // Current robot column position (0-7)
    input [2:0] danger_row,         // Danger LED row position (0-7)
    input [2:0] danger_col,         // Danger LED column position (0-7)
    output reg detection_signal     // High when robot is on danger position
);

    always @(posedge clk) begin
        if ((robot_row == danger_row) && (robot_col == danger_col) && danger) begin
            // CASE 1: Robot is on the danger position AND danger is present
            // Action: Trigger danger detection (e.g., game over, score penalty, etc.)
            detection_signal <= 1'b1;
        end
        else if ((robot_row == danger_row) && (robot_col == danger_col) && !danger) begin
            // CASE 2: Robot is on the position but NO danger is present
            // Action: Potentially safe outcome (e.g., level complete, score bonus, etc.)
            detection_signal <= 1'b0;
        end
        else begin
            // CASE 3: Robot is NOT on the danger position
            // Action: Normal navigation continues, no special events
            detection_signal <= 1'b0;
        end
    end

endmodule