.text 0x0
j init
INT:
    addi $sp, $sp, -4
    sw $t1, 0($sp)
    # la $s1, vgaAddress         # load vga address pointer
    # lw $s1, ($s1)              # load vga address
    lui $s1, 0x4000            # load vga address
    lw $t1, ($s1)              # load ascii
    sw $t1, ($s0)              # write vram
    addi $s0, $s0, 0x1         # add offset
    sw $zero, 0($s1)           # reset readn
    lw $t1, 0($sp)
    addi $sp, $sp, 4
    eret
init:
    la $t0, FP
    lw $fp, 0($t0)
    la $t0, SP
    lw $sp, 0($t0)

    la $s0, vramAddr
    lw $s0, ($s0)
    # lui $s0, 0x8000
    # addi $s0, $s0, 0x510     # with lui, get 0x80000510 = vram addr
start:
    # sw $t1, ($t0)            # write vram
    j start

.data 0x100
    FP: .word 0x500
    SP: .word 0x1000
    vramAddr: .word 0x80000510        # s0
    vgaAddress: .word 0x40000000      # s1

# FP
.data 0x500

# SP
.data 0x1000