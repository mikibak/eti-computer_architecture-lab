.686
.XMM ; zezwolenie na asemblacj� rozkaz�w grupy SSE
.model flat
public _srednia_harm
public _nowy_exp
public _dodaj_SSE, _pierwiastek_SSE, _odwrotnosc_SSE
public _suma_tablic_charow, _int2float, _pm_jeden
public _find_max_range
public _objetosc_stozka
public _szybki_max

.data

	tab1 dd 32 dup (?)
	n dd ?
	jeden dd 1.0
	piate_zadanie dd 4 dup (1.0)
	g dd 9.81
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

_find_max_range PROC
	push ebp ; zapisanie zawarto�ci EBP na stosie
	mov ebp,esp ; kopiowanie zawarto�ci ESP do EBP
	push ebx ; przechowanie zawarto�ci rejestru EBX
	push esi ; przechowanie zawarto�ci rejestru ESI
	push edi ; przechowanie zawarto�ci rejestru EDI

	fld dword ptr [ebp+12] ;alfa
	fsincos ;na ST(0) i ST(1) sinus i cosinus

	fmulp st(1), st(0) ; obliczenie sin * cos

	fld1
	fld1
	faddp ; ST(0) 2 ST(1) sin cos
	fmulp ;ST(0) 2 sin cos

	fld dword ptr [ebp+8] ;v
	fld dword ptr [ebp+8] ;v
	fmulp ;ST(0) v*v ST(1) 2 sin cos 
	fmulp

	fld dword ptr g
	fdivp

	pop edi ; odtworzenie zawarto�ci rejestr�w
	pop esi
	pop ebx
	pop ebp
	ret ; powr�t do programu g��wnego
_find_max_range ENDP

_pm_jeden PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	mov esi, [ebp+8] ; adres tablicy
	
	movups xmm5, [esi]
	movups xmm6, piate_zadanie

	;to dziwne dodawanie co drugiego
	ADDSUBPS xmm5, xmm6
	
	movups [esi], xmm5

	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_pm_jeden ENDP

_dodaj_SSE PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	mov esi, [ebp+8] ; adres pierwszej tablicy
	mov edi, [ebp+12] ; adres drugiej tablicy
	mov ebx, [ebp+16] ; adres tablicy wynikowej
	; �adowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
	; kowych 32-bitowych - liczby zostaj� pobrane z tablicy,
	; kt�rej adres poczatkowy podany jest w rejestrze ESI
	; interpretacja mnemonika "movups" :
	; mov - operacja przes�ania,
	; u - unaligned (adres obszaru nie jest podzielny przez 16),
	; p - packed (do rejestru �adowane s� od razu cztery liczby),
	; s - short (inaczej float, liczby zmiennoprzecinkowe
	; 32-bitowe)
	movups xmm5, [esi]
	movups xmm6, [edi]
	; sumowanie czterech liczb zmiennoprzecinkowych zawartych
	; w rejestrach xmm5 i xmm6
	addps xmm5, xmm6
	; zapisanie wyniku sumowania w tablicy w pami�ci
	movups [ebx], xmm5
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_dodaj_SSE ENDP

_pierwiastek_SSE PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	mov esi, [ebp+8] ; adres pierwszej tablicy
	mov ebx, [ebp+12] ; adres tablicy wynikowej
	; �adowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
	; kowych 32-bitowych - liczby zostaj� pobrane z tablicy,
	; kt�rej adres pocz�tkowy podany jest w rejestrze ESI
	; mnemonik "movups": zob. komentarz podany w funkcji dodaj_SSE
	movups xmm6, [esi]
	; obliczanie pierwiastka z czterech liczb zmiennoprzecinkowych
	; znajduj�cych sie w rejestrze xmm6
	; - wynik wpisywany jest do xmm5
	sqrtps xmm5, xmm6
	; zapisanie wyniku sumowania w tablicy w pami�ci
	movups [ebx], xmm5
	pop esi
	pop ebx
	pop ebp
	ret
_pierwiastek_SSE ENDP

; rozkaz RCPPS wykonuje obliczenia na 12-bitowej mantysie
; (a nie na typowej 24-bitowej) - obliczenia wykonywane s�
; szybciej, ale s� mniej dok�adne
_odwrotnosc_SSE PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	mov esi, [ebp+8] ; adres pierwszej tablicy
	mov ebx, [ebp+12] ; adres tablicy wynikowej
	; ladowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
	; kowych 32-bitowych - liczby zostaj� pobrane z tablicy,
	; kt�rej adres poczatkowy podany jest w rejestrze ESI
	; mnemonik "movups": zob. komentarz podany w funkcji dodaj_SSE
	movups xmm5, [esi]
	; obliczanie odwrotno�ci czterech liczb zmiennoprzecinkowych
	; znajduj�cych si� w rejestrze xmm6
	; - wynik wpisywany jest do xmm5
	rcpps xmm5, xmm6
	; zapisanie wyniku sumowania w tablicy w pamieci
	movups [ebx], xmm5
	pop esi
	pop ebx
	pop ebp
	ret
