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

li     t0, 0xD1C3F185
li     t1, 0x003358FF

sw     t0, 0(s0)
sw     t1, 4(s0)

# la    s0, _answer
lb    t0,  0(s0)
sh    t0,  8(s0)  # ans3
lhu   t1,  0(s0)
sw    t1, 12(s0)  # ans4
lw    t2,  4(s0)
sb    t2, 16(s0)  # ans5


# ######################################


main_exit:

# ######################################
# ### Return to end the simulation
# ######################################

  lw s0, 0(sp)
  addi sp, sp, 4
  ret

# ######################################
