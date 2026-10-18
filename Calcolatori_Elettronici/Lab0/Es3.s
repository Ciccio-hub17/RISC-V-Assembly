.data
mat: 
    .word 5, 4, 3, 0 ,1
    .word 0, 1, 5, 2, 3
    .word 7, 3, 4, 1, 2
capo:
    .string "\n"
.text
main:
    la s0, mat #c'è l'indirizzo di partenza di mat
    addi t0, zero, 5 #numero di colonne della matrice
    addi s1, zero, 4 #offset
    addi t1, zero, 3 #numero di righe
    addi t2, zero, 0 #la i che serve per ciclare
    mul t5, t0, s1 #lunghezza di una riga
    slli t5, t5, 1 #moltiplica per 2
    add t4, s0, t5 #cosi sono alla terza riga
    
for:
    bge t2, t0, done
    
    lw t6, 0(t4) #carica nella CPU la word dell'indirizzo puntato
    addi t6, t6, 1 #incrementa questo valore di 1
    sw t6, 0(t4) #rimettilo in memoria
    add a0, zero, t6 #copialo in t6
    addi a7, zero, 1 #printa
    ecall #chiama la funzione
    la a0, capo
    addi a7, zero, 4
    ecall
    
    addi t4, t4, 4 #passa alla word successiva
    addi t2, t2, 1 #aumenta la i di 1
    j for
done:
    addi s3, zero, 0 #simulo lo zero se completo il programma
    add a0, s3, zero
    ecall