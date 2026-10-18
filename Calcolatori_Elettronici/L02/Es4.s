.data
str: .string "abceebceebeebbacacb0"
msg: .string "Occorrenze per la lettera "
msg2: .string " nella stringa "
c: .byte 98

.text
main:
    lb s1, c
    la s0, str
    la t2, str
    addi t2, t2, 1
    lb t0, 0(s0)
    addi t1, t1, 0
    
while: 
    beq t0, x0, done
    
    bne t0, s1, else
    addi t1, t1, 1
else:
    addi t2, t2, 1
    lb t0, 0(t2)
    j while
done:
    la a0, msg
    li a7, 4
    ecall
    
    addi a0, s1, 0
    li a7, 11
    ecall
    
    la a0, msg2
    li a7, 4
    ecall
    
    la a0, str
    li a7, 4
    ecall
    
    addi a0, t1, 0
    li a7, 1
    ecall
    
    li a7, 10
    ecall
    
