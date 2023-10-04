.data
num_test: .word 5
test1: .word -10      ## -1
test2: .word 0        ## 1
test3: .word 1        ## 1
test4: .word 5        ## 120
test5: .word 10       ## 3628800

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
    #    t1 : result
    #    t2 : i
    #    t3 : n
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
    li      t2, 0                    # t2(i) = 0

    ## for loop
loop:
    bge     t2, s0, end_loop         # if(i >= num_test), go to end_loop
    lw      t3, 0(s1)                # int n = *test
    addi    s1, s1, 4                # test++

    ############### Call Function Procedure ###############
    # Caller Saved
    addi    sp, sp, -16              # Allocate stack space
                                     # sp = @sp - 28
    sw      t0, 12(sp)               # t0(*answer) -> MEM[@sp - 16]
    sw      t1, 8(sp)                # t1(result) -> MEM[@sp - 20]
    sw      t2, 4(sp)                # t2(i) -> MEM[@sp - 24]
    sw      t3, 0(sp)                # t3(n) -> MEM[@sp - 28]
    
    # Pass Arguments
    mv      a0, t3                   # a0(n) = t3(n)
    
    # Jump to Callee
    jal     ra, FUNC_FAC             # ra = Addr(lw   t0, 12(sp))
    #######################################################
    
    ## Retrieve Caller Saved
    lw      t0, 12(sp)               # t0(*answer) = MEM[@sp - 16]
    lw      t1, 8(sp)                # t1(result) = MEM[@sp - 20]
    lw      t2, 4(sp)                # t2(i) = MEM[@sp - 24]
    lw      t3, 0(sp)                # t3(n) = MEM[@sp - 28]
    addi    sp, sp, 16               # release stack space

    mv      t1, a0                   # result = factorial(n)
    sw      t1, 0(t0)                # *answer = result
    addi    t0, t0, 4                # answer++
    addi    t2, t2, 1                # i++
    jal     x0, loop                 # go to loop

end_loop:

    ## Retrieve Callee Saved, ra
    lw      ra, 8(sp)                # ra = @ra
    lw      s0, 4(sp)                # s0 = @s0
    lw      s1, 0(sp)                # s1 = @s1
    addi    sp, sp, 12               # release stack space 
    
    ret

FUNC_FAC:
    #######################################################
    # < Function >
    #    Factorial
    #
    # < Parameters >
    #    a0 : n
    #
    # < Return Value >
    #    a0 : result
    #######################################################
    # < Local Variable >
    #    t0 : n
    #    t1 : result
    #    t2 : n-1
    #    t3 : factorial(n-1)
    #######################################################

    ## Save ra & Callee Saved
    # No use saved registers -> No need to do Callee Saved
    addi    sp, sp, -4               # Allocate stack space
                                     # sp = @sp - 4
    sw      ra, 0(sp)                # @ra -> MEM[@sp - 4]

    mv      t0, a0                   # t0 = n
    addi    t2, t0, -1               # t2 = n-1
    blt     t0, x0, if_1             # if(n < 0), go to if_1
    beq     t0, x0, if_2             # if(n == 0), go to if_2
    jal     x0, else                 # else(n > 0), go to else
        
if_1:
    li      t1, -1                   # result = -1
    jal     x0, end_if
    
if_2:
    li      t1, 1                    # result = 1
    jal     x0, end_if
    
else:   
    ############### Call Function Procedure ###############
    # Caller Saved
    addi    sp, sp, -16              # Allocate stack space
                                     # sp = @sp - 20
    sw      t0, 12(sp)               # t0(n) -> MEM[@sp - 8]
    sw      t1, 8(sp)                # t1(result) -> MEM[@sp - 12]
    sw      t2, 4(sp)                # t2(n-1) -> MEM[@sp - 16]
    sw      t3, 0(sp)                # t3(factorial(n-1)) -> MEM[@sp - 20]
    
    # Pass Arguments
    mv      a0, t2                   # a0(n) = t2(n-1)
    
    # Jump to Callee
    jal     ra, FUNC_FAC             # ra = Addr(lw   t0, 8(sp))
    #######################################################
    
    ## Retrieve Caller Saved
    lw      t0, 12(sp)               # t0(n) = MEM[@sp - 8]
    lw      t1, 8(sp)                # t1(result) = MEM[@sp - 12]
    lw      t2, 4(sp)                # t2(n-1) = MEM[@sp - 16]
    lw      t3, 0(sp)                # t3(factorial(n-1)) = MEM[@sp - 20]
    addi    sp, sp, 16               # release stack space
    
    ## do n * factorial(n-1)
    mv      t3, a0                   # t3 = factorial(n-1)   
    ############### Call Function Procedure ###############
    # Caller Saved
    addi    sp, sp, -16              # Allocate stack space
                                     # sp = @sp - 20
    sw      t0, 12(sp)               # t0(n) -> MEM[@sp - 8]
    sw      t1, 8(sp)                # t1(result) -> MEM[@sp - 12]
    sw      t2, 4(sp)                # t2(n-1) -> MEM[@sp - 16]
    sw      t3, 0(sp)                # t3(factorial(n-1)) -> MEM[@sp - 20]
    
    # Pass Arguments
    mv      a0, t0                   # a0 = t0(n)
    mv      a1, t3                   # a1 = t3(factorial(n-1))
    # Jump to Callee
    jal     ra, FUNC_MUL             # ra = Addr(lw   t0, 8(sp))
    #######################################################
    
    ## Retrieve Caller Saved
    lw      t0, 12(sp)               # t0(n) = MEM[@sp - 8]
    lw      t1, 8(sp)                # t1(result) = MEM[@sp - 12]
    lw      t2, 4(sp)                # t2(n-1) = MEM[@sp - 16]
    lw      t3, 0(sp)                # t3(factorial(n-1)) = MEM[@sp - 20]
    addi    sp, sp, 16               # release stack space
    
    mv      t1, a0                   # result = n * factorial(n-1)

end_if:
    mv      a0, t1                   # return result
    ## Retrieve ra
    lw      ra, 0(sp)                # ra = @ra  
    addi    sp, sp, 4                # release stack space 

    ret
    
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