`timescale 1ns / 1ps
module kbd_to_7seg (
    input clk,
    input PS2_CLK,
    input PS2_DATA,
    output reg [7:0] SEG,
    output reg [7:0] AN
);
reg [2:0] count;
reg [7:0] buffer [3:0];
wire kbd_ready;
wire [7:0] kbd_data;
wire [7:0] AN_data, SEG_data;
wire clk_n;
divider #(.N(50000))
div(
    .clk(clk),
    .clk_n(clk_n)
);
ps2_kbd kbd_drive(
    .clk(clk),
    .clrn(1'b1),
    .ps2_clk(PS2_CLK),
    .ps2_data(PS2_DATA),
    .read(1'b1),
    .ready(kbd_ready),
    .data(kbd_data),
    .overflow()
);
wire [3:0] code = (count[0] == 1'b1 ? buffer[count[2:1]][7:4] : buffer[count[2:1]][3:0]);
num_to_7seg pat(
    .code(code),
    .patt(SEG_data)
);
decoder38n decode(
    .num(count),
    .sel(AN_data)
);
always @(posedge clk) begin
    if(kbd_ready) begin
        buffer[0] <= kbd_data;
        buffer[1] <= buffer[0];
        buffer[2] <= buffer[1];
        buffer[3] <= buffer[2];
    end
end
always @(posedge clk_n) begin
    count <= count + 3'b1;
    AN <= AN_data;
    SEG <= SEG_data;
end

integer i;
initial begin
    count = 3'b0;
    for (i = 0; i < 4; i = i + 1) begin
        buffer[i] = 8'b0;
    end
    AN = 8'b1;
    SEG = 8'b0;
end

endmodule
