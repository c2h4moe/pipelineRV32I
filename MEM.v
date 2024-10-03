`timescale 1ns / 1ps

module MEM(
    input [31:0] data,
    input [31:0] reg1,
    input [31:0] mem_data,
    input mem_to_reg,
    input load_unsigned,
    input ls_byte,
    input half,
    output [31:0] result,
    output [31:0] din
);
reg [31:0] half_s, half_u, ls_byte_s, ls_byte_u, din_b, din_h;
// assign ram_addr = data[11:2];
assign din = ls_byte ? din_b :
             half ? din_h :
             reg1;

// RAM ram (
//   .addr(ram_addr),      // input wire [9 : 0] a
//   .din(din),      // input wire [31 : 0] d
//   .clk(clk),  // input wire clk
//   .we(mem_write),    // input wire we
//   .data(mem_data)  // output wire [31 : 0] spo
// );
always @(*) begin
    case (data[1])
        1'b0: begin
            half_s = {{16{mem_data[15]}}, mem_data[15:0]};
            half_u = {16'b0, mem_data[15:0]};
            din_h = {mem_data[31:16], reg1[15:0]};
        end
        1'b1: begin
            half_s = {{16{mem_data[31]}}, mem_data[31:16]};
            half_u = {16'b0, mem_data[31:16]};
            din_h = {reg1[15:0], mem_data[15:0]};
        end
        default: begin
            half_s = {{16{mem_data[15]}}, mem_data[15:0]};
            half_u = {16'b0, mem_data[15:0]};
            din_h = {mem_data[31:16], reg1[15:0]};
        end
    endcase
    case (data[1:0])
        2'b00: begin
            ls_byte_s = {{24{mem_data[7]}}, mem_data[7:0]};
            ls_byte_u = {24'b0, mem_data[7:0]};
            din_b = {mem_data[31:8], reg1[7:0]};
        end
        2'b01: begin
            ls_byte_s = {{24{mem_data[15]}}, mem_data[15:8]};
            ls_byte_u = {24'b0, mem_data[15:8]};
            din_b = {mem_data[31:16], reg1[7:0], mem_data[7:0]};
        end
        2'b10: begin
            ls_byte_s = {{24{mem_data[23]}}, mem_data[23:16]};
            ls_byte_u = {24'b0, mem_data[23:16]};
            din_b = {mem_data[31:24], reg1[7:0], mem_data[15:0]};
        end
        2'b11: begin
            ls_byte_s = {{24{mem_data[31]}}, mem_data[31:24]};
            ls_byte_u = {24'b0, mem_data[31:24]};
            din_b = {reg1[7:0], mem_data[23:0]};
        end
        default: begin
            ls_byte_s = {{24{mem_data[7]}}, mem_data[7:0]};
            ls_byte_u = {24'b0, mem_data[7:0]};
            din_b = {mem_data[31:8], reg1[7:0]};
        end
    endcase
end
reg [31:0] mem_res;
always @(*) begin
    case ({half, ls_byte, load_unsigned})
        3'b100:
        mem_res = half_s; 
        3'b101:
        mem_res = half_u;
        3'b010:
        mem_res = ls_byte_s;
        3'b011:
        mem_res = ls_byte_u;
        default: 
        mem_res = mem_data;
    endcase
end
assign result = mem_to_reg ? mem_res : data;

endmodule