.data
int: .word 52
res: .word 0

.text
main:
    la s2, res #carica il risultato
    addi s0, zero, 0 #il numero di bit a 1
    lw t0, int #carica il numero
    addi s1, zero, 32 #il max possibile (la word)
    addi t1, zero, 0 #la i
    
for:
    bge t1, s1, end #continua se  i < 32
    andi t2, t0, 1 #calcola il valore dell'ultimo bit
    bne t2, zero, sum #controlla se = 1
    j cont #altrimenti continua
sum:
    addi s0, s0, 1 #qui c'è il numero di 1
    
cont:
    srli t0, t0, 1 #shifta a destra di 1
    addi t1, t1, 1 #i++
    j for
end:
    addi t3, zero, 2 #metti 2 in t3
    rem a0, s0, t3 #calcola il resto di (numeri di 1/2)
    sw a0, 0(s2) #carica il bit di parità in memoria
    li a7, 1 #stampa intero
    ecall
    li a7, 10 #termina
    ecall