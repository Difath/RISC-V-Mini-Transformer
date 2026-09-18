###########################################################################
# Upper bound constants for static memory reservation
###########################################################################
.equ CONST_DIMENSION 4
.equ CONST_BUFFER_SIZE 1024
.equ CONST_MAX_VOCAB_TOKENS 100
.equ CONST_MAX_INPUT_TOKENS 10

###########################################################################
# System call constants
###########################################################################
.equ CONST_SYSCALL_PRINT_INT 1
.equ CONST_SYSCALL_PRINT_STRING 4
.equ CONST_SYSCALL_PRINT_CHAR 11
.equ CONST_SYSCALL_EXIT 10
.equ CONST_SYSCALL_EXIT2 93
.equ CONST_SYSCALL_OPEN 1024
.equ CONST_SYSCALL_CLOSE 57
.equ CONST_SYSCALL_READ 63
.equ CONST_SYSCALL_WRITE 64

###########################################################################
# ASCII character constants
###########################################################################
.equ CONST_CHAR_EOF 0
.equ CONST_CHAR_SPACE 32
.equ CONST_CHAR_NEWLINE 10
.equ CONST_CHAR_HYPHEN 45
.equ CONST_CHAR_ZERO 48

.data
###########################################################################
# Data section with static memory reservations.
# Feel free to add more if needed.
###########################################################################
VOCABULARY_FILENAME:     .string "vocab.txt"
EMBEDDINGS_FILENAME:     .string "embeddings.txt"
INPUT_FILENAME:          .string "input.txt"

W_Q_FILENAME:            .string "W_Q.txt"
W_K_FILENAME:            .string "W_K.txt"
W_V_FILENAME:            .string "W_V.txt"

VOCAB_BUFFER:            .zero CONST_BUFFER_SIZE                              # Contents of the vocabulary file
INPUT_BUFFER:            .zero CONST_BUFFER_SIZE                              # Contents of the input file
MATRIX_BUFFER:           .zero CONST_BUFFER_SIZE                              # Contents of a matrix file (used for W_Q, W_K, W_V, and embeddings)

INPUT_INDICES_VECTOR:    .zero (CONST_MAX_INPUT_TOKENS * 4)                   # Vector of input token indices (#inputs x 4 bytes)
SCORES_VECTOR:           .zero (CONST_MAX_INPUT_TOKENS * 4)                   # Vector of scores (#tokens x 4 bytes)
AUX_VECTOR:              .zero (CONST_DIMENSION * 4)                          # Aux Vector for dot operation

INPUT_TOTAL_TOKENS:      .word 0                                              # Number of tokens in the input
VOCAB_TOTAL_TOKENS:      .word 0                                              # Number of tokens in the vocabulary

VOCAB_EMBEDDINGS_MATRIX: .zero (CONST_MAX_VOCAB_TOKENS * CONST_DIMENSION * 4) # Embedding matrix (#tokens x dimension x 4 bytes)
INPUT_EMBEDDINGS_MATRIX: .zero (CONST_MAX_INPUT_TOKENS * CONST_DIMENSION * 4) # Embedding matrix (#tokens x dimension x 4 bytes)
W_Q_MATRIX:              .zero (CONST_DIMENSION * CONST_DIMENSION * 4)        # W_Q matrix (dimension x dimension x 4 bytes)
W_K_MATRIX:              .zero (CONST_DIMENSION * CONST_DIMENSION * 4)        # W_K matrix (dimension x dimension x 4 bytes)
W_V_MATRIX:              .zero (CONST_DIMENSION * CONST_DIMENSION * 4)        # W_V matrix (dimension x dimension x 4 bytes)
Q_MATRIX:                .zero (CONST_MAX_INPUT_TOKENS * CONST_DIMENSION * 4) # Q matrix (#tokens x dimension x 4 bytes)
K_MATRIX:                .zero (CONST_MAX_INPUT_TOKENS * CONST_DIMENSION * 4) # K matrix (#tokens x dimension x 4 bytes)
V_MATRIX:                .zero (CONST_MAX_INPUT_TOKENS * CONST_DIMENSION * 4) # V matrix (#tokens x dimension x 4 bytes)

