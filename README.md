
---

# Stanford CS143: Compiler Assignments

This repository contains my solutions to the programming assignments from **Stanford's CS143: Compilers** course. The assignments focus on designing and building components of a compiler for the **Cool (Classroom Object-Oriented Language)** programming language.  

## Table of Contents
1. [Overview](#overview)
2. [Assignments](#assignments)
   - [PA1: Stack Machine Interpreter](#pa1-stack-machine-interpreter)
   - [PA2: Lexical Analysis](#pa2-lexical-analysis)
   - [PA3: Parsing and Abstract Syntax Tree (AST)](#pa3-parsing-and-abstract-syntax-tree-ast)
3. [Directory Structure](#directory-structure)
4. [Tools & Dependencies](#tools--dependencies)
5. [How to Run](#how-to-run)
6. [Acknowledgments](#acknowledgments)
7. [References](#references)

---

## Overview

The goal of these assignments is to design and implement individual phases of a compiler for the **Cool** programming language:

1. **PA1**: Develop a stack machine interpreter in Cool.
2. **PA2**: Implement a lexical analyzer (scanner) using `flex`/`jlex`.
3. **PA3**: Build a parser that generates an **Abstract Syntax Tree (AST)** using `bison`/`CUP`.

These assignments lay the groundwork for future phases of compiler construction, such as semantic analysis and code generation.

---

## Assignments

### PA1: Stack Machine Interpreter

#### **Overview**
In this assignment, I implemented a **Stack Machine Interpreter** in the Cool programming language. The interpreter supports a simple set of commands:

| Command | Description                          |
|---------|--------------------------------------|
| `int`   | Push an integer onto the stack.      |
| `+`     | Push a `+` operator onto the stack.  |
| `s`     | Push an `s` (swap) command.          |
| `e`     | Evaluate the stack.                 |
| `d`     | Display the stack contents.          |
| `x`     | Exit the interpreter.                |

The `e` command allows:
1. Addition (`+`) of the two top integers.
2. Swapping (`s`) of the two top items.

#### **Files**
- `PA1/stack.cl` : Stack Machine Interpreter implementation in Cool.
- `PA1/Makefile` : Build instructions.
- `PA1/stack.test` : Sample input for testing.

---

### PA2: Lexical Analysis

#### **Overview**
This phase involves writing a **Lexical Analyzer** for Cool using a lexical analyzer generator:
- **Tools**: `flex` (C++)
- The scanner reads Cool source files and identifies tokens such as keywords, identifiers, operators, and literals.

#### **Key Features**
- Token recognition for Cool.
- Handles whitespace, comments, and special characters.

#### **Files**
- `PA2/cool.flex` : Lexical rules for Cool.
- `PA2/Makefile` : Build instructions to generate the scanner.
- `PA2/lextest.cc` : Test program for verifying token output.

---

### PA3: Parsing and Abstract Syntax Tree (AST)

#### **Overview**
In this assignment, I implemented a **Parser** for Cool using:
- **Parser Generators**: `bison` (C++)
- The parser generates an **Abstract Syntax Tree (AST)** representing the syntactic structure of Cool programs.

#### **Key Features**
- Defined grammar rules for Cool.
- Constructed the AST using semantic actions.

#### **Files**
- `PA3/cool.y` : Grammar definition for Cool.
- `PA3/cool-tree.cc` : AST manipulation utilities.
- `PA3/Makefile` : Build instructions for the parser.
- `PA3/good.cl` and `PA3/bad.cl` : Sample Cool programs to validate parsing.

---

## Directory Structure

```
cool/
├── assignments/
│   ├── PA1/
│   │   ├── atoi.cl
│   │   ├── stack.cl
│   │   ├── stack.test
│   │   ├── Makefile
│   │   └── README
│   ├── PA2/
│   │   ├── cool.flex
│   │   ├── lextest.cc
│   │   ├── Makefile
│   │   └── test.cl
│   ├── PA3/
│       ├── cool.y
│       ├── cool-tree.cc
│       ├── Makefile
│       ├── good.cl
│       └── bad.cl
├── examples/ (Sample Cool programs)
└── handouts/ (Course documentation)
```

---

## Tools & Dependencies

To work with these assignments, the following tools are required:

1. **Cool Compiler Tools**: Provided as part of Stanford's CS143 course.
2. **Flex**: Lexical analyzer generator for C++.
3. **Bison**: Parser generator for C++.
4. **Make**: For automating the build process.

Ensure these tools are installed and accessible via your system's PATH.

---

## How to Run

### PA1: Stack Machine Interpreter
1. Navigate to the `PA1` directory.
2. Build the project:
   ```bash
   make
   ```
3. Run the interpreter:
   ```bash
   coolc stack.cl
   ./stack
   ```

### PA2: Lexical Analyzer
1. Navigate to the `PA2` directory.
2. Generate the scanner:
   ```bash
   make
   ```
3. Test with input files:
   ```bash
   ./lexer test.cl
   ```

### PA3: Parser
1. Navigate to the `PA3` directory.
2. Build the parser:
   ```bash
   make
   ```
3. Parse a Cool program:
   ```bash
   ./myparser good.cl
   ```

---

## **Acknowledgments**  

These assignments are part of the **Stanford CS143: Compilers** course, originally developed by Stanford University. The project materials, tools, and handouts were provided as part of the course curriculum.  

All credit for the course design, project materials, and documentation goes to **Stanford University** and the creators of the **Cool programming language**.

---

## References

- **Cool Language Manual**: [cool-manual.pdf](handouts/cool-manual.pdf)
- **Tour of Cool Tools**: [cool-tour.pdf](handouts/cool-tour.pdf)
- Official documentation for **flex**, **bison**.

---

Feel free to clone, test, and explore the code. If you have any questions or suggestions, feel free to create an issue!

--- 

