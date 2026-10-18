.data
int1: .word 5
int2: .word 10
int3: .word 3

.text
main:
    lw t0, int1
    lw t1, int2
    lw t2, int3
    addi t3, zero, 0
    
    bge t0, t1, swap1
    j cont1
swap1:
    addi t3, t0, 0
    addi t0, t1, 0
    addi t1, t3, 0
cont1:
    bge t0, t2, swap2
    j cont2
swap2:
    addi t3, t0, 0
    addi t0, t2, 0
    addi t2, t3, 0
cont2:
    bge t1, t2, swap3
    j cont3
swap3:
    addi t3, t1, 0
    addi t1, t2, 0
    addi t2, t3, 0
cont3:
    li a7, 10
    ecall