.text
main:
    ###########################################################################
    # Read vocabulary
    ###########################################################################
    la a0, VOCABULARY_FILENAME
    la a1, VOCAB_BUFFER
    li a2, CONST_BUFFER_SIZE
    jal read_file

    ###########################################################################
    # Read input
    ###########################################################################
    la a0, INPUT_FILENAME
    la a1, INPUT_BUFFER
    li a2, CONST_BUFFER_SIZE
    jal read_file

    ###########################################################################
    # Read W_Q matrix
    ###########################################################################
    la a0, W_Q_FILENAME
    la a1, MATRIX_BUFFER
    li a2, CONST_BUFFER_SIZE
    jal read_file

    ###########################################################################
    # Parse W_Q matrix from buffer
    ###########################################################################
    # TODO

    ###########################################################################
    # Read W_K matrix
    ###########################################################################
    la a0, W_K_FILENAME
    la a1, MATRIX_BUFFER
    li a2, CONST_BUFFER_SIZE
    jal read_file

    ###########################################################################
    # Parse W_K matrix from buffer
    ###########################################################################
    # TODO

    ###########################################################################
    # Read W_V matrix
    ###########################################################################
    la a0, W_V_FILENAME
    la a1, MATRIX_BUFFER
    li a2, CONST_BUFFER_SIZE
    jal read_file

    ###########################################################################
    # Parse W_V matrix from buffer
    ###########################################################################
    # TODO

    ###########################################################################
    # Read embeddings matrix
    ###########################################################################
    la a0, EMBEDDINGS_FILENAME
    la a1, MATRIX_BUFFER
    li a2, CONST_BUFFER_SIZE
    jal read_file

    ###########################################################################
    # Parse vocabulary embeddings matrix from buffer
    ###########################################################################
    # TODO

    ###########################################################################
    # Convert input tokens to indices
    ###########################################################################
    # TODO

    ###########################################################################
    # Build input embeddings matrix
    ###########################################################################
    # TODO

    ###########################################################################
    # Build matrix Q
    ###########################################################################
    # TODO

    ###########################################################################
    # Build matrix K
    ###########################################################################
    # TODO

    ###########################################################################
    # Build matrix V
    ###########################################################################
    # TODO

    ###########################################################################
    # Compute scores for the last input token
    ###########################################################################
    # TODO

    ###########################################################################
    # Get the highest score index using argmax
    ###########################################################################
    # TODO

    ###########################################################################
    # Select chosen vector in V using the index from argmax
    ###########################################################################
    # TODO

    ###########################################################################
    # Pick the next token in the vocabulary with the highest score
    ###########################################################################
    # TODO

    ###########################################################################
    # Terminate program successfully
    ###########################################################################
    li a0, 0
    j exit_with_code                                # Exit with code 0

# Read from a text file into a buffer.
# (in)     a0: filename address (char*)
# (in/out) a1: destination buffer
# (in)     a2: maximum number of bytes to read
read_file:
    mv t0, a1                   # t0 = pointer to destination buffer
    mv t1, a2                   # t1 = maximun number of bytes to read  
    li a7, CONST_SYSCALL_OPEN  
    li a1, 0                    # a1 = read only flag
    ecall                   
    mv t2, a0                   # t2 = file director (fd)

    mv a1, t0                   # a1 = pointer to destination buffer
    mv a2, t1                   # a2 = maximun number of bytes to read
    li a7, CONST_SYSCALL_READ 
    ecall
    mv t3, a0                   # t3, = read bytes

    mv a0, t2                   # 
    li a7, CONST_SYSCALL_CLOSE   
    ecall

    ret

