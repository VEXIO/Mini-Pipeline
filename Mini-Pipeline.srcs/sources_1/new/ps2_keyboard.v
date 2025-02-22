`timescale 1ns / 1ps
module ps2_keyboard (clk, reset, ps2_clk, ps2_data, rdn, data, ready, overflow, debug);
    input clk, reset; // 50 MHz
    input ps2_clk; // ps2 clock
    input ps2_data; // ps2 data
    input rdn; // read, active low
    output [7:0] data; // 8-bit code
    output ready; // code ready
    output reg overflow; // fifo overflow
    reg [9:0] buffer; // ps2_data bits
    reg [7:0] fifo[7:0]; // circular fifo
    reg [3:0] count; // count ps2_data bits
    reg [2:0] w_ptr, r_ptr; // fifo w/r pointers
    reg [3:0] ps2_clk_sync; // for detecting falling edge

    initial begin
        buffer = 0;
        count = 0;
        w_ptr = 0;
        r_ptr = 0;
        ps2_clk_sync = 0;
        overflow = 0;
    end

    output [31:0] debug;
    assign debug = {1'b0, w_ptr, 1'b0, r_ptr, fifo[r_ptr], 6'b0, buffer};
    always @ (posedge clk) begin
        ps2_clk_sync <= {ps2_clk_sync[2:0], ps2_clk};
    end
    wire sampling = &ps2_clk_sync[3:2] & ~|ps2_clk_sync[1:0]; // had a falling edge

    reg dropNext = 0;

    always @ (posedge clk) begin
        if (reset) begin // on reset
            count <= 0; // clear count
            w_ptr <= 0; // clear w_ptr
            r_ptr <= 0; // clear r_ptr
            overflow <= 0; // clear overflow
        end
        else if (sampling) begin // if sampling
            if (count == 4'd10) begin // if got one frame
                if ((buffer[0] == 0) && (ps2_data) && (^buffer[9:1])) begin
                    if ((w_ptr + 3'b1) != r_ptr) begin
                        if (buffer[8:1] == 8'hf0) begin
                            dropNext <= 1;
                        end
                        else if (dropNext) begin
                            dropNext <= 0;
                        end
                        else begin
                            fifo[w_ptr] <= buffer[8:1];
                            w_ptr <= w_ptr + 3'b1; // w_ptr++
                        end
                    end
                    else begin
                        overflow <= 1; // overflow
                    end
                end
                count <= 0; // for next frame
            end
            else begin // else
                buffer[count] <= ps2_data; // store ps2_data
                count <= count + 4'b1; // count++
            end
        end
        if (!rdn && ready) begin // on cpu read
            r_ptr <= r_ptr + 3'b1; // r_ptr++
            overflow <= 0; // clear overflow
        end
    end

    assign ready = (w_ptr != r_ptr);
    assign data = fifo[r_ptr];
endmodule
