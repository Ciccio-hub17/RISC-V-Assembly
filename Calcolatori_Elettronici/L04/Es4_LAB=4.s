.equ '0', 48
.equ '9', 58

.data
num: .string "Dammi un  numero "
new: .string "\n"
succ: .string "La stringa inserita è fatta totalmente da numeri"
err: .string "Errore"
over: .string "Il numero è troppo grande"
res: .word 1
.bss
buffer: .zero 32

.text
main:
    la a0, num 
     li a7, 4
     ecall #carica un numero
     li a0, 0
     la a1, buffer
     li a2,32
     li a7, 63
     ecall #leggi un numero di max 31 cifre (piu \n)
     
     mv s0, a1 #s0 <- Adx Buffer
     addi t0, zero, 0 #inizializza la i
     addi t1, zero, 31 #arriva max a 31
     li s1, '0' #metti 48 (ASCII di 0) in s1
     li s2, '9' #metti 57 (ASCII di 9+1) in s2
     addi s5, zero, 10 #metti 10 in s5 (per il \n)
     
 for:
     beq t0, t1, end #controlla la I
     lb t2, 0(s0) #carica un byte in t2
     
     slt t3, t2, s2 #controllo t2 < 9
     slt t4, t2, s1 #controllo t2 < 0
     not t4, t4 #ne faccio il negato
     
     and t5, t3, t4 #se entrambi sono a 1
     beq t2, s5, end #questo controlla il \n
     
     beq t5, zero, errore #lui controlla che sia una cifra
     j cont #se lo è continua
     
errore: #altrimenti manda in errore e termina il programma
    li a7, 4
    la a0, err
    ecall
    j exit
    
cont: #se il for puo continuare
     addi s0, s0, 1 #scala di un byte
     addi t0, t0, 1 #i++
     j for #continua
 
end: #dopo il for
    li a7, 4
    la a0, succ
    ecall #stampa che la stringa letta è un numero
    li a7, 4
    la a0, new
    ecall #vai a capo
    
    addi s0, zero, 0 #s0 = 0 (la i)
    addi s1, zero, 1 #s1 = 1 (Accumulatore di potenza)
    addi s2, zero, 10 #s2 = 10 (potenza da moltiplicare)
    addi t0, t0, -1 #t0--
    
loop: #lui capisce quante cifre ci sono
    beq s0, t0, end1 #lui controlla quando è il momento di uscire
    mul s1, s1, s2 #moltiplica per potenze di 10
    
    #qui potrei fare un controllo che salta 
    #se trova una potenza di 10 in overflow
    mulhu s3, s1, s2
    bne s3, zero, overflow
    
    addi s0, s0, 1 #i++
    j loop
    
end1:
    addi s0, zero, 0 #s0 = 0 (la i)
    addi s4, zero, 0 #s4 = 0 (mi serve per salvare la somma)
    addi t0, t0, 1 #t0++ (sempre il max della i)
    
for2:
    beq s0, t0, end2
    lbu s5, 0(a1) #s5 = leggi un byte
    addi s5, s5, -48 #convertilo in intero
    
    mulhu s6, s5, s1
    mul s5, s5, s1 #moltiplica per la potenza di 10
    
    bne s6, zero, overflow #controlla che il numero appena calcolato non sia in overflow
    
    
    add s4, s4, s5 #aggiungi al risultato temporaneo
    
    bltu s4, s5, overflow

    addi a1, a1, 1 #incrementa di un byte
    div s1, s1, s2 #dividi per una potenza di 10
    addi s0, s0, 1 #i++
    j for2
    
end2:
    
    mv a0, s4 #metti il numero in a0
    li a7, 1
    ecall #stampalo
    la s6, res
    sw s4, 0(s6) #mettilo in memoria
    j exit
    
overflow:
    li a7, 4
    la a0, over
    ecall #di che sei in overflow
    j exit
    
exit:
    li a7, 10
    ecall