# Assumes the matrix is stored in the buffer as space-separated integers.
# Assumes columns are separated by 1 space (' '), and rows by 1 newline ('\n').
# Assumes only signed integers are provided.
# (in/out) a0: address of the matrix to fill (int*)
# (out)    a1: number of rows in the matrix (int)
# (in)     a1: address of the buffer containing the matrix data (char*)
parse_matrix_buffer:    
    mv t1, a1                    # t1 = buffer pointer
    li t2, 0                     # t2 = numeric accumulator
    li t3, 0                     # t3 = negative sign flag (1 if negative)
    mv t4, a0                    # t4 = original matrix address
    li t5, 0                     # t5 = row counter
loop_parse:
    lbu t0, 0(t1)                 # t0 = current character 

check_EOF_parse:
    li t6, CONST_CHAR_EOF        
    beq t0, t6, end_parse        # if (character == EOF) then end_parse

check_space_parse:
    li t6, CONST_CHAR_SPACE         
    beq t0, t6, space_parse      # if (character == ' ') then space_parse

check_new_line_parse:
    li t6, CONST_CHAR_NEWLINE   
    beq t0, t6, new_line_parse   # if (character == '\n') then new_line_parse

check_hyphen_parse:
    li t6, CONST_CHAR_HYPHEN     
    beq t0, t6, hyphen_parse     # if (character == '-') then hyphen_parse

number_parse:
    li t6, CONST_CHAR_ZERO      
    sub t0, t0, t6               # t0 = integer value converted
    li t6, 10                  
    mul t2, t2, t6               # accumulator *= 10 
    add t2, t2, t0               # accumulator += digit
    j next_character_parse

hyphen_parse:
    li t3, 1                     # flag = 1 (negative)
    j next_character_parse  

new_line_parse:
    addi t5, t5, 1               # row counter += 1
    j space_parse
space_parse:                    
    beq t3, zero, store_number_parse # if flag is 0 (positive) then store_number_parse
    neg t2, t2                   # accumulator = -accumulator 
    li t3, 0                     # reset negative sign flag
store_number_parse:
    sw t2, 0(a0)                 # store the final integer in the matrix
    addi a0, a0, 4               # advance matrix pointer by 1 word (4 bytes)
    li t2, 0                     # reset accumulator
    j next_character_parse

next_character_parse:
    addi t1, t1, 1               # advance buffer pointer by 1 byte
    j loop_parse

end_parse:
    mv a0, t4                    # restore original matrix pointer for return
    mv a1, t5                    # set return value (row count)
    ret
    


# Converts the input tokens into their corresponding indices in the vocabulary.
# (in/out) a0: address of input indices vector to fill (int*)
# (out)    a1: size of input indices vector (number of tokens in input)
# (in)     a2: address to input buffer
# (in)     a3: address to vocabulary buffer
tokens_to_indices:
    addi sp,sp,-4
    sw s0, 0(sp)

    mv s0,a0 #vetor de indices
    mv t4,a2 #address do input
    mv t5,a3 #address do vocab
    li a1,0 #contador dos tokens do input

    li t2, CONST_CHAR_EOF #t2 = 0
    li t3, CONST_CHAR_NEWLINE #t3 = 10

input_loop:
    lbu t0, 0(a2) #t0= byte atual input

    beq t0,t2,end_tti #se byte == 0, acabou o input
    beq t0,t3,skip_char_input #se byte == \n, acabou a palavra

    mv t4,a2 #guarda inicio da palavra do input
    
search_vocab_start:
    mv t5,a3 #ponteiro para o início do vocab
    li t6, zero #counter dos indíces no vocab

vocab_loop:
    lbu t1,0(t5)
    beq t1,t2,end_vocab

    mv t4,a2 #ponteiro temporário para inicio palavra
compare_words:
    lbu t0,0(t4)
    lbu t1,0(t5)

    bne t0,t1,words_different

    beq t0,t3,words_match

    addi t4,t4,1 #avanca input temporario
    addi t5,t5,1 #avanca vocab
    j compare_words

words_match:
    sw t6,0(s0) #guarda o indice no vetor de indices
    addi s0,s0,4 #avanca no vetor dos indices
    addi a1,a1,1 #contador de tokens += 1
    addi a2,t4,1 #avanca no vetor do input usando o temporario
    j input_loop

