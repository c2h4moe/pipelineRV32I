`timescale 1ns / 1ps

module addsub32(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] s,
    output ov
);
wire [31:0] real_b;
assign real_b = b ^ {32{sub}};
adder32 adder(.a(a), .b(real_b), .ci(sub), .s(s), .co());
assign ov = sub ? ((a[31] ^ b[31]) & ~(b[31] ^ s[31]))
                : (~(a[31] ^ b[31]) & (b[31] ^ s[31]));
endmodule