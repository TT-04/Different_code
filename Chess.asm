global _start

section .text
N equ 8

_start:
	mov ebx, 0 
	
s: 
	cmp ebx, 4 
	je L_exit
	jmp L_ones
	
	
L_ones:
  mov rax, 1
  mov rdi, 1
  mov rsi, ones
  mov rdx, 16
  syscall
  
  	
		
L_zeros:
  mov rax, 1
  mov rdi, 1
  mov rsi, zeros
  mov rdx, 16
  syscall
  inc ebx
  jmp s
 

L_exit:
  mov rax, 60
  xor rdi, rdi
  syscall
 
  
section .data
  zeros db "O 1 0 1 0 1 0 1", 0xA, 0
  ones db "1 0 1 0 1 0 1 0", 0xA, 0
