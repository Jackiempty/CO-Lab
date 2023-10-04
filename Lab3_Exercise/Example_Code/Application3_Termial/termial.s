.data
n:  .word 10

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
    #    t0 : n
    #    t1 : result
    #######################################################
    
    ## Save ra & Callee Saved
    # No use saved registers -> No need to do Callee Saved
    addi    sp, sp, -4               # Allocate stack space
                                     # sp = @sp - 4
    sw      ra, 0(sp)                # @ra -> MEM[@sp - 4]
    
    ## Get n
    la      t0, n                    # t0 = Addr(n)
    lw      t0, 0(t0)                # t0(n) = MEM[t0]
    
    ############### Call Function Procedure ###############
    # Caller Saved
    
    # Pass Arguments
    mv      a0, t0                   # a0(n) = t0(n)
    
    # Jump to Callee
    jal     ra, FUNC_TERMIAL         # ra = Addr(mv  t1, a0)
    #######################################################
    
    ## Get return value
    mv      t1, a0                   # t1 = termial(n)  
    
    ## Retrieve ra & Retrieve Callee Saved
    lw      ra, 0(sp)                # ra = @ra
    addi    sp, sp, 4                # Release stack space
                                     # sp = @sp
    ## retrun
    ret                              # jalr  x0, ra, 0

FUNC_TERMIAL:
    #######################################################
    # < Function >
    #    n + (n-1) + (n-2) + ... + 1
    #
    # < Parameters >
    #    a0 : n
    #
    # < Return Value >
    #    a0 : n + termial(n-1)
    #######################################################
    # < Local Variable >
    #    t0 : n
    #    t1 : termial(n-1) 
    #######################################################
    
    ## Save ra & Callee Saved
    # No use saved registers -> No need to do Callee Saved
    addi    sp, sp, -4               # Allocate stack space
                                     # sp = @sp - 4
    sw      ra, 0(sp)                # @ra -> MEM[@sp - 4]
    
    mv      t0, a0                   # t0 = n
    addi    t1, a0, -1               # t1 = n - 1
    beq     t1, x0, endAdd           # if t1 == 0 (n == 1) => return 1
                                     # else => recursion     
termialRecur:
    ############### Call Function Procedure ###############
    # Caller Saved
    addi    sp, sp, -4               # Allocate stack space
                                     # sp = @sp - 8
    sw      t0, 0(sp)                # t0(n) -> MEM[@sp - 8]                                  
                                     
    # Pass Arguments
    mv      a0, t1                   # a0(n - 1) = t1(n - 1)
    
    # Jump to Callee
    jal     ra, FUNC_TERMIAL         # ra = Addr(mv  t1, a0)
    #######################################################
    
    ## Get return value
    mv      t1, a0                   # t1 = termial(n-1)
    
    ## Retrieve Caller Saved
    lw      t0, 0(sp)                # t0 = n
    addi    sp, sp, 4                # Release stack space
                                     # sp = @sp - 4
                                     
endAdd:
    add     a0, t0, t1               # if t0 == 1 => t0 = 1 + 0
                                     # if t0  > 1 => t0 = n + termial(n-1)
                                     # a0 = termial(n)

    ## Retrieve ra & Retrieve Callee Saved
    lw      ra, 0(sp)                # ra = @ra
    addi    sp, sp, 4                # Release stack space
                                     # sp = @sp
    ## return
    ret                              # jalr  x0, ra, 0
    