.data
int: .word 0x0000AA00
pattern: .string "Il pattern è presente"
nopattern: .string "il pattern non è presente"

.text
main:
    addi s0, zero, 8 #devo scorrere di 8 bit
    lw t0, int #carica l'intero in t0
    srli t0, t0, 8 #shifta di 8 bit
    addi t1, zero, 0 #la i
    addi t2, zero, 2 #metti due in t2
    addi s1, zero, 1 #ipotizzo che la sequenza sia presente
for:
    bge t1, s0, end #continua mentre i < 8
    rem t3, t1, t2 #vedi se la i è in posizione pari o dispari
    andi t4, t0, 1 #vedi se l'ultimo bit = 0 o 1
    beq t3, zero, control0
    
    beq t4, s1, cont #salta se l'ultimo bit = 1
    addi s1, zero, 0 #altrimenti la sequenza non c'è 
    j end

control0:
    bne t4, s1, cont #salta se l'ultimo bit = 0
    addi s1, zero, 0 #altrimenti la sequenza non c'è 
    j end

cont:    
    srli t0, t0, 1 #shifta di un bit
    addi t1, t1, 1 #i+1
    j for
    
end:
    li a7, 4
    beq s1, zero, false
    la a0, pattern
    j Fine
false:
    la a0, nopattern

Fine:
    ecall
    li a7, 10
    ecall