`timescale 1ns / 1ps
module MEM_WB(
    input clk,
    input stop,
    input nop,
    input [31:0] pc,
    input [31:0] din,
    input reg_write,
    input [4:0] rd,
    input ebreak,
    input [31:0] mem_din,
    input [31:0] mem_wa,
    input mem_we,
    output reg nop_out,
    output reg [31:0] pc_out,
    output reg [31:0] din_out,
    output reg reg_write_out,
    output reg [4:0] rd_out,
    output reg ebreak_out,
    output reg [31:0] mem_din_out, // for debug
    output reg [31:0] mem_wa_out,  // for debug
    output reg mem_we_out          // for debug
);

initial begin
    nop_out = 1'b1;
    pc_out = 32'b0;
    din_out = 32'b0;
    reg_write_out = 1'b0;
    rd_out = 5'b0;
    ebreak_out = 1'b0;
    mem_din_out = 32'b0;
    mem_wa_out = 32'b0;
    mem_we_out = 1'b0;
end
always @(posedge clk) begin
    if (~stop) begin
        nop_out <= nop;
        pc_out <= pc;
        din_out <= din;
        reg_write_out <= reg_write;
        rd_out <= rd;
        ebreak_out <= ebreak;
        mem_din_out <= mem_din;
        mem_wa_out <= mem_wa;
        mem_we_out <= mem_we;
    end
end
endmodule