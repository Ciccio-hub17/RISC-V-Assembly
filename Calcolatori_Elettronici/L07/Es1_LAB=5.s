.data
vet: .word 20
new: .asciz "\n"

.text
main:
    la s0, vet
    la s2, vet
    la s3, vet
    
    li t0, 2 #index che mi serve per iterare sul vettore
    li s1, 1 #s1 = 1
    sw s1, 0(s0) #v[0] = 1
    addi s0, s0, 4
    addi s2, s2, 4
    sw s1, 0(s0) #v[1] = 1
    addi s0, s0, 4
    li t1, 20 #max
    li t2, 8
    
for:
    beq t0, t1, stamp
    lw t3, 0(s2)
    lw t4, 0(s3)
    
    add t5, t3, t4
    
    sw t5, 0(s0)
    
    addi s0, s0, 4 #t2 = t2+4
    addi s2, s2, 4
    addi s3, s3, 4
    addi t0, t0, 1 #i+1
    j for   
      
stamp:
    li t0, 0
    la s0, vet
loop:
    beq t0, t1, exit
    lw a0, 0(s0)
    li a7, 1
    ecall
    la a0, new
    li a7, 4
    ecall
    S
    addi s0, s0, 4
    addi t0, t0, 1
    j loop
    
exit:
        
    li a7, 10
    ecall