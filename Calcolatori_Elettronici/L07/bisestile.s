.text
.globl bisestile
bisestile:
	li t0, 0

ciclo:
	bge t0, a2, fine_ciclo # se i >= lunghezza esci
	lw t1, 0(a0) # leggo l'anno corrente
	li t2, 100
	li t3, 400
	li t4, 4

	rem t5, t1, t3
	beq t5, zero, e_bisestile
	j non_bisestile

non_secolare:
    # L'anno non è secolare, controllo la divisibilità per 4
    rem t5, t1, t4    # t5 = anno % 4
    beq t5, zero, e_bisestile
    j non_bisestile

e_bisestile:
    li t6, 1          # Preparo un 1
    j salva_risultato

non_bisestile:
    li t6, 0          # Preparo un 0

salva_risultato:
	sb t6, 0(a1)
	# avanzo i cicli
	addi a0, a0, 4
	addi a1, a1, 1
	addi t0, t0, 1
	j ciclo

fine_ciclo:
	jr ra