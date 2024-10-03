`timescale 1ns / 1ps
module ROM (
    input [LEN-1:0] addr,
    output [31:0] data
);
initial begin
    $readmemh("e:/cpu/sim/rom.hex", rom);
end
parameter LEN = 10;
localparam size = (1 << LEN) - 1;
reg [31:0] rom [size-1:0];
assign data = rom[addr];
endmodule