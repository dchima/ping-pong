/*
 * PlayerMovement.v
 *
 * Created on: 12 Apr 2018
 *  Authors:
 * 
 *      Azeem Oguntola  SID: 201162945
 *      Chima Nnadika   SID: 201077064
 * ---------------------------------------------------------------------
 * Description
 * ---------------------------------------------------------------------
 * This is a module to move the player paddle up and down.
 * 
 * It takes the initial position as parameters and changes the
 * the Yposition according to the key input
 * 
 */

module PlayerMovement #(
    // parameters
    parameter INIT_YPOS = 10'd220,
    parameter MAX_YPOS = 10'd459,
    parameter MIN_YPOS = 10'd21

)(
    // input and output ports
    input clock,
    input reset,
    input inPlay,   // pause/play
    input up,       // up input
    input down,     // down input
    
    output reg [9:0] yPos   // player y position
);

    // some movement states
    localparam STATIONARY = 2'd0;
    localparam MOVEUP = 2'd1;
    localparam MOVEDOWN = 2'd2;

    // movement state register
    reg [1:0] mode = STATIONARY;
    
    // default to initial position
    initial begin
        yPos = INIT_YPOS;
    end

    // switch movement state according to key input
    always @ (up or down) begin
        if (up) begin
            mode = MOVEUP;
        end else if (down) begin
            mode = MOVEDOWN;
        end else begin
            mode = STATIONARY;
        end
    
    end
    
    // Move the player paddle according to the movement state
    always @ (posedge clock or posedge reset) begin
        if (reset) begin
            yPos <= INIT_YPOS;
        end else if (inPlay) begin
            // if moving up, decrement Y. 
            if (mode==MOVEUP) begin
                yPos <= yPos - 1'b1;
                if (yPos <= MIN_YPOS) begin
                    yPos <= MIN_YPOS;
                end
            // if moving down, increment Y
            end else if (mode == MOVEDOWN) begin
                yPos <= yPos + 1'b1;
                if (yPos >= MAX_YPOS) begin
                    yPos <= MAX_YPOS;
                end
            end

        end    
    end
    
endmodule