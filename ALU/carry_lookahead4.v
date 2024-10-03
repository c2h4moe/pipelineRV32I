`timescale 1ns / 1ps

module carry_lookahead4(
    input [3:0] p,
    input [3:0] g,
    input ci,
    output [3:0] c,
    output Gstar,
    output Pstar
);
assign c[0] = g[0] | (p[0] & ci);
assign c[1] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & ci);
assign c[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & ci);
assign c[3] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & ci);
assign Gstar = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
assign Pstar = p[3] & p[2] & p[1] & p[0];
endmodule