words_different:
    lbu t1,0(t5)
    beq t1,t3,next_vocab_word
    
    addi t5,t5,1
    j words_different

next_vocab_word:
    addi t5,t5,1
    addi t6,t6,1
    j vocab_loop

skip_char_input:
    addi a2,a2,1 #avanca no vetor do input usando o original
    j input_loop
    
end_vocab:
    j end_tti
    
end_tti:
    lw s0, 0(sp)
    addi sp,sp,4

    ret

# (in/out) a0: address of the output matrix to fill (int*)
# (in)     a1: address of the vocabulary embeddings matrix (int*)
# (in)     a2: address of the input indices array (int*)
# (in)     a3: number of tokens in the input (int)
build_input_embeddings_matrix:
    mv t1, a0                    # t1 = output matrix pointer

loop_build:
    beq a3, zero, end_build      # if (tokens remaining == 0) then end_build

    lw t6, 0(a2)                 # t6 = current token index
    slli t6, t6, 2               # t6 = index * 4
    mul t6, t6, CONST_DIMENSION  # t6 = offset (index * 4 * dimension)
    add t2, a1, t6               # t2 = vocabulary base address + offset

    li t3, CONST_DIMENSION       # t3 = column counter

loop_copy_columns_build:
    beq t3, zero, next_token_build # if (column counter == 0) then next_token_build

    lw t6, 0(t2)                 # t6 = current integer from vocabulary
    sw t6, 0(t1)                 # store the integer in the output matrix

    addi t1, t1, 4               # advance output matrix pointer by 1 word (4 bytes)
    addi t2, t2, 4               # advance vocabulary pointer by 1 word (4 bytes)

    addi t3, t3, -1              # column counter -= 1
    j loop_copy_columns_build

next_token_build:
    addi a3, a3, -1              # token counter -= 1
    addi a2, a2, 4               # advance input indices pointer by 1 word (4 bytes)
    j loop_build

end_build:
    ret

# (in/out) a0: address of the output matrix to fill (int*)
# (in)     a1: address of the first matrix (int*)
# (in)     a2: #rows of the first matrix (int)
# (in)     a3: #columns of the first matrix (int)
# (in)     a4: address of the second matrix (int*)
# (in)     a5: #rows of the second matrix (int)
# (in)     a6: #columns of the second matrix (int)
matrix_multiply:
    addi sp, sp, -40              # reserve stack space
    sw ra, 0(sp)                  # save return address
    sw s0, 4(sp)                  # save s0
    sw s1, 8(sp)                  # save s1
    sw s2, 12(sp)                 # save s2
    sw s3, 16(sp)                 # save s3
    sw s4, 20(sp)                 # save s4
    sw s5, 24(sp)                 # save s5
    sw s6, 28(sp)                 # save s6
    sw s7, 32(sp)                 # save s7
    sw s8, 36(sp)                 # save s8       

    mv s0, a0                     # s0 = output matrix pointer
    mv s1, a1                     # s1 = matrix 1 row pointer

    mul t0, a2, a3                # t0 = total elements in matrix 1
    slli t0, t0, 2                # t0 = total bytes in matrix 1
    add s2, a1, t0                # s2 = matrix 1 end limit

    mv s3, a3                     # s3 = matrix 1 columns count

    mv s4, a4                     # s4 = matrix 2 column pointer
    mv s8, a4                     # s8 = matrix 2 original base pointer

    slli t1, a6, 2                # t1 = bytes to jump to the next row (matrix 2)
    add s5, a4, t1                # s5 = matrix 2 columns end limit 

    mv s6, t1                     # s6 = bytes to jump to the next row (matrix 2)
    mv s7, a5                     # s7 = matrix 2 rows count 

loop_rows_multiply:
    beq s1, s2, end_multiply      # if (all rows from matrix 1 have been calculated) then end_multiply

loop_cols_multiply:
    beq s4, s5, next_row_multiply # if (current row has multiplied with all columns of matrix 2) then next_row_multiply

