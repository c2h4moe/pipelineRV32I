`timescale 1ns / 1ps
module kbd_to_7seg (
    input clk,
    inout PS2_CLK,
    inout PS2_DATA,
    output reg [7:0] SEG,
    output reg [7:0] AN,
    output [5:0] LED
);
reg [2:0] count;
reg [7:0] buffer [3:0];
wire kbd_ready;
wire [7:0] kbd_data;
wire [7:0] AN_data, SEG_data;
wire clk_n;
reg kbd_command;
reg [4:0] com_cnt;
reg [31:0] clk_lut;
reg [31:0] dat_lut;
wire ps_clk_n;
reg ps2clkout;
reg ps2datout;
reg [11:0] cntdown;
divider #(.N(2000))
divforps2(
    .clk(clk),
    .clk_n(ps_clk_n)
);
initial begin
    clk_lut = 32'b00000000010101010101010101010100;
    dat_lut = 32'b11111110000111111111111111111110;
    kbd_command = 1'b1;
    com_cnt = 5'b0;
    ps2clkout = 1'b1;
    ps2datout = 1'b1;
    cntdown = 12'b0;
end

always @(posedge ps_clk_n) begin
    if(~(&cntdown)) begin
        cntdown <= cntdown + 12'b1;
    end
    if(kbd_command && (&cntdown)) begin
        if(com_cnt == 5'd31) begin
            ps2clkout <= 1'b1;
            ps2datout <= 1'b1;
            kbd_command <= 1'b0;
        end
        else begin
            ps2clkout <= clk_lut[com_cnt];
            ps2datout <= dat_lut[com_cnt];
        end
        com_cnt <= com_cnt + 5'b1;
    end
end
assign PS2_CLK = kbd_command ? ps2clkout : 1'bz;
assign PS2_DATA = kbd_command ? ps2datout : 1'bz;
divider #(.N(50000))
div(
    .clk(clk),
    .clk_n(clk_n)
);
ps2_kbd kbd_drive(
    .clk(clk),
    .ps2_clk(kbd_command ? 1'b1 : PS2_CLK),
    .ps2_data(kbd_command ? 1'b1 : PS2_DATA),
    .read(1'b1),
    .ready(kbd_ready),
    .data(kbd_data),
    .overflow()
    // .r_ptr_out(LED[5:3]),
    // .w_ptr_out(LED[2:0])
);
// kbd_drive2 drive(
//     .clk(clk),
//     .kclk(PS2_CLK),
//     .kdata(PS2_DATA),
//     .keycodeout(kbd_data),
//     .kbd_ready(kbd_ready)
// );
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
