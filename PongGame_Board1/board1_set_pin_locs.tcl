
# Requre quartus project
package require ::quartus::project

# Set pin locations for VGA
set_location_assignment PIN_A13 -to vga_R[0]
set_location_assignment PIN_C13 -to vga_R[1]
set_location_assignment PIN_E13 -to vga_R[2]
set_location_assignment PIN_B12 -to vga_R[3]
set_location_assignment PIN_C12 -to vga_R[4]
set_location_assignment PIN_D12 -to vga_R[5]
set_location_assignment PIN_E12 -to vga_R[6]
set_location_assignment PIN_F13 -to vga_R[7]

set_location_assignment PIN_J9 -to vga_G[0]
set_location_assignment PIN_J10 -to vga_G[1]
set_location_assignment PIN_H12 -to vga_G[2]
set_location_assignment PIN_G10 -to vga_G[3]
set_location_assignment PIN_G11 -to vga_G[4]
set_location_assignment PIN_G12 -to vga_G[5]
set_location_assignment PIN_F11 -to vga_G[6]
set_location_assignment PIN_E11 -to vga_G[7]

set_location_assignment PIN_B13 -to vga_B[0]
set_location_assignment PIN_G13 -to vga_B[1]
set_location_assignment PIN_H13 -to vga_B[2]
set_location_assignment PIN_F14 -to vga_B[3]
set_location_assignment PIN_H14 -to vga_B[4]
set_location_assignment PIN_F15 -to vga_B[5]
set_location_assignment PIN_G15 -to vga_B[6]
set_location_assignment PIN_J14 -to vga_B[7]

set_location_assignment PIN_A11 -to vga_clk
set_location_assignment PIN_B11 -to vga_hs
set_location_assignment PIN_D11 -to vga_vs


# Set pin location for Clock
set_location_assignment PIN_AA16 -to clock

# Set pin locations for player0 key and switch inputs
set_location_assignment PIN_Y16 -to p0_move[0]
set_location_assignment PIN_AA14 -to p0_move[1]

set_location_assignment PIN_AB12-to p0_colour[0]
set_location_assignment PIN_AC12 -to p0_colour[1]
set_location_assignment PIN_AF9 -to p0_colour[2]

set_location_assignment PIN_AE12 -to p0_play

# Set pin locations for player0 hex outputs (scores)
set_location_assignment PIN_AE26 -to hex0[0]
set_location_assignment PIN_AE27 -to hex0[1]
set_location_assignment PIN_AE28 -to hex0[2]
set_location_assignment PIN_AG27 -to hex0[3]
set_location_assignment PIN_AF28 -to hex0[4]
set_location_assignment PIN_AG28 -to hex0[5]
set_location_assignment PIN_AH28 -to hex0[6]

set_location_assignment PIN_AA24 -to hex4[0]
set_location_assignment PIN_Y23 -to hex4[1]
set_location_assignment PIN_Y24 -to hex4[2]
set_location_assignment PIN_W22 -to hex4[3]
set_location_assignment PIN_W24 -to hex4[4]
set_location_assignment PIN_V23 -to hex4[5]
set_location_assignment PIN_W25 -to hex4[6]

set_location_assignment PIN_V25 -to hex5[0]
set_location_assignment PIN_AA28 -to hex5[1]
set_location_assignment PIN_Y27 -to hex5[2]
set_location_assignment PIN_AB27 -to hex5[3]
set_location_assignment PIN_AB26 -to hex5[4]
set_location_assignment PIN_AA26 -to hex5[5]
set_location_assignment PIN_AA25 -to hex5[6]

# Set pin locations for player0 led outputs (scores)
set_location_assignment PIN_V16 -to led[0]
set_location_assignment PIN_W16 -to led[1]
set_location_assignment PIN_V17 -to led[2]
set_location_assignment PIN_V18 -to led[3]
set_location_assignment PIN_W17 -to led[4]
set_location_assignment PIN_W19 -to led[5]
set_location_assignment PIN_Y19 -to led[6]
set_location_assignment PIN_W20 -to led[7]
set_location_assignment PIN_W21 -to led[8]
set_location_assignment PIN_Y21 -to led[9]



# Set pin locations for player1 inputs and outputs to GPIO 0 [0-9]
set_location_assignment PIN_AC18 -to p1_move[0]
set_location_assignment PIN_Y17 -to p1_move[1]

set_location_assignment PIN_AD17 -to p1_colour[0]
set_location_assignment PIN_Y18 -to p1_colour[1]
set_location_assignment PIN_AK16 -to p1_colour[2]

set_location_assignment PIN_AK18 -to p1_play

set_location_assignment PIN_AK19 -to p1_scoreOut[0]
set_location_assignment PIN_AJ19 -to p1_scoreOut[1]
set_location_assignment PIN_AJ17 -to p1_scoreOut[2]
set_location_assignment PIN_AJ16 -to p1_scoreOut[3]


# Commit assignments
export_assignments
