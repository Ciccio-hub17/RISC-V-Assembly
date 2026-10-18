.data
mat: .word 154, 123, 109, 86, 4, 0
     .word 412, 23, -231, 9, 50, 0
     .word 123, -24, 12, 55, -45, 0
     .word 0, 0, 0, 0, 0, 0
new: .string "\n"
space: .string " "
    
.text
main:
    la s0, mat
    li s2, 0
    jal ra, sommaRighe
    jal ra, sommaColonne
    
    sw s2, 96(s0)
    
sommaRighe:
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    
    li t0, 0
    add t0, t0, s0 
    li t1, 72
    add t1, t1, s0
    li s1, 0
    li t3, 0
    li t4, 5
    
forRighe:
    beq t0, t1, exitfor1
    beq t3, t4, save
    lw t2, 0(t0)
    add s1, s1, t2
    j cont
save: 
    sw s1, 0(t0)
    add s2, s2, s1
    li s1, 0
cont:   
    addi t3, t3, 1
    addi t0, t0, 4
    j forRighe
    
exitfor1:
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12
    jr ra
    
sommaColonne:
    addi sp, sp, -8
    sw s0, 0(sp)
    sw ra, 4(sp)
    
    li t0, 0
    add t0, t0, s0
    li t1, 72
    add t1, t1, s0
    li t2, 15
    li t3, 0
    li t4, 0
    li s1, 0
    li t5, 0
forColonne:
    beq t3, t2, endfor2
    beq t0, t1, saveC
    lw t5, 0(t0)
    add s1, s1, t5
    j cont1
saveC:
    sw s1, 0(t0)
    add s2, s2, s1
    li s1, 0
    mv t0, s0
    addi t0, t0, 4
    addi t0, t0, -24
    addi t1, t1, 4

cont1:    
    addi t0, t0, 24
    addi t3, t3, 1
    j forColonne
 endfor2:   
    lw s0, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8
    jr ra
stampa:
    mv t0, s0
    li t1, 100
    add t1, t1, s0
    
forS:
    beq t0, t1, exit
    
    lw a0, 0(t0)
    li a7, 1
    ecall
    la a0, space
    li a7, 4
    ecall
    
    addi t0, t0, 4
    j forS
    
exit:
    li a7, 10
    ecall