################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Dr Mario.
#
# Student 1: Eric Lu, 1010393487
# Student 2: Ayusha Thapa, 1009861972
#
# We assert that the code submitted here is entirely our own 
# creation, and will indicate otherwise when it is not.
#
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       1
# - Unit height in pixels:      1
# - Display width in pixels:    64
# - Display height in pixels:   64
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

##############################################################################
# Mutable Data
##############################################################################
LEFT:
    .word 0x10008074
RIGHT:
    .word 0x10008088
MIDDLE:
    .word 0x1000807c
TOP:
    .word 0x1000800c
##############################################################################
# Code
##############################################################################
	.text
	.globl main

    # Set up the walls.
    
    li $t1, 0x808080  # Store gray in $t1.
    lw $t0, LEFT
    # Start coloring the left side of the bottle neck.
    sw $t1, 0($t0)  # Color LEFT gray.
    

    # Run the game.
main:
    # Initialize the game

game_loop:
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep

    # 5. Go back to Step 1
    # j game_loop
