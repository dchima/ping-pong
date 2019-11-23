/*
 * VGA_Controller.v
 *
 * Created on: 12 Apr 2018
 *  Authors:
 * 
 *      Azeem Oguntola  SID: 201162945
 *      Chima Nnadika   SID: 201077064
 * ---------------------------------------------------------------------
 * Description
 * ---------------------------------------------------------------------
 * This is a VGA controller module developed for VGA 640 x 480.
 * 
 * It requires a 25 MHz clock and a 24 bit RGB colour data as input.
 *  
 * It generates the VGA sync signals and outputs the pixel coordinates
 * 
 *
 */
module VGA_Controller (
    // Input and output ports //

    input clock,            // 25MHz Clock
    input [23:0] vga_RGB,      // Input Colour  RGB
    
    // output pixel cordinates to be used by other modules
    output reg [9:0] xAddr,     // 0 to 639
    output reg [9:0] yAddr,     // 0 to 479    
    output reg inDisplay,       // signify that VGA is in display zone
    
    // VGA output ports
    output reg vga_hs,      
    output reg vga_vs,
    output reg [7:0] vga_R,
    output reg [7:0] vga_G,
    output reg [7:0] vga_B
);

    // --Timing requirements for VGA(60Hz) 640 x 480: 25.175 MHz Clock--

    // Horrizontal Timing requirements //
    // Sync pulse a 3.8 us = 96 cycles
    // Next is back porch 'b' 1.9 us = 48 cycles
    // Next is display interval 'c' 25.4 us = 640 cycles
    // And front porch 'd' 0.6 us = 16 cycles
    // Total Horizontal Cycles = 800 cycles
    
    // Vertical Timing Requirements //
    // This is similar to horizontal but instead, 
    // the number of horizontal lines
    // a = 2, b = 33, c = 480, d = 10
    // Total lines = 525
    
    // Horrizontal timing requirements as described above
    localparam H_MAX = 800;         // Total
    localparam H_A = 96;
    localparam H_B = 48;
    localparam H_C = 640;
    localparam H_D = 16;
    
    // Vertical timing requirements as described above
    localparam V_MAX = 525;         // Total
    localparam V_A = 2;
    localparam V_B = 33;
    localparam V_C = 480;
    localparam V_D = 10;
    
    // Both the horizontal and vertical sync pulses start after a 
    // and end at the max. 
    
    // After the sync pulse, the VGA starts scanning the screen horizontally
    // from left to right and moves to the next row (vertical).
    // The VGA signals are active lows, thus we must assert the horizontal 
    // and vertical sync signals high after their respective a (pulse start).
    // The display however starts after b and lasts for the whole of c. 
    // Thus the RGB values are written to the screen when the pulses are within
    // the display interval c.    
    // We need to then track the vga pixel location by getting the x and y cords.

    localparam X_START = H_A + H_B;
    localparam X_END   = H_A + H_B + H_C;
    
    localparam Y_START = V_A + V_B;
    localparam Y_END   = V_A + V_B + V_C;
    localparam ZERO = 10'd0;
    localparam INC = 10'd1;
    
    // Vertical and horizontal counter
    reg [9:0] h_count = ZERO;
    reg [9:0] v_count = ZERO;

    // Initialise all outputs to zero    
    initial begin    
        vga_R = 8'h00;
        vga_G = 8'h00;
        vga_B = 8'h00;
        vga_hs = 1'b0;
        vga_vs = 1'b0;
    end

    // -- Sync signals generation logic -- //
    always@ (posedge clock) begin    
    // Horrizontal and Vertical Sync //
        h_count <= h_count + INC;   // increment horizontal counter
        // move to next line
        if (h_count >= H_MAX) begin   
            h_count <= ZERO;
            v_count <= v_count + INC;   // increment vertical counter
            // restart when all lines are scanned
            if (v_count >= V_MAX) begin
                v_count <= ZERO;
            end
        end
        
        // Assert the horizontal signal
        if (h_count < H_A) vga_hs <= 1'b0;
        else vga_hs <= 1'b1;
        
        // Assert the Vertical signal
        if (v_count < V_A) vga_vs <= 1'b0;
        else vga_vs <= 1'b1;
        // Sync signal generation end //
            
        // Get the X and Y addresses of the pixels        
        if ((h_count >= X_START) && (h_count < X_END) && (v_count >= Y_START) && (v_count < Y_END)) begin
            xAddr <= h_count - X_START;
            yAddr <= v_count - Y_START;
            inDisplay <= 1'b1;
        end else begin
            inDisplay <= 1'b0;
            xAddr <= ZERO;
            yAddr <= ZERO;
        end
    
        // Assert the RGB signals if VGA is in display zone
        if (inDisplay) begin        
            vga_R <= vga_RGB[16+:8];
            vga_G <= vga_RGB[8+:8];
            vga_B <= vga_RGB[0+:8];
        end else begin
            vga_R <= 8'h00;
            vga_G <= 8'h00;
            vga_B <= 8'h00;
        end
    end
    
endmodule