################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Dr Mario.
#
# Student 1: Eric Lu, 1010393487
# Student 2: Ayusha Thapa, 1009861972
#
# We assert that the code submitted here is entirely our own
# creation, and will indicate otherwise when it is not.
#ss
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
LEFT:  # (22,1), 0x10008000 + 21 * 4
    .word 0x10008054
RIGHT: # (27,1)
    .word 0x10008068
MIDDLE: # (24,1)
    .word 0x1000805c
TOPLEFT:   # (1,3), 0x10008000 + 2 * 64 * 4
    .word 0x10008200
TOPRIGHT:  # (50,3), 0x10008000 + (2 * 64 + 49) * 4
    .word 0x100082c4
MIDDLERIGHT: # (27,3)
    .word 0x10008070
BOTTOMLEFT: # (1,64), 0x10008000 + 63 * (64 * 4)
    .word 0x1000bf00
LOWERHALF: # (1,34), 0x10008000 + 33 * (64 * 4)
    .word 0x1000a100
RED:
    .word 0xff0000
BLUE:
    .word 0x87ceeb
YELLOW:
    .word 0xffff00
BLACK:
    .word 0x000000
Array: # array to store information of capsules
    .space 29856
Arr: # array to store memory address of colors
    .space 16
Virus_Arr: # array that stores virus's info
    .space 32
ONE: # (56,1)
    .word 0x100080dc
TWO: # (56,3)
    .word 0x100082dc
THREE: # (56,5)
    .word 0x100084dc
FOUR: # (56,7)
    .word 0x100086dc
DRAW_START:
    .word 0x10008074
DRAW_END:
    .word 0x1000bccc
WHITE:
    .word 0xffffff
DRAW_MID:
    .word 0x10008cd0
Preview_Array: # array to store capsules preview
    .space 32
music_notes: .word 82,83,82,83,81,79,79,81,82,83,81,79,79,79,79,
                    82,83,82,83,81,79,79,81,71,71,72,72,73,73,74,74


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

############################# Set up big Viruses ################################
# Main program
lw $t2, RED
lw $t1, DRAW_MID

draw_red_virus:
    sw $t2, 4($t1)
    sw $t2, 256($t1)
    sw $t2, 264($t1)        # start of virus body
    sw $t2, 520($t1)
    sw $t2, 776($t1)
    sw $t2, 1024($t1)
    sw $t2, 1284($t1)
    sw $t2, 1032($t1)
    sw $t2, 524($t1)
    sw $t2, 1036($t1)
    sw $t2, 1292($t1)
    sw $t2, 528($t1)
    sw $t2, 784($t1)
    sw $t2, 1040($t1)
    sw $t2, 1296($t1)
    sw $t2, 532($t1)
    sw $t2, 1044($t1)
    sw $t2, 1300($t1)
    sw $t2, 280($t1)
    sw $t2, 536($t1)
    sw $t2, 792($t1)
    sw $t2, 1048($t1)
    sw $t2, 1308($t1)
    sw $t2, 1056($t1)
    sw $t2, 28($t1)
    sw $t2, 288($t1)

lw $t2, BLUE
addi $t1, $t1, 2048
draw_blue_virus:
    sw $t2, 4($t1)
    sw $t2, 256($t1)
    sw $t2, 264($t1)        # start of virus body
    sw $t2, 520($t1)
    sw $t2, 776($t1)
    sw $t2, 1024($t1)
    sw $t2, 1284($t1)
    sw $t2, 1032($t1)
    sw $t2, 524($t1)
    sw $t2, 1036($t1)
    sw $t2, 1292($t1)
    sw $t2, 528($t1)
    sw $t2, 784($t1)
    sw $t2, 1040($t1)
    sw $t2, 1296($t1)
    sw $t2, 532($t1)
    sw $t2, 1044($t1)
    sw $t2, 1300($t1)
    sw $t2, 280($t1)
    sw $t2, 536($t1)
    sw $t2, 792($t1)
    sw $t2, 1048($t1)
    sw $t2, 1308($t1)
    sw $t2, 1056($t1)
    sw $t2, 28($t1)
    sw $t2, 288($t1)

lw $t2, YELLOW
addi $t1, $t1, 2048
  draw_yellow_virus:
    sw $t2, 4($t1)
    sw $t2, 256($t1)
    sw $t2, 264($t1)        # start of virus body
    sw $t2, 520($t1)
    sw $t2, 776($t1)
    sw $t2, 1024($t1)
    sw $t2, 1284($t1)
    sw $t2, 1032($t1)
    sw $t2, 524($t1)
    sw $t2, 1036($t1)
    sw $t2, 1292($t1)
    sw $t2, 528($t1)
    sw $t2, 784($t1)
    sw $t2, 1040($t1)
    sw $t2, 1296($t1)
    sw $t2, 532($t1)
    sw $t2, 1044($t1)
    sw $t2, 1300($t1)
    sw $t2, 280($t1)
    sw $t2, 536($t1)
    sw $t2, 792($t1)
    sw $t2, 1048($t1)
    sw $t2, 1308($t1)
    sw $t2, 1056($t1)
    sw $t2, 28($t1)
    sw $t2, 288($t1)

