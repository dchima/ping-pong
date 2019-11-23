/*
 * DrawBorder.v
 *
 * Created on: 12 Apr 2018
 *  Authors:
 * 
 *      Azeem Oguntola  SID: 201162945
 *      Chima Nnadika   SID: 201077064
 * ---------------------------------------------------------------------
 * Description
 * ---------------------------------------------------------------------
 * This is a module to draw a rectangular border on the VGA.
 * 
 * It is used to draw the game environment border. 
 * 
 */

module DrawBorder #(
    // Parameters
    // Border X and Y coordinates and Colour
    parameter X1 = 10,
    parameter Y1 = 20,
    parameter X2 = 630,
    parameter Y2 = 460,
    parameter COLOUR = 24'hFFFFFF
) (
    // input and output ports
    
    input clock,
    input reset,
    
    // Pixel addresses from VGA_controller
    input [9:0] xAddr,     
    input [9:0] yAddr, 
    input inDisplay,
    
    // RGB output colour
    output reg [23:0] colour_RGB     
);

    localparam BLACK = 24'h0;

    // -- Border logic
    // set border enable signal high if 
    // pixel addresses are in the border zone
    wire left = (xAddr==X1)&(yAddr>=Y1)&(yAddr<Y2);
    wire right = (xAddr == X2)&(yAddr >= Y1)& (yAddr < Y2);
    wire top = (yAddr == Y1)&(xAddr >= X1)&(xAddr < X2);
    wire bottom = (yAddr == Y2)&(xAddr >= X1)&(xAddr < X2);
    wire inBorder = inDisplay & (left | right | top | bottom);
    
    initial begin
        colour_RGB = BLACK;
    end
    
    // set output colour to specified colour if border
    // enable signal is high. Otherwise set to black
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            colour_RGB <= BLACK;
        end else if (inBorder) begin
            colour_RGB <= COLOUR;                
        end else begin
            colour_RGB <= BLACK;    
        end
    end
    
endmodule
