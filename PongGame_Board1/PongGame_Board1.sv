/*
 * PongGame_Board1.sv
 *
 * Created on: 12 Apr 2018
 *  Authors:
 * 
 *      Azeem Oguntola  SID: 201162945
 *      Chima Nnadika   SID: 201077064
 * ---------------------------------------------------------------------
 * Description
 * ---------------------------------------------------------------------
 * This is a Multi-board two-player ping pong game built in behavioural Verilog HDL.
 * 
 * It uses VGA 640 x 480 and requires two DE1-SoC boards; one for each player.
 * Interboard communication is achieved using the GPIO pins.
 *
 * The game can also be reconfigured to run on a single board.
 * 
 * This is the project for Board 1 (the master board)
 * 
 *
 */

module PongGame_Board1 (
    // Declare input and output ports //
    input clock,            

    // keys input for movement
    input [1:0] p0_move,
    input [1:0] p1_move,    // from GPIO

    // players' colour input (RGB)
    input [2:0] p0_colour,
    input [2:0] p1_colour,  // from GPIO

    // pause/play inputs
    input p0_play,
    input p1_play,           // from GPIO
    
    // player0 score output on hex
    output [6:0] hex0,
    output [6:0] hex5,
    output [6:0] hex4,
    
    // player0 score output on LEDs
    output [9:0] led,
    
    // player1 score output to GPIO
    output [3:0] p1_scoreOut,
    
    // VGA output ports
    output vga_clk,
    output vga_hs,
    output vga_vs,
    output [7:0] vga_R,
    output [7:0] vga_G,
    output [7:0] vga_B

);


    /* Local Parameters and wires */

    // -- 1. Clock frequencies -- //
    
    // Four different clocks are required.
    // VGA clock = 25 MHz
    // Player movement clock = 250 Hz : Speed at which player paddle can move
    // Ball y-coordinate movement clock = 200 Hz : Speed at which ball moves in y-coordinate
    // Ball x-coordinate movement clock = 100 Hz : Speed at which ball moves in x-coordinate
    
    localparam IN_FREQ = 50000000;      // input clock frequency        
    localparam CLKS = 4;    // no of clocks required
    // 0 = VGA freq, 1 = Player move freq, 2 = ball y freq, 3 = ball x freq 
    localparam integer CLOCK_FREQS [0:3] = '{25000000, 250, 200, 100};
    wire [0:3] clocks;  // clock signal wires
    
    // -- 2. Game defaults -- //

    // Game environment border cordinates
    localparam ENV_X1 = 10'd10;
    localparam ENV_X2 = 10'd630;
    localparam ENV_Y1 = 10'd20;
    localparam ENV_Y2 = 10'd460;

    // Player parameters
    localparam N_PLAYERS = 2;               // no of players
    localparam PLAYER_W = 5;                // player width  
    localparam PLAYER_H = 80;               // player height
    localparam P0_XPOS = ENV_X1+1'b1;       // Player0 xposition
    localparam P1_XPOS = ENV_X2-PLAYER_W;   // player1 xposition
    localparam P_INIT_YPOS = 10'd229;       // Players' initial yposition
    localparam P_MAX_YPOS = ENV_Y2 - PLAYER_H - 1'b1;   // maximum yposition
    localparam P_MIN_YPOS = ENV_Y1 + 1'b1;              // minimum yposition
            
    // Ball size, colour, and initial position
    localparam BALL_W = 15;
    localparam BALL_H = 20;
    localparam B_INIT_XPOS = 10'd310;     
    localparam B_INIT_YPOS = 10'd230; 
    localparam BALL_COLOUR = 3'b111;    // white: each binary bit represents RGB
    // Ball movement limits
    localparam B_MIN_XPOS = P0_XPOS + PLAYER_W;
    localparam B_MAX_XPOS = P1_XPOS - BALL_W;
    localparam B_MIN_YPOS = ENV_Y1 + 1'b1;
    localparam B_MAX_YPOS = ENV_Y2 - BALL_H - 1'b1;
    
    // -- 3. Data wires -- //    
    
    // Player and ball positions
    wire [9:0] playerXpos [0:1] = '{P0_XPOS, P1_XPOS};    
    wire [9:0] playerYpos [0:1]; 
    wire [9:0] ballXpos;     
    wire [9:0] ballYpos; 

    // Player input and output signals
    wire inPlay = p0_play&p1_play;      // Pause/Play signal
    wire [1:0] playerMove [0:1] = '{p0_move, p1_move};    // Movement signal from keys

    wire [2:0] playerColour [0:1] = '{p0_colour, p1_colour}; // player colour input from switches
    wire [3:0] playerScore [0:1];                       // Scores
    
    // RGB colour data    
    wire [23:0] border_RGB;
    wire [23:0] ball_RGB;
    wire [23:0] player_RGB [0:1];
    wire [23:0] winScreen_RGB;    
    
    // RGB data to VGA is a sum of all RGB data
    wire [23:0] vga_RGB = border_RGB|ball_RGB|player_RGB[0]|player_RGB[1]|winScreen_RGB;         
    
    // VGA pixel tracking signals
    wire [9:0] xAddr;     
    wire [9:0] yAddr; 
    wire inDisplay;  // Signal to know if VGA is in display zone   

    // Game reset signals
    wire gameOver;
    wire newGame;
    
    genvar i;   // Generate variable

    assign vga_clk = clocks[0]; //assign the vga clock to its output
    assign p1_scoreOut = playerScore[1]; //Assign player 1 score to its output
    // display P1 on 7 segment for player0
    assign hex5 = 7'b0001100;   // display 'P' on hex5
    assign hex4 = 7'b1111001;   // display '1' on hex 4

    /* Begin Instantiation of sub-modules */

    // -- 1. VGA controller --  
    // This module generates the vga display signals and sends the colour data
    // It also generates the x and y addr to be used by other modules
    VGA_Controller display(
        // Ports
        .clock(clocks[0]),
        .vga_hs(vga_hs),
        .vga_vs(vga_vs),
        .vga_R(vga_R),
        .vga_B(vga_B),
        .vga_G(vga_G),
        .xAddr(xAddr),
        .yAddr(yAddr),
        .vga_RGB(vga_RGB),
        .inDisplay(inDisplay)
    );
    
    // -- 2. Game Environment border --
    // This module draws the Environment border of colour white
    DrawBorder #(
        // Parameters
        .X1(ENV_X1),
        .Y1(ENV_Y1),
        .X2(ENV_X2),
        .Y2(ENV_Y2),
        .COLOUR(24'hFFFFFF)
    )Enviro(
        // ports
        .clock(clocks[0]),
        .reset(),           // reset is not used
        .xAddr(xAddr),     
        .yAddr(yAddr), 
        .inDisplay(inDisplay),
        .colour_RGB(border_RGB)     
    );
    
    // -- 3. Game ball --
    // This module draws the ball of colour white
    // ball positions are change by GameDynamics    
    DrawFillBox #(
        // Parameters
        .WIDTH(BALL_W),
        .HEIGHT(BALL_H)
    )Ball(
        // Ports
        .clock(clocks[0]),
        .reset(gameOver),
        .xPos(ballXpos),     
        .yPos(ballYpos), 
        .colour(BALL_COLOUR),
        .xAddr(xAddr),     
        .yAddr(yAddr),    
        .inDisplay(inDisplay),
        .colour_RGB(ball_RGB)     
    );

    // -- 4. Game Dynamics --
    // Handles ball movement, bouncing and collision
    // Handles player scores, generates game reset signals
    GameDynamics #(
        // Parameters
        .INIT_XPOS(B_INIT_XPOS),
        .INIT_YPOS(B_INIT_YPOS),
        .PLAYER_H(PLAYER_H),
        .BALL_H(BALL_H),
        .MIN_YPOS(B_MIN_YPOS),
        .MIN_XPOS(B_MIN_XPOS),
        .MAX_YPOS(B_MAX_YPOS),
        .MAX_XPOS(B_MAX_XPOS)
    )playGame(
        // ports
        .Xclock(clocks[3]),
        .Yclock(clocks[2]),
        .reset(gameOver),
        .inPlay(inPlay),
        .newGame(newGame),
        .p0_Ypos(playerYpos[0]),
        .p1_Ypos(playerYpos[1]),
        .ballXpos(ballXpos),
        .ballYpos(ballYpos),
        .p0_score(playerScore[0]),
        .p1_score(playerScore[1])
    );

    // -- 5. Win Scene --
    // Displays the Scene for when the game is over
    // Displays P1 WINS or P2 WINS
    WinScene gameEnd(
        .clock(clocks[0]),
        .inPlay(inPlay),
        .p0_score(playerScore[0]),
        .p1_score(playerScore[1]),
        .p0_colour(playerColour[0]),
        .p1_colour(playerColour[1]),
        .xAddr(xAddr),     
        .yAddr(yAddr),    
        .inDisplay(inDisplay),
        .colour_RGB(winScreen_RGB),
        .gameOver(gameOver),
        .newGame(newGame)
    );

    // -- 6. Player paddle and movement circuits --
    // Draws the player on the screen and handles the player movements
    // generate for both players
    generate 
        for (i = 0; i < N_PLAYERS; i = i + 1) begin : players
            // Draw the players
            DrawFillBox #(
                // Parameters
                .WIDTH(PLAYER_W),
                .HEIGHT(PLAYER_H)
            )playerPaddle(
                // Ports
                .clock(clocks[0]),
                .reset(gameOver),
                .xPos(playerXpos[i]),     
                .yPos(playerYpos[i]), 
                .colour(playerColour[i]),                
                .xAddr(xAddr),     
                .yAddr(yAddr),    
                .inDisplay(inDisplay),
                .colour_RGB(player_RGB[i])     
            );
            
            // Handle player movement
            PlayerMovement #(
                // Parameters
                .INIT_YPOS(P_INIT_YPOS),
                .MAX_YPOS(P_MAX_YPOS),
                .MIN_YPOS(P_MIN_YPOS)            
            )playerControl(
                // ports
                .clock(clocks[1]),
                .reset(gameOver),
                .inPlay(inPlay),
                .up(~playerMove[i][0]),
                .down(~playerMove[i][1]),
                .yPos(playerYpos[i])
            );

        end
        
    endgenerate

    // -- 7. Clock Division --
    // Generates clock dividers to get the four clocks
    generate 
        for (i = 0; i < CLKS; i = i + 1) begin : theclocks
            
            FrequencyDivider #(
                .IN_CLOCK_FREQ(IN_FREQ),
                .OUT_CLOCK_FREQ(CLOCK_FREQS[i])
            ) getTheClocks (
                .in_clock(clock),
                .out_clock(clocks[i])
            );
        end
    endgenerate

    
    // -- 8. Player0 score display on Hex --
    // Displays the score of player 0 on the 7segment displays
    HexTo7Seg #(
        .INVERT_OUTPUT(1)
    )player1(
        .hexValue(playerScore[0]),
        .sevenSeg(hex0)
    );

    // -- 9. Player0 score display on Led --    
    ScoreToLed p0_scoreled (
        .scoreValue(playerScore[0]),
        .led(led)
    );
    
endmodule