build_column_multiply:
    la t0, AUX_VECTOR             # t0 = aux vector pointer
    mv t1, s4                     # t1 = matrix 2 current column pointer
    li t2, 0                      # t2 = row counter

loop_extract_multiply:
    beq t2, s7, dot_multiply      # if (row counter == matrix 2 rows) then dot_multiply
    lw t3, 0(t1)                  # t3 = current integer from matrix 2
    sw t3, 0(t0)                  # store the integer in the aux vector
    add t1, t1, s6                # jump down to the next row in matrix 2
    addi t0, t0, 4                # advance aux vector pointer by 1 word (4 bytes)
    addi t2, t2, 1                # row counter += 1
    j loop_extract_multiply

dot_multiply:
    mv a1, s1                     # a1 = matrix 1 row pointer
    la a2, AUX_VECTOR             # a2 = aux vector pointer
    mv a3, s3                     # a3 = matrix 1 columns count
    jal dot                       # execute dot product

    sw a1, 0(s0)                  # store the dot result in the output matrix
    addi s0, s0, 4                # advance output matrix pointer by 1 word (4 bytes)
    addi s4, s4, 4                # advance matrix 2 column pointer to next column (4 bytes)
    j loop_cols_multiply

next_row_multiply:
    mv s4, s8                     # restore matrix 2 column pointer to base
    slli t0, s3, 2                # t0 = bytes to jump to the next row (matrix 1)
    add s1, s1, t0                # jump down to the next row in matrix 1
    j loop_rows_multiply

end_multiply:
    lw ra, 0(sp)                  # restore return address
    lw s0, 4(sp)                  # restore s0
    lw s1, 8(sp)                  # restore s1
    lw s2, 12(sp)                 # restore s2
    lw s3, 16(sp)                 # restore s3
    lw s4, 20(sp)                 # restore s4
    lw s5, 24(sp)                 # restore s5
    lw s6, 28(sp)                 # restore s6
    lw s7, 32(sp)                 # restore s7
    lw s8, 36(sp)                 # restore s8
    addi sp, sp, 40               # deallocate stack space
    ret




# (in/out) a0: address of the output scores vector to fill (int*)
# (in)     a1: address of Q matrix (int*)
# (in)     a2: address of K matrix (int*)
# (in)     a3: #rows of Q and K (int)
# (in)     a4: #columns of Q and K (int)
# (in)     a5: target token index for which we want to compute the score (int)
compute_scores:
    # TODO

# (out) a0: address of the selected vector (int*)
# (in)  a1: address of matrix (int*)
# (in)  a2: #rows (int)
# (in)  a3: #cols (int)
# (in)  a4: target row
select_vector_in_matrix:
    # TODO

# (out) a0: index of the predicted token in the vocabulary (int)
# (in)  a0: address of target vector (int*)
# (in)  a1: vocabulary embeddings address (int*)
# (in)  a2: number of tokens in vocabulary (int)
decide_next_token:
    addi sp, sp, -28              # reserve stack space
    sw ra, 0(sp)                  # save return address
    sw s0, 4(sp)                  # save s0
    sw s1, 8(sp)                  # save s1
    sw s2, 12(sp)                 # save s2
    sw s3, 16(sp)                 # save s3
    sw s4, 20(sp)                 # save s4
    sw s5, 24(sp)                 # save s5

    mv s0, a0                     # s0 = target vector pointer
    mv s1, a1                     # s1 = current vocabulary embedding pointer
    mv s2, a2                     # s2 = vocabulary tokens count

    li s3, 0                      # s3 = best token dot result)
    li s4, 0                      # s4 = best token index   
    li s5, 0                      # s5 = loop counter (current token index)   

loop_next_token:
    bge s5, s2, end_next_token    # if (all vocabulary tokens have been checked) then end_next_token
    mv a1, s0                     # a1 = target vector pointer 
    mv a2, s1                     # a2 = current vocabulary embedding pointer
    li a3, CONST_DIMENSION        # a3 = length of the vectors (4)
    jal dot                       # execute dot product    
    beq s5, zero, change_token    # if (is first token) then bypass comparison and store result
    bge s3, a1, next_loop_next_token # if (best dot product >= current dot product) then next_loop_next_token
