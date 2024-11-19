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
LOWERHALF: # (1,34), 0x10008000 + 33 * (64 * 4)
    .word 0x1000a100
RED:
    .word 0xff0000
BLUE:
    .word 0x0000ff
YELLOW:
    .word 0xffff00
BLACK:
    .word 0x000000
Array: # array to store information of capsules
    .space 29856
Arr: # array to store memory address of colors
    .space 16
##############################################################################
# Code
##############################################################################
	.text
	.globl main

    ############################# Set up array to store capsules #############
    # My idea: there's no tuple structure in Assembly, so every 6 digits store
    # a capsule: (head_address, head_color, tail_address, tail_color). There
    # are in total 3732 blocks available, so the array needs size 3732*2*4=29856.
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

    ############################# Set up viruses ################################
 # Currently, 4 viruses.
    addi $t2, $zero, 4 # in this section (before making capsules), t2 stores the number of viruses
    add $t3, $zero, $zero # t3 stores current number of visuses (accumulator)
new_virus:
    # y-coord of random location
    li $v0, 42
    li $a0, 0
    li $a1, 30
    syscall # stored at a0
    subi $a0, $a0, 1 # first row inclusive
    sll $t4, $a0, 8 # times 256, temp stored in $t4
    lw $t0, LOWERHALF
    add $t0, $t0, $t4 # vertically moved
    # x-coord of random location
    li $v0, 42
    li $a0, 0
    li $a1, 62
    syscall # stored at a0
    sll $a0, $a0, 2 # times 4
    add $t0, $t0, $a0 # horizontally moved
    # random color
    li $v0, 42
    li $a0, 0
    li $a1, 3
    syscall
    add $t1, $zero, $a0
    jal determine_color_1
    # paint
    sw $t1, 0($t0)
    # increment
    addi $t3, $t3, 1
    beq $t3, $t2, virus_end
    j new_virus
virus_end:

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
    # addi $sp, $sp, -4
    # sw $ra, 0($sp)
    # t7 stores address of current index
    sll $t7, $s3, 2 # offset = index (s3) * 4
    add $t7, $t7, $s0 # address = base address (s0) + offset
    sw $t0, 0($t7) # load head_address
    sw $t1, 4($t7) # load head_color
    beq $a3, 1, horizontal_tail
    beq $a3, 2, vertical_tail

    # lw $ra, 0($sp)
    # addi $sp, $sp, 4
    # jr $ra
    horizontal_tail:
        # addi $sp, $sp, -4
        # sw $ra, 0($sp)
        addi $t5, $t0, 4
        sw $t5, 8($t7) # load tail_address
        sw $t2, 12($t7) # load tail_color
        j add_capsule_in_array_end
        # lw $ra, 0($sp)
        # addi $sp, $sp, 4
        # jr $ra
    vertical_tail:
        # addi $sp, $sp, -4
        # sw $ra, 0($sp)
        addi $t5, $t0, 256
        sw $t5, 8($t7) # load tail_address
        sw $t2, 12($t7) # load tail_color
        j add_capsule_in_array_end
        # lw $ra, 0($sp)
        # addi $sp, $sp, 4
        # jr $ra
    add_capsule_in_array_end:
    addi $s3, $s3, 4 # increase the index by 4

elimination_check:
# $t5 stores the memory address of current pixel
# $t6 stores the color of current pixel
la $s4, Arr
add $s5, $s4, $zero                 # keeps track of the current memory address

lw $t1, 0($t0)                      # load pixel color of base address
jal horizontal_check
beq $a3, 1, horizontal_tail_elim
beq $a3, 2, vertical_tail_elim
horizontal_tail_elim:
    addi $t0, $t0, 4
    j tail_elim_end
vertical_tail_elim:
    addi $t0, $t0, 256
tail_elim_end:
jal horizontal_check
beq $a3, 1, horizontal_tail_elim_restore
beq $a3, 2, vertical_tail_elim_restore
horizontal_tail_elim_restore:
    subi $t0, $t0, 4
    j tail_elim_restore_end
vertical_tail_elim_restore:
    subi $t0, $t0, 256
tail_elim_restore_end:




jal create_capsule
j game_loop
horizontal_check:                   # check to see if horizontal pixels have the same color
addi $sp, $sp, -4
sw $ra, 0($sp)

check_left:                         # go 3 pixels to the left
add $t7, $zero, $zero               # counter

subi $t5, $t0, 4                    # memory address of 1 pixel left
lw $t6, 0($t5)                      # load pixel color of that memory address
bne $t6, $t1, check_left_end        # $t1 = pixel color of base address, $t6 = pixel color of 1L
addi $t7, $t7, 1                    # consecutive values = +1 to the counter
sw $t5, 0($s5)
addi $s5, $s5, 4

subi $t5, $t0, 8                    # memory address 2 pixels left
lw $t6, 0($t5)                      # load pixel color that memory address
bne $t6, $t1, check_left_end        # $t5 = pixel color of 2L, $t6 = pixel color of 1L
addi $t7, $t7, 1                    # consecutive values = +1 to the counter
sw $t5, 0($s5)
addi $s5, $s5, 4

