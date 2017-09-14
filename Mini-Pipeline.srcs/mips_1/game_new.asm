
    addi $sp, $sp, -8
    sw $s0, 0($sp)
    sw $s1, 4($sp)

    la $s0, Inst_Table
    lw $s0, 0($s0)
    la $s1, Inst_Table_l
    lw $s1, 0($s0)

    add $s1, $s1, $s1
    add $s1, $s1, $s1                       # t1 * 4

    add $s1, $s0, $s1                       # mem offset
TestInst:
    beq $s0, $s1, AllInstNotMatch
    jal LoadInst
    bne $v0, $zero, InstMatch
    addi $s0, $s0, 8
    j TestInst
InstMatch:
    la $t0, LS_s
    lw $t0, 0($t0)
    beq $t0, $v0, PrintHelloWorld   # inst LS
    la $t0, Exit_s
    lw $t0, 0($t0)
    beq $t0, $v0, PrintExit         # inst Exit

AllInstNotMatch:
    j PrintNoMatch

LoadInst:
    lw $a0, 0($s0)                  # inst start
    lw $a1, 4($s0)                  # inst length
    la $t0, input_buffer
    lw $t1, 0($t0)
    bne $t1, $a1, InstIsNotSame
    lw $t1, 4($t0)
    move $a2, $t1
    add $a1, $a1, $a1
    add $a1, $a1, $a1               # calculate offset
    add $a1, $a0, $a1               # calculate inst terminate
VerifyInstSame:
    beq $a0, $a1, InstIsSame
    lw $t0, 0($a0)
    lw $t1, 0($a2)
    bne $t0, $t1, InstIsNotSame
    addi $a0, $a0, 4
    addi $a2, $a2, 4
    j VerifyInstSame
InstIsSame:
    add $v0, $zero, 1
    jr $ra
InstIsNotSame:
    move $v0, $zero
    jr $ra

PrintHelloWorld:
    la $t0, HelloWorld
    lw $t0, 0($t0)
    la $t1, HelloWorld_l
    lw $t1, 0($t1)
    add $t1, $t0, $t1
PrintHelloWorldStart:
    beq $t0, $t1, Next
    sw
    j PrintHelloWorldStart

PrintExit:



.data 0x100
input_buffer: .word 0x400
Inst_Table: .word 0x200
Inst_Table_l: .word 0x4
HelloWorld: .word 0x220
HelloWorld_l: .word 0x30

.data 0x200
LS_s: .word 0x200
LS_l: .word 0x2
Exit_s: .word 0x210
Exit_l: .word 0x4

.data 0x220
# Hello world
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

# ls
.data 0x240
.word 0x4c # L
.word 0x53 # S

# exit
.data 0x250
.word 0x65 # E
.word 0x78 # X
.word 0x69 # I
.word 0x74 # T

# input buffer
.data 0x400