change_token:
    mv s3, a1                     # s3 = update best dot product result
    mv s4, s5                     # s4 = update best token index

next_loop_next_token:
    li t6, CONST_DIMENSION        # t6 = dimension of vectors
    slli t6, t6, 2                # t6 = bytes to jump to the next vector (16 bytes)
    add s1, s1, t6                # advance vocabulary embedding pointer to the next vector
    addi s5, s5, 1                # loop counter += 1
    j loop_next_token

end_next_token:
    lw ra, 0(sp)                  # restore return address
    lw s0, 4(sp)                  # restore s0
    lw s1, 8(sp)                  # restore s1
    lw s2, 12(sp)                 # restore s2
    lw s3, 16(sp)                 # restore s3
    lw s4, 20(sp)                 # restore s4
    lw s5, 24(sp)                 # restore s5
    addi sp, sp, 28               # deallocate stack space

    mv a0, s4                     # set return value (index of the predicted token)
    ret

#############################################################################################################
# Dot product and argmax helper functions.
#############################################################################################################

# (in)  a1: address of first vector (int*)
# (in)  a2: address of second vector (int*)
# (in)  a3: length of the vectors (int)
# (out) a0: status code (0 for success, non-zero for error)
# (out) a1: dot product result (int)
dot:
    addi sp, sp, -4
    sw ra, 0(sp)                                    # Save return address on the stack
    # Initialize the result and the loop index.
    mv t0, zero                                     # t0 will hold the result (dot product)
    mv t1, zero                                     # t1 will be our loop index
    # Let's see first if SIZE < 1, and jump to dot_end if that's the case.
    slti t2, a3, 1                                  # t2 = (SIZE < 1)
    beq t2, zero, dot_loop                          # If SIZE >= 1, we can proceed to the loop
    li a0, 50                                       # Set a0 to 50 to indicate an error (invalid size)
    j dot_end                                       # If SIZE < 1, jump to dot_end
dot_loop:
    beq t1, a3, dot_end_loop                        # If t1 == SIZE, we are done
    lw t2, 0(a1)                                    # Load A[t1] into t2
    lw t3, 0(a2)                                    # Load B[t1] into t3
    mul t4, t2, t3                                  # t4 = A[t1] * B[t1]
    # Check if the multiplication of A[t1] and B[t1] overflows
    mulh t5, t2, t3                                 # t5 = high 32 bits of A[t1] * B[t1] (signed)
    srai t6, t4, 31                                 # t6 = sign extension of low 32 bits (0 or -1)
    bne t5, t6, overflow                            # Overflow if high bits != sign extension of low bits
    mv t6, t0                                       # Store the current result in t6 for overflow checking
    add t0, t0, t4                                  # t0 += A[t1] * B[t1]
    # Check if the previous addition caused an overflow
    # Careful: adding negative numbers will correctly result in a negative number, so we need to check for overflow in both directions.
    bgt t6, zero, check_positive_overflow           # If previous result was positive, check for positive overflow
    blt t6, zero, check_negative_overflow           # If previous result was negative, check for negative overflow
    j dot_continue_loop
check_positive_overflow:
    blt t4, zero, dot_continue_loop                 # If we added a negative number, we can't have a positive overflow
    blt t0, zero, overflow                          # If t0 < 0 after adding a positive number, we have an overflow
    j dot_continue_loop
check_negative_overflow:
    bgt t4, zero, dot_continue_loop                 # If we added a positive number, we can't have a negative overflow
    bgt t0, zero, overflow                          # If t0 > 0 after adding a negative number, we have an overflow
    j dot_continue_loop
dot_continue_loop:
    addi a1, a1, 4                                  # Move to the next element in A
    addi a2, a2, 4                                  # Move to the next element in B
    addi t1, t1, 1                                  # t1++
    j dot_loop                                      # Repeat the loop
