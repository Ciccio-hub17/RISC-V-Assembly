.data
int1: .word 80
int2: .word 75
err: .string "Errore"

.text
main:
    lw t0, int1
    lw t1, int2
    li t2, 256
    slt s0, t0, t2
    slt s1, t1, t2
    
    and s2, s0, s1
    
    beq s2, zero, errore
    xor t3, t0, t1
    not t4, t1
    and t5, t0, t4
    not t5, t5
    or a0, t5, t3
    li a7, 1
    ecall
    j end
    
    
errore:
    li a7, 4
    la a0, err
end:    
    li a7, 10
    ecall