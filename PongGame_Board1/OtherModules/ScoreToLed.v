/*
 * ScoreToLed.v
 *
 * Created on: 12 Apr 2018
 *  Authors:
 * 
 *      Azeem Oguntola  SID: 201162945
 *      Chima Nnadika   SID: 201077064
 * ---------------------------------------------------------------------
 * Description
 * ---------------------------------------------------------------------
 * This is a module to convert the player score to LED outputs.
 * 
 */
 
 module ScoreToLed (
    input      [3:0] scoreValue,
    output reg [9:0] led
 
 );
 
     always @ * begin
        case (scoreValue)
            4'h0: led = 10'b0000000000;
            4'h1: led = 10'b0000000001;
            4'h2: led = 10'b0000000011;
            4'h3: led = 10'b0000000111;
            4'h4: led = 10'b0000001111;
            4'h5: led = 10'b0000011111;
            4'h6: led = 10'b0000111111;
            4'h7: led = 10'b0001111111;
            4'h8: led = 10'b0011111111;
            4'h9: led = 10'b0111111111;
            4'hA: led = 10'b1111111111;
            default: led = 10'b0000000000;
        endcase
     end

endmodule
