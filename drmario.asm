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
Array: # array to store information of capsules
    .space 11196
##############################################################################
# Code
##############################################################################
	.text
	.globl main

    ############################# Set up array to store capsules #############
    # My idea: there's no tuple structure in Assembly, so every 6 digits store
    # a capsule: (head_address, head_color, head_checked,
    # tail_address, tail_color, tail_checked). _checked are for each row check
    # in elimination check and should reset to zero after each row check. There
    # are in total 3732 blocks available, so the array needs size 3732*3=11196.
    la $s0, Array # s0 stores the address of array
    add $s3, $zero, $zero # s3 stores the current index in the array (initialized at 0)

    ############################# Set up walls ################################

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

    ############################# First capsule ################################
main:    
    jal create_capsule
    
    j game_loop

    #### Delete capsule
    # lw $t0, MIDDLE
    # jal delete_capsule

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
    lw $t0, MIDDLE
    addi $a3, $zero, 1
    
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
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    sw $t1, 0($t0) # Color the head

    beq $a3, 1, horizontal_pixel # Check direction
    beq $a3, 2, vertical_pixel
    horizontal_pixel:
        sw $t2, 4($t0)
    lw $ra, 0($sp)
    addi $sp, $sp, 4
        jr $ra
    vertical_pixel:
        sw $t2, 256($t0)
    lw $ra, 0($sp)
    addi $sp, $sp, 4
        jr $ra

delete_capsule:
    # $t0 = head address of the capusle
    # $a3 = direction (1 for horizontal and 2 for vertical)

    addi $sp, $sp, -4      # Allocate space on the stack
    sw $ra, 0($sp)         # Save $ra onto the stack
    
    add $s1, $zero, $t1 # store original colors for later restoration
    add $s2, $zero, $t2
    lw $t1, BLACK
    lw $t2, BLACK
    jal make_capsule
    add $t1, $zero, $s1 # restore t1 and t2
    add $t2, $zero, $s2
    
    lw $ra, 0($sp)         # Restore $ra from the stack
    addi $sp, $sp, 4       # Deallocate stack space

    jr $ra

generate_virus:
# initialize loop counter
# beq, 4 check to see loop counter == 4
draw_virus_loop:
# randomly generate a color and store it
# randomly generate a location

j draw_virus_loop
end_draw_virus_loop:



