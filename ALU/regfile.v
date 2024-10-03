`timescale 1ns / 1ps


module regfile(
    input clk,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] wa,
    input we,
    input [31:0] din,
    output [31:0] dout1,
    output [31:0] dout2
);

reg [31:0] reg_file[31:0];
assign dout1 = reg_file[rs1];
assign dout2 = reg_file[rs2];
always @(posedge clk) begin
    if(we && (wa != 5'b0)) reg_file[wa] <= din;
end

integer i;
initial begin
    for (i = 0; i < 32; i = i + 1) begin
        reg_file[i] = 32'b0;
    end
end
endmodule
