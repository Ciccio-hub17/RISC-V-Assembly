
.text
main:
    jal ra, eqDiag
    li a7, 1
    ecall
    j exit
    
eqDiag:
    li s0, 4
    mv s1, a0
    mv s2, a0
    add s2, a0, a1
    addi s2, s2, -4
    li t0, 0
    li t1, 0
    li t2, 0
    for:
        beq t0, a1, end
        lw s3, 0(s1)
        lw s4, 0(s2)
        add t1, t1, s3
        add t2, t2, s4
        
        add s1, s1, a1
        addi s1, s1, 4
        
        add s2, s2, a1
        addi s2, s2, -4
        
        addi t0, t0, 1
        j for
    end:
        beq t1, t2, a01
        li a0, 0
        j endfun
    a01:
        li a0, 1
    endfun:
        jr ra
    
exit:
    li a7, 10
    ecall