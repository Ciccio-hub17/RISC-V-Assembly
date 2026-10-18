.text

bisestile:
    li t0, 0
    
    mv s0, a0
    mv s1, a1
    
    li s2, 100
    li s3, 400
    li s4, 4
    
    for:
        beq t0, a2, end1
        
        lw t1, 0(s0)
        #if anno / 100 e 400 => true else false 
        #else if anno / 4 => bisestile else false
        
        rem t2, t1, s2 #%100
        rem t3, t1, s3 #%400
        rem t4, t1, s4 #%4
        
        beq t2, zero, century
            beq t4, zero, annotrue
            annofalse:
                li t5, 0
                sb t5, 0(s1)
                j end
            annotrue:
                li t5, 1
                sb t5, 0(s1)
                j end
            century:
            beq t3, zero, annotrue
                j annofalse
        
        end:
        addi s1, s1, 1
        addi s0, s0, 4
        addi t0, t0, 1
        j for
        
    end1:
        jr ra