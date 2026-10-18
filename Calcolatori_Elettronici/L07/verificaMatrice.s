.text
.globl verificaMatrice
# la a0, mat
#li a1, dim

verificaMatrice:
    mv s0, a0
    li s11, 0
    addi sp, sp, -4
    sw ra, 0(sp)
    jal verificaDiagonale
    lw ra, 0(sp)
    addi sp, sp, 4
    bne s11, zero, exit
    addi sp, sp, -4
    sw ra, 0(sp)
    jal verificaSimmetrica
    lw ra, 0(sp)
    addi sp, sp, 4
    bne s11, zero, exit
    li a0, 0
    j exit
    
verificaDiagonale:
    li t0, 0
    mv t2, s0
    mv s1, s0
    li s8, 4
    mul s9, s8, a1
    
forExt:
    beq t0, a1, goodEnd
    li t1, 0
    forInt:
        beq t1, a1, endInt
        
        beq t2, s1, contInt
        lw t3, 0(t2)
        bne t3, zero, badEnd
        
    contInt:
        addi t2, t2, 4
        addi t1, t1, 1
        j forInt
        
endInt:
    add s1, s1, s9
    addi s1, s1, 4
    addi t0, t0, 1
    j forExt
    
goodEnd:
    li s11, 1
    li a0, 2
    j exit
badEnd:
    li s11, 0
    j exit
    
verificaSimmetrica:
    mv s1, s0
    li t0, 0
    mv s10, a1
    li s8, 4
    mul s9, s10, s8
    
forExt1:
    beq t0, a1, endExt1
    mv s2, s1
    mv s3, s1
    addi s2, s2, 4
    add s3, s3, s9
    mv t1, s10
    addi t1, t1, -1
    
    forInt1:
        beq t1, zero, endInt1
        lw t2, 0(s2)
        lw t3, 0(s3)
        
        bne t2, t3, badExit1
        
        addi s2, s2, 4
        add s3, s3, s9
        addi t1, t1, -1
        j forInt1
        
endInt1:
    
    addi s10, s10, -1
    add s1, s1, s9
    addi s1, s1, 4
    addi t0, t0, 1
    j forExt1
    
endExt1:
    li a0, 1
    li s11, 1
    j exit
    
badExit1:
    j exit
    
exit:
    jr ra