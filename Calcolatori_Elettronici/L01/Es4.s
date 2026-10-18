.data
msg: .string "Inserisci intero "

buffer: .zero 2

.text
main:
    li a7, 4
    la a0, msg
    ecall
    
    li a7, 63
    li a0, 0
    la a1, buffer
    li a2, 2
    ecall
    lb a0, 0(a1)
    addi t1, a0, -48
    li a7, 4
    la a0, msg
    ecall
    li a7, 63
    li a0, 0
    la a1, buffer
    li a2, 2
    ecall
    lb a0, 0(a1)
    addi t2, a0, -48
    add t1, t1, t2
    sub t2, t1, t2
    sub t1, t1, t2
    
    
    