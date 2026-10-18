.equ '0', 48
.equ '9', 57

.data
num: .string "Dammi un  numero "
new: .string "\n"
succ: .string "La stringa inserita è fatta totalmente da numeri"
err: .string "Errore"
.bss
buffer: .zero 5

.text
main:
     la a0, num
     li a7, 4
     ecall
     li a0, 0
     la a1, buffer
     li a2, 5
     li a7, 63
     ecall
     
     mv s0, a1
     addi t0, zero, 0
     addi t1, zero, 4
     li s1, '0'
     li s2, '9'
     
 for:
     beq t0, t1, end2
     lb t2, 0(s0)
     
     slt t3, t2, s2 #controllo t2 < 9
     slt t4, t2, s1 #controllo t2 < 0
     not t4, t4 #ne faccio il negato
     
     and t5, t3, t4 #se entrambi sono a 1
     
     beq t5, zero, errore
     j cont
errore:
    li a7, 4
    la a0, err
    ecall
    j end1
cont:    
     addi s0, s0, 1
     addi t0, t0, 1
     j for
 end1:
     li a7, 10
     ecall
     
end2:
    li a7, 4
    la a0, succ
    ecall
    li a7, 10
    ecall