_odwrotnosc_SSE ENDP

;Do sumowania wykorzysta� rozkaz PADDSB (wersja SSE), kt�ry sumuje, z
;uwzgl�dnieniem nasycenia, dwa wektory 16-elementowe z�o�one z liczb ca�kowitych 8-
;bitowych. Wyja�ni� (pozorne) b��dy w obliczeniach
_suma_tablic_charow PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	mov esi, [ebp+8] ; adres pierwszej tablicy
	mov edi, [ebp+12] ; adres drugiej tablicy
	mov ebx, [ebp+16] ; adres tablicy wynikowej
	; �adowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
	; kowych 32-bitowych - liczby zostaj� pobrane z tablicy,
	; kt�rej adres poczatkowy podany jest w rejestrze ESI
	; interpretacja mnemonika "movups" :
	; mov - operacja przes�ania,
	; u - unaligned (adres obszaru nie jest podzielny przez 16),
	; p - packed (do rejestru �adowane s� od razu cztery liczby),
	; s - short (inaczej float, liczby zmiennoprzecinkowe
	; 32-bitowe)
	movups xmm5, [esi]
	movups xmm6, [edi]
	; sumowanie czterech liczb zmiennoprzecinkowych zawartych
	; w rejestrach xmm5 i xmm6
	paddsb xmm5, xmm6
	; zapisanie wyniku sumowania w tablicy w pami�ci
	movups [ebx], xmm5
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_suma_tablic_charow ENDP

_int2float PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	mov esi, [ebp+8] ; adres tablicy calkowitych
	mov edi, [ebp+12] ; adres tablicy wynikowej
	; �adowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
	; kowych 32-bitowych - liczby zostaj� pobrane z tablicy,
	; kt�rej adres poczatkowy podany jest w rejestrze ESI
	; interpretacja mnemonika "movups" :
	; mov - operacja przes�ania,
	; u - unaligned (adres obszaru nie jest podzielny przez 16),
	; p - packed (do rejestru �adowane s� od razu cztery liczby),
	; s - short (inaczej float, liczby zmiennoprzecinkowe
	; 32-bitowe)
	movups xmm5, [esi]
	; konwersja
	cvtpi2ps xmm5, qword PTR [esi]
	; zapisanie wyniku sumowania w tablicy w pami�ci
	movups [edi], xmm5
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_int2float ENDP

_y_do_x PROC ;push y, push x, call _y_do_x
	push ebp ; zapisanie zawarto�ci EBP na stosie
	mov ebp,esp ; kopiowanie zawarto�ci ESP do EBP
	push ebx ; przechowanie zawarto�ci rejestru EBX
	push esi ; przechowanie zawarto�ci rejestru ESI
	push edi ; przechowanie zawarto�ci rejestru EDI

	;fld [ebp+8] ; liczba x
	fld1
	fld dword ptr [ebp+8] ;liczba y
	;potrzeba log2y

	;fldl2e ; log 2 e
	fyl2x ; log 2 y
	fld dword ptr [ebp+12] ;liczba x
	;ST(0) x ST(1) log 2 y

	fmulp st(1), st(0) ; obliczenie x * log 2 y
	; kopiowanie obliczonej warto�ci do ST(1)
	fst st(1)
	; zaokr�glenie do warto�ci ca�kowitej
	frndint
	fsub st(1), st(0) ; obliczenie cz�ci u�amkowej
	fxch ; zamiana ST(0) i ST(1)
	; po zamianie: ST(0) - cz�� u�amkowa, ST(1) - cz�� ca�kowita
	; obliczenie warto�ci funkcji wyk�adniczej dla cz�ci
	; u�amkowej wyk�adnika
	f2xm1
	fld1 ; liczba 1
	faddp st(1), st(0) ; dodanie 1 do wyniku
	; mno�enie przez 2^(cz�� ca�kowita)
	fscale
	; przes�anie wyniku do ST(1) i usuni�cie warto�ci
	; z wierzcho�ka stosu
	fstp st(1)
	; w rezultacie wynik znajduje si� w ST(0)

	pop edi ; odtworzenie zawarto�ci rejestr�w
	pop esi
	pop ebx
	pop ebp
	ret ; powr�t do programu g��wnego
_y_do_x ENDP

_nowy_exp PROC
	push ebp ; zapisanie zawarto�ci EBP na stosie
	mov ebp,esp ; kopiowanie zawarto�ci ESP do EBP
	push ebx ; przechowanie zawarto�ci rejestru EBX
	push esi ; przechowanie zawarto�ci rejestru ESI
	push edi ; przechowanie zawarto�ci rejestru EDI

	pop edi ; odtworzenie zawarto�ci rejestr�w
	pop esi
	pop ebx
	pop ebp
	ret ; powr�t do programu g��wnego
_nowy_exp ENDP

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