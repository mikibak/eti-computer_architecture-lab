.686
.XMM ; zezwolenie na asemblacj� rozkaz�w grupy SSE
.model flat

public _objetosc_stozka
public _szybki_max

.data

	trzy dd 3.0

.code

_szybki_max PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	mov esi, [ebp+8] ; adres tablicy1
	mov ebx, [ebp+12] ; adres tablicy2
	
	movups xmm0, [esi]
	movups xmm1, [ebx]

	PMAXSW xmm0, xmm1

	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_szybki_max ENDP

_objetosc_stozka PROC
	push ebp ; zapisanie zawarto�ci EBP na stosie
	mov ebp,esp ; kopiowanie zawarto�ci ESP do EBP
	push ebx ; przechowanie zawarto�ci rejestru EBX
	push esi ; przechowanie zawarto�ci rejestru ESI
	push edi ; przechowanie zawarto�ci rejestru EDI

	fild dword ptr [ebp+8] ;big_r
	fild dword ptr [ebp+8] ;big_r
	fmul ST(0), ST(0) ;ST(0) big_r^2, ST(1) big_r
	fild dword ptr [ebp+12] ;small_r
	fild dword ptr [ebp+12] ;small_r
	fmul ST(0), ST(0) ;ST(0) small_r^2, ST(1) small_r, ST(2) big_r^2, ST(3) big_r

	fxch ST(3) ;ST(0) big_r, ST(1) small_r, ST(2) big_r^2, ST(3) small_r^2
	fmulp
	faddp ;ST(0) big_r^2 + small_r * big*r
	faddp ;ST(0) small_r^2 + small_r * big*r + big_r^2, ST(1) big_r
	fld dword ptr [ebp+16] ;h
	fmulp
	fldpi
	fmulp
	fdiv trzy

	pop edi ; odtworzenie zawarto�ci rejestr�w
	pop esi
	pop ebx
	pop ebp
	ret ; powr�t do programu g��wnego
_objetosc_stozka ENDP

END