dot_end_loop:
    li a0, 0                                        # Set a0 to 0 to indicate success
    mv a1, t0                                       # Move the result into a1 for return
    j dot_end                                       # Jump to the end of the function
overflow:
    li a0, 200                                      # Set a0 to 200 to indicate an overflow error
    j dot_end                                       # Jump to the end of the function
dot_end:
    lw ra, 0(sp)                                    # Restore return address
    addi sp, sp, 4                                  # Deallocate stack space
    ret                                             # Return to the caller

# (in)  a1: pointer to int array
# (in)  a2: array length
# (out) a0: status code
# (out) a1: index of the largest element
argmax:
    # Get the index of the maximum value in A, which is of size SIZE.
    # The result will be stored in a0.
    # If here's a draw, return the smallest index among the maximum values.
    addi sp, sp, -4
    sw ra, 0(sp)                                    # Save return address on the stack
    # Initialize the max value and the index of the max value.
    lw t0, 0(a1)                                    # t0 will hold the max value
    mv t1, zero                                     # t1 will hold the index of the max value
    mv t2, zero                                     # t2 will be our loop index
    # Error checking first: if SIZE < 1, we should return 50 to indicate an error.
    slti t3, a2, 1                                  # t3 = (SIZE < 1)
    beq t3, zero, argmax_loop                       # if SIZE >= 1, we can proceed to the loop
    li a0, 50                                       # set a0 to 50 to indicate an error (invalid size)
    j argmax_end                                    # if SIZE < 1, jump to argmax_end
argmax_loop:
    # The actual loop logic.
    beq t2, a2, argmax_end_loop                     # if t2 == SIZE, we are done
    lw t3, 0(a1)                                    # load A[t2] into t3
    ble t3, t0, argmax_next                         # if A[t2] <= max_value, skip to next
    mv t0, t3                                       # max_value = A[t2]
    mv t1, t2                                       # index_of_max = t2
argmax_next:
    addi a1, a1, 4                                  # move to the next element in A
    addi t2, t2, 1                                  # t2++
    j argmax_loop                                   # repeat the loop
argmax_end_loop:
    mv a1, t1                                       # move the index of the max value into a1 for return
    li a0, 0                                        # set a0 to 0 to indicate success
argmax_end:
    lw ra, 0(sp)                                    # Restore return address
    addi sp, sp, 4                                  # Deallocate stack space
    ret                                             # return to the caller

exit_with_code:
    li a7, CONST_SYSCALL_EXIT2
    ecall

#############################################################################################################
# Helper functions for printing and debugging.
#############################################################################################################

.data
PRINT_HEADER_VOCABULARY:    .string "=== Vocabulary ==="
PRINT_HEADER_INPUT:         .string "=== Input ==="
PRINT_HEADER_INPUT_INDICES: .string "=== Input Indices ==="
PRINT_HEADER_MATRIX:        .string "=== Matrix ==="
PRINT_HEADER_SCORES:        .string "=== Scores ==="
PRINT_HEADER_NEXT_TOKEN:    .string "=== Decision ==="
PRINT_VECTOR_LB:            .string "[ "
PRINT_VECTOR_RB:            .string "]"

.text
# Prints a null-terminated string followed by a newline.
# (in) a0: buffer to print (char*)
println:
    li a7, CONST_SYSCALL_PRINT_STRING
    ecall
    li a0, CONST_CHAR_NEWLINE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    ret

# Prints the vocabulary buffer.
# (in) a0: address of the vocabulary buffer (char*)
print_vocabulary:
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)
    mv s0, a0
    la a0, PRINT_HEADER_VOCABULARY
    jal println
    mv a0, s0
    jal println
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
    ret

# Prints the input buffer as a string.
# (in) a0: address of the input buffer (char*)
print_input:
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)
    mv s0, a0
    la a0, PRINT_HEADER_INPUT
    jal println
    mv a0, s0
    jal println
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
    ret

