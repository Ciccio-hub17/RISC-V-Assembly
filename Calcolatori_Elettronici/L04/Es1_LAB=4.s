.data
op1: .word 0x0000D000
op2: .word 0xFFFFD000
over: .string "overflow\n"

.text
main:
    lw s0, op1
    lw s1, op2
    
    mulhu t0, s0, s0
    mulhu t1, s1, s1
    mulhu t2, s0, s1
    
    beq t0, zero, good1
    li a7, 4
    la a0, over
    ecall
    j end1
good1:
    li a7, 36
    mul a0, s0, s0
    ecall
    
end1:
    
    beq t1, zero, good2
    li a7, 4
    la a0, over
    ecall
    j end2
good2:
    li a7, 1
    addi a0, t1, 0
    ecall
end2:
    
    beq t2, zero, good3
    li a7, 4
    la a0, over
    ecall
    j end3
good3:
    li a7, 1
    addi a0, t2, 0
    ecall
end3:
    
    li a7, 10
    ecall