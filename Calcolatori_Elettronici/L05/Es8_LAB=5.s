.equ numrows, 5
.equ numcols, 4

.data
mat: .word 2, 3, 8, 0
     .word 1, 23, 7, 8
     .word -45, 0, 3, 1
     .word 12, 0, 2, -3
     .word 3, 4, 0, 89
     
.text
main:
    la a0, mat
    li a1, numrows
    li a2, numcols

fun:
    li t0, 0
    mv s0, a0
    lw t1, 0(s0)
    add t0, t0, t1
    
    li s11, 4
    
    mul s1, a2, s11
    addi s1, s1, -4
    
for:
    
    add t0, t0, s1
    j for
    