############################# Set up Dr. Mario ################################
# brown shoes
li $t2, 0xbe5014
lw $t1, DRAW_END
sw $t2, 4($t1)
sw $t2, 8($t1)
sw $t2, 12($t1)
sw $t2, 256($t1)
sw $t2, 260($t1)
sw $t2, 264($t1)
sw $t2, 268($t1)
sw $t2, 512($t1)
sw $t2, 516($t1)
sw $t2, 520($t1)
sw $t2, 524($t1)
sw $t2, 32($t1)
sw $t2, 36($t1)
sw $t2, 40($t1)
sw $t2, 288($t1)
sw $t2, 292($t1)
sw $t2, 296($t1)
sw $t2, 300($t1)
sw $t2, 544($t1)
sw $t2, 548($t1)
sw $t2, 552($t1)
sw $t2, 556($t1)
subi $t1, $t1, 2560
lw $t2, RED
sw $t2, 8($t1)
sw $t2, 12($t1)
sw $t2, 20($t1)
sw $t2, 24($t1)
sw $t2, 32($t1)
sw $t2, 36($t1)
sw $t2, 264($t1)
sw $t2, 268($t1)
sw $t2, 276($t1)
sw $t2, 280($t1)
sw $t2, 288($t1)
sw $t2, 292($t1)
sw $t2, 520($t1)
sw $t2, 516($t1)
sw $t2, 524($t1)
sw $t2, 776($t1)
sw $t2, 772($t1)
sw $t2, 768($t1)
sw $t2, 780($t1)
sw $t2, 1036($t1)
sw $t2, 544($t1)
sw $t2, 548($t1)
sw $t2, 552($t1)
sw $t2, 800($t1)
sw $t2, 1056($t1)
sw $t2, 804($t1)
sw $t2, 808($t1)
sw $t2, 812($t1)
# blue clothes
li $t2, 0x1b86f2
sw $t2, 16($t1)
sw $t2, 28($t1)
sw $t2, 272($t1)
sw $t2, 284($t1)
sw $t2, 528($t1)
sw $t2, 540($t1)
sw $t2, 532($t1)
sw $t2, 536($t1)
sw $t2, 784($t1)
sw $t2, 796($t1)
sw $t2, 788($t1)
sw $t2, 792($t1)
sw $t2, 1040($t1)
sw $t2, 1052($t1)
sw $t2, 1044($t1)
sw $t2, 1048($t1)
sw $t2, 1296($t1)
sw $t2, 1292($t1)
sw $t2, 1308($t1)
sw $t2, 1312($t1)
sw $t2, 1312($t1)
sw $t2, 1300($t1)
sw $t2, 1304($t1)
sw $t2, 1552($t1)
sw $t2, 1548($t1)
sw $t2, 1548($t1)
sw $t2, 1564($t1)
sw $t2, 1568($t1)
sw $t2, 1556($t1)
sw $t2, 1560($t1)
sw $t2, 1808($t1)
sw $t2, 1804($t1)
sw $t2, 1820($t1)
sw $t2, 1824($t1)
sw $t2, 1812($t1)
sw $t2, 1816($t1)
sw $t2, 2064($t1)
sw $t2, 2076($t1)
sw $t2, 2064($t1)
sw $t2, 2060($t1)
sw $t2, 2056($t1)
sw $t2, 2076($t1)
sw $t2, 2080($t1)
sw $t2, 2084($t1)
sw $t2, 2068($t1)
sw $t2, 2072($t1)
sw $t2, 2320($t1)
sw $t2, 2316($t1)
sw $t2, 2312($t1)
sw $t2, 2332($t1)
sw $t2, 2336($t1)
sw $t2, 2340($t1)
# gray outlines
li $t2, 0xbfbfbf
sw $t2, 1024($t1)
sw $t2, 1280($t1)
sw $t2, 1536($t1)
sw $t2, 1792($t1)
sw $t2, 1796($t1)
sw $t2, 1800($t1)
sw $t2, 1068($t1)
sw $t2, 1324($t1)
sw $t2, 1580($t1)
sw $t2, 1836($t1)
sw $t2, 1832($t1)
sw $t2, 1828($t1)
# shade white
lw $t2, WHITE
sw $t2, 1028($t1)
sw $t2, 1032($t1)
sw $t2, 1284($t1)
sw $t2, 1288($t1)
sw $t2, 1540($t1)
sw $t2, 1544($t1)
sw $t2, 1060($t1)
sw $t2, 1064($t1)
sw $t2, 1320($t1)
sw $t2, 1316($t1)
sw $t2, 1576($t1)
sw $t2, 1572($t1)
# yellow buttons
lw $t2, YELLOW
sw $t2, 784($t1)
sw $t2, 796($t1)
subi $t1, $t1, 2816
# red hat
lw $t2, RED
sw $t2, 12($t1)
sw $t2, 16($t1)
sw $t2, 20($t1)
sw $t2, 24($t1)
sw $t2, 28($t1)
sw $t2, 268($t1)
sw $t2, 272($t1)
sw $t2, 276($t1)
sw $t2, 280($t1)
sw $t2, 284($t1)
sw $t2, 268($t1)
sw $t2, 272($t1)
sw $t2, 276($t1)
sw $t2, 280($t1)
sw $t2, 284($t1)
sw $t2, 520($t1)
sw $t2, 524($t1)
sw $t2, 528($t1)
sw $t2, 532($t1)
sw $t2, 536($t1)
sw $t2, 540($t1)
sw $t2, 544($t1)
sw $t2, 776($t1)
sw $t2, 780($t1)
sw $t2, 784($t1)
sw $t2, 788($t1)
sw $t2, 792($t1)
sw $t2, 796($t1)
sw $t2, 800($t1)
# skin color
li $t2, 0xf7c7ac
sw $t2, 1288($t1)
sw $t2, 1296($t1)
sw $t2, 1300($t1)
sw $t2, 1040($t1)
sw $t2, 1048($t1)
sw $t2, 1044($t1)
sw $t2, 1052($t1)
sw $t2, 1308($t1)
sw $t2, 1564($t1)
sw $t2, 1820($t1)
sw $t2, 1824($t1)
sw $t2, 2080($t1)
sw $t2, 2084($t1)
sw $t2, 1552($t1)
sw $t2, 1808($t1)
sw $t2, 2064($t1)
sw $t2, 1556($t1)
sw $t2, 1812($t1)
sw $t2, 2068($t1)
sw $t2, 2072($t1)
sw $t2, 1544($t1)
sw $t2, 1800($t1)
sw $t2, 2060($t1)
sw $t2, 2316($t1)
sw $t2, 2572($t1)
sw $t2, 2320($t1)
sw $t2, 2576($t1)
sw $t2, 2576($t1)
sw $t2, 2580($t1)
sw $t2, 2584($t1)
sw $t2, 2588($t1)
# eyes
lw, $t2, WHITE
sw $t2, 1304($t1)
li, $t2, 0x1b86f2
sw $t2, 1560($t1)
sw $t2, 1816($t1)



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
    addi $a1, $zero, 22
    add $t0, $zero, $zero
    jal draw_horizontal_line

    addi $a0, $a0, 20
    addi $a1, $zero, 23
    add $t0, $zero, $zero
    jal draw_horizontal_line

    lw $a0, BOTTOMLEFT
    addi $a1, $zero, 50
    add $t0, $zero, $zero
    jal draw_horizontal_line

