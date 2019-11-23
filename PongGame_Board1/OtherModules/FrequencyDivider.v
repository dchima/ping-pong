/*
 * FrequencyDivider.v
 *
 *  Authors:
 * 
 *      Azeem Oguntola  SID: 201162945
 *      Chima Nnadika   SID: 201077064
 * -------------------------------------------------------------
 * Description
 * -------------------------------------------------------------
 * This is a clock frequency divider module to reduce the incoming clock
 * rates to the desired clock
 * 
 * The module takes in 2 parameters; the input clock frequency and the 
 * desired clock frequency, and has an input port for the incoming clock
 * and an output port for the outgoing clock
 *
 * Can divide clocks to maximum ratio of (2^32 - 1) 
 */
 
module FrequencyDivider #(
    // Module parameters
    parameter IN_CLOCK_FREQ  = 50000000,   // Input clock frequency in Hertz
    parameter OUT_CLOCK_FREQ = 128000      // Desired clock frequency in Hertz
)(
    // Input and Output Ports
    input     in_clock,         // incoming clock signal
    output    out_clock         // desired clock signal
);
    // local parameters
    localparam REG_WIDTH    = 32;      // Width of the counter
    localparam ZERO         = {(REG_WIDTH){1'b0}};
    localparam CLOCK_RATIO = IN_CLOCK_FREQ/OUT_CLOCK_FREQ; // Clock Frequency Ratio

    /* Frequency Divider Logic */
    
    // The frequency divider produces one edge of the output clock for every
    // N edges of the input clock, where N is the clock ratio.
    
    // The module works by counting up to half the number cycles defined by 
    // the clock ratio. When the counter reaches this value, the output clock
    // signal is inverted.

    // Create the counter register and a register for the output clock
    // Initialize both to zero.
    reg [REG_WIDTH-1:0] counter = ZERO;
    reg out_clock_reg = 1'b0;
    
    // At the positive edge of the input clock, the counter is incremented
    // When the counter reaches half the clock ratio, the counter is reset
    // and the output signal is inverted.
    
    always @ (posedge in_clock) begin
        counter <= counter + 1'b1;
        if (counter >= (CLOCK_RATIO/2 - 1)) begin
            counter <= ZERO;
            out_clock_reg <= ~out_clock_reg;
        end

    end
    
    // assign the output clock register to the output clock port
    assign out_clock = out_clock_reg;

endmodule
