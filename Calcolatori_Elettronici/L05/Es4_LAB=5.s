.data
vet1: .word 1, 2, 3, 4
vet2: .word 4, 3, 2, 1
new: .string "\n"
space: .string " "
.bss
mat: .word 16

.text
main:
    li t0, 0 #i
    li t1, 0 #j
    li s4, 4
    
    la s0, vet1
    la s3, mat
    
forExt:
    beq t0, s4, end
    lw t2, 0(s0)
    la s1, vet2
    li t1, 0
forInt:
    beq t1, s4, endInt
    lw t3, 0(s1)
    mul t4, t3, t2
    
    sw, t4, 0(s3)
    
    mv a0, t4
    li a7, 1
    ecall
    li a7, 4
    la a0, space
    ecall
    
    addi s3, s3, 4
    addi s1, s1, 4
    addi t1, t1, 1
    j forInt
    
endInt:
    li a7, 4
    la a0, new
    ecall
    
    addi s0, s0, 4
    addi t0, t0, 1
    j forExt
    
end:
    li a7, 10
    ecall