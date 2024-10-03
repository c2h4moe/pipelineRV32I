`timescale 1ns / 1ps

module cpu (
    input clk,
    input [31:0] mem_data,
    output mem_we,
    output mem_read,
    output [31:0] mem_wa,
    output [31:0] mem_din,
    output stop,             // for debug
    output WB_nop,           // for debug
    output [31:0] WB_pc,     // for debug
    output WB_we,            // for debug
    output [4:0] WB_wa,      // for debug
    output [31:0] WB_din,    // for debug
    output WB_mem_we,        // for debug
    output [31:0] WB_mem_wa, // for debug
    output [31:0] WB_mem_din // for debug
);
wire IF_stall, ID_stall, ID_clear, EX_stall, EX_clear, MEM_stall, MEM_clear, WB_stall;
wire [31:0] IF_inst, IF_pc;
wire [31:0] ID_pc, 
            ID_inst, 
            ID_jumpaddr,
            ID_reg0,
            ID_reg1,
            ID_imm;
wire [4:0] ID_rs0,
           ID_rs1,
           ID_rd,
           ID_alu_op;
wire ID_nop,
     ID_jump,
     ID_jalr,
     ID_jal_or_jalr,
     ID_branch_type,
     ID_alusrc0,
     ID_alusrc1,
     ID_reg_write,
     ID_mem_write,
     ID_mem_to_reg,
     ID_load_unsigned,
     ID_byte,
     ID_half,
     ID_ebreak;


wire [31:0] EX_res, EX_reg0, EX_reg1, EX_reg1_out, EX_imm, EX_pc;
wire [4:0] EX_rs0, EX_rs1, EX_rd, EX_alu_op;
wire EX_nop,
     EX_reg_write, 
     EX_mem_write,
     EX_mem_to_reg,
     EX_alusrc0,
     EX_alusrc1,
     EX_load_unsigned,
     EX_jal_or_jalr,
     EX_byte, 
     EX_half, 
     EX_ebreak;

wire [31:0] MEM_data, MEM_reg1, MEM_result, MEM_pc, MEM_real_din;
wire [4:0] MEM_rd;
wire MEM_nop,
     MEM_reg_write, 
     MEM_mem_write,
     MEM_mem_to_reg,
     MEM_load_unsigned,
     MEM_byte, 
     MEM_half, 
     MEM_ebreak;
wire [31:0] forward_to_ID_reg0,
            forward_to_ID_reg1,
            forward_to_EX_reg0,
            forward_to_EX_reg1;
wire forward_to_ID_sel0,
     forward_to_ID_sel1,
     forward_to_EX_sel0,
     forward_to_EX_sel1;
IF if_process(
    .clk(clk),
    .stop(IF_stall),
    .jump_addr(ID_jumpaddr),
    .jump(ID_jump),
    .inst(IF_inst),
    .pc_out(IF_pc)
);
IF_ID if_id(
    .clk(clk),
    .stop(ID_stall),
    .clr(ID_clear),
    .pc(IF_pc),
    .inst(IF_inst),
    .ir(ID_inst),
    .pc_out(ID_pc),
    .nop(ID_nop)
);
ID id_process(
    .clk(clk),
    .ir(ID_inst),
    .pc(ID_pc),
    .WB_wa(WB_wa),
    .WB_we(WB_we),
    .WB_din(WB_din),
    .forward_sel0(forward_to_ID_sel0),
    .forward_sel1(forward_to_ID_sel1),
    .forward_reg0(forward_to_ID_reg0),
    .forward_reg1(forward_to_ID_reg1),
    .branch_type(ID_branch_type),
    .jump_addr(ID_jumpaddr),
    .jump(ID_jump),
    .jalr(ID_jalr),
    .jal_or_jalr(ID_jal_or_jalr),
    .rs0(ID_rs0),
    .rs1(ID_rs1),
    .rd(ID_rd),
    .reg0(ID_reg0),
    .reg1(ID_reg1),
    .imm(ID_imm),
    .alu_src0(ID_alusrc0),
    .alu_src1(ID_alusrc1),
    .alu_op(ID_alu_op),
    .reg_write(ID_reg_write),
    .mem_write(ID_mem_write),
    .mem_to_reg(ID_mem_to_reg),
    .load_unsigned(ID_load_unsigned),
    .ls_byte(ID_byte),
    .half(ID_half),
    .ebreak(ID_ebreak)
);
ID_EX id_ex(
    .clk(clk),
    .stop(EX_stall),
    .clr(EX_clear),
    .nop(ID_nop),
    .reg0(ID_reg0),
    .reg1(ID_reg1),
    .rs0(ID_rs0),
    .rs1(ID_rs1),
    .rd(ID_rd),
    .imm(ID_imm),
    .pc(ID_pc),
    .jal_or_jalr(ID_jal_or_jalr),
    .alu_src0(ID_alusrc0),
    .alu_src1(ID_alusrc1),
    .alu_op(ID_alu_op),
    .reg_write(ID_reg_write),
    .mem_write(ID_mem_write),
    .mem_to_reg(ID_mem_to_reg),
    .load_unsigned(ID_load_unsigned),
    .ls_byte(ID_byte),
    .half(ID_half),
    .ebreak(ID_ebreak),
    .nop_out(EX_nop),
    .reg0_out(EX_reg0),
    .reg1_out(EX_reg1),
    .rs0_out(EX_rs0),
    .rs1_out(EX_rs1),
    .rd_out(EX_rd),
    .imm_out(EX_imm),
    .pc_out(EX_pc),
    .jal_or_jalr_out(EX_jal_or_jalr),
    .alu_src0_out(EX_alusrc0),
    .alu_src1_out(EX_alusrc1),
    .alu_op_out(EX_alu_op),
    .reg_write_out(EX_reg_write),
    .mem_write_out(EX_mem_write),
    .mem_to_reg_out(EX_mem_to_reg),
    .load_unsigned_out(EX_load_unsigned),
    .ls_byte_out(EX_byte),
    .half_out(EX_half),
    .ebreak_out(EX_ebreak)
);
EX ex_process(
    .reg0(EX_reg0),
    .reg1(EX_reg1),
    .imm(EX_imm),
    .jal_or_jalr(EX_jal_or_jalr),
    .pc(EX_pc),
    .alu_src0(EX_alusrc0),
    .alu_src1(EX_alusrc1),
    .alu_op(EX_alu_op),
    .forward_sel0(forward_to_EX_sel0),
    .forward_sel1(forward_to_EX_sel1),
    .forward_reg0(forward_to_EX_reg0),
    .forward_reg1(forward_to_EX_reg1),
    .res(EX_res),
    .reg1_out(EX_reg1_out)
);
EX_MEM ex_mem(
    .clk(clk),
    .stop(MEM_stall),
    .clr(MEM_clear),
    .nop(EX_nop),
    .pc(EX_pc),
    .res(EX_res),
    .reg1(EX_reg1_out),
    .rd(EX_rd),
    .reg_write(EX_reg_write),
    .mem_write(EX_mem_write),
    .mem_to_reg(EX_mem_to_reg),
    .load_unsigned(EX_load_unsigned),
    .ls_byte(EX_byte),
    .half(EX_half),
    .ebreak(EX_ebreak),
    .nop_out(MEM_nop),
    .pc_out(MEM_pc),
    .res_out(MEM_data),
    .reg1_out(MEM_reg1),
    .rd_out(MEM_rd),
    .reg_write_out(MEM_reg_write),
    .mem_write_out(MEM_mem_write),
    .mem_to_reg_out(MEM_mem_to_reg),
    .load_unsigned_out(MEM_load_unsigned),
    .ls_byte_out(MEM_byte),
    .half_out(MEM_half),
    .ebreak_out(MEM_ebreak)
);
assign mem_read = MEM_mem_to_reg & (~MEM_nop); // all zero inst's mem2reg is 1
MEM mem_process(
    .data(MEM_data),
    .reg1(MEM_reg1),
    .mem_data(mem_data),
    .mem_to_reg(MEM_mem_to_reg),
    .load_unsigned(MEM_load_unsigned),
    .ls_byte(MEM_byte),
    .half(MEM_half),
    .result(MEM_result),
    .din(MEM_real_din)
);
assign mem_din = MEM_real_din;
assign mem_wa = MEM_data;
assign mem_we = MEM_mem_write;
MEM_WB mem_wb(
    .clk(clk),
    .stop(WB_stall),
    .nop(MEM_nop),
    .pc(MEM_pc),
    .din(MEM_result),
    .mem_din(MEM_real_din),
    .mem_wa(MEM_data),
    .mem_we(MEM_mem_write),
    .reg_write(MEM_reg_write),
    .rd(MEM_rd),
    .ebreak(MEM_ebreak),
    .nop_out(WB_nop),
    .pc_out(WB_pc),
    .din_out(WB_din),
    .mem_din_out(WB_mem_din),
    .mem_wa_out(WB_mem_wa),
    .mem_we_out(WB_mem_we),
    .reg_write_out(WB_we),
    .rd_out(WB_wa),
    .ebreak_out(stop)
);
forward forward_to_ID(
    .rs0(ID_rs0),
    .rs1(ID_rs1),
    .MEM_rd(MEM_rd),
    .MEM_regwrite(MEM_reg_write),
    .WB_rd(WB_wa),
    .WB_regwrite(WB_we),
    .MEM_reg(MEM_data),
    .WB_reg(WB_din),
    .sel0(forward_to_ID_sel0),
    .sel1(forward_to_ID_sel1),
    .forward_reg0(forward_to_ID_reg0),
    .forward_reg1(forward_to_ID_reg1)
);
forward forward_to_EX(
    .rs0(EX_rs0),
    .rs1(EX_rs1),
    .MEM_rd(MEM_rd),
    .MEM_regwrite(MEM_reg_write),
    .WB_rd(WB_wa),
    .WB_regwrite(WB_we),
    .MEM_reg(MEM_data),
    .WB_reg(WB_din),
    .sel0(forward_to_EX_sel0),
    .sel1(forward_to_EX_sel1),
    .forward_reg0(forward_to_EX_reg0),
    .forward_reg1(forward_to_EX_reg1)
);
pipeline_controller pipeline_control(
    .ebreak(stop),
    .ID_rs0(ID_rs0),
    .ID_rs1(ID_rs1),
    .ID_branch_type(ID_branch_type),
    .ID_jalr(ID_jalr),
    .ID_jump(ID_jump),
    .EX_rs0(EX_rs0),
    .EX_rs1(EX_rs1),
    .EX_rd(EX_rd),
    .EX_alusrc0(EX_alusrc0),
    .EX_alusrc1(EX_alusrc1),
    .EX_mem_write(EX_mem_write),
    .EX_regwrite(EX_reg_write),
    .EX_jal_or_jalr(EX_jal_or_jalr),
    .MEM_rd(MEM_rd),
    .MEM_mem_to_reg(MEM_mem_to_reg),
    .IF_stall(IF_stall),
    .ID_stall(ID_stall),
    .ID_clear(ID_clear),
    .EX_stall(EX_stall),
    .EX_clear(EX_clear),
    .MEM_stall(MEM_stall),
    .MEM_clear(MEM_clear),
    .WB_stall(WB_stall)
);
endmodule
