.data
msg1: .string "Pari"
msg2: .string "Dispari"
buffer: .zero 2

.text
main:
     li a7, 63
     li a0, 0
     la a1, buffer
     li a2, 2
     ecall
     lb t0, 0(a1)
     addi t0, t0, -48
     andi t1, t0, 1
     beq t1, zero, is_even
     li a7, 4
     la a0, msg2
     ecall
     j end
is_even:
    li a7, 4
    la a0, msg1
    ecall
end:
    li a7, 10
    ecall