subi $t5, $t0, 12                   # memory address 3 pixels left
lw $t6, 0($t5)                      # load pixel color that memory address
bne $t6, $t1, check_left_end         # $t5 = pixel color of 2L, $t6 = pixel color of 3L
addi $t7, $t7, 1                    # consecutive values = +1 to the counter
sw $t5, 0($s5)
addi $s5, $s5, 4

check_left_end:
# go back to base address
addi $t7, $t7, 1
sw $t0, 0($s5)
addi $s5, $s5, 4
beq $t7, 4, four_found              # all 3 pixels to the left have the same color

check_right:

addi $t5, $t0, 4                    # memory address of 1 pixel right
lw $t6, 0($t5)                      # load pixel color of that memory address
bne $t6, $t1, check_right_end       # $t1 = pixel color of base address, $t6 = pixel color of 1R
addi $t7, $t7, 1                    # consecutive values = +1 to the counter
sw $t5, 0($s5)
addi $s5, $s5, 4
beq $t7, 4, four_found

addi $t5, $t0, 8                    # memory address 2 pixels right
lw $t6, 0($t5)                      # load pixel color that memory address
bne $t6, $t1, check_right_end       # $t5 = pixel color of 2R, $t6 = pixel color of 1R
addi $t7, $t7, 1                    # consecutive values = +1 to the counter
sw $t5, 0($s5)
addi $s5, $s5, 4
beq $t7, 4, four_found

addi $t5, $t0, 12                   # memory address 3 pixels right
lw $t6, 0($t5)                      # load pixel color that memory address
bne $t6, $t1, check_right_end       # $t5 = pixel color of 2R, $t6 = pixel color of 3R
addi $t7, $t7, 1                    # consecutive values = +1 to the counter
sw $t5, 0($s5)
beq $t7, 4, four_found

check_right_end:

check_top:
subi $t5, $t0, 256
lw $t6, 0($t5)
bne $t6, $t1, check_top_end
addi $t7, $t7, 1
sw $t5, 0($s5)
addi $s5, $s5, 4

subi $t5, $t0, 512
lw $t6, 0($t5)
bne $t6, $t1, check_top_end
addi $t7, $t7, 1
sw $t5, 0($s5)
addi $s5, $s5, 4

subi $t5, $t0, 768
lw $t6, 0($t5)
bne $t6, $t1, check_top_end
addi $t7, $t7, 1
sw $t5, 0($s5)
addi $s5, $s5, 4
beq $t7, 4, four_found

check_top_end:

check_bottom:

addi $t5, $t0, 256
lw $t6, 0($t5)
bne $t6, $t1, check_bottom_end
addi $t7, $t7, 1
sw $t5, 0($s5)
addi $s5, $s5, 4
beq $t7, 4, four_found

addi $t5, $t0, 512
lw $t6, 0($t5)
bne $t6, $t1, check_bottom_end
addi $t7, $t7, 1
sw $t5, 0($s5)
addi $s5, $s5, 4
beq $t7, 4, four_found

addi $t5, $t0, 768
lw $t6, 0($t5)
bne $t6, $t1, check_bottom_end
addi $t7, $t7, 1
sw $t5, 0($s5)
addi $s5, $s5, 4
beq $t7, 4, four_found

check_bottom_end:
j check_end


four_found:
    lw $t1, BLACK
    lw $t2, 0($s4)      # load memory address of index 0 in $t2
    sw $t1, 0($t2)      # color that memory address black
    lw $t2, 4($s4)      # load memory address of index 1 in $t2
    sw $t1, 0($t2)
    lw $t2, 8($s4)      # load memory address of index 2 in $t2
    sw $t1, 0($t2)
    lw $t2, 12($s4)      # load memory address of index 3 in $t2
    sw $t1, 0($t2)


lw $t2, BLACK
add $t1, $zero, $zero                                   # inner loop counter
add $s3, $s0, $zero                                     # initialize $s3 = current memory address of Array

arr_loop_start:
add $s5, $s4, $zero                                     # initialize $s5 = current memory address of arr
arr_loop:
bne $s5, $s3, address_not_equal                         # check if the memory addresses are equal
lw $t2, 4($s3)                                          # color stored in the memory address of next element in Arr = black
address_not_equal:
addi $s5, $s5, 4                                        # go to the next memory address
addi $t1, $t1, 1                                        # increment loop counter
beq $t1, 4, arr_loop_end                                # check to see if we have iterated through the entire array
j arr_loop                                              # if we have reached the end, then continue the loop

arr_loop_end:
addi $s3, $s3, 8 # go to the next memory address in Array
j arr_loop_start

exit_loop:

check_end:
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra




drop:
    # start from s0, the base address of Array. Traverse Array to find all half-capsules.
    # Since the old capusle is no longer used, t0,t1,t2,t3 will be reset.
    # During the traversal, t0=head_address, t1=head_color, t2=tail_color
    add $t6, $s0, $zero # t6 stores the current address (location) in Array
    # If current capsule is full, (recursively) perform S.
    # If it's half, drop the half capsule.
    # If it's wholly black, disregard it: link it to the nex item in Array.
