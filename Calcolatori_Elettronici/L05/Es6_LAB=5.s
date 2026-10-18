.data
A:  .word 100, 150, 200, 50, 30
    .word 250, 128, 127, 180, 90
    .word 220, 10, 60, 170, 140
    .word 100, 255, 0, 45, 133
    
B:  .word 100, 150, 200, 50, 30
    .word 250, 128, 127, 180, 90
    .word 220, 10, 60, 170, 140
    .word 100, 255, 0, 45, 133
    
.text
main:
    la s0, A
    la s1, B
    
    mv t0, s0
    li t1, 80
    add t1, t1, s0
    mv t2, s1
    li s2, 1
    li s3, 128
    li s4, 0
    
for:
    beq t0, t1, end
    
    lw t3, 0(s0)
    bge t3, s3, one
    sw zero, 0(t2)
    j cont
one:
    sw s2, 0(t2)
    addi s4, s4, 1
cont:    
    addi t0, t0, 4
    addi t2, t2, 4
    j for
end:
    mv a0, s4
    li a7, 1
    ecall
    li a7, 10
    ecall