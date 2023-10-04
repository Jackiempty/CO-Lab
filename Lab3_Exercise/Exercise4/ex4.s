.data
num_test: .word 3 
TEST1_SIZE: .word 34
TEST2_SIZE: .word 19
TEST3_SIZE: .word 29
test1: .word 3,41,18,8,40,6,45,1,18,10,24,46,37,23,43,12,3,37,0,15,11,49,47,27,23,30,16,10,45,39,1,23,40,38
test2: .word -3,-23,-22,-6,-21,-19,-1,0,-2,-47,-17,-46,-6,-30,-50,-13,-47,-9,-50
test3: .word -46,0,-29,-2,23,-46,46,9,-18,-23,35,-37,3,-24,-18,22,0,15,-43,-16,-17,-42,-49,-29,19,-44,0,-18,23

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
    #    s1 : *size
    #    t0 : *test
    #    t1 : *answer
    #    t2 : i
    #    t3 : j
    #    t4 : test_size
    #######################################################

    ## Save ra & Callee Saved
    addi    sp, sp, -12              # Allocate stack space
                                     # sp = @sp - 12
    sw      ra, 8(sp)                # @ra -> MEM[@sp - 4]
    sw      s0, 4(sp)                # @s0 -> MEM[@sp - 8]
    sw      s1, 0(sp)                # @s1 -> MEM[@sp - 12]

    ## Get num_test, *size, *test, *answer
    li      s0, 0x10000000 
    lw      s0, 0(s0)                # s0(num_test) = MEM[0x10000000]
    li      s1, 0x10000004           # s1(*size) = 0x10000004
    slli    t5, s0, 2                # t5 = num_test * 4
    add     t0, s1, t5               # t0(*test) = 0x10000004 + (num_test * 4)
    li      t1, 0x01000000           # t0(*answer) = 0x01000000
    li      t2, 0                    # t5(i) = 0

    ## for loops
loop_1:
    bge     t2, s0, endloop_1        # if (i >= num_test), go to end_loop
    lw      t4, 0(s1)                # test_size = MEM[size] 
    addi    s1, s1, 4                # size++

    ############### Call Function Procedure ###############
    # Caller Saved
    addi    sp, sp, -20              # Allocate stack space
                                     # sp = @sp - 32
    sw      t0, 16(sp)               # t0(*test) -> MEM[@sp - 16]
    sw      t1, 12(sp)               # t1(*answer) -> MEM[@sp - 20]
    sw      t2, 8(sp)                # t2(i) -> MEM[@sp - 24]
    sw      t3, 4(sp)                # t3(j) -> MEM[@sp - 28]
    sw      t4, 0(sp)                # t4(test_size) -> MEM[@sp - 32]
    # Pass Arguments
    mv      a0, t0                   # a0(*arr) = test
    li      a1, 0                    # a1(start) = 0
    addi    t5, t4, -1               # t5 = test_size - 1
    mv      a2, t5                   # a2(end) = t5(test_size - 1)
    
    # Jump to Callee
    jal     ra, FUNC_MERGESORT       # ra = Addr(ra = lw   t0, 16(sp))
    #######################################################

    ## Retrieve Caller Saved
    lw      t0, 16(sp)               # t0(*test) = MEM[@sp - 16]
    lw      t1, 12(sp)               # t1(*answer) = MEM[@sp - 20]
    lw      t2, 8(sp)                # t2(i) = MEM[@sp - 24]
    lw      t3, 4(sp)                # t3(j) = MEM[@sp - 28]
    lw      t4, 0(sp)                # t4(test_size) = MEM[@sp - 32]
    addi    sp, sp, 20               # release stack space 

    ## for loop_2
    li      t3, 0                    # t3(j) = 0

