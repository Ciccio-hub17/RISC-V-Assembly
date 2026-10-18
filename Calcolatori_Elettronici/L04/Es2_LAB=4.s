.data
 op1: .word 0x0000D000
op2: .word 0xFFFFD000
over: .string "Overflow"
new: .string "\n"

.text
main:
    lw s0, op1
    lw s1, op2
    
    mul t0, s0, s0
    mul t1, s1, s1
    mul t2, s0, s1
    
    mv s2, t0
    mv s3, t1
    mv s4, t2
    
    mulh t3, s0, s0
    mulh t4, s1, s1
    mulh t5, s0, s1
    
    srai s2, s2, 31
    srai s3, s3, 31
    srai s4, s4, 31
    
    beq s2, t3, good1
    li a7, 4
    la a0, over
    ecall
    la a0, new
    ecall
    j end1
good1:
    li a7, 1
    addi a0, t0, 0
    ecall
    li a7, 4
    la a0, new
    ecall
end1:
    beq s3, t4, good2
    li a7, 4
    la a0, over
    ecall
    la a0, new
    ecall
    j end2
good2:
    li a7, 1
    addi a0, t1, 0
    ecall
    li a7, 4
    la a0, new
    ecall
end2:
    beq s4, t5, good3
    li a7, 4
    la a0, over
    ecall
    la a0, new
    ecall
    j end3
good3:
    li a7, 1
    addi a0, t2, 0
    ecall
    li a7, 4
    la a0, new
    ecall
end3:
    li a7, 10
    ecall
    
    