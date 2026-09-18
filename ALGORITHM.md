# Mini-Transformer Algorithm & Implementation Details

This document provides an in-depth technical overview of the AI sequence prediction algorithm implemented in this project. The entire logic is written in raw RISC-V Assembly, bridging the gap between high-level machine learning concepts and low-level hardware execution.

## 1. The Attention Mechanism

The core of this project is a simplified version of the **Self-Attention mechanism** introduced in the groundbreaking paper *"Attention Is All You Need"*. The algorithm predicts the most probable next token in a given sequence using embeddings and weight matrices.

The process is divided into three primary linear transformations:
- **Queries (Q)**: Represents the current state or the token we are analyzing.
- **Keys (K)**: Represents the context of all possible tokens.
- **Values (V)**: Represents the actual content or meaning of the tokens.

## 2. Execution Pipeline

The Assembly implementation executes the following sequential steps:

### Phase 1: Input Parsing and Embedding Lookup
The program parses `input.txt` to read the input sequence. For each token, it queries the `vocab.txt` dictionary to find its index. This index is then used to retrieve the corresponding vector from `embeddings.txt`.

### Phase 2: Q, K, V Computations
Using the embedding vectors, the program computes the Query, Key, and Value representations by performing matrix multiplications with the pre-trained weight matrices (`W_Q`, `W_K`, `W_V`).
- *Assembly implementation*: This relies heavily on nested loops and the custom `dot` product subroutine to perform the multiply-accumulate (MAC) operations required for matrix multiplication.

### Phase 3: Attention Scores (Dot Product)
The raw attention scores are calculated by taking the dot product of the Query vector with every Key vector. 
- *Mathematical operation*: `Score_i = Q \cdot K_i`
- *Assembly implementation*: The `dot.s` module is heavily utilized here to compute the scalar product between arrays stored in contiguous memory blocks.

### Phase 4: Token Selection (Argmax & Select)
Unlike a full transformer that uses a Softmax function, this *Mini-Transformer* utilizes a hard-argmax approximation to determine the highest attention score.
1. **Argmax**: The `argmax.s` subroutine iterates through the calculated attention scores to find the index of the maximum value.
2. **Select**: The `select.s` subroutine extracts the final predicted token string from the vocabulary array using the winning index.

## 3. Memory Management in RISC-V

Since the architecture lacks an operating system with dynamic memory allocation (like `malloc`), memory is managed statically:
- **Data Segment (`.data`)**: Used for file buffers, matrix dimensions, and static pointers.
- **Heap Segment**: Used for dynamically loading the matrix contents parsed from the text files. Pointers are carefully manipulated and stored in registers (`s0`-`s11`) to prevent memory leaks or segmentation faults during the matrix multiplications.

## 4. Subroutine Calling Convention
All subroutines (`argmax`, `dot`, `select`) strictly adhere to the standard RISC-V calling convention:
- `a0-a7`: Used for passing arguments (array pointers, lengths).
- `a0, a1`: Used for returning results (e.g., the maximum index or the dot product scalar).
- `s0-s11`: Saved registers are pushed to the stack `sp` at the prologue of every function and popped at the epilogue to preserve the caller's state.
