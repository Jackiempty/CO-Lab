.data
num_test: .word 18
test1: .word 0, 0       ## invalid
test2: .word 0, -2      ## invalid
test3: .word 0, 7       ## 0
test4: .word 7, 0       ## 1
test5: .word -3, 0      ## 1
test6: .word 1, 4       ## 1
test7: .word 1, 0       ## 1
test8: .word 1, -5      ## 1
test9: .word -1, 5      ## -1
test10: .word -1, 4     ## 1
test11: .word -1, 0     ## 1
test12: .word -1, -5    ## -1
test13: .word -1, -4    ## 1
test14: .word 2, 3      ## 8
test15: .word 2, -3     ## 0
test16: .word -3, 5     ## -243
test17: .word -3, 6     ## 729
test18: .word -3, -3    ## 0

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
    #    t1 : base
    #    t2 : exponent
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
    lw      t1, 0(s1)                # t1(base) = *(test)
    addi    s1, s1, 4                # s1(test)++
    lw      t2, 0(s1)                # t2(exponent) = *(test)
    addi    s1, s1, 4                # s1(test)++
    bne     t1, x0, else             # if(base != 0), go to else
    beq     t2, x0, if               # base == 0, if(exponent == 0), go to if
    blt     t2, x0, if               # base == 0, exponent != 0, if(exponent < 0), go to if
    jal     x0, else                 # base == 0, exponent > 0, go to else

if:
    li      t3, 0                    # t3(valid) = 0
    jal     x0, endif

else:
    ############### Call Function Procedure ###############
    # Caller Saved
    addi    sp, sp, -24              # Allocate stack space
                                     # sp = @sp - 36
    sw      t0, 20(sp)               # t0(*answer) -> MEM[@sp - 16]
    sw      t1, 16(sp)               # t1(base) -> MEM[@sp - 20]
    sw      t2, 12(sp)               # t2(exponent) -> MEM[@sp - 24]
    sw      t3, 8(sp)                # t3(valid) -> MEM[@sp - 28]
    sw      t4, 4(sp)                # t4(result) -> MEM[@sp - 32]
    sw      t5, 0(sp)                # t5(i) -> MEM[@sp - 36]
    # Pass Arguments
    mv      a0, t1                   # a0(base) = t1(base)
    mv      a1, t2                   # a1(exponent) = t2(exponent) 
    
    # Jump to Callee
    jal     ra, FUNC_POW             # ra = Addr(ra = lw   t0, 20(sp) )
    #######################################################
    
    ## Retrieve Caller Saved
    lw      t0, 20(sp)               # t0(*answer) = MEM[@sp - 16]
    lw      t1, 16(sp)               # t1(base) = MEM[@sp - 20]
    lw      t2, 12(sp)               # t2(exponent) = MEM[@sp - 24]
    lw      t3, 8(sp)                # t3(valid) = MEM[@sp - 28]
    lw      t4, 4(sp)                # t4(result) = MEM[@sp - 32]
    lw      t5, 0(sp)                # t5(i) = MEM[@sp - 36]
    addi    sp, sp, 24               # release stack space 

endif:
    mv      t4, a0                   # result = pow(base, exponent)
    sw      t3, 0(t0)                # *(answer) = valid
    addi    t0, t0, 4                # answer++
    sw      t4, 0(t0)                # *(answer) = result
    addi    t0, t0, 4                # answer++
    addi    t5, t5, 1                # i++
    jal     x0, loop                 # go to loop

end_loop:
    ## Retrieve Callee Saved, ra
    lw      ra, 8(sp)                # ra = @ra
    lw      s0, 4(sp)                # s0 = @s0
    lw      s1, 0(sp)                # s1 = @s1
    addi    sp, sp, 12               # release stack space 
    
    ret


FUNC_POW:
    #######################################################
    # < Function >
    #    Power
    #
    # < Parameters >
    #    a0 : base
    #    a1 : exponent
    #
    # < Return Value >
    #    a0 : result
    #######################################################
    # < Local Variable >
    #    t0 : abs(exponent), base
    #    t1 : i
    #    t2 : result
    #    t3 : -1
    #    t4 : 1
    #    t5 : mask_exponent(a)
    #    t6 : b(exponent)
    #######################################################

    ## Save ra & Callee Saved
    # No use saved registers -> No need to do Callee Saved
    addi    sp, sp, -4               # Allocate stack space
                                     # sp = @sp - 4
    sw      ra, 0(sp)                # @ra -> MEM[@sp - 4]

    li      t3, -1                   # t3 = -1
    li      t4, 1                    # t4 = 1

    ## if_1
    bne     a0, t3, else_1           # if(base != -1), go to else_1
