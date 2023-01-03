.686
.XMM ; zezwolenie na asemblacjê rozkazów grupy SSE
.model flat
public _srednia_harm
public _nowy_exp
public _dodaj_SSE, _pierwiastek_SSE, _odwrotnosc_SSE
public _suma_tablic_charow, _int2float, _pm_jeden

.data

	tab1 dd 32 dup (?)
	n dd ?
	jeden dd 1.0
	piate_zadanie dd 4 dup (1.0)

.code

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
	; ³adowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
	; kowych 32-bitowych - liczby zostaj¹ pobrane z tablicy,
	; której adres poczatkowy podany jest w rejestrze ESI
	; interpretacja mnemonika "movups" :
	; mov - operacja przes³ania,
	; u - unaligned (adres obszaru nie jest podzielny przez 16),
	; p - packed (do rejestru ³adowane s¹ od razu cztery liczby),
	; s - short (inaczej float, liczby zmiennoprzecinkowe
	; 32-bitowe)
	movups xmm5, [esi]
	movups xmm6, [edi]
	; sumowanie czterech liczb zmiennoprzecinkowych zawartych
	; w rejestrach xmm5 i xmm6
	addps xmm5, xmm6
	; zapisanie wyniku sumowania w tablicy w pamiêci
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
	; ³adowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
	; kowych 32-bitowych - liczby zostaj¹ pobrane z tablicy,
	; której adres pocz¹tkowy podany jest w rejestrze ESI
	; mnemonik "movups": zob. komentarz podany w funkcji dodaj_SSE
	movups xmm6, [esi]
	; obliczanie pierwiastka z czterech liczb zmiennoprzecinkowych
	; znajduj¹cych sie w rejestrze xmm6
	; - wynik wpisywany jest do xmm5
	sqrtps xmm5, xmm6
	; zapisanie wyniku sumowania w tablicy w pamiêci
	movups [ebx], xmm5
	pop esi
	pop ebx
	pop ebp
	ret
_pierwiastek_SSE ENDP

; rozkaz RCPPS wykonuje obliczenia na 12-bitowej mantysie
; (a nie na typowej 24-bitowej) - obliczenia wykonywane s¹
; szybciej, ale s¹ mniej dok³adne
_odwrotnosc_SSE PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	mov esi, [ebp+8] ; adres pierwszej tablicy
	mov ebx, [ebp+12] ; adres tablicy wynikowej
	; ladowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
	; kowych 32-bitowych - liczby zostaj¹ pobrane z tablicy,
	; której adres poczatkowy podany jest w rejestrze ESI
	; mnemonik "movups": zob. komentarz podany w funkcji dodaj_SSE
	movups xmm5, [esi]
	; obliczanie odwrotnoœci czterech liczb zmiennoprzecinkowych
	; znajduj¹cych siê w rejestrze xmm6
	; - wynik wpisywany jest do xmm5
	rcpps xmm5, xmm6
	; zapisanie wyniku sumowania w tablicy w pamieci
	movups [ebx], xmm5
	pop esi
	pop ebx
	pop ebp
	ret
_odwrotnosc_SSE ENDP

;Do sumowania wykorzystaæ rozkaz PADDSB (wersja SSE), który sumuje, z
;uwzglêdnieniem nasycenia, dwa wektory 16-elementowe z³o¿one z liczb ca³kowitych 8-
;bitowych. Wyjaœniæ (pozorne) b³êdy w obliczeniach
_suma_tablic_charow PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	mov esi, [ebp+8] ; adres pierwszej tablicy
	mov edi, [ebp+12] ; adres drugiej tablicy
	mov ebx, [ebp+16] ; adres tablicy wynikowej
	; ³adowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
	; kowych 32-bitowych - liczby zostaj¹ pobrane z tablicy,
	; której adres poczatkowy podany jest w rejestrze ESI
	; interpretacja mnemonika "movups" :
	; mov - operacja przes³ania,
	; u - unaligned (adres obszaru nie jest podzielny przez 16),
	; p - packed (do rejestru ³adowane s¹ od razu cztery liczby),
	; s - short (inaczej float, liczby zmiennoprzecinkowe
	; 32-bitowe)
	movups xmm5, [esi]
	movups xmm6, [edi]
	; sumowanie czterech liczb zmiennoprzecinkowych zawartych
	; w rejestrach xmm5 i xmm6
	paddsb xmm5, xmm6
	; zapisanie wyniku sumowania w tablicy w pamiêci
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
	; ³adowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
	; kowych 32-bitowych - liczby zostaj¹ pobrane z tablicy,
	; której adres poczatkowy podany jest w rejestrze ESI
	; interpretacja mnemonika "movups" :
	; mov - operacja przes³ania,
	; u - unaligned (adres obszaru nie jest podzielny przez 16),
	; p - packed (do rejestru ³adowane s¹ od razu cztery liczby),
	; s - short (inaczej float, liczby zmiennoprzecinkowe
	; 32-bitowe)
	movups xmm5, [esi]
	; konwersja
	cvtpi2ps xmm5, qword PTR [esi]
	; zapisanie wyniku sumowania w tablicy w pamiêci
	movups [edi], xmm5
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_int2float ENDP

_y_do_x PROC ;push y, push x, call _y_do_x
	push ebp ; zapisanie zawartoœci EBP na stosie
	mov ebp,esp ; kopiowanie zawartoœci ESP do EBP
	push ebx ; przechowanie zawartoœci rejestru EBX
	push esi ; przechowanie zawartoœci rejestru ESI
	push edi ; przechowanie zawartoœci rejestru EDI

	;fld [ebp+8] ; liczba x
	fld1
	fld dword ptr [ebp+8] ;liczba y
	;potrzeba log2y

	;fldl2e ; log 2 e
	fyl2x ; log 2 y
	fld dword ptr [ebp+12] ;liczba x
	;ST(0) x ST(1) log 2 y

	fmulp st(1), st(0) ; obliczenie x * log 2 y
	; kopiowanie obliczonej wartoœci do ST(1)
	fst st(1)
	; zaokr¹glenie do wartoœci ca³kowitej
	frndint
	fsub st(1), st(0) ; obliczenie czêœci u³amkowej
	fxch ; zamiana ST(0) i ST(1)
	; po zamianie: ST(0) - czêœæ u³amkowa, ST(1) - czêœæ ca³kowita
	; obliczenie wartoœci funkcji wyk³adniczej dla czêœci
	; u³amkowej wyk³adnika
	f2xm1
	fld1 ; liczba 1
	faddp st(1), st(0) ; dodanie 1 do wyniku
	; mno¿enie przez 2^(czêœæ ca³kowita)
	fscale
	; przes³anie wyniku do ST(1) i usuniêcie wartoœci
	; z wierzcho³ka stosu
	fstp st(1)
	; w rezultacie wynik znajduje siê w ST(0)

	pop edi ; odtworzenie zawartoœci rejestrów
	pop esi
	pop ebx
	pop ebp
	ret ; powrót do programu g³ównego
_y_do_x ENDP

_nowy_exp PROC
	push ebp ; zapisanie zawartoœci EBP na stosie
	mov ebp,esp ; kopiowanie zawartoœci ESP do EBP
	push ebx ; przechowanie zawartoœci rejestru EBX
	push esi ; przechowanie zawartoœci rejestru ESI
	push edi ; przechowanie zawartoœci rejestru EDI

	pop edi ; odtworzenie zawartoœci rejestrów
	pop esi
	pop ebx
	pop ebp
	ret ; powrót do programu g³ównego
_nowy_exp ENDP

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