# You can change these values to test your solution.
.data
ARRAY: .word -6 -1 6 1
SIZE:  .word 4
INDEX: .word 2

.text
main:
  la a1, ARRAY      # a1 = pointer to array
  lw a2, SIZE       # a2 = array length
  lw a3, INDEX      # a3 = element index
  jal ra, select    # call select function
exit:
  li a7, 10         # exit syscall code
  ecall             # terminate the program

# ==========================================================================
# FUNCTION: select
#   This function selects an element from an integer array.
# Arguments:
#   a1 = pointer to int array
#   a2 = array length
#   a3 = element index
# Returns:
#   a0 = status code
#   a1 = value of the selected element
# ===========================================================================
select:
  li t0, 1                    # t0 = minimum length
  blt a2, t0, invalid_length  # if a2 (array length) < t0 then invalid_length
  blt a3, zero, out_of_bounds # if a3 (index) < 0 then out_of_bounds
  bge a3, a2, out_of_bounds   # if a3 (index) >= a2 (array length) then out_of_bounds

  slli t0, a3, 2              # t0 (offset) = a3 (index) * 4 bytes
  add t1, a1, t0              # t1 = pointer to array + offset
  lw  t2, 0(t1)               # t2 = array[index] 
  mv a1, t2                   # a1 (return value) = t2 (selected value)
  li a0, 0                    # a0 = 0 (success status code)
  j select_end

out_of_bounds:
  li a0, 100                  # a0 = 100 (out of bounds status code)
  j select_end                

invalid_length:
  li a0, 50                   # a0 = 50 (invalid length status code)
  j select_end                

select_end:
  jr ra                       # return to the caller