if_1:
    ## abs(exponent)
    srai    t5, a1, 31               # t5 = 0xffffffff(-) / 0(+)
    xor     t0, a1, t5               # Inverse(-) / Keep(+)
    sub     t0, t0, t5               # -(-1) / -0
                                     # t0 = abs(exponent)
    
    andi    t0, t0, 1                # t0 = abs(exponent) % 2
    beq     t0, t4, else_2           # if (a == 1), go to else_2

if_2:
    li      t2, 1                    # return 1 
    jal     x0, endif_2

else_2:
    li      t2, -1                   # return -1
    jal     x0, endif_2

endif_2:
    jal     x0, endif_1

else_1:
    mv      t0, a0                   # t0(a) = base
    mv      t6, a1                   # t6(b) = exponent  
    bge     t6, x0, else_3           # if(exponent >= 0)
    beq     t0, t4, else_3           # if(base == 1), go to else_3  
if_3:
    li      t2, 0                    # return 0
    jal     x0, endif_3

else_3:
    li      t2, 1                    # t2(result) = 1 
    li      t1, 0                    # t1(i) = 0
    ## for loop in function
funcloop:
    bge     t1, t6, end_funcloop     # if(i == exponent), fo to end_funcloop
    

    ############### Call Function Procedure ###############
    # Caller Saved
    addi    sp, sp, -28              # Allocate stack space
                                     # sp = @sp - 32
    sw      t6, 24(sp)               # t6 -> MEM[@sp - 8]  
    sw      t0, 20(sp)               # t0 -> MEM[@sp - 8] 
    sw      t1, 16(sp)               # t1(i) -> MEM[@sp - 12]
    sw      t2, 12(sp)               # t2(result) -> [@sp - 16]
    sw      t3, 8(sp)                # t3(-1) -> MEM[@sp - 28]
    sw      t4, 4(sp)                # t4(1) -> MEM[@sp - 24]
    sw      t5, 0(sp)                # t5(mask_exponent(a)) -> MEM[@sp - 28]
    # Pass Arguments
    mv      a0, t2                   # a0(result) = t2(result)
    mv      a1, t0                   # a1(base) = t0(a == base) 
    
    # Jump to Callee
    jal     ra, FUNC_MUL             # ra = Addr(ra = lw   t0, 20(sp) )
    #######################################################

    ## Retrieve Caller Saved
    lw      t6, 24(sp)               # t6 = MEM[@sp - 8]
    lw      t0, 20(sp)               # t0 = MEM[@sp - 8] 
    lw      t1, 16(sp)               # t1(i) = MEM[@sp - 12]
    lw      t2, 12(sp)               # t2(result) = MEM[@sp - 16]
    lw      t3, 8(sp)                # t3(-1) = MEM[@sp - 20]
    lw      t4, 4(sp)                # t4(1) = MEM[@sp - 24]
    lw      t5, 0(sp)                # t5(mask_exponent(a)) = MEM[@sp - 28]
    addi    sp, sp, 28

    mv      t2, a0                   # result = mul(result, base)

    addi    t1, t1, 1                # t1(i)++
    jal     x0, funcloop    
    
end_funcloop:
    jal     x0, endif_3

endif_3:
    jal     x0, endif_1

endif_1:

    ## Pass return value
    mv      a0, t2                   # a0(return value) = t2
                                     
    ## Retrieve ra & Callee Saved
    lw      ra, 0(sp)               # ra = @ra
    addi    sp, sp, 4               # sp = @sp
    
    ## return
    ret                              # jalr  x0, ra, 0



