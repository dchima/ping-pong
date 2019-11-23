/*
 * HexTo7Seg.v
 *
 * Created on: 12 Apr 2018
 *  Authors:
 * 
 *      Azeem Oguntola  SID: 201162945
 *      Chima Nnadika   SID: 201077064
 * ---------------------------------------------------------------------
 * Description
 * ---------------------------------------------------------------------
 * This is a Hexadecimal to seven segment display converter module.
 * 
 */

module HexTo7Seg #(
    parameter INVERT_OUTPUT = 0

)(
    input      [3:0] hexValue,
    output reg [6:0] sevenSeg
);

    always @ * begin
        if (INVERT_OUTPUT == 0) begin
            case (hexValue)
                4'h0: sevenSeg = 7'b0111111;
                4'h1: sevenSeg = 7'b0000110;
                4'h2: sevenSeg = 7'b1011011;
                4'h3: sevenSeg = 7'b1001111;
                4'h4: sevenSeg = 7'b1100110;
                4'h5: sevenSeg = 7'b1101101;
                4'h6: sevenSeg = 7'b1111101;
                4'h7: sevenSeg = 7'b0000111;
                4'h8: sevenSeg = 7'b1111111;
                4'h9: sevenSeg = 7'b1100111;
                4'hA: sevenSeg = 7'b1110111;
                4'hB: sevenSeg = 7'b1111100;
                4'hC: sevenSeg = 7'b0111001;
                4'hD: sevenSeg = 7'b1011110;
                4'hE: sevenSeg = 7'b1111001;
                4'hF: sevenSeg = 7'b1110001;
                default: sevenSeg = 7'b0000000;
            endcase
        end else begin
            case (hexValue)
                4'h0: sevenSeg = 7'b1000000;
                4'h1: sevenSeg = 7'b1111001;
                4'h2: sevenSeg = 7'b0100100;
                4'h3: sevenSeg = 7'b0110000;
                4'h4: sevenSeg = 7'b0011001;
                4'h5: sevenSeg = 7'b0010010;
                4'h6: sevenSeg = 7'b0000010;
                4'h7: sevenSeg = 7'b1111000;
                4'h8: sevenSeg = 7'b0000000;
                4'h9: sevenSeg = 7'b0011000;
                4'hA: sevenSeg = 7'b0001000;
                4'hB: sevenSeg = 7'b0000011;
                4'hC: sevenSeg = 7'b1000110;
                4'hD: sevenSeg = 7'b0100001;
                4'hE: sevenSeg = 7'b0000110;
                4'hF: sevenSeg = 7'b0001110;
                default: sevenSeg = 7'b1111111;
            endcase
        end
    end
endmodule
