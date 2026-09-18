# You can change these values to test your solution.
.data
A:    .word 6, 1, 3, 9, 12, 4, 13, 153
B:    .word 6, 1, 3, 9, 12, 4, 13, 153
SIZE: .word 8

.text
main:
  la a1, A          # a1 = pointer to array A
  la a2, B          # a2 = pointer to array B
  lw a3, SIZE       # a3 = number of elements in each array
  jal ra, dot       # call dot function
exit:
  li a7, 10         # exit syscall code
  ecall             # terminate the program


# ==========================================================================
# FUNCTION: dot
#   This function computes the dot product of two integer arrays.
# Arguments:
#   a1 = pointer to first array
#   a2 = pointer to second array
#   a3 = array length
# Returns:
#   a0 = status code
#   a1 = dot product result
# ===========================================================================
dot:
  li t0, 1                   # t0 = minimum length
  li t1, 0                   # t1 = i
  li t2, 0                   # t2 = sum
  blt a3, t0, invalid_length # if a3 (array length) < t0 then invalid_length
  
for:
  bge t1, a3, dot_end        # if t1 (i) >= a3 (array length) then dot_end
  slli t3, t1, 2             # t3 (offset) = t1 (i) * 4

  add t4, a1, t3             # t4 = pointer to array A + offset
  lw t5, 0(t4)               # t5 = A[i]

  add t4, a2, t3             # t4 = pointer to array B + offset
  lw t6, 0(t4)               # t6 = B[i]

# ================= Multiplication Overflow Check ========================
  mul t3, t5, t6             # t3 = lower 32 bits of A[i] * B[i]
  mulh t4, t5, t6            # t4 = upper 32 bits of A[i] * B[i]

  srai t5, t3, 31            # t5 = Fills with the most significant bit of t3
  bne t4, t5, overflow       # if t4 (upper bits) != t5 then overflow

# ======================= Addition Overflow Check ========================
  add t6, t2, t3             # t6 = (temp sum) = t2 (sum) + t3 (product)

# checks if t2 and t3 had the same sign
  xor t4, t2, t3             # t4 MSB = 1 if signs were different 0 if same
  bltz t4, do_sum            # if t4 < 0 (different signs) then do_sum

# checks if the result´s sign changed
  xor t4, t2, t6             # t4 MSB = 1 if signs were different 0 if same 
  bltz t4, overflow          # if t4 < 0 (sign changed) then overflow

do_sum:                      
  mv t2, t6                  # t2 (sum) = t6 (current sum)
 
next:
  addi t1, t1, 1             # t1 (i) += 1
  j for

overflow:
  li a0, 200                 # a0 = 200 (overflow status code)
  jr ra                      # return to the caller

invalid_length:
  li a0, 50                  # a0 = 50 (invalid length status code)
  jr ra                      # return to the caller

dot_end:
  li a0, 0                   # a0 = 0 (success status code)
  mv a1, t2                  # a1 = t2 (final sum)
  jr ra                      # return to the caller
