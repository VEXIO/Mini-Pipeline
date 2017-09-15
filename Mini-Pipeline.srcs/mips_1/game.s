.text 0x0
j init
INT:
    # j EXITINT
    la $k0, keyboardAddr
    lw $k0, 0($k0)                              # load keyboard address
    lw $k0, 0($k0)                              # load ascii

    li $k1, 0xff                                # ignore undefined char
    beq $k0, $k1, EXITINT                       # just ignore

    li $k1, 0x1                                 # deal with backspace
    beq $k0, $k1, backspaceOp

    li $k1, 0x3
    beq $k0, $k1, testEnter

    j NormalOp

backspaceOp:
    beq $t8, $zero, EXITINT
    la $k1, vramAddr
    lw $k1, 0($k1)                          # load vram base addr
    add $k1, $k1, $t8                       # add addr offset
    sw $zero, 0($k1)                        # clear underline - screen

    la $k1, input_buffer
    lw $k1, 0($k1)                          # load input buffer address
    add $k1, $k1, $t8
    add $k1, $k1, $t8
    add $k1, $k1, $t8
    add $k1, $k1, $t8
    sw $zero, -4($k1)                        # clear underline - input buffer

    addi $t8, $t8, -1                           # clear one bit
    j EXITINT

testEnter:
    # move data buffer with 80 offset
    # at the same time, update vram buffer
    # CANNOT USE K0 HERE!!!

    la $k1, data_buffer
    lw $k1, 0($k1)
    la $t8, vramTop
    lw $t8, 0($t8)
    la $t9, data_buffer_write
    lw $t9, 0($t9)
ShiftDataBuffer:
    lw $gp, 320($k1)
    sw $gp, 0($t8)
    sw $gp, 0($k1)
    addi $k1, $k1, 4
    addi $t8, $t8, 1
    bne $k1, $t9, ShiftDataBuffer

ManipulateInputBuffer:
    # copy input buffer to data buffer
    la $k1, data_buffer_write
    lw $k1, 0($k1)
    addi $k1, $k1, -320                 # copy at the line before
    la $t8, input_buffer
    lw $t8, 0($t8)
    addi $t9, $t8, 0x140                # 80 * 4 = 480d = 0x140
CopyInputBufferToData:
    lw $gp, 0($t8)
    sw $gp, 0($k1)
    addi $t8, $t8, 4
    addi $k1, $k1, 4
    bne $t8, $t9, CopyInputBufferToData

LoadVRAMToReg:
    # copy input buffer to vram buffer
    # and at the same time clear input buffer
    la $k1, vramAddr
    lw $k1, 0($k1)
    addi $k1, $k1, -80                 # copy at the line before
    la $t8, input_buffer
    lw $t8, 0($t8)
CopyInputBufferToVRAM:
    lw $gp, 0($t8)
    sw $gp, 0($k1)
    sw $zero, 0($t8)                    # clear input buffer at this time
    sw $zero, 80($k1)                   # clear input line
    addi $t8, $t8, 4
    addi $k1, $k1, 1
    bne $t8, $t9, CopyInputBufferToVRAM

# ProcessInput:
#     j FinishBufferCopy
#     la $s0, Inst_Table
#     lw $s0, 0($s0)
#     la $s1, Inst_Table_l
#     lw $s1, 0($s1)

#     add $s1, $s1, $s1
#     add $s1, $s1, $s1                       # t1 * 4

#     add $s1, $s0, $s1                       # mem offset
# TestInst:
#     beq $s0, $s1, AllInstNotMatch
#     jal LoadInst
#     bne $v0, $zero, InstMatch
#     addi $s0, $s0, 8
#     j TestInst
# InstMatch:
#     la $s3, LS_s
#     lw $s3, 0($s3)
#     beq $s3, $v0, PrintHelloWorld   # inst LS
#     la $s3, Exit_s
#     lw $s3, 0($s3)
#     beq $s3, $v0, PrintExit         # inst Exit

# AllInstNotMatch:
#     j PrintNoMatch