FUNC_MUL:
    #######################################################
    # < Function >
    #    It can handle multiplication of 2 integer variables
    #
    # < Parameters >
    #    a0 : multiplicand
    #    a1 : multiplier
    #
    # < Return Value >
    #    a0 : result
    #######################################################
    # < Local Variable >
    #    t0 : mask_a
    #    t1 : mask_b
    #    t2 : abs(multiplicand) / smaller one 
    #    t3 : abs(multiplier) / bigger one
    #    t4 : mask_result
    #    t5 : i
    #    t6 : result
    #######################################################
    
    ## Save ra & Callee Saved
    # No use saved registers -> No need to do Callee Saved
    addi    sp, sp, -4               # Allocate stack space
                                     # sp = @sp - 4
    sw      ra, 0(sp)                # @ra -> MEM[@sp - 4]
    
    ## abs(multiplicand)
    srai    t0, a0, 31               # t0 = 0xffffffff(-) / 0(+)
    xor     t2, a0, t0               # Inverse(-) / Keep(+)
    sub     t2, t2, t0               # -(-1) / -0
                                     # t2 = abs(multiplicand)
    
    ## abs(multiplier)
    srai    t1, a1, 31               # t1 = 0xffffffff(-) / 0(+)
    xor     t3, a1, t1               # Inverse(-) / Keep(+)
    sub     t3, t3, t1               # t3 = abs(multiplier) 
    
    ## mask_result
    xor     t4, t0, t1               # t4 = 0xffffffff(-) / 0(+)
    
    ## array[2] = {a, b}
    addi    sp, sp, -8               # Allocate stack space
                                     # sp = @sp - 12
    sw      t3, 4(sp)                # t3 -> MEM[@sp - 8]
    sw      t2, 0(sp)                # t2 -> MEM[@sp - 12]
    
    ############### Call Function Procedure ###############
    # Caller Saved
    addi    sp, sp, -4               # Allocate stack space
                                     # sp = @sp - 16
    sw      t4, 0(sp)                # t4 -> MEM[@sp - 16]
    
    # Pass Arguments
    addi    a0, sp, 4                # a0 = &array
    
    # Jump to Callee
    jal     ra, FUNC_TWO_SORT        # ra = Addr(lw  t4, 0(sp))
    #######################################################
    
    # Retrieve Caller Saved
    lw      t4, 0(sp)                # t4(mask_result)
    lw      t2, 4(sp)                # t2 = smaller one 
    lw      t3, 8(sp)                # t3 = bigger one
    
    ## Do multiplication through successive addition
    li      t5, 0                    # t5(i) = 0
    li      t6, 0                    # t6(result) = 0
    bge     t5, t2, FMUL_endWhile_1  # if (i >= smaller), go to endWhile
FMUL_while_1:
    add     t6, t6, t3               # result += bigger
    addi    t5, t5, 1                # i++
    blt     t5, t2, FMUL_while_1     # if (i < smaller), go to while
FMUL_endWhile_1: 
    
    ## Now, t6 = abs(result)
    ## Append sign on the t6
    xor     t6, t6, t4               # Inverse(-) / Keep(+)
    sub     t6, t6, t4               # -(-1) / -0
                                     # t6 = result
                                     
    ## Pass return value
    mv      a0, t6                   # a0(return value) = t6
                                     
    ## Retrieve ra & Callee Saved
    lw      ra, 12(sp)               # ra = @ra
    addi    sp, sp, 16               # sp = @sp
    
    ## return
    ret                              # jalr  x0, ra, 0
    
    
FUNC_TWO_SORT:
    #######################################################
    # < Function >
    #    Do sorting
    #    * Put the smaller one in *array
    #    * Put the bigger one in *(array+1)
    #
    # < Parameters >
    #    a0 : int *array
    #
    # < Return Value >
    #    NULL
    #######################################################
    # < Local Variable >
    #    t0 : a
    #    t1 : b
    #######################################################
    
    ## Save ra & Callee Saved
    # No Function Call -> No need to save ra
    # No use saved registers -> No need to do Callee Saved
    
    lw      t0, 0(a0)                # a = *array
    lw      t1, 4(a0)                # b = *(array+1)
    
    bleu    t0, t1, FUNC_TWO_EXIT    # if a <= b, no need to swap
     
    sw      t1, 0(a0)                # smaller -> *array
    sw      t0, 4(a0)                # bigger -> *(array+1)
FUNC_TWO_EXIT:
    ret                              # return