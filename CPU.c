global  _start
						
N equ 100						
code_a equ 97
code_z equ 122
code_A equ 65
code_Z equ 90
interval equ 32



section .bss						
var_read:	resb N					
					

section .text						
_start:							
call asm_read_BIG
call asm_write
call asm_exit

asm_read_BIG:	


	call asm_read	; считали то, что ввел				
	
	mov rcx, N					; rcx = N, установили счетчик в N

	L_WOW:					
		
		mov rdx, N
		sub rdx, rcx				            ; rdx = N-rcx - будет номером символа, который сейчас обрабатывается, считая от 0
		xor rbx, rbx				            ; rbx=0
		mov bl, [var_read + rdx]		        ; положили следующий по ходу символ в bl ; [var_read + rdx] - обращение к значению, лежащему по адресу var_read + смещение из rdx
		cmp bl, code_a
        jge L_small_possible_letter
		jl L_big_possible_letter
		
	ret			

L_small_possible_letter:
cmp bl, code_z
jle L_small_exact_letter
jg L_End





L_small_exact_letter:
sub bl, interval
mov [var_read + rdx], bl
jmp L_End


L_big_possible_letter:
cmp bl, code_Z
jg L_End
jle L_almost_big_letter




L_almost_big_letter:
cmp bl, code_A
jge L_exact_big_letter
jl L_End





L_exact_big_letter:
add bl, interval
mov [var_read + rdx], bl
jmp L_End





L_End:
Loop L_WOW




    asm_read:						
	mov rax, 0					; в rax кладем номер системного вызова, который надо вызвать, для read это 0
	mov rdi, 0					; определяем, откуда надо считать данные 0 это stdin - т.е. считываем из консоли (она же командная строка/терминал, и т.д.)
	mov rsi, var_read				; считает результат посимвольно в строго определенную переменную var_read
	mov rdx, N					; указывает столько байт, сколько нужно считать, тут он должен заполнить весь массив целиком
	syscall						; делает "системный вызов" (это термин, "system call"), т.е. зовет функцию операционной системы 
	ret		


    asm_write:						
	mov rax, 1					
	mov rdi, 1					
	mov rsi, var_read				
	mov rdx, N					
	syscall						
	ret

    asm_exit:						
	mov rax, 60					
	xor rdi, rdi					
	syscall
	ret