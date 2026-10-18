.equ '1', 49
.text
main:
    lw s0, opa
    lw s1, opb
    
    li a7, 4
    la a0, msg
    ecall
    
    li a7, 63
    la a1, buffer
    li a2, 2
    li a0, 0
    ecall
    
    lb t0, buffer
    li s2, 0
    li s3, 4
    addi t0, t0, -'1'
    blt t0, s2, error
    bge t0, s3, error
    
    slli t0, t0, 2
    la t1, tabella
    add t2, t0, t1
    lw t3, 0(t2)
    jr t3
    
    
somma: add a0, s0, s1
    j end
sottrazione: sub a0, s0, s1
    j end
moltiplicazione: mul a0, s0, s1
    j end
divisione: div a0, s0, s1
    j end
error:
    li a7, 4
    la a0, err
    ecall
    j exit
end:
    li a7, 1
    ecall
    j exit
exit:
    li a7, 10
    ecall
    
.data
tabella: .word somma, sottrazione, moltiplicazione, divisione
opa: .word 2043
opb: .word 5
res: .word 0
msg: .string "Dammi un numero da 1 a 4 "
err: .string "Input errato"

.bss
buffer: .word 2