.data
SEC_BLUE:
    .word 0x1b86f2
DRAW_START:
    .word 0x10008074
DRAW_END:
    .word 0x1000bccc
RED:
    .word 0xff0000
BROWN:
    .word 0xbe5014
GRAY:
    .word 0xbfbfbf
WHITE: 
    .word 0xffffff
YELLOW:
    .word 0xffff00
SKIN:
    .word 0xf7c7ac
    
.text 
# left shoe
lw $t2, BROWN
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

# right shoe
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

# left right block on top of left shoe
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
lw $t2, SEC_BLUE
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
lw $t2, GRAY 
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

lw $t2, SKIN

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
sw $t2, 2076($t1)

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

sw $t2, 2064($t1)
sw $t2, 2320($t1)
sw $t2, 2576($t1)

sw $t2, 2324($t1)
sw $t2, 2328($t1)
sw $t2, 2332($t1)
sw $t2, 2576($t1)
sw $t2, 2580($t1)
sw $t2, 2584($t1)
sw $t2, 2588($t1)