############################# Set up preview array ################################
    la $s5, Preview_Array # s5 will be overwritten, so initialize it every time.
    # Create a capsule in the middle.
    lw $t0, MIDDLE
    jal create_new_capsule
    lw $t0, ONE
    jal create_new_capsule
    lw $t1, 0($t0)
    lw $t2, 4($t0)
    sw $t1, 0($s5)
    sw $t2, 4($s5)
    addi $s5, $s5, 8
    lw $t0, TWO
    jal create_new_capsule
    lw $t1, 0($t0)
    lw $t2, 4($t0)
    sw $t1, 0($s5)
    sw $t2, 4($s5)
    addi $s5, $s5, 8
    lw $t0, THREE
    jal create_new_capsule
    lw $t1, 0($t0)
    lw $t2, 4($t0)
    sw $t1, 0($s5)
    sw $t2, 4($s5)
    addi $s5, $s5, 8
    lw $t0, FOUR
    jal create_new_capsule
    lw $t1, 0($t0)
    lw $t2, 4($t0)
    sw $t1, 0($s5)
    sw $t2, 4($s5)
    la $s5, Preview_Array

    # Initialize t0, t1, t2, a3
    lw $t0, MIDDLE
    lw $t1, 0($t0)
    lw $t2, 4($t0)
    addi $a3, $zero, 1



    ############################# Set up viruses ################################
 # Currently, 4 viruses.
    la $s6, Virus_Arr


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
    li $a1, 48
    syscall # stored at a0
    addi $a0, $a0, 1
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
    # add virus to array
    sw $t0, 0($s6)
    sw $t1, 4($s6)
    addi $s6, $s6, 8
    # increment
    addi $t3, $t3, 1
    beq $t3, $t2, virus_end
    j new_virus
virus_end:

    ############################# First capsule ################################
main:
    # Initialize t0, t1, t2, a3
    lw $t0, MIDDLE
    lw $t1, 0($t0)
    lw $t2, 4($t0)
    addi $a3, $zero, 1

    add $s7, $zero, $zero, # s7 is the game loop counter
    add $t9, $zero, $zero # t9 is the counter for music notes
    j game_loop

    #### Delete capsule
    # lw $t0, MIDDLE
    # jal delete_capsule

 draw_vertical_line:
addi $sp, $sp, -4
sw $ra, 0($sp)
    #  $a0 = starting address
    #  $a1 = length of the line
    sw $t1, 0($a0) # Color a0 gray
    addi $t0, $t0, 1 # Increment length counter by 1
    addi $a0, $a0, 256 # Go to the next row. 256 = 64 * 4
    beq $t0, $a1, draw_vertical_line_end # if length numbers painted, break out
    j draw_vertical_line
    draw_vertical_line_end:
lw $ra, 0($sp)
addi $sp, $sp, 4
    jr $ra

