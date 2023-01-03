.686
.model flat
public _srednia_harm

.data

	tab1 dd 32 dup (?)
	n dd ?
	jeden dd 1.0

.code

_srednia_harm PROC
	push ebp ; zapisanie zawartoœci EBP na stosie
	mov ebp,esp ; kopiowanie zawartoœci ESP do EBP
	push ebx ; przechowanie zawartoœci rejestru EBX
	push esi ; przechowanie zawartoœci rejestru ESI
	push edi ; przechowanie zawartoœci rejestru EDI

	mov esi, [ebp+8] ; adres tablicy tab1
	mov ecx, [ebp+12] ; liczba elementów tablicy
	mov ebx, 0 ; indeks w tab1
	mov n, ecx
	mov tab1, esi

	finit
	fldz ; ST(0): suma

	petla:
		fld jeden ; ST(0): 1  ST(1): suma
		fld dword ptr [esi+ebx] ;ST(0): element tablicy; ST(1): 1; ST(2): suma
		fdivp ;ST(0): 1/element tablicy  ST(1): suma
		faddp ;ST(0): suma
		add ebx, 4
	loop petla

	fild n ;ST(0): n; ST(1): suma
	fxch ST(1) ;ST(0): suma; ST(1): n
	fdivp ;ST(0): n/suma

	pop edi ; odtworzenie zawartoœci rejestrów
	pop esi
	pop ebx
	pop ebp
	ret ; powrót do programu g³ównego

_srednia_harm ENDP

END