game_loop:
    # 1a. Check if key has been pressed
    lw $t3, ADDR_KBRD # t3 is the base address for keyboard
    lw $t4, 0($t3) # load value at ADDR_KBRD to t4
    beq $t4, 0, sleep
    # 1b. Check which key has been pressed
    lw $t3, KEY_VAL
    lw $t4, 0($t3)              # load keyboard value to t4
    beq $t4, 0x77, W            # 0x77 is the ASCII value for W
    beq $t4, 0x61, A
    beq $t4, 0x73, S
    beq $t4, 0x64, D
    # beq $t4, , P (e)
    beq $t4, 0x71, Q
    j sleep
    j game_loop

    W:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
        beq $a3, 1, hor_to_ver
        beq $a3, 2, ver_to_hor
        hor_to_ver: # horizontal to vertical
        addi $t5, $t0, 256 # check if the block under the head is colored
        lw $t5, 0($t5)
        bne $t5, 0x0, W_end
        jal delete_capsule
        addi $a3, $zero, 2
        jal make_capsule
        W_end:
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra
        ver_to_hor:
        subi $t5, $t0, 4 # check if the block to the left of the head is colored
        lw $t6, 0($t5) # t6 temporarily stores the color to the left of the head
        # Note here that t5 is the address, t6 is the value.
        bne $t6, 0x0, W_end
        jal delete_capsule
        addi $a3, $zero, 1
        add $t0, $zero, $t5 # change the head
        # switch t1 and t2
        add $t6, $zero, $t1 # now t6 stores t2 (temp for var switch)
        add $t1, $zero, $t2
        add $t2, $zero, $t6
        jal make_capsule
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

    A:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
        subi $t5, $t0, 4 # check if the block to the left of the head is colored
        # beq $t5, 0, move_left
        lw $t5, 0($t5)
        bne $t5, 0x0, A_end
        move_left:
        jal delete_capsule
        subi $t0, $t0, 4
        jal make_capsule
        # orientation will be the same
    A_end:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

    D:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
        addi $t5, $t0, 8 # check if the block to the right of the tail is colored
        # beq $t5, 0, move_right
        lw $t5, 0($t5)
        bne $t5, 0x0, D_end
        move_right:
        jal delete_capsule
        addi $t0, $t0, 4
        jal make_capsule
    D_end:
    lw $ra, 0($sp)
    addi $sp, $sp, -4
    jr $ra

    S:
    # $a3 = direction (1 for horizontal and 2 for vertical)
    addi $sp, $sp, -4
    sw $ra, 0($sp)
        beq $a3, 1, down_horizontal             # check to see aligment is horizontal
        beq $a3, 2, down_vertical               # check to see alignment is vertical

        down_horizontal:
        addi $t5, $t0, 256                      # from base address to memory address of pixel below
        lw $t6, 0($t5)                          # fetch its value from memory and store it temporarily in a register
        bne $t6, 0x0, collision                 # check to see if that value is black or not and if it is not black, then go to S_end
        addi $t5, $t0, 260                      # from base address to memory address of pixel below and 1 unit right
        lw $t6, 0($t5)                          # fetch its value from memory and store it temporarily in a register
        bne $t6, 0x0, collision                 # check to see if that value is black or not and if it is not black, then go to S_end
        # path is clear
        jal delete_capsule
        addi $t0, $t0, 256
        jal make_capsule
        j S_end

        down_vertical:
        addi $t5, $t0, 512                      # from base address to memory address of pixel 2 rows below
        lw $t6, 0($t5)                          # fetch its value from memory and store it temporarily in a register
        bne $t6, 0x0, collision                     # check to see if that value is black or not and if it is not black, then go to S_end
        # path is clear
        jal delete_capsule
        addi $t0, $t0, 256
        jal make_capsule

    S_end:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
        # go the memory address of the pixel below the base address
    collision: # Assumption: This is the only possible place to "halt" current capsule and make a new capsule.
        # Eliminate 4-in-a-row, iteratively.

        # If the bottle entrance is blocked, end the game. [I don't think we really have to implement this]

        # j main # Create a new capsule at the top and refresh all capsule-related variables (t0,a3,t1,t2) to the new capsule.

add_capsule_in_array:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    # t7 stores address of current index
    sll $t7, $s3, 2 # offset = index (s3) * 4
    add $t7, $t7, $s0 # address = base address (s0) + offset
    sw $t0, 0($t7) # load head_address
    sw $t1, 4($t7) # load head_color
    sw $zero, 8($t7) # load head_checked
    beq $a3, 1, horizontal_tail
    beq $a3, 2, vertical_tail
    addi $s3, $s3, 6 # increase the index by 6
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    horizontal_tail:
        addi $sp, $sp, -4
        sw $ra, 0($sp)
        addi $t5, $t0, 4
        sw $t5, 12($t7) # load tail_address
        sw $t2, 16($t7) # load tail_color
        sw $zero, 20($t7) # load tail_checked
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra
    vertical_tail:
        addi $sp, $sp, -4
        sw $ra, 0($sp)
        addi $t5, $t0, 256
        sw $t5, 12($t7) # load tail_address
        sw $t2, 16($t7) # load tail_color
        sw $zero, 20($t7) # load tail_checked
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra
elimination_check:
    # For each block (3 digits) in the array, if it is checked, pass; 
    # if it is not checked yet, traverse the row in which this block is located (by address, you might need a helper fucntion),
    # traverse all blocks on this row and in the array, count the blocks with the same color while marking them as checked,
    # when the counter reaches 4, remove every block of this color on this row.
    # Let the blocks "drop" if necessary.



    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep
    sleep:
    li $v0, 32
    addi $a0, $zero, 17 # 16.67 milliseconds = 1/60 second
    syscall
    # 5. Go back to Step 1
    j game_loop

Q:
    li $v0, 10 # exit the program gracefully
    syscall
    