draw_horizontal_line:
addi $sp, $sp, -4
sw $ra, 0($sp)
    #  $a0 = starting address
    #  $a1 = length of the line
    sw $t1, 0($a0) # Color a0 gray
    addi $t0, $t0, 1 # Increment length counter by 1
    addi $a0, $a0, 4 # Go to the next unit
    beq $t0, $a1, draw_horizontal_line_end # if length numbers painted, break out
    j draw_horizontal_line
    draw_horizontal_line_end:
lw $ra, 0($sp)
addi $sp, $sp, 4
    jr $ra

determine_color_1:
addi $sp, $sp, -4      # Allocate space on the stack
sw $ra, 0($sp)         # Save $ra onto the stack
    # Map number 0,1,2 to the three colors.
    # $t1 = number 0,1,2
    beq $t1, 0, is_red_1
    beq $t1, 1, is_blue_1
    beq $t1, 2, is_yellow_1
    is_red_1:
        lw $t1, RED
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra
    is_blue_1:
        lw $t1, BLUE
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra
    is_yellow_1:
        lw $t1, YELLOW
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra

determine_color_2:
addi $sp, $sp, -4
sw $ra, 0($sp)
    # Map number 0,1,2 to the three colors.
    # $t2 = number 0,1,2
    beq $t2, 0, is_red_2
    beq $t2, 1, is_blue_2
    beq $t2, 2, is_yellow_2
    is_red_2:
        lw $t2, RED
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra
    is_blue_2:
        lw $t2, BLUE
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra
    is_yellow_2:
        lw $t2, YELLOW
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra

create_capsule:
    addi $sp, $sp, -4      # Allocate space on the stack
    sw $ra, 0($sp)         # Save $ra onto the stack


# black virus
lw $t2, BLACK
lw $t1, DRAW_MID
sw $t2, 256($t1)
sw $t2, 1024($t1)
sw $t2, 288($t1)
sw $t2, 1056($t1)
addi $t1, $t1, 2304
sw $t2, 256($t1)
sw $t2, 1024($t1)
sw $t2, 288($t1)
sw $t2, 1056($t1)
addi $t1, $t1, 2304
sw $t2, 256($t1)
sw $t2, 1024($t1)
sw $t2, 288($t1)
sw $t2, 1056($t1)
lw $t2, RED
lw $t1, DRAW_MID
subi $t1, $t1, 256
sw $t2, 0($t1)
sw $t2, 32($t1)
sw $t2, 1792($t1)
sw $t2, 1824($t1)
lw $t2, BLUE
addi $t1, $t1, 2560
subi $t1, $t1, 256
sw $t2, 0($t1)
sw $t2, 32($t1)
sw $t2, 1792($t1)
sw $t2, 1824($t1)
lw $t2, YELLOW
addi $t1, $t1, 2560
subi $t1, $t1, 256
sw $t2, 0($t1)
sw $t2, 32($t1)
sw $t2, 1792($t1)
sw $t2, 1824($t1)
li $v0, 32
li $a0, 200
syscall
lw $t2, BLACK
lw $t1, DRAW_MID
subi $t1, $t1, 256
sw $t2, 0($t1)
sw $t2, 32($t1)
sw $t2, 1792($t1)
sw $t2, 1824($t1)
addi $t1, $t1, 2560
subi $t1, $t1, 256
sw $t2, 0($t1)
sw $t2, 32($t1)
sw $t2, 1792($t1)
sw $t2, 1824($t1)
addi $t1, $t1, 2560
subi $t1, $t1, 256
sw $t2, 0($t1)
sw $t2, 32($t1)
sw $t2, 1792($t1)
sw $t2, 1824($t1)
lw $t2, RED
lw $t1, DRAW_MID
sw $t2, 256($t1)
sw $t2, 1024($t1)
sw $t2, 288($t1)
sw $t2, 1056($t1)
lw $t2, BLUE
addi $t1, $t1, 2304
sw $t2, 256($t1)
sw $t2, 1024($t1)
sw $t2, 288($t1)
sw $t2, 1056($t1)
lw $t2, YELLOW
addi $t1, $t1, 2304
sw $t2, 256($t1)
sw $t2, 1024($t1)
sw $t2, 288($t1)
sw $t2, 1056($t1)
li $v0, 32
li $a0, 200
syscall

    la $s5, Preview_Array
    # First in the middle
    lw $t0, MIDDLE
    lw $t1, 0($s5)
    lw $t2, 4($s5)
    sw $t1, 0($t0)
    sw $t2, 4($t0)
    addi $a3, $zero, 1
    # Move the preview array
    # 2nd -> 1st
    lw $t1, 8($s5)
    lw $t2, 12($s5)
    sw $t1, 0($s5)
    sw $t2, 4($s5)
    addi $s5, $s5, 8
    # 3rd -> 2nd
    lw $t1, 8($s5)
    lw $t2, 12($s5)
    sw $t1, 0($s5)
    sw $t2, 4($s5)
    addi $s5, $s5, 8
    # 4th -> 3rd
    lw $t1, 8($s5)
    lw $t2, 12($s5)
    sw $t1, 0($s5)
    sw $t2, 4($s5)
    # 4th still vacant.

    la $s5, Preview_Array
    # Paint ONE, TWO, THREE
    lw $t0, ONE
    lw $t1, 0($s5)
    lw $t2, 4($s5)
    sw $t1, 0($t0)
    sw $t2, 4($t0)
    addi $s5, $s5, 8
    lw $t0, TWO
    lw $t1, 0($s5)
    lw $t2, 4($s5)
    sw $t1, 0($t0)
    sw $t2, 4($t0)
    addi $s5, $s5, 8
    lw $t0, THREE
    lw $t1, 0($s5)
    lw $t2, 4($s5)
    sw $t1, 0($t0)
    sw $t2, 4($t0)
    addi $s5, $s5, 8

    # Create a new capsule at FOUR and later add it to the array.
    lw $t0, FOUR
    jal create_new_capsule
    lw $t1, 0($t0)
    lw $t2, 4($t0)
    sw $t1, 0($s5)
    sw $t2, 4($s5)

    # Initialize t0, t1, t2, a3
    lw $t0, MIDDLE
    lw $t1, 0($t0)
    lw $t2, 4($t0)
    addi $a3, $zero, 1

    # If not possible to move down, game over
    addi $s1, $t0, 256
    addi $s2, $t0, 260
    lw $s1, 0($s1)
    lw $s2, 0($s2)
    bne $s1, 0x0, Q
    bne $s2, 0x0, Q


    lw $ra, 0($sp)         # Restore $ra from the stack
    addi $sp, $sp, 4       # Deallocate stack space

    jr $ra


