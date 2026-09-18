# RISC-V Mini-Transformer

An AI-powered sequence prediction model based on a simplified Self-Attention mechanism, implemented entirely in RISC-V Assembly. This project translates mathematical operations—such as Query, Key, and Value matrix multiplications and dot-product attention—into low-level hardware instructions to predict the next token in a text sequence, operating purely at the processor architecture level.

## Table of Contents
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Quick Start](#quick-start)
  - [Prerequisites](#prerequisites)
  - [Installation & Execution](#installation--execution)
- [Input and Output Formats](#input-and-output-formats)
- [Repository Structure](#repository-structure)

## Features

> [!NOTE]
> For a detailed mathematical and architectural breakdown of how the Attention Mechanism is implemented in Assembly, read the [ALGORITHM.md](./ALGORITHM.md) file.

- **AI Sequence Prediction** - Predicts the next token in a sequence using attention scores.
- **Matrix Operations** - Hardware-level dot products and array selections.
- **File I/O** - Reads vocabulary, embeddings, and weight matrices dynamically from `.txt` files.

## Tech Stack
- **Language**: RISC-V Assembly (RV32)
- **Environment**: Ripes Simulator

## Quick Start

### Prerequisites
- [Ripes Simulator](https://github.com/mortbopet/Ripes)

### Installation & Execution
1. Open the Ripes simulator.
2. Load the main source file: `mini_transformer.s`.
3. The necessary data files (`vocab.txt`, `embeddings.txt`, `W_K.txt`, `W_Q.txt`, `W_V.txt`, `input.txt`) are located in the `data/` directory.
4. Run the simulator to see the output prediction.

## Input and Output Formats

### Data Files (`vocab.txt`, `input.txt`)
Each line contains one token string ending with a newline.
```text
the
robot
finds
```

### Matrix Files (`embeddings.txt`, `W_K.txt`, etc.)
Each row corresponds to a matrix row, separated by spaces.
```text
-2 1 1 -2
-8 -6 -8 -1
```

### Expected Output
```text
Predicted token: street
```

## Repository Structure
```text
.
├── data/              # Directory containing input text files and matrices
│   ├── embeddings.txt # Embeddings data matrix
│   ├── input.txt      # Input sequence tokens
│   ├── vocab.txt      # Vocabulary tokens dictionary
│   └── W_*.txt        # Weight matrices (W_K, W_Q, W_V)
├── ALGORITHM.md       # In-depth architectural and mathematical breakdown
├── README.md          # Project documentation and instructions
└── mini_transformer.s # Final source code for the Mini-Transformer
```