loop_2:
    bge     t3, t4, endloop_2        # if(j >= test_size), go to endloop_2
    lw      t5, 0(t0)                # t5 = MEM[test]
    sw      t5, 0(t1)                # *answer = t5(*test)
    addi    t0, t0, 4                # test++
    addi    t1, t1, 4                # answer++
    addi    t3, t3, 1                # j++
    jal     x0, loop_2  


endloop_2:
    addi    t2, t2, 1                # i++
    jal     x0, loop_1          

endloop_1:

    ## Retrieve Callee Saved, ra
    lw      ra, 8(sp)                # ra = @ra
    lw      s0, 4(sp)                # s0 = @s0
    lw      s1, 0(sp)                # s1 = @s1
    addi    sp, sp, 12               # release stack space 
    
    ret


FUNC_MERGESORT:
    #######################################################
    # < Function >
    #    Mergesort
    #
    # < Parameters >
    #    a0 : *arr
    #    a1 : start(0)
    #    a2 : end(n-1)
    #
    # < Return Value >
    #    no return value
    #######################################################
    # < Local Variable >
    #    t0 : *arr
    #    t1 : start
    #    t2 : end
    #    t3 : mid
    #######################################################
    ## Save ra & Callee Saved
    # No use saved registers -> No need to do Callee Saved
    addi    sp, sp, -4               # Allocate stack space
                                     # sp = @sp - 4
    sw      ra, 0(sp)                # @ra -> MEM[@sp - 4]

    mv      t0, a0                   # t0 = *arr
    mv      t1, a1                   # t1 = start index
    mv      t2, a2                   # t2 = end index

    ## if loop
    bge     t1, t2, endif            # if (start >= end), go to endif
    
if:
    add     t3, t1, t2               # t3 = start + end
    srai    t3, t3, 1                # t3(mid) = (start + end) / 2

    ############### Call Function Procedure ###############
    # Caller Saved
    addi    sp, sp, -16              # Allocate stack space
                                     # sp = @sp - 20
    sw      t0, 12(sp)               # t0(*arr) -> MEM[@sp - 8]
    sw      t1, 8(sp)                # t1(start) -> MEM[@sp - 12]
    sw      t2, 4(sp)                # t2(end) -> MEM[@sp - 16]
    sw      t3, 0(sp)                # t3(mid) -> MEM[@sp - 20]
    
    # Pass Arguments
    mv      a0, t0                   # a0 = *arr
    mv      a1, t1                   # a1 = t1(start)
    mv      a2, t3                   # a2 = t3(mid)
    
    # Jump to Callee
    jal     ra, FUNC_MERGESORT       # ra = Addr(lw   t0, 12(sp))
    #######################################################
    
    ## Retrieve Caller Saved
    lw      t0, 12(sp)               # t0(*arr) = MEM[@sp - 8]
    lw      t1, 8(sp)                # t1(start) = MEM[@sp - 12]
    lw      t2, 4(sp)                # t2(end) = MEM[@sp - 16]
    lw      t3, 0(sp)                # t3(mid) = MEM[@sp - 20]
    addi    sp, sp, 16               # release stack space

    ## mid + 1 ############################################
    addi    t4, t3, 1                # t4 = mid + 1
    #######################################################

    ############### Call Function Procedure ###############
    # Caller Saved
    addi    sp, sp, -16              # Allocate stack space
                                     # sp = @sp - 20
    sw      t0, 12(sp)               # t0(*arr) -> MEM[@sp - 8]
    sw      t1, 8(sp)                # t1(start) -> MEM[@sp - 12]
    sw      t2, 4(sp)                # t2(end) -> MEM[@sp - 16]
    sw      t3, 0(sp)                # t3(mid) -> MEM[@sp - 20]
    
    # Pass Arguments
    mv      a0, t0                   # a0 = *arr
    mv      a1, t4                   # a1 = t4(mid + 1)
    mv      a2, t2                   # a2 = t2(end)
    
    # Jump to Callee
    jal     ra, FUNC_MERGESORT       # ra = Addr(lw   t0, 12(sp))
    #######################################################
    
    ## Retrieve Caller Saved
    lw      t0, 12(sp)               # t0(*arr) = MEM[@sp - 8]
    lw      t1, 8(sp)                # t1(start) = MEM[@sp - 12]
    lw      t2, 4(sp)                # t2(end) = MEM[@sp - 16]
    lw      t3, 0(sp)                # t3(mid) = MEM[@sp - 20]
    addi    sp, sp, 16               # release stack space

    ## call func_merge

    ############### Call Function Procedure ###############
    # Caller Saved
    addi    sp, sp, -16              # Allocate stack space
                                     # sp = @sp - 20
    sw      t0, 12(sp)               # t0(*arr) -> MEM[@sp - 8]
    sw      t1, 8(sp)                # t1(start) -> MEM[@sp - 12]
    sw      t2, 4(sp)                # t2(end) -> MEM[@sp - 16]
    sw      t3, 0(sp)                # t3(mid) -> MEM[@sp - 20]
    
    # Pass Arguments
    mv      a0, t0                   # a0 = *arr
    mv      a1, t1                   # a1 = t1(start)
    mv      a2, t3                   # a2 = t3(mid)
    mv      a3, t2                   # a3 = t2(end)
    
    # Jump to Callee
    jal     ra, FUNC_MERGE           # ra = Addr(lw   t0, 12(sp))
    #######################################################
    
    ## Retrieve Caller Saved
    lw      t0, 12(sp)               # t0(*arr) = MEM[@sp - 8]
    lw      t1, 8(sp)                # t1(start) = MEM[@sp - 12]
    lw      t2, 4(sp)                # t2(end) = MEM[@sp - 16]
    lw      t3, 0(sp)                # t3(mid) = MEM[@sp - 20]
    addi    sp, sp, 16               # release stack space

