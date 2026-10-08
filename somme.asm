default rel

section .data
fmt_in:  db "%ld", 0
fmt_out: db "Somme des carres: %ld", 10, 0

section .bss
n: resq 1

section .text
global main
extern scanf
extern printf

; carre: rdi = x, retourne x*x dans rax
carre:
    mov rax, rdi
    imul rax, rdi
    ret

; somme_carres: rdi = n, retourne 1^2 + ... + n^2 dans rax
; registres sauvegardes: rbx = la somme, r12 = le compteur, r13 = n
; (je garde n dans r13 parce que rdi est reecrit avant chaque call carre)
; on les push au debut et on les pop a la fin dans l'ordre inverse, sinon
; on casse les valeurs de l'appelant.
; pile apres les 3 push:
;   [rsp+16] rbx de l'appelant
;   [rsp+8]  r12 de l'appelant
;   [rsp]    r13 de l'appelant
; alignement: a l'entree rsp = 16k+8, apres 3 push (24 octets) ca retombe sur
; un multiple de 16, donc pas besoin de remplissage avant le call.
somme_carres:
    push rbx
    push r12
    push r13
    mov r13, rdi
    xor ebx, ebx
    mov r12, 1
.boucle:
    cmp r12, r13
    jg .fin                   ; si n = 0 on sort direct sans appeler carre
    mov rdi, r12
    call carre
    add rbx, rax
    inc r12
    jmp .boucle
.fin:
    mov rax, rbx
    pop r13
    pop r12
    pop rbx
    ret

main:
    push rbp
    mov rbp, rsp
    lea rdi, [fmt_in]
    lea rsi, [n]
    xor eax, eax
    call scanf
    mov rdi, [n]
    call somme_carres
    mov rsi, rax
    lea rdi, [fmt_out]
    xor eax, eax
    call printf
    xor eax, eax
    pop rbp
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
