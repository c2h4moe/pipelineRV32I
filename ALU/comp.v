`timescale 1ns / 1ps

module comp(
    input [31:0] a,
    input [31:0] b,
    output sl,
    output ul,
    output eq
);
wire uge,ov;
wire [31:0] res;
adder32 adder(.a(a),
              .b(b ^ {32{1'b1}}),
              .ci(1'b1),
              .s(),
              .co(uge));
assign ul = ~uge;
addsub32 sub(.a(a),
             .b(b),
             .sub(1'b1),
             .s(res),
             .ov(ov));
assign sl = (res[31] & (~ov)) | ((~res[31]) & ov);
assign eq = ~|res;
endmodule