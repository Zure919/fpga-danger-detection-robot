module danger_chance (
    input  wire clk,
    input  wire rst,
    output reg  danger
);
    reg [3:0] prng;

    // Reset to non-zero seed
    always @(posedge clk or posedge rst) begin
        if (rst)
            prng <= 4'b0001;
        else if (prng == 4'b0000)
            prng <= 4'b0001;
        else
            prng <= {prng[2:0], prng[3] ^ prng[0]}; // taps for x^4 + x + 1
    end

    // ~30% chance of danger
    always @(posedge clk) begin
        danger <= (prng <= 4'd4);
    end
endmodule