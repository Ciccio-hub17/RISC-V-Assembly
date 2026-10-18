.data
vet: .word 2, 5, 7, -3, 1
    
.text
main:
    la t0, vet #contiene l'indice del primo elemento del vettore
    lw t1, 0(t0) #t1 contiene il minimo
    add t3, t0, x0 #t3 mi serve per spostarmi dei byte
    addi t2, x0, 0 #t2 è la i del ciclo for
    addi s0, x0, 5 #s0 contiene il numero di elementi
    
for: bge t2, s0, done #condizione per terminare il for
    lw t4, 0(t3) #t4 contiene il valore del vettore in cui mi trovo
    bge t4, t1, skip #condizione if per l'else
    add t1, t4, x0 #aggiorno se la condizione è falsa
    skip:
    addi t2, t2, 1 #aggiorna la i
    addi t3, t3, 4 #aggiorno la poisizione in cui sono
    j for #skippa all'etichetta del for
done:
    add a0, t1, x0 #metti il minimo in a0 per poterlo stampare
    li a7, 1 #esegui una print
    ecall #chiama la funzione
    
    
    
    
    
    
    
    
    