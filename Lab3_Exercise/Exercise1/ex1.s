.data
num_test: .word 15
test1: .word 8, 0     # invalid
test2: .word 0, 8     # 0
test3: .word 0, -3    # 0
test4: .word 4, 4     # 1
test5: .word 8, 4     # 2
test6: .word 29, 5    # 5
test7: .word 3, 4     # 0
test8: .word -8, 4    # -2
test9: .word -11, 4   # -2
test10: .word -3, 4   # 0
test11: .word 7, -4   # -1
test12: .word 3, -4   # 0
test13: .word -9, -6  # 1
test14: .word -5, -5  # 1
test15: .word -3, -5  # 0

.text
setup:
    li    ra, -1
    li    sp, 0x7ffffff0

main:
    #######################################################
    # < Function >
    #    main procedure
    #
    # < Parameters >
    #    NULL
    #
    # < Return Value >
    #    NULL
    #######################################################
    # < Local Variable >
    #    s0 : num_test
    #    s1 : *test
    #    t0 : *answer
    #    t1 : dividend
    #    t2 : devisor
    #    t3 : valid
    #    t4 : result
    #    t5 : i
    #######################################################

    ## Save ra & Callee Saved
    addi    sp, sp, -12              # Allocate stack space
                                     # sp = @sp - 12
    sw      ra, 8(sp)                # @ra -> MEM[@sp - 4]
    sw      s0, 4(sp)                # @s0 -> MEM[@sp - 8]
    sw      s1, 0(sp)                # @s1 -> MEM[@sp - 12]

    ## Get num_test, *test, *answer
    li      s0, 0x10000000 
    lw      s0, 0(s0)                # s0(num_test) = MEM[0x10000000]
    li      s1, 0x10000004           # s1(*test) = 0x10000004
    li      t0, 0x01000000           # t0(*answer) = 0x01000000
    li      t5, 0                    # t5(i) = 0
    
    
    ## for loop:  
loop:
    bge     t5, s0, end_loop         # if (i >= num_test), go to end_loop
    li      t3, 1                    # t3(valid) = 1
    lw      t1, 0(s1)                # t1(dividend) = *(test)
    addi    s1, s1, 4                # s1(test)++
    lw      t2, 0(s1)                # t2(divisor) = *(test)
    addi    s1, s1, 4                # s1(test)++
    bne     t2, x0, else             # if (divisor != 0), go to else
if:
    li      t3, 0                    # t3(valid) = 0
    jal     x0, endif                # go to endif
else:
    ############### Call Function Procedure ###############
    # Caller Saved
    addi    sp, sp, -24              # Allocate stack space
                                     # sp = @sp - 36
    sw      t0, 20(sp)               # t0(*answer) -> MEM[@sp - 4]
    sw      t1, 16(sp)               # t1(dividend) -> MEM[@sp - 8]
    sw      t2, 12(sp)               # t2(divisor) -> MEM[@sp - 12]
    sw      t3, 8(sp)                # t3(valid) -> MEM[@sp - 16]
    sw      t4, 4(sp)                # t4(result) -> MEM[@sp - 20]
    sw      t5, 0(sp)                # t5(i) -> MEM[@sp - 24]
    # Pass Arguments
    mv      a0, t1                   # a0(dividend) = t1(dividend)
    mv      a1, t2                   # a1(divisor) = t2(divisor) 
    
    # Jump to Callee
    jal     ra, FUNC_DIV             # ra = Addr(ra = lw   t0, 20(sp) )
    #######################################################

    ## Retrieve Caller Saved
    lw      t0, 20(sp)               # t0(*answer) = MEM[@sp - 4] 
    lw      t1, 16(sp)               # t1(dividend) = MEM[@sp - 8]
    lw      t2, 12(sp)               # t2(divisor) = MEM[@sp - 12]
    lw      t3, 8(sp)                # t3(valid) = MEM[@sp - 16]
    lw      t4, 4(sp)                # t4(result) = MEM[@sp - 20]
    lw      t5, 0(sp)                # t5(i) = MEM[@sp - 24]
    addi    sp, sp, 24
    
    mv      t4, a0                   # result = div(dividend, divisor)
    
    
endif:
    sw      t3, 0(t0)                # *(answer) = valid
    addi    t0, t0, 4                # answer++
    sw      t4, 0(t0)                # *(answer) = result
    addi    t0, t0, 4                # answer++
    addi    t5, t5, 1                # i++
    jal     x0, loop                 # go to loop

end_loop:
    lw      ra, 8(sp)                # ra = @ra
    lw      s0, 4(sp)                # s0 = @s0
    lw      s1, 0(sp)                # s1 = @s1
    addi    sp, sp, 12
    ## return
    ret


     

FUNC_DIV:
    #######################################################
    # < Function >
    #    It can handle division of 2 integer variables
    #
    # < Parameters >
    #    a0 : dividend
    #    a1 : divisor
    #
    # < Return Value >
    #    a0 : result
    #######################################################
    # < Local Variable >
    #    t0 : mask_a
    #    t1 : mask_b
    #    t2 : abs(dividend)
    #    t3 : abs(divisor)
    #    t4 : mask_result
    #    t5 : i(result)
    #    t6 : temp_bigger  
    #######################################################
    
    ## Do yourself
    ## Save ra & Callee Saved
    # No use saved registers -> No need to do Callee Saved
    addi    sp, sp, -4               # Allocate stack space
                                     # sp = @sp - 4
    sw      ra, 0(sp)                # @ra -> MEM[@sp - 4]
    
    ## abs(dividend)
    srai    t0, a0, 31               # t0 = 0xffffffff(-) / 0(+)
    xor     t2, a0, t0               # Inverse(-) / Keep(+)
    sub     t2, t2, t0               # -(-1) / -0
                                     # t2 = abs(dividend)
    
    ## abs(divisor)
    srai    t1, a1, 31               # t1 = 0xffffffff(-) / 0(+)
    xor     t3, a1, t1               # Inverse(-) / Keep(+)
    sub     t3, t3, t1               # t3 = abs(divisor) 
    
    ## mask_result
    xor     t4, t0, t1               # t4 = 0xffffffff(-) / 0(+)
    
    ## Do division through successive subtraction
    li      t5, 0                    # t5(i) = 0
    mv      t6, t2                   # t6(dividend) = t2
    blt     t6, t3 FDIV_endWhile_1   # if (dividend < divisor), go to endWhile
FDIV_while_1:
    sub     t6, t6, t3               # dividend -= divisor
    addi    t5, t5, 1                # i++
    bge     t6, t3 FDIV_while_1      # if (dividend >= divisor), go to while  
FDIV_endWhile_1:
    
    ## Now, t5 = abs(result)
    ## Append sign on the t5
    xor     t5, t5, t4               # Inverse(-) / Keep(+)
    sub     t5, t5, t4               # -(-1) / -0
                                     # t5 = result
                                     
    ## Pass return value
    mv      a0, t5                   # a0(return value) = t5
                                     
    ## Retrieve ra & Callee Saved
    lw      ra, 0(sp)               # ra = @ra
    addi    sp, sp, 4               # sp = @sp
    
    ## return
    ret                              # jalr  x0, ra, 0