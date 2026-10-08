default rel

section .data
fmt_in:  db "%ld %ld", 0
fmt_out: db "Combinaisons: %ld", 10, 0

section .bss
n: resq 1
k: resq 1

section .text
global main
extern scanf
extern printf

; combinaisons: rdi = n, rsi = k, retourne C(n, k) dans rax
; cadre de pile (cas pas de base):
;   [rbp+8]   adresse de retour
;   [rbp]     ancien rbp
;   [rbp-8]   n
;   [rbp-16]  k
;   [rbp-24]  resultat du premier appel C(n-1, k-1)
;   [rbp-32]  vide, pour l'alignement
; sub rsp, 32: 24 octets utiles + 8 de remplissage, comme ca rsp est un
; multiple de 16 avant chaque call.
; Les appels recursifs n'ecrasent pas ces variables parce que chaque appel fait
; son propre push rbp / sub rsp, donc son cadre est plus bas en memoire que
; celui de l'appelant. Chacun travaille dans son cadre avec rbp. Par contre
; rdi, rsi et rax changent apres un call, alors on recharge n et k depuis le
; cadre pour le deuxieme appel.
combinaisons:
    test rsi, rsi             ; base: k = 0
    jz .base
    cmp rsi, rdi              ; base: k = n
    je .base
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov [rbp-8], rdi          ; n
    mov [rbp-16], rsi         ; k
    dec rdi
    dec rsi
    call combinaisons         ; C(n-1, k-1)
    mov [rbp-24], rax         ; a garder pendant le 2e appel
    mov rdi, [rbp-8]
    dec rdi
    mov rsi, [rbp-16]
    call combinaisons         ; C(n-1, k)
    add rax, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.base:
    mov rax, 1
    ret

main:
    push rbp
    mov rbp, rsp
    lea rdi, [fmt_in]
    lea rsi, [n]
    lea rdx, [k]
    xor eax, eax
    call scanf
    mov rdi, [n]
    mov rsi, [k]
    call combinaisons
    mov rsi, rax
    lea rdi, [fmt_out]
    xor eax, eax
    call printf
    xor eax, eax
    pop rbp
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
