# x86-64 Assembly: Procedures and the Stack

Three small NASM x86-64 assembly programs for Linux, written to practice procedure calls, the System V calling convention and stack frames.

## Programs

| File | What it does | What it demonstrates |
|---|---|---|
| `minimum.asm` | Minimum of three integers | nested calls, a local variable stored in the stack frame |
| `somme.asm` | Sum of squares from 1 to n | callee-saved registers (RBX, R12, R13) |
| `combinaisons.asm` | Number of combinations C(n, k) | two-call recursion, intermediate result kept in the frame |

Integers are signed 64-bit. Input and output use `scanf` and `printf` (`%ld`), and only in `main`.

## Build and run

You need `nasm` and `gcc`:

```bash
sudo apt install nasm gcc
```

Then, for each file (example with `minimum`):

```bash
nasm -f elf64 minimum.asm -o minimum.o
gcc -o minimum minimum.o -no-pie
./minimum
```

## Examples

```
$ echo "8 -3 5" | ./minimum
Minimum: -3

$ echo "10" | ./somme
Somme des carres: 385

$ echo "20 10" | ./combinaisons
Combinaisons: 184756
```

Expected input:
- `minimum`: three integers between -1,000,000 and 1,000,000
- `somme`: one integer n with 0 ≤ n ≤ 1000
- `combinaisons`: two integers n and k with 0 ≤ k ≤ n ≤ 20

## Notes

- The computing procedures do no I/O and use no global variables.
- The stack is 16-byte aligned before every `call`. Stack frame layouts are explained in the comments of each file (written in French).
