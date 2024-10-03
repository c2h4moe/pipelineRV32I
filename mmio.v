`timescale 1ns / 1ps
module mmio (
    input clk,
    input [31:0] addr,
    input [31:0] din,
    input kbd_ready,
    input [7:0] kbd_data,
    input [9:0] vga_haddr,
    input [9:0] vga_vaddr,
    input read,
    input we,
    output kbd_read,
    output [31:0] dout,
    output [11:0] vga_data
);

wire ram_space = (addr[31:20] == 12'd0);
wire vram_chrspace = (addr[31:20] == 12'd1);
wire baselinectl_space = (addr[31:20] == 12'd2);
wire vram_guispace = (addr[31:20] == 12'd3);
wire graphicctl_space = (addr[31:20] == 12'd4);
wire kbd_space = (addr[31:20] == 12'hbad);
assign kbd_read = kbd_space & read;
reg [4:0] tty_scan_baseline;
wire [4:0] tty_scan_line = (vga_vaddr[8:4] + tty_scan_baseline >= 30) ? 
                           (vga_vaddr[8:4] + tty_scan_baseline - 30) :
                           (vga_vaddr[8:4] + tty_scan_baseline);
wire [9:0] vga_char_addr = {tty_scan_line, 5'b0} | vga_haddr[9:5];
wire [11:0] vga_gui_addr = {vga_vaddr[8:3], 6'b0} | vga_haddr[9:4];
wire [31:0] ram_data, vram_chrdata, vram_chrdout, vram_guidout;
wire [7:0] vram_gui_rdout, vram_gui_gdout, vram_gui_bdout;
wire [7:0] vram_gui_rdata, vram_gui_gdata, vram_gui_bdata;
wire [7:0] vram_ascii;
wire [127:0] shape;
reg gui_or_tty;
always @(posedge clk) begin
    if (graphicctl_space & we) begin
        gui_or_tty <= din[0];
    end
    if(baselinectl_space & we) begin
        tty_scan_baseline <= din[4:0];
    end
end
data_ram ram(
    .clk(clk),
    .we(ram_space & we),
    .a(addr[11:2]),
    .d(din),
    .spo(ram_data)
);
// RAM #(.LEN(10)) 
// ram(
//     .clk(clk),
//     .we(ram_space & we),
//     .w_addr(addr),
//     .r_addr(addr),
//     .din(din),
//     .data(ram_data)
// );

RAM #(.LEN(10))
vram_char(
    .clk(clk),
    .we(vram_chrspace & we),
    .w_addr(addr[11:2]),
    .r_addr(vga_char_addr),
    .din(din),
    .w_data(vram_chrdout),
    .r_data(vram_chrdata)
);

RAM #(.LEN(12), .WIDTH(8))
vram_gui_r(
    .clk(clk),
    .we(vram_guispace & we),
    .w_addr(addr[13:2]),
    .r_addr(vga_gui_addr),
    .din({din[27:24], din[11:8]}),
    .w_data(vram_gui_rdout),
    .r_data(vram_gui_rdata)
);

RAM #(.LEN(12), .WIDTH(8))
vram_gui_g(
    .clk(clk),
    .we(vram_guispace & we),
    .w_addr(addr[13:2]),
    .r_addr(vga_gui_addr),
    .din({din[23:20], din[7:4]}),
    .w_data(vram_gui_gdout),
    .r_data(vram_gui_gdata)
);

RAM #(.LEN(12), .WIDTH(8))
vram_gui_b(
    .clk(clk),
    .we(vram_guispace & we),
    .w_addr(addr[13:2]),
    .r_addr(vga_gui_addr),
    .din({din[19:16], din[3:0]}),
    .w_data(vram_gui_bdout),
    .r_data(vram_gui_bdata)
);

assign vram_guidout = {4'b0, vram_gui_rdout[7:4], vram_gui_gdout[7:4], vram_gui_bdout[7:4], 
                       4'b0, vram_gui_rdout[3:0], vram_gui_gdout[3:0], vram_gui_bdout[3:0]};
assign vram_ascii = vga_haddr[4:3] == 2'b00 ? vram_chrdata[7:0] :
                    vga_haddr[4:3] == 2'b01 ? vram_chrdata[15:8] :
                    vga_haddr[4:3] == 2'b10 ? vram_chrdata[23:16] :
                    vram_chrdata[31:24];


ascii_rom ascii_to_shape(
    .a(vram_ascii),
    .spo(shape)
);

wire [3:0] vga_rdata = vga_haddr[3] ? vram_gui_rdata[7:4] : vram_gui_rdata[3:0];
wire [3:0] vga_gdata = vga_haddr[3] ? vram_gui_gdata[7:4] : vram_gui_gdata[3:0];
wire [3:0] vga_bdata = vga_haddr[3] ? vram_gui_bdata[7:4] : vram_gui_bdata[3:0];

assign vga_data = gui_or_tty ? {vga_rdata, vga_gdata, vga_bdata} :
                  (shape[~({vga_vaddr[3:0], 3'b0} | vga_haddr[2:0])] ? {12{1'b1}} : 12'b0);

assign dout = ram_space ? ram_data : 
              kbd_space ? {24'b0, kbd_ready ? kbd_data : 8'b0} :
              vram_chrspace ? vram_chrdout :
              vram_guidout;

initial begin
    tty_scan_baseline = 5'b0;
    gui_or_tty = 1'b0;
end
endmodule