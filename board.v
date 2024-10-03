`timescale 1ns / 1ps
module board (
    input clk,
    input PS2_CLK,
    input PS2_DATA,
    output VGA_HS,    //行同步和列同步信号
    output VGA_VS,
    output [3:0] VGA_R,    //红绿蓝颜色信号
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output reg [7:0] SEG,
    output reg [7:0] AN,
    output [1:0] LED            // for debug
    // output stop,             // for debug
    // output WB_nop,           // for debug
    // output [31:0] WB_pc,     // for debug
    // output WB_we,            // for debug
    // output [4:0] WB_wa,      // for debug
    // output [31:0] WB_din,    // for debug
    // output WB_mem_we,        // for debug
    // output [31:0] WB_mem_wa, // for debug
    // output [31:0] WB_mem_din // for debug
);

wire kbd_ready, kbd_read;
wire [7:0] kbd_data;
wire real_clk, vga_clk;
wire [11:0] vga_data;
wire [9:0] vga_haddr, vga_vaddr;
wire [31:0] cpu_mem_wa, cpu_mem_din, cpu_mem_data;
wire cpu_mem_we;
wire cpu_mem_read;
wire [7:0] SEG_data, AN_data;
reg [2:0] count;
reg [7:0] buffer [3:0];
assign LED[0] = kbd_ready;
assign LED[1] = kbd_read;
divider #(.N(50000))
div0(
    .clk(clk),
    .clk_n(clk_n)
);

// divider #(.N(2)) 
// vga_clk_divider(
//     .clk(real_clk),
//     .clk_n(vga_clk)
// );
// clk_wiz_0 wizard(
//     .clk_in1(clk),
//     .clk_out1(real_clk),
//     .clk_out2(vga_clk)
// );
divider #(.N(4))
div1(
    .clk(clk),
    .clk_n(real_clk)
);

divider #(.N(4))
div2(
    .clk(clk),
    .clk_n(vga_clk)
);

vga_driver vga_drive(
    .pclk(vga_clk),     //25MHz时钟
    .reset(1'b0),    //置位
    .vga_data(vga_data), //上层模块提供的VGA颜色数据
    .h_addr(vga_haddr),   //提供给上层模块的当前扫描像素点坐标
    .v_addr(vga_vaddr),
    .hsync(VGA_HS),    //行同步和列同步信号
    .vsync(VGA_VS),
    .vga_r(VGA_R),    //红绿蓝颜色信号
    .vga_g(VGA_G),
    .vga_b(VGA_B)
);
ps2_kbd kbd_drive(
    .clk(real_clk),
    .clrn(1'b1),
    .ps2_clk(PS2_CLK),
    .ps2_data(PS2_DATA),
    .read(kbd_read),
    .ready(kbd_ready),
    .data(kbd_data)
);
mmio mmio_part(
    .clk(real_clk),
    .addr(cpu_mem_wa),
    .din(cpu_mem_din),
    .kbd_ready(kbd_ready),
    .kbd_data(kbd_data),
    .vga_haddr(vga_haddr),
    .vga_vaddr(vga_vaddr),
    .kbd_read(kbd_read),
    .we(cpu_mem_we),
    .read(cpu_mem_read),
    .dout(cpu_mem_data),
    .vga_data(vga_data)
);
cpu CPU(
    .clk(real_clk),
    .mem_data(cpu_mem_data),
    .mem_we(cpu_mem_we),
    .mem_read(cpu_mem_read),
    .mem_wa(cpu_mem_wa),
    .mem_din(cpu_mem_din)
    // .stop(stop),             // for debug
    // .WB_nop(WB_nop),         // for debug
    // .WB_pc(WB_pc),           // for debug
    // .WB_we(WB_we),           // for debug
    // .WB_wa(WB_wa),           // for debug
    // .WB_din(WB_din),         // for debug
    // .WB_mem_we(WB_mem_we),   // for debug
    // .WB_mem_wa(WB_mem_wa),   // for debug
    // .WB_mem_din(WB_mem_din)  // for debug
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
always @(posedge real_clk) begin
    if(kbd_ready & kbd_read) begin
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