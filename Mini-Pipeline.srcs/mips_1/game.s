.text 0x0
j init
INT:
    # if system not init, eret
    # la $k0, SP
    # lw $k0, 0($k0)
    # bne $k0, $sp, ERET

    # addi $s1, $zero, 0x5f5f
    # bne $k1, $s1, ERET
    # self check finish

    # preserve register
    addi $sp, $sp, -4
    sw $t0, 0($sp)

    # load keyboard address
    la $t0, keyboardAddr
    lw $t0, 0($t0)

    # store key
    lw $k0, 0($t0)
    # write to vram
    sw $k0, 0($t8)

    # update vram pointer
    addi $t8, $t8, 1

    # reset readn
    sw $zero, 0($t0)

    # save back to registers
    lw $t0, 0($sp)
    addi $sp, $sp, 4

ERET:
    eret

init:
    # load FP and SP pointers
    la $t0, FP
    lw $fp, 0($t0)
    la $t0, SP
    lw $sp, 0($t0)

    # la $t0, vramAddr
    # lw $t8, 0($t0)
    lui $t8, 0x8000
    addi $t8, $t8, 0x10

    # save system status
    # addi $k1, $zero, 0x5f5f

    # start
    j start

start:
    j start
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
    sw $t3, 0($t8)
    move $t0, $zero                             # clear counter

blink_cursor_loop:
    addi $t0, $t0, 0x1
    lui $t2, 0x0020
    beq $t0, $t2, blink_cursor_clear
    j blink_cursor_loop

.data 0x200
    FP: .word 0x500
    SP: .word 0x1000
    vramAddr: .word 0x80000010
    keyboardAddr: .word 0x40000000

# FP
.data 0x500

# SP
.data 0x1000