global  _start						; сделать _start доступной извне - т.е. объявляем точку входа

N equ 8							; это макрос, в тексте программы N везде заменится на 8, аналогично #define N 2 в Си.
							; В программе - это количество символов числа, которое может быть считано, не больше 10,
							; иначе число уже не влезет в регистр
							; программа работает корректно, только если количество введенных чисел совпадает с N
							; и только если нет посторонних символов, например, отрицательные числа дадут непредсказуемый результат
							
code_zero equ 48					; 48 это код нуля в ASCII

section .bss						; аналог секции .data, но позволяющий выделять не инициализированную память
var_read:	resb N					; reserve N bytes, т.е. создали переменную (по сути - массив) var_read состоящую из N ячеек по 1 байту каждая
var_write:	resb N					; reserve N bytes, команда resb N - res - зарезервировать, b - байт, N - N штук
							; вместо b могут быть w - (word) 2 байта, d - (double) 4 байта, q - 8 байт

section .text						; аналог секции .code, тут пишем код
_start:							; метка - точка входа, аналог int main() в Си
	call asm_read_decimal				; вызов функции без аргументов, чтобы считать введенное посимвольно число в регистр rax
							; можно работать со считанным числом
	call asm_write_decimal				; вывести посимвольно число, хранящееся в rax
	call asm_exit					; wrapper - функция, в которую "завернут" стандартный набор инструкций для выхода из системы

asm_read_decimal:					; объявление новой функции, похоже на atoi() в Си
	call asm_read					; вызов функции, внутри будет read, который считает символы в var_read
	xor rax, rax					; rax = 0 - будет содержать итоговое число, на каждой итерации цикла оно будет умножаться на 10,
							; и к нему будет прибавляться следующая цифра
	mov rcx, N					; rcx = N, установили счетчик в N
	l_rd:						; метка - начало цикла
		mov ebx, 10
		mul ebx					; эти инструкции, чтобы умножить rax на 10, не учтено, что может произойти переполнение,
							; и часть результата попадет в rdx, тут нужна еще проверка на rdx!=0
		mov rdx, N
		sub rdx, rcx				; rdx = N-rcx - будет номером символа, который сейчас обрабатывается, считая от 0
		xor rbx, rbx				; rbx=0
		mov bl, [var_read + rdx]		; положили следующий по ходу символ в bl, 
							; [var_read + rdx] - обращение к значению, лежащему по адресу var_read + смещение из rdx
		sub bl, code_zero			; из номера символа сделали цифру, т.е. вычти из него код нуля, не учтено, что могли вводить не только цифры
		add rax, rbx				; добавили эту цифру к числу в rax
		loop l_rd				; зациклили, loop уменьшает rcx на 1, и выходит, если при этом rcx стал = 0, если нет - идет на метку
	ret						; выход из функции, если не поставить, код будет исполняться дальше подряд, аналог return в Си

asm_write_decimal:					; объявление новой функции, похоже на itoa() в Си
	mov rcx, N					; rcx = N - инициализировали счетчик
	l_wr:						; метка - начало цикла
		xor rdx, rdx				; rdx = 0 - нужно для корректной работы операции деления, т.е. делимое это rdx:rax,
							; т.е. делимое разбито на 2 регистра
		mov ebx, 10				; делимое
		div ebx					; само деление, частное будет в rax, его будут преобразовывать в посимвольное представление на следующих итерациях,
							; остаток - попадает в rdx
		add rdx, code_zero			; из остатка в rdx делаем соответствующий ему символ
		mov rbx, rcx				; в rbx кладем смещение в массиве, по которому надо этот полученный символ положить
		dec rbx						
		mov [var_write + rbx], dl		; кладем этот символ по полученному смещению, dl - т.к. элементы массива имеют размер 1 байт
		loop l_wr				; зациклили, уменьшит rcx на 1, проверит rxc!=0 и перейдет на метку; при rcx=0 мы выходим из цикла.
							; Т.е. при rcx=0 цикл не выполняется
	call asm_write					; вызов функции, внутри будет write, который распечатает символы из var_write
	ret						; выход из функции

asm_read:						; wrapper - функция, в которую "завернут" стандартный вызов read
	mov rax, 0					; в rax кладем номер системного вызова, который надо вызвать, для read это 0
	mov rdi, 0					; определяем, откуда надо считать данные 0 это stdin - т.е. считываем из консоли 
							; (она же командная строка/терминал, и т.д.)
	mov rsi, var_read				; считает результат посимвольно в строго определенную переменную var_read
	mov rdx, N					; указывает столько байт, сколько нужно считать, тут он должен заполнить весь массив целиком
	syscall						; делает "системный вызов" (это термин, "system call"), т.е. зовет функцию операционной системы 
	ret						; ret нужен, чтобы корректно выйти из wrapper'a.
	
asm_write:						; wrapper - функция, в которую "завернут" стандартный вызов write
	mov rax, 1					; 1 - номер системного вызова write - считывает посимвольно
	mov rdi, 1					; rdi - откуда считываем, 1 это stdout  - т.е. командная строка
	mov rsi, var_write				; в rsi кладем указатель на то, что нужно напечатать
	mov rdx, N					; rdx - кол-во байт, т.е. в консоль будет выведено N байт начиная с адреса var_write
	syscall						; rax, rdi, rsi, rdx - содержат параметры для этого вызова
	ret

asm_exit:						; wrapper - функция, в которую "завернут" стандартный вызов exit
	mov rax, 60					; 60 - номер системного вызова exit - завершить программу
	xor rdi, rdi					; rdi = 0 - код, с которым завершится исполнение программы
	syscall
	ret