create_new_capsule:
    # $t0 = head address of the capusle
    addi $sp, $sp, -4      # Allocate space on the stack
    sw $ra, 0($sp)         # Save $ra onto the stack

    addi $a3, $zero, 1

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


##############################  Game Loop  #################################

game_loop:
    # Background music
    addi $sp, $sp, -4
    sw $a3, 0($sp)
    la $t3, music_notes
    sll $t4, $t9, 2
    add $t4, $t3, $t4 # t4 is the current location in music_notes
    li $v0, 31
    lw $a0, 0($t4)
    li $a1, 1000
    li $a2, 0
    li $a3, 20
    syscall
    lw $a3, 0($sp)
    addi $sp, $sp, 4
    addi $s7, $s7, 1
    addi $t4, $zero, 10
    div $s7, $t4
    mfhi $t4
    beq $t4, 0, music_counter_increment
    j music_counter_increment_end
    music_counter_increment:
    addi $t9, $t9, 1
    addi $t4, $zero, 30
    div $t9, $t4
    mfhi $t9
    music_counter_increment_end:
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
    # addi $sp, $sp, -4
    # sw $ra, 0($sp)

    addi $sp, $sp, -4
    sw $a3, 0($sp)
    li $v0, 31
    li $a0, 64
    li $a1, 1000
    li $a2, 0
    li $a3, 100
    syscall
    lw $a3, 0($sp)
    addi $sp, $sp, 4
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
        # lw $ra, 0($sp)
        # addi $sp, $sp, 4
        # jr $ra
        j sleep
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
    # lw $ra, 0($sp)
    # addi $sp, $sp, 4
    # jr $ra
    j sleep

    A:
    # addi $sp, $sp, -4
    # sw $ra, 0($sp)

    # Put a3 into stack (because the soundtone will use a3 later) and put back
    addi $sp, $sp, -4
    sw $a3, 0($sp)
    li $v0, 31
    li $a0, 61
    li $a1, 1000
    li $a2, 0
    li $a3, 100
    syscall
    lw $a3, 0($sp)
    addi $sp, $sp, 4
        subi $t5, $t0, 4 # check if the block to the left of the head is colored
        # beq $t5, 0, move_left
        lw $t5, 0($t5)
        bne $t5, 0x0, A_end
        beq $a3, 1, move_left
        # if vertical, also check the block to the left-bottom
        subi $t5, $t0, 4
        addi $t5, $t5, 256
        lw $t5, 0($t5)
        bne $t5, 0x0, A_end
        move_left:
        jal delete_capsule
        subi $t0, $t0, 4
        jal make_capsule
        # orientation will be the same
    A_end:
    # lw $ra, 0($sp)
    # addi $sp, $sp, 4
    # jr $ra
    j sleep

    D:
    # addi $sp, $sp, -4
    # sw $ra, 0($sp)
    addi $sp, $sp, -4
    sw $a3, 0($sp)
    li $v0, 31
    li $a0, 62
    li $a1, 1000
    li $a2, 0
    li $a3, 100
    syscall
    lw $a3, 0($sp)
    addi $sp, $sp, 4
        # if horizontal, check right 2 blocks; if vertical check right and right-bottom
        beq $a3, 2, vertical_D_check
        addi $t5, $t0, 8 # check if the block to the right of the tail is colored
        # beq $t5, 0, move_right
        lw $t5, 0($t5)
        bne $t5, 0x0, D_end
        j move_right
        vertical_D_check:
        addi $t5, $t0, 4
        lw $t5, 0($t5)
        bne $t5, 0x0, A_end
        addi $t5, $t0, 4
        addi $t5, $t5, 256
        lw $t5, 0($t5)
        bne $t5, 0x0, A_end
        move_right:
        jal delete_capsule
        addi $t0, $t0, 4
        jal make_capsule
    D_end:
    # lw $ra, 0($sp)
    # addi $sp, $sp, -4
    # jr $ra
    j sleep

    S:
    # $a3 = direction (1 for horizontal and 2 for vertical)
    # addi $sp, $sp, -4
    # sw $ra, 0($sp)
    addi $sp, $sp, -4
    sw $a3, 0($sp)
    li $v0, 31
    li $a0, 63
    li $a1, 1000
    li $a2, 0
    li $a3, 100
    syscall
    lw $a3, 0($sp)
    addi $sp, $sp, 4
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
    # lw $ra, 0($sp)
    # addi $sp, $sp, 4
    # jr $ra
    j sleep
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
# Switch t1 and t2 (and later swtch back)
add $s1, $zero, $t1
add $t1, $zero, $t2
add $t2, $zero, $s1
beq $a3, 1, horizontal_tail_elim
beq $a3, 2, vertical_tail_elim
horizontal_tail_elim:
    addi $t0, $t0, 4
    j tail_elim_end
