.686
.model flat
public _dot_product
public _replace_below_zero
public _mse_loss
public _merge_reversed

.data

	pol_n dd ?
	tablica dd 32 dup (?)

.code

_merge_reversed PROC
	push ebp ; zapisanie zawartości EBP na stosie
	mov ebp,esp ; kopiowanie zawartości ESP do EBP
	push ebx ; przechowanie zawartości rejestru EBX
	push esi ; przechowanie zawartości rejestru ESI
	push edi ; przechowanie zawartości rejestru EDI

	mov esi, [ebp+8] ; adres tablicy tab1
	mov ecx, [ebp+16] ; liczba elementów tablicy
	mov edi, offset tablica ;adres w tablicy złączonej

	;sprawdzenie czy size < 32
	cmp ecx, 32
	ja zly_rozmiar

	; wpisanie kolejnego elementu tablicy 1 do rejestru EAX
	ptl: mov eax, [esi]
		mov [edi], eax
		add esi, 4 ; wyznaczenie adresu kolejnego elementu w tab1
		add edi, 4 ; wyznaczenie adresu kolejnego elementu w tablicy
	loop ptl ; organizacja pętli

	;obliczenie liczby bajtów, włożenie do ebx
	mov ecx, [ebp+16] ; liczba elementów tablicy
	mov eax, ecx
	mov edx, 0
	mov esi, 8
	mul esi
	mov ebx, eax

	mov esi, [ebp+12] ; adres tablicy tab1
	
	mov eax, offset tablica
	add eax, ebx ;koniec tablicy
	mov edi, eax
	ptl2: sub edi, 4 ; wyznaczenie adresu kolejnego elementu w tablicy
		mov eax, [esi]
		mov [edi], eax
		add esi, 4 ; wyznaczenie adresu kolejnego elementu w tab1
	loop ptl2 ; organizacja pętli2

	mov eax, offset tablica

	koniec:
	pop edi ; odtworzenie zawartości rejestrów
	pop esi
	pop ebx
	pop ebp
	ret ; powrót do programu głównego

	zly_rozmiar:
		mov eax, 0
		jmp koniec

_merge_reversed ENDP


_mse_loss PROC
	push ebp ; zapisanie zawartości EBP na stosie
	mov ebp,esp ; kopiowanie zawartości ESP do EBP
	push ebx ; przechowanie zawartości rejestru EBX
	push esi ; przechowanie zawartości rejestru ESI
	push edi ; przechowanie zawartości rejestru EDI

	mov ebx, [ebp+8] ; adres tablicy tab1
	mov esi, [ebp+12] ; adres tablicy tab2
	mov ecx, [ebp+16] ; liczba elementów tablicy

	mov eax, ecx
	mov edx, 0
	mov edi, 2
	div edi ;liczbę elementów dzielę przez 2

	mov eax, edx ;reszta do eax
	mov edx, 0 
	mul edi 
	mov pol_n, eax
	mov edi, 0 ;suma
	;dec ecx
	; wpisanie kolejnego elementu tablicy 1 do rejestru EAX
	ptl: mov eax, [ebx]
		mov edx, 0
		;mul word ptr [esi]
		sub eax, [esi] ;odejmowanie y2
		mul eax ;kwadrat
		add edi, eax
		add ebx, 4 ; wyznaczenie adresu kolejnego elementu
		add esi, 4 ; wyznaczenie adresu kolejnego elementu
	loop ptl ; organizacja pętli

	mov eax, edi ;suma kwadratów do eax w celu podzielenia
	mov edx, 0
	div dword ptr [ebp+16] ;dzielenie przez sumę
	; 
	mov esi, eax ;calosc z dziel przez n
	mov edi, edx ;reszta z dziel przez n

	mov eax, [ebp+16]
	mov edx, 0
	mov ecx, 2
	div ecx
	cmp eax, edi
	jbe w_gore


	koniec:
	mov eax, esi
	pop edi ; odtworzenie zawartości rejestrów
	pop esi
	pop ebx
	pop ebp
	ret ; powrót do programu głównego

	w_gore:
		inc esi
		jmp koniec
_mse_loss ENDP


_dot_product PROC
	push ebp ; zapisanie zawartości EBP na stosie
	mov ebp,esp ; kopiowanie zawartości ESP do EBP
	push ebx ; przechowanie zawartości rejestru EBX
	mov ebx, [ebp+8] ; adres tablicy tab1
	mov esi, [ebp+12] ; adres tablicy tab2
	mov ecx, [ebp+16] ; liczba elementów tablicy
	mov edi, 0 ;iloczyn
	dec ecx
	; wpisanie kolejnego elementu tablicy 1 do rejestru EAX
	ptl: mov eax, [ebx]
		mov edx, 0
		mul word ptr [esi]
		add edi, eax
		add ebx, 4 ; wyznaczenie adresu kolejnego elementu
		add esi, 4 ; wyznaczenie adresu kolejnego elementu
	loop ptl ; organizacja pętli
	mov eax, edi ;zwracana wartość w rejesrze eax
	pop ebx ; odtworzenie zawartości rejestrów
	pop ebp
	ret ; powrót do programu głównego
_dot_product ENDP

_replace_below_zero PROC
	push ebp ; zapisanie zawartości EBP na stosie
	mov ebp,esp ; kopiowanie zawartości ESP do EBP
	push ebx ; przechowanie zawartości rejestru EBX
	mov esi, [ebp+8] ; adres tablicy tab
	mov ecx, [ebp+12] ; liczba elementów tablicy
	mov edi, [ebp+16] ; liczba na którą będzie zamieniane

	;dec ecx
	; wpisanie kolejnego elementu tablicy do rejestru EAX
	ptl: mov eax, [esi]
		cmp eax, 0
		jge nie_zamieniaj
		mov [esi], edi
		nie_zamieniaj:
		add esi, 4 ; wyznaczenie adresu kolejnego elementu
	loop ptl ; organizacja pętli
	mov eax, esi ;adres tablicy
	pop ebx ; odtworzenie zawartości rejestrów
	pop ebp
	ret ; powrót do programu głównego
_replace_below_zero ENDP
END