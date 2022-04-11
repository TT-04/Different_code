global  _start
flags equ 0x42
N equ 8


section .bss
var_fd: resq 1
utr: resq 1

section .text
_start:

        mov rax, 2
        mov rdi, name
        mov rsi, flags
        syscall

        mov [var_fd], rax


        mov rax, 1
        mov rdi, [var_fd]
        mov rsi, text
        mov rdx, 8
        syscall

	mov rax, 1
	mov rdi, [var_fd]
	mov rsi, string
	mov rdx, 8
	syscall 	                                                                                                                                                                                                      
        mov rax, 3
        mov rdi, [var_fd]
        syscall

        mov rax, 60
        xor rdi, rdi
        syscall


name:   db      "Rum.txt", 0
text:   db      "AAAAAAAA",0xA
string: db      "DDDDDDDD"
