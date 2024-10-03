`timescale 1ns / 1ps
module IF(
    input clk,
    input stop,
    input [31:0] jump_addr,
    input jump,
    output [31:0] inst,
    output [31:0] pc_out
);
reg [31:0] pc;
wire [31:0] pc_add_4, next_addr;
assign pc_out = pc;
adder32 pcadder(
    .a(pc),
    .b(32'd4),
    .ci(1'b0),
    .s(pc_add_4),
    .co()
);
assign next_addr = jump ? jump_addr : pc_add_4;
always @(posedge clk) begin
    if (~stop) begin
        pc <= next_addr;
    end
end
pc_rom rom (
  .a(pc[11:2]),      // input wire [9 : 0] a
  .spo(inst)  // output wire [31 : 0] spo
);
initial begin
    pc = 32'h8000000;
end
endmodule
