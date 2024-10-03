`timescale 1ns / 1ps
module forward (
    input [4:0] rs0,
    input [4:0] rs1,
    input [4:0] MEM_rd,
    input MEM_regwrite,
    input [4:0] WB_rd,
    input WB_regwrite,
    input [31:0] MEM_reg,
    input [31:0] WB_reg,
    output sel0,
    output sel1,
    output [31:0] forward_reg0,
    output [31:0] forward_reg1
);
assign forward_reg0 = (rs0 == MEM_rd && MEM_regwrite) ? MEM_reg : WB_reg;
assign forward_reg1 = (rs1 == MEM_rd && MEM_regwrite) ? MEM_reg : WB_reg;
assign sel0 = (rs0 == MEM_rd && MEM_regwrite && rs0 != 5'b0 || rs0 == WB_rd && WB_regwrite && rs0 != 5'b0);
assign sel1 = (rs1 == MEM_rd && MEM_regwrite && rs1 != 5'b0 || rs1 == WB_rd && WB_regwrite && rs1 != 5'b0);
endmodule