default rel

section .data
fmt_in:  db "%ld %ld %ld", 0
fmt_out: db "Minimum: %ld", 10, 0

section .bss
a: resq 1
b: resq 1
c: resq 1

section .text
global main
extern scanf
extern printf

; minimum2: rdi = a, rsi = b, retourne le plus petit dans rax
minimum2:
    mov rax, rdi
    cmp rdi, rsi
    cmovg rax, rsi            ; comparaison signee, si a > b alors rax = b
    ret

; minimum3: rdi = a, rsi = b, rdx = c
; cadre de pile:
;   [rbp+8]   adresse de retour
;   [rbp]     ancien rbp
;   [rbp-8]   c
;   [rbp-16]  vide, juste pour l'alignement
; c est a [rbp-8]. Je reserve 16 octets avec sub (8 pour c + 8 de remplissage),
; donc 24 octets avec l'ancien rbp. Comme ca rsp reste multiple de 16 avant
; les call. Je garde c dans le cadre parce que rdx peut changer apres un appel.
minimum3:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp-8], rdx          ; sauvegarde de c
    call minimum2             ; rax = min(a, b)
    mov rdi, rax
    mov rsi, [rbp-8]          ; on relit c
    call minimum2             ; rax = min(min(a, b), c)
    mov rsp, rbp
    pop rbp
    ret

main:
    push rbp
    mov rbp, rsp
    lea rdi, [fmt_in]
    lea rsi, [a]
    lea rdx, [b]
    lea rcx, [c]
    xor eax, eax
    call scanf
    mov rdi, [a]
    mov rsi, [b]
    mov rdx, [c]
    call minimum3
    mov rsi, rax              ; le resultat va dans rsi avant de toucher a eax
    lea rdi, [fmt_out]
    xor eax, eax
    call printf
    xor eax, eax
    pop rbp
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
