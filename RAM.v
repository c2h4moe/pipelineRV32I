`timescale 1ns / 1ps
module RAM #(
    parameter LEN = 10,
    parameter WIDTH = 32
)(
    input clk,
    input we,
    input [LEN-1:0] w_addr,
    input [LEN-1:0] r_addr,
    input [WIDTH-1:0] din,
    output [WIDTH-1:0] w_data,
    output [WIDTH-1:0] r_data
);
localparam size = (1 << LEN);

reg [WIDTH-1:0] ram [size-1:0];
always @(posedge clk) begin
    if(we) ram[w_addr] <= din;
end
assign w_data = ram[w_addr];
assign r_data = ram[r_addr];

integer i;
initial begin
    for (i = 0; i < size; i = i + 1) begin
        ram[i] = 0;
    end
end
endmodule