endif:
    ## Retrieve ra & Callee Saved
    lw      ra, 0(sp)               # ra = @ra
    addi    sp, sp, 4               # sp = @sp
    
    ## return
    ret                              # jalr  x0, ra, 0


FUNC_MERGE:
    #######################################################
    # < Function >
    #    Merge
    #
    # < Parameters >
    #    a0 : *arr
    #    a1 : start
    #    a2 : mid
    #    a3 : end
    #
    # < Return Value >
    #    no return value
    #######################################################
    # < Local Variable >
    #    t0 : temp_size
    #    t1 : left_index
    #    t2 : right_index
    #    t3 : left_max
    #    t4 : right_max
    #    t5 : arr_index
    #    t6 : i
    #    s0 : *temp
    #    s1 : dummy1
    #    s2 : dummy2
    #    s3 : dummy3
    #######################################################
    ## Save ra & Callee Saved
    # do Callee Saved @@@
    addi    sp, sp, -20              # Allocate stack space
                                     # sp = @sp - 20
    sw      ra, 0(sp)                # @ra -> MEM[@sp - 20]
    sw      s0, 4(sp)                # @s0 -> MEM[@sp - 16]
    sw      s1, 8(sp)                # @s1 -> MEM[@sp - 12]
    sw      s2, 12(sp)               # @s2 -> MEM[@sp - 8]
    sw      s3, 16(sp)               # @s3 -> MEM[@sp - 4]
    
    sub     t0, a3, a1               # t0 = end - start
    addi    t0, t0, 1                # t0(temp_size) = t0 + 1
    mv      s0, sp                   # s0 = [@sp - 4]
    addi    s0, s0, -4               # s0(*temp) = [@sp - 8]
    

    ## for loop
    li      t6, 0                    # i = 0
sub_loop:
    bge     t6, t0, end_subloop      # if(i >= temp_size), go to end_subloop
    add     s1, a1, t6               # s1 = start + i
    slli    s1, s1, 2                # s1 = (start + i) * 4
    add     s1, a0, s1               # s1 = arr + (start + i) * 4
    lw      s2, 0(s1)                # s2 = arr[i + start]
    slli    s1, t6, 2                # s1 = i * 4
    sub     s1, s0, s1               # s1 = (@sp - 4) - (i * 4)
    sw      s2, 0(s1)                # temp[i] = arr[i + start]  
    addi    t6, t6, 1                # i++
    jal     x0, sub_loop

