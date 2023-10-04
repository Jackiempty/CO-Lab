.data
# ...

.text
.globl main

main:

# ######################################
# ### Load address of _answer to s0 
# ######################################

  addi sp, sp, -4
  sw s0, 0(sp)
  la s0, _answer

# ######################################


# ######################################
# ### Main Program
# ######################################
# a : t0
# b : t1
# c : t2
# d : t3

li    t0, 9     # a
li    t1, -13   # b
li    t2, 7     # c
li    t3, -15   # d

# ans0
slli  t4, t0, 2    
add   t4, t4, t0    
addi  t4, t4, 30
slli  t5, t4, 3
sub   t5, t5, t4
slli  t6, t1, 1
add   t6, t6, t1
add   t5, t5, t6
sw    t5, 0(s0)

# ans1
slli  t4, t0, 2   
sub   t5, t0, t4  # t5
slli  t4, t1, 2
add   t4, t4, t1
add   t4, t4, t1
sub   t6, t1, t4
add   t6, t6, t5
sw    t6, 4(s0)

# ans2
slti  t4, t0, 0   # t4 = (a < 0) (0)
slli  t5, t4, 1
sub   t5, t4, t5  # t5 = -t4
xor   t5, t5, t0   
add   t5, t5, t4  # t5 = abs(a)
slti  t4, t1, 0   # t4 = 1
slli  t6, t4, 1
sub   t6, t4, t6
xor   t6, t6, t1
add   t6, t6, t4  # t6 = abs(b)
add   t4, t5, t6
sw    t4, 8(s0)

# ans3 
slti  t4, t0, 0  
slli  t5, t4, 1
sub   t5, t4, t5  
xor   t5, t5, t0   
add   t5, t5, t4  # t5 = abs(a)
slti  t4, t1, 0   
slli  t6, t4, 1
sub   t6, t4, t6
xor   t6, t6, t1
add   t6, t6, t4  # t6 = abs(b)
# take abs(a) mod 4
andi  s3, t5, 3
# check if a < 0 and change sign of [abs(a) mod 4] with it
slti  s1, t0, 0
slli  s2, s1, 1
sub   s2, s1, s2
xor   s3, s3, s2  
add   s3, s3, s1  # s3
# take abs(b) mod 4
andi  s4, t6, 3
# check if b < 0 and change sign of [abs(b) mod 4] with it
slti  s1, t1, 0
slli  s2, s1, 1
sub   s2, s1, s2
xor   s4, s4, s2  
add   s4, s4, s1  # s4
# a%4 + b%4 , save
add   t6, s3, s4
sw    t6, 12(s0)

# ans4
srai  t4, t0, 3
srai  t5, t1, 3
slti  t6, t4, 0
add   t4, t4, t6
slti  t6, t5, 0
add   t5, t5, t6
add   t6, t4, t5
sw    t6, 16(s0)

# t0, t1 released

# ans5 
# li    t0, 45       # 45 * 100 / 8
# slli  t1, t0, 2
# add   t0, t0, t1
# slli  t1, t0, 2
# add   t0, t0, t1
# slli  t0, t0, 2
# srli  t0, t0, 3

li      t0, 100     # 100 * 45 / 8
slli    t1, t0, 2
add     t1, t1, t0
slli    t4, t0, 3
add     t1, t1, t4
slli    t4, t0, 5
add     t1, t1, t4
srli    t0, t1, 3

sw    t0, 20(s0)

# ans6
li    t0, -5
slli  t1, t0, 3
sub   t1, t1, t0
srai  t1, t1, 1
addi  t1, t1, 1

sw    t1, 24(s0)

# ans7
li    t0, 3
slli  t1, t0, 2
sub   t1, t1, t0
srli  t1, t1, 2

sw    t1, 28(s0)

# ans8
slli  t0, t2, 2
sub   t1, t0, t2
srai  t1, t1, 2   # t1
slli  t0, t3, 2
sub   t4, t0, t3
srai  t4, t4, 2   # t4
add   t0, t1, t4
addi  t0, t0, 1

sw    t0, 32(s0)

# ######################################


main_exit:

# ######################################
# ### Return to end the simulation
# ######################################

  lw s0, 0(sp)
  addi sp, sp, 4
  ret

# ######################################
