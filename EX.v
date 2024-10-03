`timescale 1ns / 1ps

module EX(
    input [31:0] reg0,
    input [31:0] reg1,
    input [31:0] imm,
    input jal_or_jalr,
    input [31:0] pc,
    input alu_src0,
    input alu_src1,
    input [4:0] alu_op,
    input forward_sel0,
    input forward_sel1,
    input [31:0] forward_reg0,
    input [31:0] forward_reg1,
    output [31:0] res,
    output [31:0] reg1_out
);
wire [31:0] real_src0, real_src1, alu_res;
assign real_src0 = alu_src0 ? pc : // for auipc
                   forward_sel0 ? forward_reg0 :
                   reg0;
assign real_src1 = alu_src1 ? imm :
                   forward_sel1 ? forward_reg1 :
                   reg1;
assign reg1_out = forward_sel1 ? forward_reg1 : reg1;
alu ALU(
    .alu_src0(real_src0),
    .alu_src1(real_src1),
    .alu_op(alu_op),
    .alu_res(alu_res)
);
wire [31:0] next_pc;
adder32 adder_for_next_pc(
    .a(pc),
    .b(32'd4),
    .ci(1'b0),
    .s(next_pc),
    .co()
);
assign res = jal_or_jalr ? next_pc : alu_res;

endmodule