end_subloop:

    ## for loop end
    li      t1, 0                    # t1(left_index)
    sub     t2, a2, a1               # 
    addi    t2, t2, 1                # t2(right_index)
    sub     t3, a2, a1               # t3(left_max)
    sub     t4, a3, a1               # t4(right_max)
    mv      t5, a1                   # t5(arr_index)

    ## while loop_1
    bgt     t1, t3, end_while_1      # if(left_index > left_max), go to end_while_1
    bgt     t2, t4, end_while_1      # if(right_index > right_max), go to end_while_1

while_1:    
    
    ## if_1
    slli    s1, t1, 2                
    sub     s1, s0, s1
    slli    s2, t2, 2
    sub     s2, s0, s2 
    lw      s1, 0(s1)                # s1 = temp[left_index]
    lw      s2, 0(s2)                # s2 = temp[right_index]
    bgt     s1, s2, else_1           # if(s1 > s2), go to endif_1

if_1:
    slli    s3, t5, 2                # s3 = arr_index * 4
    add     s3, a0, s3
    sw      s1, 0(s3)                # arr[arr_index] = temp[left_index]
    addi    t5, t5, 1                # arr_index++
    addi    t1, t1, 1                # left_index++
    jal     x0, endif_1

else_1:
    slli    s3, t5, 2                # s3 = arr_index * 4
    add     s3, a0, s3
    sw      s2, 0(s3)                # arr[arr_index] = temp[right_index] 
    addi    t5, t5, 1                # arr_index++
    addi    t2, t2, 1                # right_index++
    jal     x0, endif_1

endif_1:
    bgt     t1, t3, end_while_1      # if(left_index > left_max), go to end_while_1
    bgt     t2, t4, end_while_1      # if(right_index > right_max), go to end_while_1
    jal     x0, while_1

end_while_1:

    ## while loop_2
    bgt     t1, t3, end_while_2      # if(left_index > left_max), go to end_while_2

while_2:
    slli    s1, t1, 2                
    sub     s1, s0, s1 
    lw      s1, 0(s1)                # s1 = temp[left_index]
    slli    s3, t5, 2                # s3 = arr_index * 4
    add     s3, a0, s3
    sw      s1, 0(s3)                # arr[arr_index] = temp[left_index]
    addi    t5, t5, 1                # arr_index++
    addi    t1, t1, 1                # left_index++
    ble     t1, t3, while_2          # if(left_index <= left_max), go to while_2

end_while_2:

    ## while loop 3
    bgt     t2, t4, end_while_3      # if(right_index > right_max), go to end_while_3

while_3:
    slli    s2, t2, 2
    sub     s2, s0, s2 
    lw      s2, 0(s2)                # s2 = temp[right_index]
    slli    s3, t5, 2                # s3 = arr_index * 4
    add     s3, a0, s3
    sw      s2, 0(s3)                # arr[arr_index] = temp[right_index] 
    addi    t5, t5, 1                # arr_index++
    addi    t2, t2, 1                # right_index++
    ble     t2, t4, while_3          # if(right_index > right_max), go to while_3

end_while_3:    

    ## Retrieve Callee Saved, ra
    lw      ra, 0(sp)                # @ra = MEM[@sp - 20]
    lw      s0, 4(sp)                # @s0 = MEM[@sp - 16]
    lw      s1, 8(sp)                # @s1 = MEM[@sp - 12]
    lw      s2, 12(sp)               # @s2 = MEM[@sp - 8]
    lw      s3, 16(sp)               # @s3 = MEM[@sp - 4]
    addi    sp, sp, 20               # release stack space 

    ret