vertical_tail_elim:
    addi $t0, $t0, 256
tail_elim_end:
jal horizontal_check
# switch back
add $s2, $zero, $t1
add $t1, $zero, $t2
add $t2, $zero, $s2
# add $s5, $s4, $zero
beq $a3, 1, horizontal_tail_elim_restore
beq $a3, 2, vertical_tail_elim_restore
horizontal_tail_elim_restore:
    subi $t0, $t0, 4
    j tail_elim_restore_end
vertical_tail_elim_restore:
    subi $t0, $t0, 256
tail_elim_restore_end:
    j drop


jal create_capsule
j game_loop

horizontal_check:                   # check to see if horizontal pixels have the same color
addi $sp, $sp, -4
sw $ra, 0($sp)

check_left:                         # go 3 pixels to the left
addi $t7, $zero, 1                    # counter
sw $t0, 0($s5)
addi $s5, $s5, 4

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

# addi $s5, $s5, 4
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
addi $s5, $s5, 4
beq $t7, 4, four_found

check_right_end:
jal erase_arr

addi $t7, $zero, 1                    # counter
sw $t0, 0($s5)
add $s5, $s5, 4

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
# addi $s5, $s5, 4
beq $t7, 4, four_found

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
jal erase_arr
j check_end

erase_arr:
addi $sp, $sp, -4
sw $ra, 0($sp)
    # beq $t7, 4, four_found
    # if 4 is not accumulated horizontally,
    lw $t7, 0($s4)
    beq $t7, 0x0, arr_erase_loop_end
    arr_erase_loop:
        subi $s5, $s5, 4
        sw $zero, 0($s5)
        sub $t7, $s5, $s4
        bgtz $t7, arr_erase_loop
    arr_erase_loop_end:
        add $t7, $zero, $zero

lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra


four_found:
    lw $t1, BLACK
    lw $t2, 0($s4)      # load memory address of index 0 in $t2
    sw $t1, 0($t2)      # color that memory address black
    jal traverse_virus_arr
    lw $t2, 4($s4)      # load memory address of index 1 in $t2
    sw $t1, 0($t2)
    jal traverse_virus_arr
    lw $t2, 8($s4)      # load memory address of index 2 in $t2
    sw $t1, 0($t2)
    jal traverse_virus_arr
    lw $t2, 12($s4)      # load memory address of index 3 in $t2
    sw $t1, 0($t2)
    jal traverse_virus_arr
    addi $sp, $sp, -4
    sw $a3, 0($sp)
    li $v0, 31
    li $a0, 65
    li $a1, 1000
    li $a2, 0
    li $a3, 100
    syscall
    lw $a3, 0($sp)
    addi $sp, $sp, 4
    jal check_virus_arr # if no viruses left, game over
    


