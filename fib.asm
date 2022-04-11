global _start ;В rdx положить 7е число Фибоначчи.(Это 8)

code_zero equ 48	

section .bss
    var_write: resb 1
section .text
    _start:	
    mov rax, 0 ; fir
    mov rbx, 1 ; sec 
    mov rsi, 0 ;thi
mov rcx, 5
start_loop: 
    add rsi, rax
    add rsi, rbx
    
    mov rax, rbx
    mov rbx, rsi 
    xor rsi, rsi 
    
    loop start_loop
    mov rdx, rbx
    add rdx, code_zero 
    mov [var_write], rdx
    jmp asm_write

asm_write:						
	mov rax, 1					
	mov rdi, 1					
	mov rsi, var_write				
	mov rdx, 1					
	syscall						
	jmp exit

exit:
    mov rax, 60
    xor rdi, rdi
    syscall
    
