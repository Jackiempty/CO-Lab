.text
setup:
    li    ra, -1             # ra = -1
    li    sp, 0x7ffffff0     # sp = 0x7ffffff0
    
main:
    ###########################################################
    # t0 : result
    # t1 : i
    # t2 : loop boundary (max)
    ###########################################################
    
    ## Save ra & Callee Saved
    # No Function Call -> No need to save ra
    # No use saved registers -> No need to do Callee Saved
    
    li    t0, 0                  # t0(result) = 0
    li    t1, 0                  # t1(i) = 10
    li    t2, 10                 # max = 10
    
main_loop_1:
    bge   t1, t2, main_endLoop_1 # if (i >= max), go to main_endLoop_1
    add   t0, t0, t1             # result += i
    addi  t1, t1, 1              # i++
    jal   x0, main_loop_1        # x0 = 0, pc = main_loop_1 
main_endLoop_1:    
    
    ret                          # jalr  x0, ra, 0
    