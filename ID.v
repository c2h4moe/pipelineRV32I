`timescale 1ns / 1ps

module ID(
    input clk,
    input [31:0] ir,
    input [31:0] pc,
    input [4:0] WB_wa,
    input WB_we,
    input [31:0] WB_din,
    input forward_sel0,
    input forward_sel1,
    input [31:0] forward_reg0,
    input [31:0] forward_reg1,
    output branch_type,
    output [31:0] jump_addr,
    output jump,
    output jalr,
    output jal_or_jalr,
    output [4:0] rs0,
    output [4:0] rs1,
    output [4:0] rd,
    output [31:0] reg0,
    output [31:0] reg1,
    output [31:0] imm,
    output alu_src0,
    output alu_src1,
    output [4:0] alu_op,
    output reg_write,
    output mem_write,
    output mem_to_reg,
    output load_unsigned,
    output ls_byte,
    output half,
    output ebreak
);
wire beq;
wire bne;
wire blt;
wire bge;
wire bltu;
wire bgeu;
wire U_type;
wire jal;
wire ecall;
wire mret;
controller control(
    .inst(ir),
    .alu_op(alu_op),
    .alu_src0(alu_src0),
    .alu_src1(alu_src1),
    .reg_write(reg_write),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),
    .beq(beq),
    .bne(bne),
    .blt(blt),
    .bge(bge),
    .bltu(bltu),
    .bgeu(bgeu),
    .U_type(U_type),
    .load_unsigned(load_unsigned),
    .ls_byte(ls_byte),
    .half(half),
    .jal(jal),
    .jalr(jalr),
    .ecall(ecall),
    .ebreak(ebreak),
    .mret(mret)
);

assign rs0 = ir[19:15];
assign rs1 = ir[24:20];
assign rd = ir[11:7];
wire [31:0] rf_reg0, rf_reg1;
regfile reg_file(
    .clk(clk),
    .rs1(rs0),
    .rs2(rs1),
    .wa(WB_wa),
    .we(WB_we),
    .din(WB_din),
    .dout1(rf_reg0),
    .dout2(rf_reg1)
);
wire [31:0] real_reg0, real_reg1;
assign real_reg0 = forward_sel0 ? forward_reg0 : rf_reg0;
assign real_reg1 = forward_sel1 ? forward_reg1 : rf_reg1;
assign reg0 = real_reg0;
assign reg1 = real_reg1;
wire sl, ul, eq;
wire [31:0] I_imm, B_imm, S_imm, J_imm, U_imm;
immgen immgenerate(
    .inst(ir),
    .I_imm(I_imm),
    .B_imm(B_imm),
    .S_imm(S_imm),
    .J_imm(J_imm),
    .U_imm(U_imm)
);
comp comparer(
    .a(real_reg0),
    .b(real_reg1),
    .sl(sl),
    .ul(ul),
    .eq(eq)
);
assign jump = (beq & eq)
            | (bne & ~eq)
            | (blt & sl)
            | (bltu & ul)
            | (bge & ~sl)
            | (bgeu & ~ul)
            | jal
            | jalr;
wire [31:0] branch_addr, jal_addr, jalr_addr;
adder32 adder_for_branchaddr(
    .a(pc),
    .b(B_imm),
    .ci(1'b0),
    .s(branch_addr),
    .co()
);
adder32 adder_for_jaladdr(
    .a(pc),
    .b(J_imm),
    .ci(1'b0),
    .s(jal_addr),
    .co()
);
adder32 adder_for_jalraddr(
    .a(real_reg0),
    .b(I_imm),
    .ci(1'b0),
    .s(jalr_addr),
    .co()
);
assign jal_or_jalr = jal | jalr;
assign branch_type = beq | bne | blt | bltu | bge | bgeu;
assign jump_addr = branch_type ? branch_addr :
                   jal ? jal_addr :
                   jalr ? jalr_addr : branch_addr;
assign imm = U_type ? U_imm :
             branch_type ? B_imm :
             mem_write ? S_imm :
             jal ? J_imm :
             I_imm;
endmodule