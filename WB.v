`timescale 1ns / 1ps

module WB(
    input [31:0] din,
    input [4:0] rd,
    input reg_write,
    input ebreak,
    output [31:0] dout,
    output [4:0] rd_out,
    output reg_write_out,
    output ebreak_out
);
assign dout = din;
assign rd_out = rd;
assign reg_write_out = reg_write;
assign ebreak_out = ebreak;

endmodule
