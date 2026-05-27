module lfsr_6bit (
    input  wire clk,
    input  wire rst,
    output wire [5:0] out
);
    reg [5:0] lfsr;

    always @(posedge clk or posedge rst) begin
        if (rst)
            lfsr <= 6'b000001;
        else if (lfsr == 6'b000000)
            lfsr <= 6'b000001;
        else
            lfsr <= {lfsr[4:0], lfsr[5] ^ lfsr[4]}; // taps for x^6 + x^5 + 1
    end
	 
	 assign out = lfsr;
endmodule