`timescale 1ns / 1ps
module ps2_kbd(clk,clrn,ps2_clk,ps2_data,data,
                    ready,read,overflow);
    input clk,clrn,ps2_clk,ps2_data;
    input read;
    output [7:0] data;
    output reg ready;
    output reg overflow;     // fifo overflow
    // internal signal, for test
    reg [9:0] buffer;        // ps2_data bits
    reg [7:0] fifo[7:0];     // data fifo
    reg [2:0] w_ptr,r_ptr;   // fifo write and read pointers
    reg [3:0] count;  // count ps2_data bits
    // detect falling edge of ps2_clk
    reg [2:0] ps2_clk_sync;

    always @(posedge clk) begin
        ps2_clk_sync <=  {ps2_clk_sync[1:0],ps2_clk};
    end

    wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];

    always @(posedge clk) begin
        if (clrn == 0) begin // reset
            count <= 0; w_ptr <= 0; r_ptr <= 0; overflow <= 0; ready<= 0;
        end
        else begin
            if ( ready ) begin // read to output next data
                if(read == 1'b1) //read next data
                begin
                    r_ptr <= r_ptr + 3'b1;
                    if(w_ptr==(r_ptr+1'b1)) //empty
                        ready <= 1'b0;
                end
            end
            if (sampling) begin
              if (count == 4'd10) begin
                if ((buffer[0] == 0) &&  // start bit
                    (ps2_data)       &&  // stop bit
                    (^buffer[9:1])) begin      // odd  parity
                    fifo[w_ptr] <= buffer[8:1];  // kbd scan code
                    w_ptr <= w_ptr+3'b1;
                    ready <= 1'b1;
                    overflow <= overflow | (r_ptr == (w_ptr + 3'b1));
                end
                count <= 0;     // for next
              end else begin
                buffer[count] <= ps2_data;  // store ps2_data
                count <= count + 3'b1;
              end
            end
        end
    end
assign data = fifo[r_ptr]; //always set output data

integer i;
initial begin
    for (i = 0; i < 8; i = i + 1) begin
        fifo[i] = 0;
    end
    buffer = 0;
    r_ptr = 0;
    w_ptr = 0;
    count = 0;
    overflow = 0;
    ready = 0;
    ps2_clk_sync = 0;
end
endmodule

// module ps2_kbd (
//     input clk,
//     input ps2_clk,
//     input ps2_data,
//     input read,
//     output ready,
//     output [7:0] data
// );

// reg [3:0] counter;
// reg [9:0] buffer;
// reg [7:0] fifo[7:0];
// reg [2:0] r_ptr, w_ptr;
// always @(negedge ps2_clk) begin
//     if (counter == 4'd10
//     && ps2_data == 1'b1
//     && ^buffer[9:1]
//     && ~buffer[0]
//     && w_ptr + 3'b1 != r_ptr
//     ) begin
//         fifo[w_ptr] <= buffer[8:1];
//         w_ptr <= w_ptr + 3'b1;
//         counter <= 4'b0;
//     end
//     else if (counter == 4'd10) begin
//         counter <= 4'b0;
//     end
//     else begin
//         buffer[counter] <= ps2_data;
//         counter <= counter + 4'd1;
//     end
// end
// assign ready = !(r_ptr == w_ptr);
// assign data = fifo[r_ptr];
// always @(posedge clk) begin
//     if (ready && read) begin
//         r_ptr <= r_ptr + 3'b1;
//     end
// end

// integer i;
// initial begin
//     r_ptr = 3'b0;
//     w_ptr = 3'b0;
//     counter = 4'b0;
//     buffer = 10'b0;
//     for (i = 0; i < 8; i = i + 1) begin
//         fifo[i] = 8'b0;
//     end
// end
// endmodule