# black virus
lw $t2, BLACK
lw $t1, DRAW_MID
sw $t2, 256($t1)
sw $t2, 1024($t1)
sw $t2, 288($t1)
sw $t2, 1056($t1)
addi $t1, $t1, 2304
sw $t2, 256($t1)
sw $t2, 1024($t1)
sw $t2, 288($t1)
sw $t2, 1056($t1)
addi $t1, $t1, 2304
sw $t2, 256($t1)
sw $t2, 1024($t1)
sw $t2, 288($t1)
sw $t2, 1056($t1)
lw $t2, RED
lw $t1, DRAW_MID
subi $t1, $t1, 256
sw $t2, 0($t1)
sw $t2, 32($t1)
sw $t2, 1792($t1)
sw $t2, 1824($t1)
lw $t2, BLUE
addi $t1, $t1, 2560
subi $t1, $t1, 256
sw $t2, 0($t1)
sw $t2, 32($t1)
sw $t2, 1792($t1)
sw $t2, 1824($t1)
lw $t2, YELLOW
addi $t1, $t1, 2560
subi $t1, $t1, 256
sw $t2, 0($t1)
sw $t2, 32($t1)
sw $t2, 1792($t1)
sw $t2, 1824($t1)
li $v0, 32
li $a0, 200
syscall
lw $t2, BLACK
lw $t1, DRAW_MID
subi $t1, $t1, 256
sw $t2, 0($t1)
sw $t2, 32($t1)
sw $t2, 1792($t1)
sw $t2, 1824($t1)
addi $t1, $t1, 2560
subi $t1, $t1, 256
sw $t2, 0($t1)
sw $t2, 32($t1)
sw $t2, 1792($t1)
sw $t2, 1824($t1)
addi $t1, $t1, 2560
subi $t1, $t1, 256
sw $t2, 0($t1)
sw $t2, 32($t1)
sw $t2, 1792($t1)
sw $t2, 1824($t1)
lw $t2, RED
lw $t1, DRAW_MID
sw $t2, 256($t1)
sw $t2, 1024($t1)
sw $t2, 288($t1)
sw $t2, 1056($t1)
lw $t2, BLUE
addi $t1, $t1, 2304
sw $t2, 256($t1)
sw $t2, 1024($t1)
sw $t2, 288($t1)
sw $t2, 1056($t1)
lw $t2, YELLOW
addi $t1, $t1, 2304
sw $t2, 256($t1)
sw $t2, 1024($t1)
sw $t2, 288($t1)
sw $t2, 1056($t1)
li $v0, 32
li $a0, 200
syscall

    j four_found_end

traverse_virus_arr:
# t2: current memory to be painted black
addi $sp, $sp, -4
sw $ra, 0($sp)
    la $a1, Virus_Arr # Traverse the virus array
    lw $a2, 0($a1)
    bne $t2, $a2, virus_elimination_1_end
    sw $zero, 0($a1)
    sw $zero, 4($a1)
    j virus_elimination_end
    virus_elimination_1_end:
    addi $a1, $a1, 8
    lw $a2, 0($a1)
    bne $t2, $a2, virus_elimination_2_end
    sw $zero, 0($a1)
    sw $zero, 4($a1)
    j virus_elimination_end
    virus_elimination_2_end:
    addi $a1, $a1, 8
    lw $a2, 0($a1)
    bne $t2, $a2, virus_elimination_3_end
    sw $zero, 0($a1)
    sw $zero, 4($a1)
    j virus_elimination_end
    virus_elimination_3_end:
    addi $a1, $a1, 8
    lw $a2, 0($a1)
    bne $t2, $a2, virus_elimination_end
    sw $zero, 0($a1)
    sw $zero, 4($a1)
    virus_elimination_end:
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

check_virus_arr:
addi $sp, $sp, -4
sw $ra, 0($sp)
    la $a1, Virus_Arr
    lw $a2, 0($a1)
    bne $a2, 0, check_virus_array_end
    addi $a1, $a1, 8
    lw $a2, 0($a1)
    bne $a2, 0, check_virus_array_end
    addi $a1, $a1, 8
    lw $a2, 0($a1)
    bne $a2, 0, check_virus_array_end
    addi $a1, $a1, 8
    lw $a2, 0($a1)
    bne $a2, 0, check_virus_array_end
    jal Q
    check_virus_array_end:
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

four_found_end:
lw $s2, BLACK
add $t5, $s0, $zero                                     

# Put s5 into stack
addi $sp, $sp, -4
sw $s5, 0($sp)
arr_loop_start:


addi $t7, $t5, 4                                        
lw $t7, 0($t7)
beq, $t7, $s2, check_second
j arr_inner_loop_start
check_second:
addi $t7, $t5, 8
lw $t7, 0($t7)
beq $t7, $s2, exit_loop                                # check to see if $t7 is black
j arr_inner_loop_start

arr_inner_loop_start:
add $s1, $zero, $zero                                   # inner loop counter
add $s5, $s4, $zero                                     # initialize $s5 = current memory address of arr
arr_loop:
lw $t6, 0($t5)
lw $t7, 0($s5)
bne $t6, $t7, address_not_equal                         # check if the memory addresses are equal
sw $s2, 4($t5)                                          # color stored in the memory address of next element in Arr = black
j arr_loop_end
address_not_equal:
addi $s5, $s5, 4                                        # go to the next memory address
addi $s1, $s1, 1                                        # increment loop counter
beq $s1, 4, arr_loop_end                                # check to see if we have iterated through the entire array
j arr_loop                                              # if we have reached the end, then continue the loop

arr_loop_end:
addi $t5, $t5, 8 # go to the next memory address in Array

j arr_loop_start

exit_loop:
# Retrieve s5 back from stack
lw $s5, 0($sp)
addi $sp, $sp, 4
check_end:
jal erase_arr
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
    
    # put the previous t9 (music counter) into slack
    addi $sp, $sp, -4
    sw $t9, 0($sp)
    addi $t9, $zero, 1 # (initializing) detector to see if anything changes
