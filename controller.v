`timescale 1ns / 1ps

`define ADD                 5'B00000    
`define SUB                 5'B00010   
`define SLT                 5'B00100
`define SLTU                5'B00101
`define AND                 5'B01001
`define OR                  5'B01010
`define XOR                 5'B01011
`define SLL                 5'B01110   
`define SRL                 5'B01111    
`define SRA                 5'B10000  
`define SRC0                5'B10001
`define SRC1                5'B10010

module controller(
    input [31:0] inst,
    output reg [4:0] alu_op,
    output reg alu_src0,
    output reg alu_src1,
    output reg reg_write,
    output reg mem_write,
    output reg mem_to_reg,
    output reg beq,
    output reg bne,
    output reg blt,
    output reg bge,
    output reg bltu,
    output reg bgeu,
    output reg U_type,
    output reg load_unsigned,
    output reg ls_byte,
    output reg half,
    output reg jal,
    output reg jalr,
    output reg ecall,
    output reg ebreak,
    output reg mret
);
// initial begin
//     alu_op = 5'b0;
//     alu_src0 = 1'b0;
//     alu_src1 = 1'b0;
//     reg_write = 1'b0;
//     mem_write = 1'b0;
//     mem_to_reg = 1'b0;
//     beq = 1'b0;
//     bne = 1'b0;
//     blt = 1'b0;
//     bge = 1'b0;
//     bltu = 1'b0;
//     bgeu = 1'b0;
//     U_type = 1'b0;
//     load_unsigned = 1'b0;
//     ls_byte = 1'b0;
//     half = 1'b0;
//     jal = 1'b0;
//     jalr = 1'b0;
//     ecall = 1'b0;
//     ebreak = 1'b0;
//     mret = 1'b0;
// end
wire [4:0] opcode;
wire [2:0] funct3;
assign opcode = inst[6:2];
assign funct3 = inst[14:12];
always @(*) begin
    case (opcode)
        5'hc: begin // R-type
            alu_src0 = 1'b0;
            alu_src1 = 1'b0;
            reg_write = 1'b1;
            mem_write = 1'b0;
            mem_to_reg = 1'b0;
            beq = 1'b0;
            bne = 1'b0;
            blt = 1'b0;
            bge = 1'b0;
            bltu = 1'b0;
            bgeu = 1'b0;
            U_type = 1'b0;
            load_unsigned = 1'b0;
            ls_byte = 1'b0;
            half = 1'b0;
            jal = 1'b0;
            jalr = 1'b0;
            ecall = 1'b0;
            mret = 1'b0;
            ebreak = 1'b0;
            case (funct3)
                3'd0:
                if (inst[30]) 
                    alu_op = `SUB;
                else
                    alu_op = `ADD;
                3'd1:
                alu_op = `SLL;
                3'd2:
                alu_op = `SLT;
                3'd3:
                alu_op = `SLTU;
                3'd4:
                alu_op = `XOR;
                3'd5:
                if(inst[30])
                    alu_op = `SRA;
                else
                    alu_op = `SRL;
                3'd6:
                alu_op = `OR;
                3'd7:
                alu_op = `AND;
            endcase
        end
        5'h4: begin // I-type-compute (not priviledge)
            alu_src0 = 1'b0;
            alu_src1 = 1'b1;
            reg_write = 1'b1;
            mem_write = 1'b0;
            mem_to_reg = 1'b0;
            beq = 1'b0;
            bne = 1'b0;
            blt = 1'b0;
            bge = 1'b0;
            bltu = 1'b0;
            bgeu = 1'b0;
            U_type = 1'b0;
            load_unsigned = 1'b0;
            ls_byte = 1'b0;
            half = 1'b0;
            jal = 1'b0;
            jalr = 1'b0;
            ecall = 1'b0;
            mret = 1'b0;
            ebreak = 1'b0;
            case (funct3)
                3'd0:
                alu_op = `ADD;
                3'd1:
                alu_op = `SLL;
                3'd2:
                alu_op = `SLT;
                3'd3:
                alu_op = `SLTU;
                3'd4:
                alu_op = `XOR;
                3'd5:
                if (inst[30])
                    alu_op = `SRA;
                else
                    alu_op = `SRL;
                3'd6:
                alu_op = `OR;
                3'd7:
                alu_op = `AND;
                default: 
                alu_op = `ADD;
            endcase
        end
        5'h0: begin // load
            alu_src0 = 1'b0;
            alu_src1 = 1'b1;
            reg_write = 1'b1;
            mem_write = 1'b0;
            mem_to_reg = 1'b1;
            beq = 1'b0;
            bne = 1'b0;
            blt = 1'b0;
            bge = 1'b0;
            bltu = 1'b0;
            bgeu = 1'b0;
            U_type = 1'b0;
            jal = 1'b0;
            jalr = 1'b0;
            ecall = 1'b0;
            mret = 1'b0;
            ebreak = 1'b0;
            alu_op = `ADD;
            case (funct3)
                3'd0: begin // lb
                    ls_byte = 1'b1;
                    half = 1'b0;
                    load_unsigned = 1'b0;
                end
                3'd1: begin // lh
                    ls_byte = 1'b0;
                    half = 1'b1;
                    load_unsigned = 1'b0;
                end
                3'd2: begin // lw
                    ls_byte = 1'b0;
                    half = 1'b0;
                    load_unsigned = 1'b0;
                end
                3'd4: begin // lbu
                    ls_byte = 1'b1;
                    half = 1'b0;
                    load_unsigned = 1'b1;
                end
                3'd5: begin // lhu
                    ls_byte = 1'b0;
                    half = 1'b1;
                    load_unsigned = 1'b1;
                end
                default: begin
                    ls_byte = 1'b0;
                    half = 1'b0;
                    load_unsigned = 1'b0;
                end
            endcase
        end
        5'h18: begin // B-type
            alu_src0 = 1'b0;
            alu_src1 = 1'b0;
            reg_write = 1'b0;
            mem_write = 1'b0;
            mem_to_reg = 1'b0;
            U_type = 1'b0;
            load_unsigned = 1'b0;
            ls_byte = 1'b0;
            half = 1'b0;
            jal = 1'b0;
            jalr = 1'b0;
            ecall = 1'b0;
            mret = 1'b0;
            ebreak = 1'b0;
            alu_op = 5'b0;
            case (funct3)
                3'd0: begin // beq
                    beq = 1'b1;
                    bne = 1'b0;
                    blt = 1'b0;
                    bge = 1'b0;
                    bltu = 1'b0;
                    bgeu = 1'b0;
                end
                3'd1: begin // bne
                    beq = 1'b0;
                    bne = 1'b1;
                    blt = 1'b0;
                    bge = 1'b0;
                    bltu = 1'b0;
                    bgeu = 1'b0;
                end
                3'd4: begin // blt
                    beq = 1'b0;
                    bne = 1'b0;
                    blt = 1'b1;
                    bge = 1'b0;
                    bltu = 1'b0;
                    bgeu = 1'b0;
                end
                3'd5: begin // bge
                    beq = 1'b0;
                    bne = 1'b0;
                    blt = 1'b0;
                    bge = 1'b1;
                    bltu = 1'b0;
                    bgeu = 1'b0;
                end
                3'd6: begin // bltu
                    beq = 1'b0;
                    bne = 1'b0;
                    blt = 1'b0;
                    bge = 1'b0;
                    bltu = 1'b1;
                    bgeu = 1'b0;
                end
                3'd7: begin // bgeu
                    beq = 1'b0;
                    bne = 1'b0;
                    blt = 1'b0;
                    bge = 1'b0;
                    bltu = 1'b0;
                    bgeu = 1'b1;
                end
                default: begin
                    beq = 1'b0;
                    bne = 1'b0;
                    blt = 1'b0;
                    bge = 1'b0;
                    bltu = 1'b0;
                    bgeu = 1'b0;
                end
            endcase
        end
        5'h8: begin // store
            alu_src0 = 1'b0;
            alu_src1 = 1'b1;
            reg_write = 1'b0;
            mem_write = 1'b1;
            mem_to_reg = 1'b0;
            beq = 1'b0;
            bne = 1'b0;
            blt = 1'b0;
            bge = 1'b0;
            bltu = 1'b0;
            bgeu = 1'b0;
            U_type = 1'b0;
            load_unsigned = 1'b0;
            jal = 1'b0;
            jalr = 1'b0;
            ecall = 1'b0;
            mret = 1'b0;
            ebreak = 1'b0;
            alu_op = `ADD;
            case (funct3)
                3'd0: begin // sb
                    ls_byte = 1'b1;
                    half = 1'b0;
                end 
                3'd1: begin // sh
                    ls_byte = 1'b0;
                    half = 1'b1;
                end 
                3'd2: begin // sw
                    ls_byte = 1'b0;
                    half = 1'b0;
                end
                default: begin
                    ls_byte = 1'b0;
                    half = 1'b0;
                end 
            endcase
        end
        5'hd: begin // lui
            alu_src0 = 1'b0;
            alu_src1 = 1'b1;
            reg_write = 1'b1;
            mem_write = 1'b0;
            mem_to_reg = 1'b0;
            beq = 1'b0;
            bne = 1'b0;
            blt = 1'b0;
            bge = 1'b0;
            bltu = 1'b0;
            bgeu = 1'b0;
            U_type = 1'b1;
            load_unsigned = 1'b0;
            ls_byte = 1'b0;
            half = 1'b0;
            jal = 1'b0;
            jalr = 1'b0;
            ecall = 1'b0;
            mret = 1'b0;
            ebreak = 1'b0;
            alu_op = `SRC1;
        end
        5'h5: begin // auipc
            alu_src0 = 1'b1;
            alu_src1 = 1'b1;
            reg_write = 1'b1;
            mem_write = 1'b0;
            mem_to_reg = 1'b0;
            beq = 1'b0;
            bne = 1'b0;
            blt = 1'b0;
            bge = 1'b0;
            bltu = 1'b0;
            bgeu = 1'b0;
            U_type = 1'b1;
            load_unsigned = 1'b0;
            ls_byte = 1'b0;
            half = 1'b0;
            jal = 1'b0;
            jalr = 1'b0;
            ecall = 1'b0;
            mret = 1'b0;
            ebreak = 1'b0;
            alu_op = `ADD;
        end
        5'h1b: begin // jal
            alu_src0 = 1'b0;
            alu_src1 = 1'b0;
            reg_write = 1'b1;
            mem_write = 1'b0;
            mem_to_reg = 1'b0;
            beq = 1'b0;
            bne = 1'b0;
            blt = 1'b0;
            bge = 1'b0;
            bltu = 1'b0;
            bgeu = 1'b0;
            U_type = 1'b0;
            load_unsigned = 1'b0;
            ls_byte = 1'b0;
            half = 1'b0;
            jal = 1'b1;
            jalr = 1'b0;
            ecall = 1'b0;
            mret = 1'b0;
            ebreak = 1'b0;
            alu_op = 5'b0;
        end
        5'h19: begin // jalr
            alu_src0 = 1'b0;
            alu_src1 = 1'b0;
            reg_write = 1'b1;
            mem_write = 1'b0;
            mem_to_reg = 1'b0;
            beq = 1'b0;
            bne = 1'b0;
            blt = 1'b0;
            bge = 1'b0;
            bltu = 1'b0;
            bgeu = 1'b0;
            U_type = 1'b0;
            load_unsigned = 1'b0;
            ls_byte = 1'b0;
            half = 1'b0;
            jal = 1'b0;
            jalr = 1'b1;
            ecall = 1'b0;
            mret = 1'b0;
            ebreak = 1'b0;
            alu_op = 5'b0;
        end
        5'h1c: begin // priviledge instructions
            alu_src0 = 1'b0;
            alu_src1 = 1'b0;
            reg_write = 1'b0;
            mem_write = 1'b0;
            mem_to_reg = 1'b0;
            beq = 1'b0;
            bne = 1'b0;
            blt = 1'b0;
            bge = 1'b0;
            bltu = 1'b0;
            bgeu = 1'b0;
            U_type = 1'b0;
            load_unsigned = 1'b0;
            ls_byte = 1'b0;
            half = 1'b0;
            jal = 1'b0;
            jalr = 1'b1;
            alu_op = 5'b0;
            if (funct3 == 3'b0) begin
                case ({inst[28], inst[21], inst[20]})
                    3'b0: begin // ecall
                        ecall = 1'b1;
                        ebreak = 1'b0;
                        mret = 1'b0;
                    end
                    3'b001: begin // ebreak
                        ecall = 1'b0;
                        ebreak = 1'b1;
                        mret = 1'b0;
                    end
                    3'b110: begin // mret
                        ecall = 1'b0;
                        ebreak = 1'b0;
                        mret = 1'b1;
                    end
                    default: begin
                        ecall = 1'b0;
                        ebreak = 1'b0;
                        mret = 1'b0;
                    end
                endcase
            end
            else begin
                ecall = 1'b0;
                ebreak = 1'b0;
                mret = 1'b0;
            end
        end
        default: begin
            alu_src0 = 1'b0;
            alu_src1 = 1'b0;
            reg_write = 1'b0;
            mem_write = 1'b0;
            mem_to_reg = 1'b0;
            beq = 1'b0;
            bne = 1'b0;
            blt = 1'b0;
            bge = 1'b0;
            bltu = 1'b0;
            bgeu = 1'b0;
            U_type = 1'b0;
            load_unsigned = 1'b0;
            ls_byte = 1'b0;
            half = 1'b0;
            jal = 1'b0;
            jalr = 1'b0;
            ecall = 1'b0;
            mret = 1'b0;
            ebreak = 1'b0;
            alu_op = 5'b0;
        end
    endcase
end
// alu_src0 = !(opcode == 5'h05); // not auipc
// alu_src1 = (opcode == 5'h4) // I-type-compute
//          | (opcode == )
// reg_write = 1'b0;
// mem_write = 1'b0;
// mem_to_reg = 1'b0;
// beq = 1'b0;
// bne = 1'b0;
// blt = 1'b0;
// bge = 1'b0;
// bltu = 1'b0;
// bgeu = 1'b0;
// U_type = 1'b0;
// load_unsigned = 1'b0;
// ls_byte = 1'b0;
// half = 1'b0;
// jal = 1'b0;
// jalr = 1'b0;
// ecall = 1'b0;
// mret = 1'b0;
// ebreak = 1'b0;
// alu_op = 5'b0;
endmodule
