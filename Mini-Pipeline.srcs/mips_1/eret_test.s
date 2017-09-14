.text 0x0
j init
INT:
    # lui $k0, 0x4000            # load vga address
    la $k0, vgaAddress
    lw $k0, 0($k0)              # load vga address
    lw $k1, ($k0)               # load ascii
    sw $k1, ($t8)               # write vram
    addi $t8, $t8, 0x1          # add offset
    sw $zero, 0($k0)            # reset readn
    eret
init:
    la $t0, FP
    lw $fp, 0($t0)
    la $t0, SP
    lw $sp, 0($t0)

    la $t8, vramAddr
    lw $t8, ($t8)

start:
    # sw $t1, ($t0)              # write vram
    j blink_cursor

blink_cursor:
    addi $t0, $zero, 0x1                        # i
    move $t1, $t0                               # flag
    j blink_cursor_loop

blink_cursor_clear:
    beq $t1, $zero, blink_cursor_set_underline
    move $t1, $zero                             # revert flag
    move $t3, $zero                             # set char space
    # addi $t3, $zero, 0xff                       # set char space
    j blink_cursor_clear_next
blink_cursor_set_underline:
    addi $t1, $zero, 0x1                        # revert flag
    addi $t3, $zero, 0x5f                       # set char underline
blink_cursor_clear_next:
    sw $t3, 0($t8)
    move $t0, $zero                             # clear counter

blink_cursor_loop:
    addi $t0, $t0, 0x1
    lui $t2, 0x0020
    # addi $t2, $zero, 0x3
    beq $t0, $t2, blink_cursor_clear
    j blink_cursor_loop


.data 0x100
    FP: .word 0x500
    SP: .word 0x1000
    vramAddr: .word 0x80000510        # s0
    vgaAddress: .word 0x40000000      # s1

# FP
.data 0x500

# SP
.data 0x1000