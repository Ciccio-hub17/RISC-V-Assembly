.data
var: .word 0x3FFFFFF0

.text
main:
    la t0, var
    lw t0, 0(t0)
    add t1, t0, t0
    addi t2, t1, 40
    add a0, zero, t2
    li a7, 1
    ecall
    