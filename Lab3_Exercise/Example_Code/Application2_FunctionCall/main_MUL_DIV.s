.data
n1: .word 3
n2: .word 7

.text
setup:
    li      ra, -1
    li      sp, 0x7ffffff0
    
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
    #    s0 : a
    #    s1 : b
    #    t0 : c 
    #    t1 : d
    #    t2 : e
    #    t3 : result
    #######################################################
    
    ## Save ra & Callee Saved
    addi    sp, sp, -12              # Allocate stack space
                                     # sp = @sp - 12
    sw      ra, 8(sp)                # @ra -> MEM[@sp - 4]
    sw      s0, 4(sp)                # @s0 -> MEM[@sp - 8]
    sw      s1, 0(sp)                # @s1 -> MEM[@sp - 12]
    
    ## Get a, b
    la      s0, n1                   # s0 = Addr(a)
    lw      s0, 0(s0)                # s0(a) = MEM[s0]
    lw      s1, n2                   # s1(b) = MEM[Addr(b)]
    
    add     t0, s0, s1               # t0(c) = s0(a) + s1(b)
    sub     t1, s0, s1               # t1(d) = s0(a) - s1(b)
    
    ############### Call Function Procedure ###############
    # Caller Saved
    addi    sp, sp, -8               # Allocate stack space
                                     # sp = @sp - 20
    sw      t0, 4(sp)                # t0(c) -> MEM[@sp - 16]
    sw      t1, 0(sp)                # t1(d) -> MEM[@sp - 20]
    
    # Pass Arguments
    mv      a0, t0                   # a0(multiplicand) = t0(c)
    mv      a1, t1                   # a1(multiplier) = t1(d) 
    
    # Jump to Callee
    jal     ra, FUNC_MUL             # ra = Addr(addi  sp, sp, -4)
    #######################################################
    
    
    ############### Call Function Procedure ###############
    # Caller Saved
    addi    sp, sp, -4               # Allocate stack space
                                     # sp = @sp - 24
    sw      a0, 0(sp)                # a0(e) -> MEM[@sp - 24]
    
    # Pass Arguments
    lw      a0, 8(sp)                # a0(dividend) = c
    lw      a1, 4(sp)                # a1(divisor) = d 
    
    # Jump to Callee
    jal     ra, FUNC_DIV             # ra = Addr(lw  t0, 8(sp))
    #######################################################
    
    ## Retrieve Caller Saved
    lw      t0, 8(sp)                # t0 = c
    lw      t1, 4(sp)                # t1 = d
    lw      t2, 0(sp)                # t2 = e
    
    add     t3, s0, s1               # t3 = s0(a) + s1(b)
    add     t4, t0, t1               # t4 = t0(c) + t1(d)
    add     t3, t3, t4               # t3 = a + b + c + d
    add     t4, t2, a0               # t4 = t2(e) + a0(f) 
    add     t3, t3, t4               # t3 = result
    
    ## Retrieve ra & Retrieve Callee Saved
    lw      s1, 12(sp)                # s1 = @s1
    lw      s0, 16(sp)                # s0 = @s0
    lw      ra, 20(sp)                # ra = @ra
    
    addi    sp, sp, 24                # Release stack space
                                      # sp = @sp
    ## retrun
    ret                               # jalr  x0, ra, 0

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
     
    sw      t1, 0(a0)                # *array = b
    sw      t0, 4(a0)                # *(array+1) = a
FUNC_TWO_EXIT:
    ret                              # return
    

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
    #    t2 : abs(dividee) / smaller one 
    #    t3 : abs(divider) / bigger one
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

    ## Do division through successive subtraction
    li      t5, 0                    # t5(i) = 0
    mv      t6, t3                   # t6(temp_bigger) = 0
    blt     t6, t2 FDIV_endWhile_1   # if (temp_bigger < smaller), go to endWhile
FDIV_while_1:
    sub     t6, t6, t2               # temp_bigger -= smaller
    addi    t5, t5, 1                # i++
    bge     t6, t2 FDIV_while_1      # if (temp_bigger >= smaller), go to while  
FDIV_endWhile_1:
    
    ## Now, t5 = abs(result)
    ## Append sign on the t5
    xor     t5, t5, t4               # Inverse(-) / Keep(+)
    sub     t5, t5, t4               # -(-1) / -0
                                     # t5 = result
                                     
    ## Pass return value
    mv      a0, t5                   # a0(return value) = t5
                                     
    ## Retrieve ra & Callee Saved
    lw      ra, 12(sp)               # ra = @ra
    addi    sp, sp, 16               # sp = @sp
    
    ## return
    ret                              # jalr  x0, ra, 0
