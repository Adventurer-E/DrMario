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
KEY_VAL:
    .word 0xffff0004

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
RED:
    .word 0xff0000
BLUE:
    .word 0x0000ff
YELLOW:
    .word 0xffff00
BLACK:
    .word 0x000000
##############################################################################
# Code
##############################################################################
	.text
	.globl main

    ##### Set up the walls.

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

    ##### First capsule
    lw $t0, MIDDLE
    addi $a3, $zero, 1
    jal create_capsule

    #### Delete capsule
    # lw $t0, MIDDLE
    # jal delete_capsule

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

    ##### First capsule
    lw $t0, MIDDLE
    addi $a3, $zero, 1
    jal create_capsule
    
    lw $t0, BOTTOMLEFT
    addi $a3, $zero, 1
    jal create_capsule

    li $v0, 10 # exit the program gracefully
    syscall

determine_color_1:
    # Map number 0,1,2 to the three colors.
    # $t1 = number 0,1,2
    beq $t1, 0, is_red_1
    beq $t1, 1, is_blue_1
    beq $t1, 2, is_yellow_1
    is_red_1:
        lw $t1, RED
        jr $ra
    is_blue_1:
        lw $t1, BLUE
        jr $ra
    is_yellow_1:
        lw $t1, YELLOW
        jr $ra

determine_color_2:
    # Map number 0,1,2 to the three colors.
    # $t2 = number 0,1,2
    beq $t2, 0, is_red_2
    beq $t2, 1, is_blue_2
    beq $t2, 2, is_yellow_2
    is_red_2:
        lw $t2, RED
        jr $ra
    is_blue_2:
        lw $t2, BLUE
        jr $ra
    is_yellow_2:
        lw $t2, YELLOW
        jr $ra

create_capsule:
    # $t0 = head address of the capusle
    # $a3 = direction (1 for horizontal and 2 for vertical)
    addi $sp, $sp, -4      # Allocate space on the stack
    sw $ra, 0($sp)         # Save $ra onto the stack

    li $v0, 42 # For randomness
    li $a0, 0 # required random number generator
    li $a1, 3 # maximum number for random call
    syscall # the color is stored in a0
    add $t1, $zero, $a0 # store random number (0,1,2) in t1
    jal determine_color_1 # color1 is stored in t1

    li $v0, 42
    li $a0, 0
    li $a1, 3
    syscall
    add $t2, $zero, $a0
    jal determine_color_2 # color2 is stored in t2

    jal make_capsule

    lw $ra, 0($sp)         # Restore $ra from the stack
    addi $sp, $sp, 4       # Deallocate stack space

    jr $ra

make_capsule:
    # $t0 = head address of the capusle
    # $t1 = color1
    # $t2 = color2
    # $a3 = direction (1 for horizontal and 2 for vertical)
    sw $t1, 0($t0) # Color the head

    beq $a3, 1, horizontal_pixel # Check direction
    beq $a3, 2, vertical_pixel
    horizontal_pixel:
        sw $t2, 4($t0)
        jr $ra
    vertical_pixel:
        sw $t2, 256($t0)
        jr $ra

delete_capsule:
    # $t0 = head address of the capusle
    # $t1 = color1
    # $t2 = color2
    # $a3 = direction (1 for horizontal and 2 for vertical)

    addi $sp, $sp, -4      # Allocate space on the stack
    sw $ra, 0($sp)         # Save $ra onto the stack

    lw $t1, BLACK
    lw $t2, BLACK
    jal make_capsule

    lw $ra, 0($sp)         # Restore $ra from the stack
    addi $sp, $sp, 4       # Deallocate stack space

    jr $ra


    # Run the game.
main:
    # Initialize the game

game_loop:
    # 1a. Check if key has been pressed
    lw $t3, ADDR_KBRD # t3 is the base address for keyboard
    lw $t4, 0($t3) # load value at ADDR_KBRD to t4
    beq $t4, 0, sleep
    # 1b. Check which key has been pressed
    lw $t4, 1($t3) # load keyboard value to t4
    beq $t4, 0x77, W
    beq $t4, 0x61, A
    beq $t4, 0x73, S
    beq $t4, 0x64, D
    beq $t4, 0x71, quit

    A:
    subi $t5, $t0, 4
    beq $t5, 0, move_left
    move_left:
    jal delete_capsule
    subi $t0, $t0, 4
    jal make_capsule
    # orientation will be the same

    D:
    addi $t5, $t0, 8
    beq $t5, 0, move_right
    move_right:
    jal delete_capsule
    addi $t0, $t0, 8
    jal make_capsule

    S:
    addi $t5, $t0, 256
    beq $t5, 0, move_down
    move_down:
    jal delete_capsule
    addi $t0, $t0, 256
    jal make_capsule



    # W:
    # addi $sp, $sp, -4
    # sw $ra, 0($sp)
        # beq $a3, 1, hor_to_ver
        # beq $a3, 2, ver_to_hor
        # hor_to_ver: # horizontal to vertical
        # add $t5, $t0, 256 # check if the block under the head is colored
        # bne $t5, 0, W_end
        # jal delete_capsule
        # addi $a3, $zero, 2
        # jal make_capsule
        # W_end:
        # lw $ra, 0($sp)
        # addi $sp, $sp, 4
        # jr $ra
        
        
        
    A:
    S:
    D:

    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep
    sleep:
    # 5. Go back to Step 1
    # j game_loop

quit:
    li $v0, 10 # exit the program gracefully
    syscall