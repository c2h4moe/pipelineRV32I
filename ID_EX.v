`timescale 1ns / 1ps
module ID_EX(
    input clk,
    input stop,
    input clr,
    input nop,
    input [31:0] reg0,
    input [31:0] reg1,
    input [4:0] rs0,
    input [4:0] rs1,
    input [4:0] rd,
    input [31:0] imm,
    input [31:0] pc,
    input jal_or_jalr,
    input alu_src0,
    input alu_src1,
    input [4:0] alu_op,
    input reg_write,
    input mem_write,
    input mem_to_reg,
    input load_unsigned,
    input ls_byte,
    input half,
    input ebreak,
    output reg nop_out,
    output reg [31:0] reg0_out,
    output reg [31:0] reg1_out,
    output reg [4:0] rs0_out,
    output reg [4:0] rs1_out,
    output reg [4:0] rd_out,
    output reg [31:0] imm_out,
    output reg [31:0] pc_out,
    output reg jal_or_jalr_out,
    output reg alu_src0_out,
    output reg alu_src1_out,
    output reg [4:0] alu_op_out,
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
    reg0_out = 32'b0;
    reg1_out = 32'b0;
    rs0_out = 5'b0;
    rs1_out = 5'b0;
    rd_out = 5'b0;
    imm_out = 32'b0;
    pc_out = 32'b0;
    jal_or_jalr_out = 1'b0;
    alu_src0_out = 1'b0;
    alu_src1_out = 1'b0;
    alu_op_out = 5'b0;
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
        if (clr) begin
            nop_out <= 1'b1;
            reg0_out <= 32'b0;
            reg1_out <= 32'b0;
            rs0_out <= 5'b0;
            rs1_out <= 5'b0;
            rd_out <= 5'b0;
            imm_out <= 32'b0;
            pc_out <= 32'b0;
            jal_or_jalr_out <= 1'b0;
            alu_src0_out <= 1'b0;
            alu_src1_out <= 1'b0;
            alu_op_out <= 5'b0;
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
            reg0_out <= reg0;
            reg1_out <= reg1;
            rs0_out <= rs0;
            rs1_out <= rs1;
            rd_out <= rd;
            imm_out <= imm;
            pc_out <= pc;
            jal_or_jalr_out <= jal_or_jalr;
            alu_src0_out <= alu_src0;
            alu_src1_out <= alu_src1;
            alu_op_out <= alu_op;
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
