`timescale 1ns / 1ps
module IF_ID(
    input clk,
    input stop,
    input clr,
    input [31:0] pc,
    input [31:0] inst,
    output reg [31:0] ir,
    output reg [31:0] pc_out,
    output reg nop
);
initial begin
    ir = 32'b0;
    pc_out = 32'b0;
    nop = 1'b1;
end
always @(posedge clk) begin
    if (~stop) begin
        if (clr) begin
            ir <= 32'b0;
            pc_out <= 32'b0;
            nop <= 1'b1;
        end
        else begin
            ir <= inst;
            pc_out <= pc;
            nop <= 1'b0;
        end
    end
end
endmodule