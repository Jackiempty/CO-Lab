.text
setup:
    li    ra, -1             # ra = -1
    li    sp, 0x7ffffff0     # sp = 0x7ffffff0
    
main:
    #################################################
    # a : s0
    # b : t1
    # c : s2
    # d : s3
    #################################################
    
    ## Callee Saved
    addi  sp, sp, -12    # Allocate stack space
                         # sp = @sp - 12
    sw    s0, 8(sp)      # @s0 -> MEM[@sp-4]
    sw    s2, 4(sp)      # @s2 -> MEM[@sp-8]
    sw    s3, 0(sp)      # @s3 -> MEM[@sp-12]
    
    li    s0, 10         # s0(a) = 10
    li    t1, 5          # t1(b) = 5
    li    s2, 7          # s2(c) = 7
    
    ############ Call Function Procedure ###########
    # Caller Saved
    addi  sp, sp, -4     # Allocate stack space
                         # sp = @sp - 16
    sw    ra, 0(sp)      # @ra -> MEM[@sp-16]
    
    # Pass Arguments
    mv    a0, s0         # a0(x) = s0(a)
    mv    a1, t1         # a1(y) = t1(b)
    mv    a2, s2         # a2(z) = s2(c)
    
    # Jump to Callee
    jal   ra, FUNC_XYZ   # ra = Addr(mv  s3, a0)
    #################################################
    
    mv    s3, a0         # s3(d) = a0(return value)
    
    ############ Call Function Procedure ###########
    # Caller Saved

    # Pass Arguments
    mv    a0, s0         # a0(x) = s0(a)
    mv    a1, s2         # a1(y) = s2(c)
    mv    a2, s3         # a2(z) = s3(d)
    
    # Jump to Callee
    jal   ra, FUNC_XYZ   # ra = Addr(add  t4, s0, s3)
    #################################################
    
    add   t4, s0, s3     # t4(f) = s0(a) + s3(d)
    add   t4, t4, a0     # t4(f) = t4 + a0(e)
    
    ## Retrieve ra & Retrieve Callee Saved
    lw    s0, 12(sp)     # s0 = @s0
    lw    s2, 8(sp)      # s2 = @s2
    lw    s3, 4(sp)      # s3 = @s3
    lw    ra, 0(sp)      # ra = @ra
    addi  sp, sp, 16     # Release stack space
                         # sp = @sp                                  
    ## return
    ret                  # jalr  x0, ra, 0
    
FUNC_XYZ:
    #################################################
    # x : a0
    # y : a1
    # z : a2
    # return value : a0
    #################################################
    
    slli  t1, a1, 1      # t1 = y * 2
    slli  t2, a2, 1      # t2 = z * 2
    add   t2, t2, a2     # t2 = z * 3
    
    ## Pass Return Value
    add   a0, a0, t1     # a0 = x + y*2
    add   a0, a0, t2     # a0 = x + y*2 + z*3
    
    ## return
    ret                  # jalr  x0, ra, 0
    