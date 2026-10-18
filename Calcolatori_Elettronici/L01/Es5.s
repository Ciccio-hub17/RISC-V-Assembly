.data
msg: .string "Inserisci intero "
conf: .string "Numeri inseriti"
res: .word 0

buffer: .zero 2

.text
main:
    la s1, res #carica l'indirizzo di res
    
    li a7, 4 #stampa stringa
    la a0, msg #dai come argomento la stringa
    ecall
    li a7, 63 #devo dare in input qualcosa
    li a0, 0 #ecco l'aegomento che mi serve
    la a1, buffer #voglio mettere l'input in buffer
    li a2, 2 #max 2 caratteri
    ecall
    lb a0, 0(a1) #carica l'indirizzo del buffer che ho inserito
    addi t1, a0, -48 #calcola l'offset per trasformarlo in intero
    
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
    
    li a7, 4
    la a0, msg
    ecall
    li a7, 63
    li a0, 0
    la a1, buffer
    li a2, 2
    ecall
    lb a0, 0(a1)
    addi t3, a0, -48
    
    li a7, 4
    la a0, msg
    ecall
    li a7, 63
    li a0, 0
    la a1, buffer
    li a2, 2
    ecall
    lb a0, 0(a1)
    addi t4, a0, -48
    
    li a7, 4
    la a0, conf
    ecall
    
    add t5, t1, t2 
    add t6, t3, t4
    sub s0, t5, t6
    
    sw s0, 0(s1)
    li a7, 10
    ecall