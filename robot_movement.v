module robot_detection_system (
    input  wire        clk,
    input  wire        reset,
    input  wire [3:0]  buttons,
    input  wire [2:0]  user_input,
    output wire [7:0]  led_row,
    output wire [7:0]  led_col,
    output wire [6:0]  seg_display,
    output reg         led_flash
);
    // Mode flags
    wire check_danger   = (user_input == 3'b110);
    wire detect_mode    = (user_input == 3'b111);
    wire field_check    = (user_input == 3'b101);

    // Position regs
    reg [2:0] robot_row, robot_col;
    reg [3:0] movement_status;
    reg        danger_mode;
    reg        position_checked;
    reg        out_of_bounds;
    reg        field_check_mode;
    reg [3:0]  display_code;

    // Debounce/edge-detect
    reg [3:0] buttons_prev;
    reg [2:0] user_input_prev;
    wire [3:0] button_pressed;
    wire       user_input_changed;

    // Pseudo-random / danger
    wire [5:0] lfsr_out;
    wire       danger_present;
    wire       danger_detected;
    reg  [5:0] refresh_counter;
    wire       refresh_danger;
	 
	 assign button_pressed     = buttons & ~buttons_prev;
    assign user_input_changed = (user_input != user_input_prev);
    assign refresh_danger     = (refresh_counter == 6'h3F);

    // Inc refresh & store prev inputs
    always @(posedge clk) begin
        buttons_prev <= buttons;
        user_input_prev <= user_input;
        refresh_counter <= reset ? 6'd0 : (refresh_counter + 1);
    end

    // Movement & modes
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            robot_row         <= 3'd0;
            robot_col         <= 3'd0;
            movement_status   <= 4'h0;
            danger_mode       <= 1'b0;
            position_checked  <= 1'b0;
            out_of_bounds     <= 1'b0;
            field_check_mode  <= 1'b0;
            led_flash         <= 1'b0;
        end else begin
            movement_status  <= 4'h0;
            out_of_bounds    <= 1'b0;

            // Field-check latches until mode change
            if (field_check && user_input_changed)
                field_check_mode <= 1'b1;
            // Clear if switching to detect
            if (detect_mode && user_input_changed)
                field_check_mode <= 1'b0;

            // Danger mode enter
            if (detect_mode && user_input_changed) begin
                danger_mode <= 1'b1;
                position_checked <= 1'b0;
            end
            // Check danger
            if (check_danger && user_input_changed && danger_mode)
                position_checked <= 1'b1;

            // Movement
            if (!danger_mode || (danger_mode && position_checked)) begin
                if (button_pressed[3]) begin // Up
                    if (robot_row == 0) begin out_of_bounds <= 1; led_flash <= ~led_flash; end
                    else begin robot_row <= robot_row - 1; movement_status <= 4'h1; end
                end else if (button_pressed[2]) begin // Down
                    if (robot_row == 7) begin out_of_bounds <= 1; led_flash <= ~led_flash; end
                    else begin robot_row <= robot_row + 1; movement_status <= 4'h2; end
                end else if (button_pressed[1]) begin // Left
                    if (robot_col == 0) begin out_of_bounds <= 1; led_flash <= ~led_flash; end
                    else begin robot_col <= robot_col - 1; movement_status <= 4'h3; end
                end else if (button_pressed[0]) begin // Right
                    if (robot_col == 7) begin out_of_bounds <= 1; led_flash <= ~led_flash; end
                    else begin robot_col <= robot_col + 1; movement_status <= 4'h4; end
                end
                if (position_checked && button_pressed != 4'b0000) begin
                    danger_mode <= 1'b0;
                    position_checked <= 1'b0;
                end
            end
        end
    end

    // Registered display code to avoid glitches
    always @(posedge clk or posedge reset) begin
        if (reset)
            display_code <= 4'h0;
        else if (out_of_bounds)
            display_code <= 4'hE;
        else if (field_check_mode)
            display_code <= 4'hF;
        else if (danger_mode && position_checked)
            display_code <= danger_detected ? 4'hD : 4'hC;
        else
            display_code <= movement_status;
    end

    // Instantiate submodules
    lfsr_6bit        u_lfsr  (.clk(clk), .rst(reset), .out(lfsr_out));
    danger_chance    u_d_ch  (.clk(clk), .rst(reset), .danger(danger_present));
    led_8x8          u_led   (.clk(clk), .rst(reset), .load(refresh_danger), .lfsr_in(lfsr_out), .row(led_row), .col(led_col));
    danger_detection u_det   (.clk(clk), .danger(danger_present), .robot_row(robot_row), .robot_col(robot_col), .danger_row(lfsr_out[5:3]), .danger_col(lfsr_out[2:0]), .detection_signal(danger_detected));
    seg7             u_seg7  (.hex(display_code), .leds(seg_display));
endmodule