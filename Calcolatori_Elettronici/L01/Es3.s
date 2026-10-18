.data
op1: .byte 150
op2: .byte 100

.text
main:
    la s0, op1
    la s1, op2
    lbu t0, 0(s0)
    lbu t1, 0(s1)
    add t3, t1, t0
    addi a7, zero, 1
    add a0, zero, t3
    ecall
    li a7, 10
    ecall
    