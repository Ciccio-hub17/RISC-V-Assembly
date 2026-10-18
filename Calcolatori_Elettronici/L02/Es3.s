
.text
main:
    li t0, 0
    li s0, 10
    li t1, 0
for:
    bge t1, s0, done
    
    add t0, t0, t1
    addi t1, t1, 1
    
    j for
done:
    addi a0, t0, 0
    li a7, 1
    ecall
    li a7, 10
    ecall