.data
mystring: .string "ciao"
conv1: .string "A"
conv2: .string "a"

.text
main:
    la t0, mystring #carica stringa in mem
    lb t1, conv1 #carica A
    lb t2, conv2 #carica a
    sub t3, t1, t2 #calcola la distanza
    addi t4, zero, 0 #la i
    addi t5, zero, 4 #max
for: bge t4, t5, done

    lb t6, 0(t0) #carica il carattere
    add t6, t6, t3 #converti in maiuscolo
    sb t6, 0(t0) #metti giu il carattere
    addi t0, t0, 1 #avanti di un byte
    addi t4, t4, 1
    j for
done:
    la a0, mystring
    addi a7, zero, 4
    ecall
    li a7, 10
    ecall