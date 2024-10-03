`timescale 1ns / 1ps

module shifter(
    input [31:0] src0,
    input [4:0] src1,
    output reg [31:0] sll_res,
    output reg [31:0] srl_res,
    output reg [31:0] sra_res
);
initial begin
    sll_res = 32'b0;
    srl_res = 32'b0;
    sra_res = 32'b0;
end
wire [31:0] sll_1, sll_2;
wire [31:0] srl_1, srl_2;
wire [31:0] sra_1, sra_2;
assign sll_1 = src1[4] ? {src0[15:0], {16{1'b0}}} : src0;
assign sll_2 = src1[3] ? {sll_1[23:0], {8{1'b0}}} : sll_1;
assign srl_1 = src1[4] ? {{16{1'b0}}, src0[31:16]} : src0;
assign srl_2 = src1[3] ? {{8{1'b0}}, srl_1[31:8]} : srl_1;
assign sra_1 = src1[4] ? {{16{src0[31]}}, src0[31:16]} : src0;
assign sra_2 = src1[3] ? {{8{sra_1[31]}}, sra_1[31:8]} : sra_1;
always @(*) begin
    case(src1[2:0])
        3'b000: begin
            sll_res = sll_2;
            srl_res = srl_2;
            sra_res = sra_2;
        end
        3'b001: begin
            sll_res = {sll_2[30:0], 1'b0};
            srl_res = {1'b0, srl_2[31:1]};
            sra_res = {sra_2[31], sra_2[31:1]};
        end
        3'b010: begin
            sll_res = {sll_2[29:0], {2{1'b0}}};
            srl_res = {{2{1'b0}}, srl_2[31:2]};
            sra_res = {{2{sra_2[31]}}, sra_2[31:2]};
        end
        3'b011: begin
            sll_res = {sll_2[28:0], {3{1'b0}}};
            srl_res = {{3{1'b0}}, srl_2[31:3]};
            sra_res = {{3{sra_2[31]}}, sra_2[31:3]};
        end
        3'b100: begin
            sll_res = {sll_2[27:0], {4{1'b0}}};
            srl_res = {{4{1'b0}}, srl_2[31:4]};
            sra_res = {{4{sra_2[31]}}, sra_2[31:4]};
        end
        3'b101: begin
            sll_res = {sll_2[26:0], {5{1'b0}}};
            srl_res = {{5{1'b0}}, srl_2[31:5]};
            sra_res = {{5{sra_2[31]}}, sra_2[31:5]};
        end
        3'b110: begin
            sll_res = {sll_2[25:0], {6{1'b0}}};
            srl_res = {{6{1'b0}}, srl_2[31:6]};
            sra_res = {{6{sra_2[31]}}, sra_2[31:6]};
        end
        3'b111: begin
            sll_res = {sll_2[24:0], {7{1'b0}}};
            srl_res = {{7{1'b0}}, srl_2[31:7]};
            sra_res = {{7{sra_2[31]}}, sra_2[31:7]};
        end
        default: begin
            sll_res = sll_2;
            srl_res = srl_2;
            sra_res = sra_2;
        end
    endcase
end
endmodule