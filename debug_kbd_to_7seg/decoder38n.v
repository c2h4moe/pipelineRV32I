`timescale 1ns / 1ps
module decoder38n(
    input [2:0] num,
    output reg [7:0] sel
);
always @(*) begin
    case(num)
    3'b000: sel=8'b11111110;
    3'b001: sel=8'b11111101;
    3'b010: sel=8'b11111011;
    3'b011: sel=8'b11110111;
    3'b100: sel=8'b11101111;
    3'b101: sel=8'b11011111;
    3'b110: sel=8'b10111111;
    3'b111: sel=8'b01111111;
    endcase
end
endmodule
