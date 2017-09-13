`timescale 1ns / 1ps
module scan_decoder(
    input [7:0] scan_code,
    output reg [7:0] ascii
);
    always @ (*)
        case (scan_code)
            8'h1C: ascii <= 8'd65;
            8'h32: ascii <= 8'd66;
            8'h21: ascii <= 8'd67;
            8'h23: ascii <= 8'd68;
            8'h24: ascii <= 8'd69;
            8'h2B: ascii <= 8'd70;
            8'h34: ascii <= 8'd71;
            8'h33: ascii <= 8'd72;
            8'h43: ascii <= 8'd73;
            8'h3B: ascii <= 8'd74;
            8'h42: ascii <= 8'd75;
            8'h4B: ascii <= 8'd76;
            8'h3A: ascii <= 8'd77;
            8'h31: ascii <= 8'd78;
            8'h44: ascii <= 8'd79;
            8'h4D: ascii <= 8'd80;
            8'h15: ascii <= 8'd81;
            8'h2D: ascii <= 8'd82;
            8'h1B: ascii <= 8'd83;
            8'h2C: ascii <= 8'd84;
            8'h3C: ascii <= 8'd85;
            8'h2A: ascii <= 8'd86;
            8'h1D: ascii <= 8'd87;
            8'h22: ascii <= 8'd88;
            8'h35: ascii <= 8'd89;
            8'h1A: ascii <= 8'd90;
            8'h45: ascii <= 8'd48;
            8'h16: ascii <= 8'd49;
            8'h1E: ascii <= 8'd50;
            8'h26: ascii <= 8'd51;
            8'h25: ascii <= 8'd52;
            8'h2E: ascii <= 8'd53;
            8'h36: ascii <= 8'd54;
            8'h3D: ascii <= 8'd55;
            8'h3E: ascii <= 8'd56;
            8'h46: ascii <= 8'd57;
            8'h66: ascii <= 8'd1;
            8'h29: ascii <= 8'd0;
            8'h12: ascii <= 8'd2;
            8'h5A: ascii <= 8'd3;
            8'hE0: ascii <= 8'd4;
            8'h75: ascii <= 8'd5;
            8'h6B: ascii <= 8'd6;
            8'h72: ascii <= 8'd7;
            8'h74: ascii <= 8'd8;
            8'hF0: ascii <= 8'd255;
            default: ascii <= 8'd255;
        endcase

endmodule