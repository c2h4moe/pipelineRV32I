`timescale 1ns / 1ps
module pipeline_controller (
    input ebreak,
    input [4:0] ID_rs0,
    input [4:0] ID_rs1,
    input ID_branch_type,
    input ID_jalr,
    input ID_jump,
    input [4:0] EX_rs0,
    input [4:0] EX_rs1,
    input [4:0] EX_rd,
    input EX_alusrc0,
    input EX_alusrc1,
    input EX_mem_write,
    input EX_regwrite,
    input EX_jal_or_jalr,
    input [4:0] MEM_rd,
    input MEM_mem_to_reg,
    output IF_stall,
    output ID_stall,
    output ID_clear,
    output EX_stall,
    output EX_clear,
    output MEM_stall,
    output MEM_clear,
    output WB_stall
);

wire EX_data_hazard;
assign EX_data_hazard = (~EX_alusrc0 && ~EX_jal_or_jalr && EX_rs0 != 5'b0 && EX_rs0 == MEM_rd && MEM_mem_to_reg)
                      | (~EX_alusrc1 && ~EX_jal_or_jalr && EX_rs1 != 5'b0 && EX_rs1 == MEM_rd && MEM_mem_to_reg)
                      | (EX_mem_write && EX_rs1 != 5'b0 && EX_rs1 == MEM_rd && MEM_mem_to_reg);
wire ID_data_hazard;
assign ID_data_hazard = ((ID_branch_type | ID_jalr) && ID_rs0 != 5'b0 && ID_rs0 == EX_rd && EX_regwrite)
                      | ((ID_branch_type | ID_jalr) && ID_rs0 != 5'b0 && ID_rs0 == MEM_rd && MEM_mem_to_reg)
                      | (ID_branch_type && ID_rs1 != 5'b0 && ID_rs1 == EX_rd && EX_regwrite)
                      | (ID_branch_type && ID_rs1 != 5'b0 && ID_rs1 == MEM_rd && MEM_mem_to_reg);
assign IF_stall = ebreak | EX_data_hazard | ID_data_hazard;
assign ID_stall = ebreak | EX_data_hazard | ID_data_hazard;
assign ID_clear = ~ID_stall && ID_jump;
assign EX_stall = ebreak | EX_data_hazard;
assign EX_clear = ~EX_stall && ID_data_hazard;
assign MEM_stall = ebreak;
assign MEM_clear = ~MEM_stall && EX_data_hazard;
assign WB_stall = ebreak;
endmodule