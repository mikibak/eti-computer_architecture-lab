.686
.model flat
public _srednia_harm

.data

	tab1 dd 32 dup (?)
	n dd ?
	jeden dd 1.0

.code

_srednia_harm PROC
	push ebp ; zapisanie zawarto�ci EBP na stosie
	mov ebp,esp ; kopiowanie zawarto�ci ESP do EBP
	push ebx ; przechowanie zawarto�ci rejestru EBX
	push esi ; przechowanie zawarto�ci rejestru ESI
	push edi ; przechowanie zawarto�ci rejestru EDI

	mov esi, [ebp+8] ; adres tablicy tab1
	mov ecx, [ebp+12] ; liczba element�w tablicy
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

	pop edi ; odtworzenie zawarto�ci rejestr�w
	pop esi
	pop ebx
	pop ebp
	ret ; powr�t do programu g��wnego

_srednia_harm ENDP

END