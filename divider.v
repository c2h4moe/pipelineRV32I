`timescale 1ns / 1ps
module divider #(
    parameter N = 2
) (
    input clk,
    output reg clk_n
);
reg [31:0] counter;
always @(posedge clk) begin
    if (counter == N / 2) begin
        counter <= 32'b1;
        clk_n <= ~clk_n;
    end
    else begin
        counter <= counter + 32'b1;
    end
end
initial begin
    counter = 32'b0;
    clk_n = 1'b0;
end
endmodule