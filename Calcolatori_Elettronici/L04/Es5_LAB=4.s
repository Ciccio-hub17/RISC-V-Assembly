.equ '+', 43
.equ '-', 45
.equ '0', 48
.equ '9', 58

.data
input: .string "Dammi un numero "
err: .string "Errore"
new: .string "\n"
overflow: .string "Il numero è troppo grande"
stringaok: .string "La stringa introdotta è un numero"

.bss
buffer: .zero 32

.text
main:
    li a7, 4
    la a0, input
    ecall
    li a7, 63
    li a0, 0
    la a1, buffer
    li a2, 32
    ecall #input del numero
    
    mv s0, a1 #copia il buffer in s0
    mv t0, a0 #salva il numero di caratteri letti (fa da max)
    li s1, '+' #salva il +
    li s2, '-' #salva il -
    
    lb t1, 0(s0) #salva il primo carattere
    
    xor s3, t1, s1 #controlla se è uguale ad un piu
    
    xor s4, t1, s2 #controlla se è uguale ad un meno
    
    addi s0, s0, 1 #avanza di un carattere
    addi s5, zero, 10 #salva il valore del \n
    li s6, '0'
    li s7, '9'
    beq s3, zero, cont
    beq s4, zero, cont
    j errore
    
cont:
    
    addi t2, zero, 0 #la i
    
for:
    beq t2, t0, endfor
    
    lb t1, 0(s0)
    beq t1, s5, endfor #ho letto il \n
    
    slt t3, t1, s7 #t3 = byte letto < 9
    slt t4, t1, s6 #t1 = byte letto < 0
    not t4, t4 #ne faccio il negato
    
    and t5, t3, t4 #se entrambi sono a 1 questo fara 1
    
    beq t5, zero, errore #altrimenti se fa 0 errore
    
    addi s0, s0, 1 #avanza di un byte
    addi t2, t2, 1 #i++
    j for
    
endfor:
    li a7, 4
    la a0, stringaok
    ecall #stampa che la stringa è buona
    la a0, new
    ecall
    
    addi t0, t0, -2 #max -1
    addi t1, zero, 1 #i
    addi s7, zero, 1 #potenze del 10 che mi servono
    addi t6, zero, 10 #cio che devo moltiplicare
    
potenze:
    beq t1, t0, endpotenze
    mulhu s8, s7, t6 #qui mi serve per trovare eventuale overflow
    bne s8, zero, over
    
    mul s7, s7, t6 #moltiplica per la potenza di 10
    
    addi t1, t1, 1 #i++
    j potenze
endpotenze:
    #addi t0, t0, 3
    addi t1, zero, 0 # i = 0
    mv s0, a1 #s0 = a1
    addi s0, s0, 1 #balza il primo carattere
    addi s5, zero, 0 #s5 = 0
    #s7 occupato
    #s0 occupato
    #t1 occupato
    #t2 occupato
    #t1 occupato
    #s3, s4 occupati
    #s1, s2 occupati
    #s5, s6 liberi
    #t3, t4, liberi
loop:
    beq t1, t0, goodend
    
    lb s3, 0(s0) #metti il byte in s3
    addi s3, s3, -48 #fallo diventare numero
    mulh t3, s3, s7 #parte alta
    mul t4, s3, s7 #parte bassa
    srai s6, t4, 31 #shifta a destra di 31 bit
    
    xor s6, s6, t3 #vedi se i 32 bit coincidono con il primo dei piu piccoli
    
    bne s6, zero, over #se non è zero c'è overflow
    
    add s5, s5, t4 #s5 = s5 + t4 (accumulatore)
    
    srai s8, s5, 31 #shifta s5 di 31 bit aritmetici
    
    xori s8, s8, 0xFFFFFFFF #controlla che sia uguale a -1 (xor = 0)
    
    beq s8, zero, over #controlla
    addi t1, t1, 1 #i++
    addi s0, s0, 1 #shifta di un bit
    div s7, s7, t6 #dividi per la potenza di 10
    j loop
    
goodend:
    beq s4, zero, negnum
fine:    
    li a7, 1
    mv a0, s5
    ecall
    j exit
negnum:
    not s5, s5 #fai il negato della somma che hai calcolato
    addi s5, s5, 1 #aggiungi un per complementare completamente
    j fine
errore:
    li a7, 4
    la a0, err
    ecall
    j exit    

over:
    li a7, 4
    la a0, overflow
    ecall
    j exit    
    
exit:
    li a7, 10
    ecall
    
    
    
    
    
    