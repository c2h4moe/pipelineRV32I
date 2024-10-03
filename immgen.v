`timescale 1ns / 1ps

module immgen(
    input [31:0] inst,
    output [31:0] I_imm,
    output [31:0] B_imm,
    output [31:0] S_imm,
    output [31:0] J_imm,
    output [31:0] U_imm
);
assign I_imm = {{20{inst[31]}}, inst[31:20]};
assign B_imm = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
assign S_imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
assign J_imm = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0};
assign U_imm = {inst[31:12], 12'b0};
endmodule
