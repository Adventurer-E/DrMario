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
LEFT:  # (30,1), 0x10008000 + 29 * 4
    .word 0x10008074
RIGHT: # (34,1)
    .word 0x10008088
MIDDLE:
    .word 0x1000807c
TOPLEFT:   # (1,3), 0x10008000 + 2 * 64 * 4
    .word 0x10008200
TOPRIGHT:  # (64,3), 0x10008000 + (2 * 64 + 63) * 4
    .word 0x100082fc
MIDDLERIGHT: # (34,3)
    .word 0x1000808f
BOTTOMLEFT: # (64,1), 0x10008000 + 63 * (64 * 4)
    .word 0x1000bf00
##############################################################################
# Code
##############################################################################
	.text
	.globl main

    # Set up the walls.

    li $t1, 0x808080  # Store gray in $t1.
    lw $a0, LEFT # Set t0 the first address to be painted (left neck)
    addi $a1, $zero, 3 # a1=3, the length of the left neck
    add $t0, $zero, $zero # Length counter. Currently zero.
    jal draw_vertical_line
    # Now draw the right neck
    lw $a0, RIGHT
    addi $a1, $zero, 3
    add $t0, $zero, $zero
    jal draw_vertical_line
    # Now draw the left vertical body
    lw $a0, TOPLEFT
    addi $a1, $zero, 62
    add $t0, $zero, $zero
    jal draw_vertical_line
    # Now draw the right vertical body
    lw $a0, TOPRIGHT
    addi $a1, $zero, 62
    add $t0, $zero, $zero
    jal draw_vertical_line

    lw $a0, TOPLEFT
    addi $a1, $zero, 30
    add $t0, $zero, $zero
    jal draw_horizontal_line

    addi $a0, $a0, 20
    addi $a1, $zero, 30
    add $t0, $zero, $zero
    jal draw_horizontal_line

    lw $a0, BOTTOMLEFT
    addi $a1, $zero, 63
    add $t0, $zero, $zero
    jal draw_horizontal_line


    li $v0, 10 # exit the program gracefully
    syscall

draw_vertical_line:
    #  $a0 = starting address
    #  $a1 = length of the line
    sw $t1, 0($a0) # Color a0 gray
    addi $t0, $t0, 1 # Increment length counter by 1
    addi $a0, $a0, 256 # Go to the next row. 256 = 64 * 4
    beq $t0, $a1, draw_vertical_line_end # if length numbers painted, break out
    j draw_vertical_line
    draw_vertical_line_end:
    jr $ra

draw_horizontal_line:
    #  $a0 = starting address
    #  $a1 = length of the line
    sw $t1, 0($a0) # Color a0 gray
    addi $t0, $t0, 1 # Increment length counter by 1
    addi $a0, $a0, 4 # Go to the next unit
    beq $t0, $a1, draw_horizontal_line_end # if length numbers painted, break out
    j draw_horizontal_line
    draw_horizontal_line_end:
    jr $ra

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
