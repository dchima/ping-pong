/*
 * DrawFillBox.v
 *
 * Created on: 12 Apr 2018
 *  Authors:
 * 
 *      Azeem Oguntola  SID: 201162945
 *      Chima Nnadika   SID: 201077064
 * ---------------------------------------------------------------------
 * Description
 * ---------------------------------------------------------------------
 * This is a module to draw a filled box on the VGA.
 * 
 * It is used to draw the ball and the player paddles. 
 * 
 */

module DrawFillBox #(
    // Parameters
    parameter WIDTH  = 5,
    parameter HEIGHT = 5    
)(
    // Input and output ports
    input clock,
    input reset,
    // Box position
    input [9:0] xPos,            
    input [9:0] yPos,       
    input [2:0] colour,      // rgb colour selector
    
    // Pixel addresses from VGA_controller
    input [9:0] xAddr,     
    input [9:0] yAddr,    
    input inDisplay,
    
    // RGB output colour
    output reg [23:0] colour_RGB     

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

    // Register to store the desired colour
    reg [23:0] colour_reg = BLACK;
    
    // -- Box logic
    // Set Box enable signal high 
    // if the pixel addresses are within the box
    wire inBox = inDisplay&(xAddr>=xPos)&(xAddr<(xPos+WIDTH))&(yAddr>=yPos)&(yAddr<(yPos+HEIGHT));

    // initialise output colour to black
    initial begin
        colour_RGB = BLACK;
    end
    
    // Switch desired colour state based on colour selector value
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

    // Set output colour to desired colour if box enable signal is high
    // otherwise, set to black
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            colour_RGB <= BLACK;
        end else if (inBox) begin
            colour_RGB <= colour_reg;                
        end else begin
            colour_RGB <= BLACK;    
        end
    end

endmodule