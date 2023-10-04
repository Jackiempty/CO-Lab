.text
setup:
    li    ra, -1             # ra = -1
    li    sp, 0x7ffffff0     # sp = 0x7ffffff0
    
main:
    #################################################
    # a : t0
    # b : t1
    # c : t2
    #################################################
    
    li    t0, 10         # t0(a) = 10
    li    t1, 5          # t1(b) = 5
    li    t2, 7          # t2(c) = 7
    
    ############ Call Function Procedure ###########
    # Caller Saved
    addi  sp, sp, -12    # Allocate stack space
                         # sp = @sp - 12
    sw    ra, 8(sp)      # @ra -> MEM[@sp-4]
    sw    t0, 4(sp)      # t0(a) -> MEM[@sp-8]
    sw    t2, 0(sp)      # t2(c) -> MEM[@sp-12]
    
    # Pass Arguments
    mv    a0, t0         # a0(x) = t0(a)
    mv    a1, t1         # a1(y) = t1(b)
    mv    a2, t2         # a2(z) = t2(c)
    
    # Jump to Callee
    jal   ra, FUNC_XYZ   # ra = Addr(lw  t0, 4(sp))
    #################################################
 
    ## Retrieve Caller Saved
    lw    t0, 4(sp)      # t0(a) = 10
    lw    t2, 0(sp)      # t2(c) = 7
    
    ############ Call Function Procedure ###########
    # Caller Saved
    addi  sp, sp, -4     # Allocate stack space
                         # sp = @sp - 16
    sw    a0, 0(sp)      # a0(d) -> MEM[@sp-16]
    
    # Pass Arguments
    mv    a2, a0         # a2(z) = a0(d)
    mv    a0, t0         # a0(x) = t0(a)
    mv    a1, t2         # a1(y) = t2(c)
    
    # Jump to Callee
    jal   ra, FUNC_XYZ   # ra = Addr(lw  t0, 8(sp))
    #################################################
    
    ## Retrieve Caller Saved
    lw    t0, 8(sp)      # t0(a) = 10
    lw    t3, 0(sp)      # t3(d)
    
    add   t4, t0, t3     # t4(f) = t0(a) + t3(d)
    add   t4, t4, a0     # t4(f) = t4 + a0(e)
    
    ## Retrieve ra & Retrieve Callee Saved
    lw    ra, 12(sp)     # ra = @ra
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
    