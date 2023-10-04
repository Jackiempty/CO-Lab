.text
setup:
    li    ra, -1             # ra = -1
    li    sp, 0x7ffffff0     # sp = 0x7ffffff0
    
main:
    ###########################################################
    # a : t0
    # b : t1
    # 10 : t2
    ###########################################################
    
    ## Save ra & Callee Saved
    # No Function Call -> No need to save ra
    # No use saved registers -> No need to do Callee Saved
    
    li    t0, 0                # t0(a) = 0
    li    t1, 10               # t1(b) = 10
    li    t2, 10               # comparison immediate
    
    blt   t1, t2, main_else_1  # if (b < 10), go to main_else_1
main_if_1:
    li    t0, 5                # a = 5
    li    t1, 3                # b = 3
    jal   x0, main_endIf_1     # x0 = 0, pc = main_endIf_1 
main_else_1:
    li    t0, 3                # a = 3
    li    t1, 3                # b = 3
main_endIf_1:
    
    beq   t0, t1, main_if_2    # if (a == b), go to main_if_2
main_else_2:
    li    t0, 4                # a = 4
    li    t1, 2                # b = 2       
    jal   x0, main_endIf_2     # x0 = 0, pc = main_endIf_2
main_if_2:
    li    t0, 6                # a = 6
    li    t1, 11               # b = 11
main_endIf_2:
    
    bge   t1, t2, main_else_3  # if (b >= c), go to main_else_3
main_if_3:
    li    t0, 10               # a = 10
    li    t1, 5                # b = 5
    jal   x0, main_endIf_3     # x0 = 0, go to main_endIf_3
main_else_3:
    li    t0, 9                # a = 9
    li    t1, 7                # b = 7
main_endIf_3:
    
    ret                        # jalr  x0, ra, 0
