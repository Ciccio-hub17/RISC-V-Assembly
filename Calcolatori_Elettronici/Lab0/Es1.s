.data # dichiarazione dati
op1: .byte 3
op2: .byte 2
.bss # variabili inizializzate a 0
res: .zero 1
.text
.globl main
main: lb t1, op1 # caricamento dati
lb t2, op2
add t1, t1, t2 # calcolo somma

la t3, res
sb t1, 0(t3) # salvataggio in memoria
li a7, 10 # codice per uscita dal programma
ecall # fine

