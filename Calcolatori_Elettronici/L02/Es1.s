.data
err: .string "Errore, c'è overflow"
res: .word 0
op1: .word 0x7FFFFFFF
op2: .word 0

.text
main:
    #carico gli indirizzi
    la s0, res #metti il risultato in s0
    la s1, op1 #metti op1 in s1
    la s2, op2 #metti op2 in s2
    
    lw t0, 0(s1) #carica il valore di s0 in t0
    lw t1, 0(s2) #fai lo stesso con s1
    
    add t2, t0, t1 #fai la somma
    
    bgt t2, x0, good
    li a7, 4 
    la a0, err
    ecall
    j done
    
good:
    sw t2, 0(s0) #carica il risultato in memoria
    
done:
    li a7, 10
    ecall