# LoadInst:
#     lw $a0, 0($s0)                  # inst start
#     lw $a1, 4($s0)                  # inst length
#     add $a1, $a1, $a1
#     add $a1, $a1, $a1               # calculate offset
#     add $a1, $a0, $a1               # calculate inst terminate
#     la $s2, input_buffer
#     lw $s2, 0($s2)
# VerifyInstSame:
#     beq $a0, $a1, InstIsSame
#     lw $s3, 0($a0)
#     lw $s4, 0($s2)
#     bne $s3, $s4, InstIsNotSame
#     addi $a0, $a0, 4
#     addi $s2, $s2, 4
#     j VerifyInstSame
# InstIsSame:
#     lw $v0, 0($s0)
#     jr $ra
# InstIsNotSame:
#     move $v0, $zero
#     jr $ra

# PrintHelloWorld:
#     la $s0, HelloWorld
#     lw $s0, 0($s0)
#     la $s1, HelloWorld_l
#     lw $s1, 0($s1)
#     add $s1, $s0, $s1
#     la $s2, input_buffer
#     lw $s2, 0($s2)
#     la $s3, vramAddr
#     lw $s3, 0($s3)
# PrintHelloWorldStart:
#     beq $s0, $s1, Next
#     lw $s4, 0($s0)
#     sw $s4, 0($s2)
#     sw $s4, 0($s3)
#     addi $s0, $s0, 4
#     addi $s2, $s2, 4
#     addi $s3, $s3, 1
#     j PrintHelloWorldStart
# Next:
#     j FinishBufferCopy
# PrintExit:
#     j FinishBufferCopy
# PrintNoMatch:
#     j FinishBufferCopy

FinishBufferCopy:
    move $t8, $zero
    j EXITINT

NormalOp:
    li $k1, 0x46
    beq $k1, $t8, EXITINT                       # ignore if the buffer is full
    la $k1, vramAddr
    lw $k1, 0($k1)
    add $k1, $k1, $t8
    sw $k0, 0($k1)                              # write vram

    la $k1, input_buffer
    lw $k1, 0($k1)
    move $t9, $t8
    add $t9, $t9, $t9
    add $t9, $t9, $t9
    add $k1, $k1, $t9
    sw $k0, 0($k1)                              # write input buffer
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

    move $t8, $zero

start:
    j blink_cursor

blink_cursor:
    li $t0, 1                                   # i
    move $t1, $t0                               # flag
    j blink_cursor_loop

blink_cursor_clear:
    beq $t1, $zero, blink_cursor_set_underline
    move $t1, $zero                             # revert flag
    move $t3, $zero                             # set char space
    j blink_cursor_clear_next
blink_cursor_set_underline:
    li $t1, 0x1                                 # revert flag
    li $t3, 0x5f                                # set char underline
blink_cursor_clear_next:
    la $t4, vramAddr
    lw $t4, 0($t4)                              # load vram base addr
    add $t4, $t4, $t8                           # add offset
    sw $t3, 0($t4)
    move $t0, $zero                             # clear counter

blink_cursor_loop:
    addi $t0, $t0, 0x1                          # i++
    lui $t2, 0x0010                             # i < 0x00100000
    # li $t2, 0x3
    beq $t0, $t2, blink_cursor_clear
    j blink_cursor_loop

.data 0x1000
    FP: .word 0x1500
    SP: .word 0x1ffc
    data_buffer: .word 0x2000
    data_buffer_write: .word 0x6610             # 0x1184 * 4 + 2000
    vramTop: .word 0x80000000
    vramAddr: .word 0x80001184                  # 4484
    keyboardAddr: .word 0x40000000
    input_buffer: .word 0x1400
    Inst_Table: .word 0x1160
    Inst_Table_l: .word 0x4
    HelloWorld: .word 0x1200
    HelloWorld_l: .word 0x30

.data 0x1160
    LS_s: .word 0x1240
    LS_l: .word 0x2
    Exit_s: .word 0x1250
    Exit_l: .word 0x4

.data 0x1200                 # Hello world
    .word 0x48 # H
    .word 0x65 # e
    .word 0x6c # l
    .word 0x6c # l
    .word 0x6f # o
    .word 0x20 #
    .word 0x77 # w
    .word 0x6f # o
    .word 0x72 # r
    .word 0x6c # l
    .word 0x64 # d
    .word 0x21 # !

.data 0x1240                 # ls
    .word 0x4c # L
    .word 0x53 # S

.data 0x1250                 # exit
    .word 0x65 # E
    .word 0x78 # X
    .word 0x69 # I
    .word 0x74 # T

.data 0x1400                 # input buffer


# FP
.data 0x1800

# SP
.data 0x1ffc

# Data BUFFER
.data 0x2000
