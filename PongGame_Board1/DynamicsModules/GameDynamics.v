/*
 * GameDynamics.v
 *
 * Created on: 12 Apr 2018
 *  Authors:
 * 
 *      Azeem Oguntola  SID: 201162945
 *      Chima Nnadika   SID: 201077064
 * ---------------------------------------------------------------------
 * Description
 * ---------------------------------------------------------------------
 * This is a module that handles the ball motion and collision.
 * It also counts the players' scores
 * 
 */

module GameDynamics #(
    // parameters
    // Ball intial and maximum positions
    parameter INIT_XPOS = 10'd310,
    parameter INIT_YPOS = 10'd230,
    parameter MIN_YPOS = 10'd21,
    parameter MAX_YPOS = 10'd459,
    parameter MIN_XPOS = 10'd10,
    parameter MAX_XPOS = 10'd630,
    parameter PLAYER_H = 10'd80,
    parameter BALL_H = 10'd20

)(
    // input and output ports
    input Xclock,               // Ball X movement clock
    input Yclock,               // Ball Y movement clock
    input reset,                // reset from gameOver
    input newGame,              // newGame signal
    input inPlay,               // pause/play
    // player positions
    input [9:0] p0_Ypos,
    input [9:0] p1_Ypos,
    // ball positions
    output reg [9:0] ballXpos,
    output reg [9:0] ballYpos,
    // player scores
    output reg [3:0] p0_score,
    output reg [3:0] p1_score
    
);

    // local parameters
    localparam XINC = 1'b1;
    localparam YINC = 1'b1;
    
    // forward or backward direction modes
    localparam INC = 1'b1;
    localparam DEC = 1'b0;

    localparam SCORE = 4'd1;
    localparam ZERO = 4'd0;

    // register to hold direction states
    reg xDir = DEC;
    reg yDir = DEC;
    
    // -- Player and ball collision checker logic
    // player0
    wire p0_coll1 = (ballYpos >= p0_Ypos)&(ballYpos < (p0_Ypos + PLAYER_H));
    wire p0_coll2 = ((ballYpos + BALL_H - 1'b1) >= p0_Ypos)&((ballYpos + BALL_H - 1'b1) < (p0_Ypos + PLAYER_H));
    wire p0_collision = p0_coll1 | p0_coll2;
    // player1
    wire p1_coll1 = (ballYpos >= p1_Ypos)&(ballYpos < (p1_Ypos + PLAYER_H));
    wire p1_coll2 = ((ballYpos + BALL_H - 1'b1) >= p1_Ypos)&((ballYpos + BALL_H - 1'b1) < (p1_Ypos + PLAYER_H));
    wire p1_collision = p1_coll1 | p1_coll2;

    // initial to defaults
    initial begin
        ballXpos = INIT_XPOS;
        ballYpos = INIT_YPOS;
        p0_score = ZERO;
        p1_score = ZERO;
    end
    
    //-- Begin reflected motion logic //
    
    // Vertical movement logic
    always @(posedge Yclock or posedge reset) begin
        if (reset) begin
            ballYpos <= INIT_YPOS;
        end else if (inPlay) begin
            // if direction state is decrement,
            // decrement ball Y position
            // Switch direction once the border is reached
            if (yDir == DEC) begin
                ballYpos <= ballYpos - YINC;
                if (ballYpos <= MIN_YPOS) begin
                    yDir <= INC;
                    ballYpos <= MIN_YPOS;
                end
            end else begin
            // if direction state is increment,
            // increment ball Y position
            // Switch direction once the border is reached
                ballYpos <= ballYpos + YINC;
                if (ballYpos >= MAX_YPOS) begin
                    yDir <= DEC;
                    ballYpos <= MAX_YPOS;
                end
            end        
        
        end    
    end
    
    // Horrizontal movement logic
    always @(posedge Xclock or posedge reset) begin
        if (reset) begin
            ballXpos <= INIT_XPOS;
        end else if (newGame) begin
        // if newGame is requested, reset the scores
            ballXpos <= INIT_XPOS;
            p0_score <= ZERO;
            p1_score <= ZERO;
        end else if (inPlay) begin
            // if direction state is decrement, decrement ball X position.
            // Once the border is reached, check for collsion with player paddle. 
            // Switch direction if collision occurs, otherwise, increment oppponent'scores
            // score and reset to initial position
            if (xDir == DEC) begin
                ballXpos <= ballXpos - XINC;
                if (ballXpos <= MIN_XPOS) begin
                    if (p0_collision) begin
                        xDir <= INC;
                        ballXpos <= MIN_XPOS;
                    end else begin  // no collision
                        ballXpos <= INIT_XPOS;
                        p1_score <= p1_score + SCORE;
                    end
                end
            end else begin
            // if direction state is increment, increment ball X position.
            // Once the border is reached, check for collsion with player paddle. 
            // Switch direction if collision occurs, otherwise, increment oppponent'scores
            // score and reset to initial position
                ballXpos <= ballXpos + XINC;
                if (ballXpos >= MAX_XPOS) begin
                    if (p1_collision) begin
                        xDir <= DEC;
                        ballXpos <= MAX_XPOS;
                    end else begin
                        ballXpos <= INIT_XPOS;  // no collision
                        p0_score <= p0_score + SCORE;
                    end
                end
            end        
        
        end
    
    end
    
endmodule