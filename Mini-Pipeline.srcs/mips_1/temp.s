.text 0x0
j init
INT:
    la $k0, keyboardAddr
    lw $k0, 0($k0)                              # load keyboard address
    lw $k0, 0($k0)                              # load ascii

    li $k1, 0xff                                # ignore undefined char
    beq $k0, $k1, EXITINT                       # just ignore

    li $k1, 0x1                                 # deal with backspace
    bne $k0, $k1, testEnter

backspaceOp:
    addi $t8, $t8, -1                           # clear one bit
    j EXITINT

testEnter:
    j NormalOp

NormalOp:
    sw $k0, 0($t8)                              # write vram
    addi $t8, $t8, 1                            # add offset

EXITINT:
    la $k0, keyboardAddr
    lw $k0, 0($k0)                              # load keyboard address
    sw $zero, 0($k0)                            # reset readn
    eret

init:
    la $t0, FP
    lw $fp, 0($t0)
    la $t0, SP
    lw $sp, 0($t0)

    la $t8, vramAddr
    lw $t8, 0($t8)

start:
    j blink_cursor

blink_cursor:
    addi $t0, $zero, 0x1                        # i
    move $t1, $t0                               # flag
    j blink_cursor_loop

blink_cursor_clear:
    beq $t1, $zero, blink_cursor_set_underline
    move $t1, $zero                             # revert flag
    move $t3, $zero                             # set char space
    j blink_cursor_clear_next
blink_cursor_set_underline:
    addi $t1, $zero, 0x1                        # revert flag
    addi $t3, $zero, 0x5f                       # set char underline
blink_cursor_clear_next:
    sw $t3, 0($t8)
    move $t0, $zero                             # clear counter

blink_cursor_loop:
    addi $t0, $t0, 0x1
    lui $t2, 0x0010
    beq $t0, $t2, blink_cursor_clear
    j blink_cursor_loop


.data 0x100
    FP: .word 0x500
    SP: .word 0x1000
    vramAddr: .word 0x80000510                  # s0
    keyboardAddr: .word 0x40000000              # s1

# FP
.data 0x500

# SP
.data 0x1000