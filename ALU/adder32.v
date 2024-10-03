`timescale 1ns / 1ps

module adder32(
    input [31:0] a,
    input [31:0] b,
    input ci,
    output [31:0] s,
    output co
);
wire [31:0] G;
wire [31:0] P;
assign G = a & b;
assign P = a ^ b;
wire [31:0] c;
wire [7:0] ccl;
wire [7:0] Gstar;
wire [7:0] Pstar;
wire [1:0] Gstar1;
wire [1:0] Pstar1;
carry_lookahead4 cl0(P[3:0], G[3:0], ci, c[3:0], Gstar[0], Pstar[0]);
carry_lookahead4 cl1(P[7:4], G[7:4], ccl[0], c[7:4], Gstar[1], Pstar[1]);
carry_lookahead4 cl2(P[11:8], G[11:8], ccl[1], c[11:8], Gstar[2], Pstar[2]);
carry_lookahead4 cl3(P[15:12], G[15:12], ccl[2], c[15:12], Gstar[3], Pstar[3]);
carry_lookahead4 cl4(P[19:16], G[19:16], ccl[3], c[19:16], Gstar[4], Pstar[4]);
carry_lookahead4 cl5(P[23:20], G[23:20], ccl[4], c[23:20], Gstar[5], Pstar[5]);
carry_lookahead4 cl6(P[27:24], G[27:24], ccl[5], c[27:24], Gstar[6], Pstar[6]);
carry_lookahead4 cl7(P[31:28], G[31:28], ccl[6], c[31:28], Gstar[7], Pstar[7]);
carry_lookahead4 cl00(.p(Pstar[3:0]), .g(Gstar[3:0]), .ci(ci), .c(ccl[3:0]), .Gstar(), .Pstar());
carry_lookahead4 cl01(.p(Pstar[7:4]), .g(Gstar[7:4]), .ci(ccl[3]), .c(ccl[7:4]), .Gstar(), .Pstar());
assign s = P ^ {c[30:0], ci};
assign co = c[31];
endmodule