drop_loop:
    lw $t0, 0($t6)
    lw $t5, 8($t6)
    lw $t1, 4($t6)
    lw $t2, 12($t6)
    beq $t0, 0x0, drop_end
    beq $t9, $zero, drop_end
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
        judge_direction_end:
        # Now that t0,t1,t2,a3 are initialized
        jal full_drop
        # Update the capsule info in Array
        sw $t0, 0($t6)
        sw $t1, 4($t6)
        sw $t2, 12($t6)
        jal evaluate_tail_address
        sw $t5, 8($t6)
        # TODO: should recheck this capsule, but I'm afraid the loop will never halt
        addi $t6, $t6, 16
        j drop_loop
        is_horizontal:
        # addi $sp, $sp, -4
        # sw $ra, 0($sp)
            addi $a3, $zero, 1
        # lw $ra, 0($sp)
        # addi $sp, $sp, 4
        # jr $ra
        j judge_direction_end
        is_vertical:
        # addi $sp, $sp, -4
        # sw $ra, 0($sp)
            addi $a3, $zero, 2
        # lw $ra, 0($sp)
        # addi $sp, $sp, 4
        # jr $ra
        j judge_direction_end
    half_1:
        add $t5, $t0, 256 # t5 is now the address of the block under the head
        lw $t7, 0($t5)
        bne $t7, 0x0, half_1_end
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
        lw $t7, 0($t5)
        bne $t7, 0x0, half_2_end
        jal one_drop_2
        sw $t0, 8($t6)
        sw $t2, 12($t6)
        # TODO: should recheck this capsule, but I'm afraid the loop will never halt
        j half_2
        half_2_end:
        addi $t6, $t6, 16
        j drop_loop
    wholly_black:
        # Store current t6 in s6, and later restore back.
        add $s6, $zero, $t6
        addi $sp, $sp, -4  # store t9 in stack, because it'll be overwritten
        sw $t9, 0($sp)
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
        add $t6, $t6, 16 # moved
        # if both current colors are black, halt; otherwise, keep moving
        move_loop:
            lw $t7, 0($t6)
            bne $t7, 0x0, move_loop_body
            move_loop_body:
            lw $t8, 16($t6)
            lw $s1, 20($t6)
            lw $t9, 24($t6)
            lw $s2, 28($t6)
            sw $t8, 0($t6)
            sw $s1, 4($t6)
            sw $t9, 8($t6)
            sw $s2, 12($t6)
            # subi $s3, $s3, 4
            lw $t7, 0($t6)
            beq $t7, 0x0, move_loop_end
            add $t6, $t6, 16 # moved
            j move_loop
        move_loop_end:
        subi $s3, $s3, 4
        # restore t9
        lw $t9, 0($sp)
        addi $sp, $sp, 4
        # restore to previous t6
        add $t6, $zero, $s6
        lw $s1, 20($t6)
        lw $s2, 28($t6)
        
        j drop_loop

full_drop:
addi $sp, $sp, -4
sw $ra, 0($sp)
        
    beq $a3, 1, full_drop_horizontal             # check to see aligment is horizontal
    beq $a3, 2, full_drop_vertical               # check to see alignment is vertical

    full_drop_horizontal:
    addi $t5, $t0, 256                      # from base address to memory address of pixel below
    lw $t7, 0($t5)                          # fetch its value from memory and store it temporarily in a register
    bne $t7, 0x0, full_drop_end                 # check to see if that value is black or not and if it is not black, then go to S_end
    addi $t5, $t0, 260                      # from base address to memory address of pixel below and 1 unit right
    lw $t7, 0($t5)                          # fetch its value from memory and store it temporarily in a register
    bne $t7, 0x0, full_drop_end                 # check to see if that value is black or not and if it is not black, then go to S_end
    # path is clear
    jal delete_capsule
    addi $t0, $t0, 256
    jal make_capsule
    addi $t9, $zero, 1
    jal full_drop

    full_drop_vertical:
    addi $t5, $t0, 512                      # from base address to memory address of pixel 2 rows below
    lw $t7, 0($t5)                          # fetch its value from memory and store it temporarily in a register
    bne $t7, 0x0, full_drop_end                     # check to see if that value is black or not and if it is not black, then go to S_end
    # path is clear
    jal delete_capsule
    addi $t0, $t0, 256
    jal make_capsule
    addi $t9, $zero, 1
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
    addi $t9, $zero, 1
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
    addi $t9, $zero, 1
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

drop_end:
# Restore t9 back.
lw $t9, 0($sp)
addi $sp, $sp, 4
jal create_capsule
j game_loop


evaluate_tail_address:
addi $sp, $sp, -4
sw $ra, 0($sp)
    beq $a3, 1, evaluate_horizontal_tail_address
    beq $a3, 2, evaluate_vertical_tail_address
    evaluate_horizontal_tail_address:
        addi $t5, $t0, 4
        j evaluate_tail_address_end
    evaluate_vertical_tail_address:
        addi $t5, $t0, 256
    evaluate_tail_address_end:
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

    sleep:
    li $v0, 32
    addi $a0, $zero, 16 # 16.67 milliseconds = 1/60 second
    syscall
    # 5. Go back to Step 1
    j game_loop

Q:
    addi $sp, $sp, -4
    sw $a3, 0($sp)
    li $v0, 31
    li $a0, 66
    li $a1, 1000
    li $a2, 0
    li $a3, 100
    syscall
    lw $a3, 0($sp)
    addi $sp, $sp, 4
    li $v0, 10 # exit the program gracefully
    syscall
    
