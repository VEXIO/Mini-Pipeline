.text 0x0
j init
INT:
    # if system not init, eret
    la $k0, SP
    lw $k0, 0($k0)
    bne $k0, $sp, ERET

    addi $s1, $zero, 0x5f5f
    bne $k1, $s1, ERET
    # self check

    # load keyboard address
    la $t0, keyboardAddr
    lw $t0, 0($t0)

    # store key
    lw $k0, 0($t0)

    # load vram write address
    la $t1, vramAddr
    lw $t2, 0($t1)

    # write to vram
    sw $k0, 0($t2)

    # update vram pointer
    addi $t1, $t1, 0x1
    sw $t1, 0($t2)

    # reset readn
    sw $zero, 0($t1)

ERET:
    eret

init:
    # load FP and SP pointers
    la $t0, FP
    lw $fp, 0($t0)
    la $t0, SP
    lw $sp, 0($t0)

    # save system status
    addi $k1, $zero, 0x5f5f

    # start
    j start

start:
    j blink_cursor

reset:
    j reset

blink_cursor:
    addi $t0, $zero, 0x1                        # i
    move $t1, $t0                               # flag
    j blink_cursor_loop

blink_cursor_clear:
    beq $t1, $zero, blink_cursor_set_underline
    move $t3, $zero                             # set char space
    move $t1, $zero                             # revert flag
    j blink_cursor_clear_next
blink_cursor_set_underline:
    addi $t1, $zero, 0x1                        # revert flag
    addi $t3, $zero, 0x5f                       # set char underline
blink_cursor_clear_next:
    la $t4, vramAddr
    lw $t4, 0($t4)
    sw $t3, 0($t4)
    move $t0, $zero                             # clear counter

blink_cursor_loop:
    addi $t0, $t0, 0x1
    lui $t2, 0x000f
    # addi $t2, $zero, 0x0002
    beq $t0, $t2, blink_cursor_clear
    j blink_cursor_loop

.data 0x100
    FP: .word 0x500
    SP: .word 0x1000
    vramAddr: .word 0x80000510
    keyboardAddr: .word 0x40000000

#FP
.data 0x500

#SP
.data 0x1000