.equ numrows, 5
.equ numcols, 4

.data
mat: .word 2, 3, 8, 0
     .word 1, 23, 7, 8
     .word -45, 0, 3, 1
     .word 12, 0, 2, -3
     .word 3, 4, 0, 89
res: .word 0
.text
main:
    la a0, mat
    li a1, numrows
    li a2, numcols
    jal ra, fun
    
    la s0, res
    sw a0, 0(s0)
    li a7, 1
    ecall
    
    li a7, 10
    ecall

fun:
    mv t0, a0
    li s9, 0
    
    li s11, 4
    
    mul s1, a2, s11
    addi s1, s1, -4
    
    mul s10, a1, a2
    mul s10, s10, s11
    add s10, s10, a0
    
for:
    lw t1, 0(t0)
    add t0, t0, s1
    
    add s9, s9, t1
    
    lw t1, 0(t0)
    
    add s9, s9, t1
    
    addi t0, t0, 4
    
    beq t0, s10, end
    j for
    
end:
    mv a0, s9
    jr ra
    