.text
.globl numSoluzioniReali

numSoluzioniReali:
	mul t0, a1, a1
	li t1, -4
	mul t2, t1, a0
	mul t2, t2, a2

	add t2, t0, t2

	slt t3, zero, t2 #t3 = 1 if t2 >= 0

	beq t3, zero, zerosoluzioni
	beq t2, zero, unasoluzione
	li a0, 2
	jr ra
zerosoluzioni:
	li a0, 0
	jr ra
unasoluzione:
	li a0, 1
	jr ra

	
	