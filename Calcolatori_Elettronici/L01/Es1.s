.data
n1: .byte 10
n2: .byte 0x10
n3: .string "1"

.bss
res: .zero 1

.text
main:
    lb t0, n1 #metti n1 in t0
    lb t1, n2 #metti n1 in t0
    lb t2, n3 #metti n1 in t0
    
    sub t3, t0, t1 # t3 = n1 - n2
    add t4, t3, t2 #t4 = t3 + n3
    
    la t5, res #carica l'indirzzo di res
    sb t4, 0(t5) #carica in memoria
    li a7, 1
    add a0, zero, t4
    ecall
    li a7, 10 #termina il programma
    ecall