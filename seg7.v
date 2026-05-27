module seg7 (
    input  wire [3:0] hex,
    output reg  [6:0] leds
);
    always @(*) begin
        case (hex)
            4'h0: leds = 7'b1111110; // 0
            4'h1: leds = 7'b0110000; // 1
            4'h2: leds = 7'b1101101; // 2
            4'h3: leds = 7'b1111001; // 3
            4'h4: leds = 7'b0110011; // 4 (custom)
            4'hC: leds = 7'b1001110; // c
            4'hD: leds = 7'b1011110; // d
            4'hE: leds = 7'b1001111; // E
            4'hF: leds = 7'b1000111; // F
            default: leds = 7'b0000000; // blank
        endcase
    end
endmodule