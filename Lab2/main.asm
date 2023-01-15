; Przyk³ad wywo³ywania funkcji MessageBoxA i MessageBoxW
.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC
extern _MessageBoxW@16 : PROC
public _main

.data
	liczba dd 12.875
.code
_main PROC
	mov eax, liczba
	push 0 ; kod powrotu programu
	call _ExitProcess@4
_main ENDP
END