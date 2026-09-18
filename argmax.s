# You can change these values to test your solution.
.data
ARRAY: .word -6 -1 6 6
SIZE:  .word 4

.text
main:
  la a1, ARRAY        # a1 = pointer to array
  lw a2, SIZE         # a2 = number of elements in the array
  jal ra, argmax      # call argmax function
exit:
  li a7, 10           # exit syscall code
  ecall               # terminate the program

# ==========================================================================
# FUNCTION: argmax
#   Takes an array of integers and returns the index of the largest element.
#   If there are multiple elements with the same maximum value, 
#   it should return the smallest index among them.
# Arguments:
#   a1 = pointer to int array
#   a2 = array length
# Returns:
#   a0 = status code
#   a1 = index of the largest element
# ===========================================================================
argmax:
  li t0, 1                   # t0 = minimum length
  li t1, 1                   # t1 = i
  li t2, 0                   # t2 = max idx
  blt a2, t0, invalid_length # if a2 < t0 then invalid_length

  lw t3, 0(a1)               # t3 = max value (array[0])
for:
  bge t1, a2, argmax_end     # if t1 (i) >= a2 (array length) then argmax_end

  slli t0, t1, 2             # t0 (offset) = t1 (i) * 4
  add t4, a1, t0             # t4 = pointer to array + offset
  lw t4, 0(t4)               # t4 = array[i]
  
  ble t4, t3, next           # if t4 (array[i]) <= t3 (array[max idx]) then next
  mv t2, t1                  # t2 (max idx) = i
  mv t3, t4                  # t3 (max value) = array[i]

next:
  addi t1, t1, 1             # t1 (i) += 1
  j for

invalid_length:
  li a0, 50                  # a0 = 50 (
  jr ra

argmax_end:
  li a0, 0                   # a0 = 0 (
  mv a1, t2                  # t
  jr ra                      # return to the caller