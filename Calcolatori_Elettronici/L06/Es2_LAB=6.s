.equ ';', 59 
.data

alimenti: .string "Pomodoro;Pasta;Formaggio;Sale;Uova;Olio;"

dispensa: .word 100, 80, 34, 5, 48, 24
          .word 75, 16, 11, 4, 7, 10

alimento: .string "Formaggio"

.text

main:
    la a0, dispensa
    la a1, alimenti
    la a2, alimento
    jal gestisciDispensa
    li a7, 10
    ecall
    
gestisciDispensa:
    li s0, 4
    mv t0, a2
    
    