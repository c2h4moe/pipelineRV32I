`timescale 1ns / 1ps
module EX_MEM(
    input clk,
    input stop,
    input clr,
    input nop,
    input [31:0] pc,
    input [31:0] res,
    input [31:0] reg1,
    input [4:0] rd,
    input reg_write,
    input mem_write,
    input mem_to_reg,
    input load_unsigned,
    input ls_byte,
    input half,
    input ebreak,
    output reg nop_out,
    output reg [31:0] pc_out,
    output reg [31:0] res_out,
    output reg [31:0] reg1_out,
    output reg [4:0] rd_out,
    output reg reg_write_out,
    output reg mem_write_out,
    output reg mem_to_reg_out,
    output reg load_unsigned_out,
    output reg ls_byte_out,
    output reg half_out,
    output reg ebreak_out
);
initial begin
    nop_out = 1'b1;
    pc_out = 32'b0;
    res_out = 32'b0;
    reg1_out = 32'b0;
    rd_out = 5'b0;
    reg_write_out = 1'b0;
    mem_write_out = 1'b0;
    mem_to_reg_out = 1'b0;
    load_unsigned_out = 1'b0;
    ls_byte_out = 1'b0;
    half_out = 1'b0;
    ebreak_out = 1'b0;
end
always @(posedge clk) begin
    if (~stop) begin
        if(clr) begin
            nop_out <= 1'b1;
            pc_out <= 32'b0;
            res_out <= 32'b0;
            reg1_out <= 32'b0;
            rd_out <= 5'b0;
            reg_write_out <= 1'b0;
            mem_write_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
            load_unsigned_out <= 1'b0;
            ls_byte_out <= 1'b0;
            half_out <= 1'b0;
            ebreak_out <= 1'b0;
        end
        else begin
            nop_out <= nop;
            pc_out <= pc;
            res_out <= res;
            reg1_out <= reg1;
            rd_out <= rd;
            reg_write_out <= reg_write;
            mem_write_out <= mem_write;
            mem_to_reg_out <= mem_to_reg;
            load_unsigned_out <= load_unsigned;
            ls_byte_out <= ls_byte;
            half_out <= half;
            ebreak_out <= ebreak;
        end
    end
end
endmodule