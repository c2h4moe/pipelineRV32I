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

module alu(
    input [31:0] alu_src0,
    input [31:0] alu_src1,
    input [4:0] alu_op,
    output reg [31:0] alu_res
);
initial begin
    alu_res = 32'b0;
end
wire [31:0] add_res, sub_res, slt_res, sltu_res, sll_res, srl_res, sra_res;
adder32 adder(.a(alu_src0),
              .b(alu_src1),
              .ci(1'b0),
              .s(add_res),
              .co());
addsub32 sub(.a(alu_src0),
             .b(alu_src1),
             .sub(1'b1),
             .s(sub_res),
             .ov());
wire sl,ul;
comp compare(.a(alu_src0),
             .b(alu_src1),
             .sl(sl),
             .ul(ul),
             .eq());
assign slt_res = {31'b0, sl};
assign sltu_res = {31'b0, ul};
shifter shift(.src0(alu_src0),
              .src1(alu_src1[4:0]),
              .sll_res(sll_res),
              .srl_res(srl_res),
              .sra_res(sra_res));
always @(*) begin
    case(alu_op)
        `ADD: alu_res = add_res;
        `SUB: alu_res = sub_res;
        `SLT: alu_res = slt_res;
        `SLTU: alu_res = sltu_res;
        `SLL: alu_res = sll_res;
        `SRL: alu_res = srl_res;
        `SRA: alu_res = sra_res;
        `AND: alu_res = alu_src0 & alu_src1;
        `OR: alu_res = alu_src0 | alu_src1;
        `XOR: alu_res = alu_src0 ^ alu_src1;
        `SRC0: alu_res = alu_src0;
        `SRC1: alu_res = alu_src1;
        default: alu_res = add_res;
    endcase
end

endmodule