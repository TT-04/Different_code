global main
extern scanf		
extern printf
 
section .bss
var: resd 1
 
section .text
_start:
	mov rdi, format		
	mov rsi, var		
	mov rax, 0			
	call scanf
 
       mov rdx, [var]
       shr rdx, 4
       sub [var], rdx
    
	mov rdi, format		
	mov rsi, [var]		
	mov rax, 0
	call printf
 
	xor rax, rax
	ret
 
format: db "%d", 10, 0
