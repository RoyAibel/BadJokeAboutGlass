; Vibe
section .data
    prefix      db "User drank 20%; "
    nums        db 8, 6, 4, 2
    suffix_tmpl db " 00% Left"
    newline     db 10
    message     db "Intern summoned; glass refilled"
    quitMessage db "Intern quit; glass empty."

section .bss
    counter     resb 1

section .text
    global _start

_start:
    mov byte [counter], 4

round_loop:
    xor esi, esi

print_loop:
    mov eax, 4
    mov ebx, 1
    mov ecx, prefix
    mov edx, 16
    int 0x80

    mov al, [nums + esi]
    xor ah, ah
    imul ax, ax, 10
    mov dl, 10
    div dl
    add al, '0'
    mov [suffix_tmpl + 1], al
    add ah, '0'
    mov [suffix_tmpl + 2], ah

    mov eax, 4
    mov ebx, 1
    mov ecx, suffix_tmpl
    mov edx, 10
    int 0x80

    inc esi
    cmp esi, 4
    jl print_loop

    mov eax, 4
    mov ebx, 1
    cmp byte [counter], 1
    jne .not_last
    mov ecx, quitMessage
    mov edx, 26
    jmp .print_message

.not_last:
    mov ecx, message
    mov edx, 31

.print_message:
    int 0x80

    cmp byte [counter], 1
    je .skip_newline

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

.skip_newline:
    dec byte [counter]
    cmp byte [counter], 0
    jg round_loop

    mov eax, 1
    xor ebx, ebx
    int 0x80
