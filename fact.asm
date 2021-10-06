%include "io.inc"

section .text
global CMAIN
CMAIN:
    GET_DEC 4, eax
    mov ecx, eax
    mov eax, 1
    mov ebx, 1 
start_loop:
    cmp ecx, ebx
    je exit
 
    
    mul ecx
    dec ecx
    jmp start_loop
    
exit:

    PRINT_DEC 4, eax
    
    ret