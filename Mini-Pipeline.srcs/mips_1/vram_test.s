# vram test bench using 9' cpu, IM & DM combined.
# displays 'A' to 'Z' at (16, 16) on VGA board

start:
    lw $t0, 64($zero)        # vram addr
    lw $t1, 68($zero)        # char 'A'
    lw $t2, 72($zero)        # load 1
    lw $t3, 76($zero)        # load 'Z' + 1
    sw $t1, ($t0)            # write vram
loop:
    add $t1, $t1, $t2        # 'A' to 'Z'
    beq $t1, $t3, start      # reset if larger than 'Z'
    sw $t1, ($t0)            # write vram
    j loop                   # loop

    .space 20                # empty data placeholder
    .word 0x80000510         # 80 * 16 + 16
    .word 0x41               # A
    .word 0x1                # 1
    .word 0x5b               # Z + 1
    .space 16
