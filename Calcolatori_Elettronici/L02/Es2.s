.data
i: .word 0
j: .word 0
msg1: .string "Dammi il primo intero "
msg2: .string "Dammi il secondo intero "
.bss
buffer: .zero 2

.text
main:
    la a0, msg1
    li a7, 4
    ecall
    
    li a0, 0
    li a2, 2
    la a1, buffer
    li a7, 63
    ecall
    lb t0, 0(a1)
    addi t0, t0, -48
    
    la a0, msg2
    li a7, 4
    ecall
    
    li a0, 0
    li a2, 2
    la a1, buffer
    li a7, 63
    ecall
    lb t1, 0(a1)
    addi t1, t1, -48
    
    bge t0, t1, else
    add s1, t0, t1
    j finish

else:
    sub s1, t0, t1
    
finish:
    addi a0, s1, 0
    li a7, 1
    ecall
    li a7, 10
    ecall
    
    