# Prints the input indices vector.
# (in) a0: address of the input indices vector (int*)
# (in) a1: size of the input indices vector (int)
print_indices:
    addi sp, sp, -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    mv s0, a0
    mv s1, a1
    la a0, PRINT_HEADER_INPUT_INDICES
    jal println
    mv a0, s0
    mv a1, s1
    jal print_vector
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12
    ret

print_scores:
    addi sp, sp, -4
    sw ra, 0(sp)
    la a0, PRINT_HEADER_SCORES
    jal println
    la a0, SCORES_VECTOR
    lw a1, INPUT_TOTAL_TOKENS
    jal print_vector
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# a0: address of matrix to print (int*)
# a1: number of rows
# a2: number of columns
print_matrix:
    addi sp, sp, -24
    sw ra, 0(sp)                                    # return address
    sw s0, 4(sp)                                    # matrix pointer
    sw s1, 8(sp)                                    # row index
    sw s2, 12(sp)                                   # col index
    sw s3, 16(sp)                                   # number of rows
    sw s4, 20(sp)                                   # number of columns
    mv s0, a0                                       # s0 = pointer to matrix
    mv s3, a1                                       # s3 = number of rows
    mv s4, a2                                       # s4 = number of columns
    li s1, 0                                        # s1 = current row index
    la a0, PRINT_HEADER_MATRIX
    jal println
print_matrix_row_loop:
    beq s1, s3, print_matrix_done
    li s2, 0
print_matrix_col_loop:
    beq s2, s4, print_matrix_next_row
    lw a0, 0(s0)
    li a7, CONST_SYSCALL_PRINT_INT
    ecall
    addi s0, s0, 4
    addi s2, s2, 1
    li a0, CONST_CHAR_SPACE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    j print_matrix_col_loop
print_matrix_next_row:
    li a0, CONST_CHAR_NEWLINE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    addi s1, s1, 1
    j print_matrix_row_loop
print_matrix_done:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24
    ret

# a0: address of vector to print (int*)
# a1: number of elements (int)
print_vector:
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    mv s0, a0                                       # s0 = pointer to vector
    mv s1, a1                                       # s1 = number of elements
    la a0, PRINT_VECTOR_LB                          # Print "[ "
    li a7, CONST_SYSCALL_PRINT_STRING
    ecall
print_vector_loop:
    beq s1, zero, print_vector_done
    lw a0, 0(s0)
    li a7, CONST_SYSCALL_PRINT_INT
    ecall
    li a0, CONST_CHAR_SPACE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    addi s0, s0, 4
    addi s1, s1, -1
    j print_vector_loop
print_vector_done:
    la a0, PRINT_VECTOR_RB                          # Print "]"
    li a7, CONST_SYSCALL_PRINT_STRING
    ecall
    li a0, CONST_CHAR_NEWLINE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    ret

# (in) a0: index of the predicted token in the vocabulary (int)
# (in) a1: address of vocabulary buffer (char*)
print_predicted_token:
    addi sp, sp, -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    mv s0, a0                                       # s0 = countdown to target index
    mv s1, a1                                       # s1 = current position in vocab buffer
    la a0, PRINT_HEADER_NEXT_TOKEN
    jal println
print_predicted_token_skip:
    beq s0, zero, print_predicted_token_read
    mv a0, s1                                       # a0 = current position in vocab buffer
    jal advance_to_next_token                       # a0 = next token start
    mv s1, a0                                       # update current position
    addi s0, s0, -1
    j print_predicted_token_skip
print_predicted_token_read:
    # s1 = start of target token, print it char by char until newline or null
print_predicted_token_char:
    lb t0, 0(s1)
    beq t0, zero, print_predicted_token_nl          # null terminator
    li t1, CONST_CHAR_NEWLINE
    beq t0, t1, print_predicted_token_nl            # newline terminator
    mv a0, t0
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    addi s1, s1, 1
    j print_predicted_token_char
print_predicted_token_nl:
    li a0, CONST_CHAR_NEWLINE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12
    ret