drop_loop:
    lw $t0, 0($t6)
    lw $t5, 8($t6)
    lw $t1, 4($t6)
    lw $t2, 12($t6)
    bne $t1, 0x0, half_or_full
    bne $t2, 0x0, half_2 # t1 black, t2 not black
    j wholly_black # both black
    half_or_full:
    bne $t2, 0x0, full # both not black
    j half_1 # t1 not black, t2 black
    full:
        sub $t5, $t5, $t0 # check direction
        beq $t5, 4, is_horizontal
        beq $t5, 256, is_vertical
        # Now that t0,t1,t2,a3 are initialized
        jal full_drop
        # Update the capsule info in Array
        sw $t0, 0($t6)
        sw $t1, 4($t6)
        sw $t2, 12($t6)
        addi $t5, $t5, 4
        sw $t5, 8($t6)
        # TODO: should recheck this capsule, but I'm afraid the loop will never halt
        addi $t6, $t6, 16
        j drop_loop
        is_horizontal:
        addi $sp, $sp, -4
        sw $ra, 0($sp)
            addi $a3, $zero, 1
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra
        is_vertical:
        addi $sp, $sp, -4
        sw $ra, 0($sp)
            addi $a3, $zero, 2
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra
    half_1:
        add $t5, $t0, 256 # t5 is now the address of the block under the head
        bne $t5, 0x0, half_1_end
        jal one_drop_1
        sw $t0, 0($t6)
        sw $t1, 4($t6)
        # TODO: should recheck this capsule, but I'm afraid the loop will never halt
        j half_1
        half_1_end:
        addi $t6, $t6, 16
        j drop_loop
    half_2:
        add $t0, $zero, $t5 # $t0 is the TAIL address
        add $t5, $t0, 256 # t5 is now the address of the block under the TAIL
        bne $t5, 0x0, half_2_end
        jal one_drop_2
        sw $t0, 8($t6)
        sw $t2, 12($t6)
        # TODO: should recheck this capsule, but I'm afraid the loop will never halt
        j half_2
        half_2_end:
        addi $t6, $t6, 8
        j drop_loop
    wholly_black:
        # Shift all items in the array to the left.
        # the next capsule = (t8, s1, t9, s2)
        lw $t8, 16($t6)
        lw $s1, 20($t6)
        lw $t9, 24($t6)
        lw $s2, 28($t6)
        sw $t8, 0($t6)
        sw $s1, 4($t6)
        sw $t9, 8($t6)
        sw $s2, 12($t6)
        add $t6, $t6, 16
        j drop_loop

full_drop:
addi $sp, $sp, -4
sw $ra, 0($sp)
        
    beq $a3, 1, full_drop_horizontal             # check to see aligment is horizontal
    beq $a3, 2, full_drop_vertical               # check to see alignment is vertical

    full_drop_horizontal:
    addi $t5, $t0, 256                      # from base address to memory address of pixel below
    lw $t6, 0($t5)                          # fetch its value from memory and store it temporarily in a register
    bne $t6, 0x0, full_drop_end                 # check to see if that value is black or not and if it is not black, then go to S_end
    addi $t5, $t0, 260                      # from base address to memory address of pixel below and 1 unit right
    lw $t6, 0($t5)                          # fetch its value from memory and store it temporarily in a register
    bne $t6, 0x0, full_drop_end                 # check to see if that value is black or not and if it is not black, then go to S_end
    # path is clear
    jal delete_capsule
    addi $t0, $t0, 256
    jal make_capsule
    jal full_drop

    full_drop_vertical:
    addi $t5, $t0, 512                      # from base address to memory address of pixel 2 rows below
    lw $t6, 0($t5)                          # fetch its value from memory and store it temporarily in a register
    bne $t6, 0x0, full_drop_end                     # check to see if that value is black or not and if it is not black, then go to S_end
    # path is clear
    jal delete_capsule
    addi $t0, $t0, 256
    jal make_capsule
    jal full_drop
full_drop_end: 
# j elimination_check
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

one_drop_1:
addi $sp, $sp, -4
sw $ra, 0($sp)
    add $s1, $zero, $t1
    lw $t1, BLACK
    sw $t1, 0($t0)
    add $t1, $zero, $s1
    add $t0, $t0, 256
    sw $t1, 0($t0)
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

one_drop_2:
addi $sp, $sp, -4
sw $ra, 0($sp)
    add $s2, $zero, $t2
    lw $t2, BLACK
    sw $t2, 0($t0)
    add $t2, $zero, $s2
    add $t0, $t0, 256
    sw $t2, 0($t0)
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

# check to see the color of the consecutive pixels have the same color
# if yes, add 1 to the counter

# iterate three pixels to the right

vertical_check:         # check to see if vertical pixels have the same color


# from base address to memory address of pixel to left
# from base address to memory address of pixel to right
# from base address to memory address of pixel to top
# from base address to memory address of pixel to bottom




# elimination_check:
    # For each block (2 digits) in the array, if it is checked, pass; 
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
    
