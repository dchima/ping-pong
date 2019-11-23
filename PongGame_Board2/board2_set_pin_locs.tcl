
# Requre quartus project
package require ::quartus::project

# Set pin locations for player1 key and switch inputs
set_location_assignment PIN_Y16 -to move[0]
set_location_assignment PIN_AA14 -to move[1]

set_location_assignment PIN_AB12-to colour[0]
set_location_assignment PIN_AC12 -to colour[1]
set_location_assignment PIN_AF9 -to colour[2]

set_location_assignment PIN_AE12 -to play

# Set pin locations for player1 hex outputs (scores)
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

# Set pin locations for player1 led outputs (scores)
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

set_location_assignment PIN_AK19 -to p1_score[0]
set_location_assignment PIN_AJ19 -to p1_score[1]
set_location_assignment PIN_AJ17 -to p1_score[2]
set_location_assignment PIN_AJ16 -to p1_score[3]


# Commit assignments
export_assignments
