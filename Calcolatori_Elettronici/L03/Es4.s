.data
parola: .half 0x00000007

.text
main:
    lw s1, parola
    addi s0, zero, 16
    addi t0, zero, 0
    addi a0, zero, 0
for: bge t0, s0, end
    andi t1, s1, 1
    
    beq t1, zero, cont
    addi a0, a0, 1 
cont:    
    srli s1, s1, 1
    addi t0, t0, 1
    j for
end:
    li a7, 1
    ecall
    li a7, 10
    ecall
    