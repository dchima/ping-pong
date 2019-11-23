/*
 * WinScene.v
 *
 * Created on: 12 Apr 2018
 *  Authors:
 * 
 *      Azeem Oguntola  SID: 201162945
 *      Chima Nnadika   SID: 201077064
 * ---------------------------------------------------------------------
 * Description
 * ---------------------------------------------------------------------
 * This is a module to display the winner of the game when the game is over.
 *
 * It also generates the gameOver and newGame signals
 * that are used to reset the game
 * 
 * It displays the texts P1 WINS or P2 WINS on the VGA according to the winner
 */

module WinScene (
    // Input and output ports
    input clock,
    input inPlay,           // play/pause signal
    
    // Players scores and colour inputs
    input [3:0] p0_score,            
    input [3:0] p1_score,       
    input [2:0] p0_colour,
    input [2:0] p1_colour,
    
    // Pixel addresses from VGA_controller
    input [9:0] xAddr,     
    input [9:0] yAddr,    
    input inDisplay,
    
    // output RGB colour and game reset signals
    output reg [23:0] colour_RGB,     
    output gameOver,
    output newGame
);

    // Define some RGB colours    
    localparam BLACK   = 24'h0;
    localparam RED     = 24'hFF0000;
    localparam GREEN   = 24'h00FF00;
    localparam BLUE    = 24'h0000FF;
    localparam YELLOW  = RED|GREEN;
    localparam CYAN    = GREEN|BLUE;
    localparam MAGENTA = RED|BLUE;
    localparam WHITE   = 24'hFFFFFF;

    localparam WIN_SCORE = 4'd10;   // The winning score

    // Text high and width
    localparam T_H = 10'd80;
    localparam T_W = 10'd30;
    
    // Text X locations
    localparam P_X = 10'd242;
    localparam NUM_X = 10'd286;
    localparam W_X = 10'd208;
    localparam I_X = 10'd252;
    localparam N_X = 10'd276;
    localparam S_X = 10'd320;
    
    // Text Y locations
    localparam L1_Y = 10'd150;    
    localparam L2_Y = 10'd250;

    // register for desired colour
    reg [2:0] colour;   //selector
    reg [23:0] colour_reg;

    // -- Text logic
    // Generate enable signals for the letters
    
    // P
    wire p = (((xAddr==P_X)&(yAddr>=L1_Y)&(yAddr<(L1_Y+T_H)))|((xAddr==P_X+T_W))&(yAddr>=L1_Y)&(yAddr<(L1_Y+T_H/2)))|(((yAddr==L1_Y)|(yAddr==L1_Y+T_H/2))&(xAddr>=P_X)&(xAddr<(P_X+T_W)));
    // 1
    wire no_1 = (xAddr == NUM_X)&(yAddr>=L1_Y)&(yAddr<(L1_Y+T_H));    
    // 2
    wire no_2 = (((xAddr==NUM_X)&(yAddr>=L1_Y+T_H/2)&(yAddr<(L1_Y+T_H)))|((xAddr==NUM_X+T_W)&(yAddr>=L1_Y)&(yAddr<(L1_Y+T_H/2)))|(((yAddr==L1_Y)|(yAddr==L1_Y+T_H/2)|(yAddr==L1_Y+T_H))&(xAddr>=NUM_X)&(xAddr<(NUM_X+T_W))));
    // W
    wire w = (((xAddr==W_X)|(xAddr==W_X+T_W))&(yAddr>=L2_Y)&(yAddr<L2_Y+T_H))|((yAddr==L2_Y+T_H)&(xAddr>=W_X)&(xAddr<(W_X+T_W)))|((xAddr==W_X+T_W/2)&(yAddr>=L2_Y+T_H/2)&(yAddr<L2_Y+T_H));
    // I
    wire i = (xAddr == I_X)&(yAddr>=L2_Y)&(yAddr<(L2_Y+T_H));
    // N
    wire n = (((xAddr==N_X)|(xAddr==N_X+T_W))&(yAddr>=L2_Y)&(yAddr<L2_Y+T_H))|((yAddr==L2_Y)&(xAddr>=N_X)&(xAddr<(N_X+T_W)));
    // S
    wire s = (((xAddr==S_X)&(yAddr>=L2_Y)&(yAddr<(L2_Y+T_H/2)))|((xAddr==S_X+T_W)&(yAddr>=L2_Y+T_H/2)&(yAddr<(L2_Y+T_H)))|(((yAddr==L2_Y)|(yAddr==L2_Y+T_H/2)|(yAddr==L2_Y+T_H))&(xAddr>=S_X)&(xAddr<(S_X+T_W))));

    // Enable signal for P1 WINS
    wire p0_wintext = p|no_1|w|i|n|s;
    // Enable signal for P2 WINS
    wire p1_wintext = p|no_2|w|i|n|s;
    
    // -- Game winner/end logic
    // A player wins when the score is equal to the winning score
    wire p0_win = (p0_score >= WIN_SCORE); 
    wire p1_win = (p1_score >= WIN_SCORE);
    wire win = p0_win | p1_win;
    // The game ends when a player wins and the game is not paused
    wire gameEnd = win & inPlay;
    // Enable the win scene when the game ends and the vga is in display
    wire enable = inDisplay & gameEnd;
    
    // Game is over when game ends
    assign gameOver = gameEnd;
    // newGame is requested when a player toggles the play/pause switch
    assign newGame = win & ~inPlay;
    
    
    // Set text colour selector to the winner's colour
    always @* begin    
        if (p0_win) begin 
            colour = p0_colour;
        end else begin
            colour = p1_colour;
        end
    end
    
    // switch desired colour state according to colour selector
    always @(colour) begin    
        case(colour)
            3'b100: colour_reg = RED;
            3'b010: colour_reg = GREEN;
            3'b001: colour_reg = BLUE;
            3'b110: colour_reg = YELLOW;
            3'b011: colour_reg = CYAN;
            3'b101: colour_reg = MAGENTA;
            3'b111: colour_reg = WHITE;
            default: colour_reg = RED;
        endcase
    end
    
    // Generate the win scene    
    always @(posedge clock) begin
        colour_RGB <= BLACK;
        if (enable) begin
            if (p0_win & p0_wintext) begin
                colour_RGB <= colour_reg;
            end else if (p1_win & p1_wintext) begin
                colour_RGB <= colour_reg;
            end else begin
                colour_RGB <= BLACK;
            end
        end
    end
    
endmodule
