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
	push ebp ; zapisanie zawarto�ci EBP na stosie
	mov ebp,esp ; kopiowanie zawarto�ci ESP do EBP
	push ebx ; przechowanie zawarto�ci rejestru EBX
	push esi ; przechowanie zawarto�ci rejestru ESI
	push edi ; przechowanie zawarto�ci rejestru EDI

	mov esi, [ebp+8] ; adres tablicy tab1
	mov ecx, [ebp+16] ; liczba element�w tablicy
	mov edi, offset tablica ;adres w tablicy z��czonej

	;sprawdzenie czy size < 32
	cmp ecx, 32
	ja zly_rozmiar

	; wpisanie kolejnego elementu tablicy 1 do rejestru EAX
	ptl: mov eax, [esi]
		mov [edi], eax
		add esi, 4 ; wyznaczenie adresu kolejnego elementu w tab1
		add edi, 4 ; wyznaczenie adresu kolejnego elementu w tablicy
	loop ptl ; organizacja p�tli

	;obliczenie liczby bajt�w, w�o�enie do ebx
	mov ecx, [ebp+16] ; liczba element�w tablicy
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
	loop ptl2 ; organizacja p�tli2

	mov eax, offset tablica

	koniec:
	pop edi ; odtworzenie zawarto�ci rejestr�w
	pop esi
	pop ebx
	pop ebp
	ret ; powr�t do programu g��wnego

	zly_rozmiar:
		mov eax, 0
		jmp koniec

_merge_reversed ENDP


_mse_loss PROC
	push ebp ; zapisanie zawarto�ci EBP na stosie
	mov ebp,esp ; kopiowanie zawarto�ci ESP do EBP
	push ebx ; przechowanie zawarto�ci rejestru EBX
	push esi ; przechowanie zawarto�ci rejestru ESI
	push edi ; przechowanie zawarto�ci rejestru EDI

	mov ebx, [ebp+8] ; adres tablicy tab1
	mov esi, [ebp+12] ; adres tablicy tab2
	mov ecx, [ebp+16] ; liczba element�w tablicy

	mov eax, ecx
	mov edx, 0
	mov edi, 2
	div edi ;liczb� element�w dziel� przez 2

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
	loop ptl ; organizacja p�tli

	mov eax, edi ;suma kwadrat�w do eax w celu podzielenia
	mov edx, 0
	div dword ptr [ebp+16] ;dzielenie przez sum�
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
	pop edi ; odtworzenie zawarto�ci rejestr�w
	pop esi
	pop ebx
	pop ebp
	ret ; powr�t do programu g��wnego

	w_gore:
		inc esi
		jmp koniec
_mse_loss ENDP


_dot_product PROC
	push ebp ; zapisanie zawarto�ci EBP na stosie
	mov ebp,esp ; kopiowanie zawarto�ci ESP do EBP
	push ebx ; przechowanie zawarto�ci rejestru EBX
	mov ebx, [ebp+8] ; adres tablicy tab1
	mov esi, [ebp+12] ; adres tablicy tab2
	mov ecx, [ebp+16] ; liczba element�w tablicy
	mov edi, 0 ;iloczyn
	dec ecx
	; wpisanie kolejnego elementu tablicy 1 do rejestru EAX
	ptl: mov eax, [ebx]
		mov edx, 0
		mul word ptr [esi]
		add edi, eax
		add ebx, 4 ; wyznaczenie adresu kolejnego elementu
		add esi, 4 ; wyznaczenie adresu kolejnego elementu
	loop ptl ; organizacja p�tli
	mov eax, edi ;zwracana warto�� w rejesrze eax
	pop ebx ; odtworzenie zawarto�ci rejestr�w
	pop ebp
	ret ; powr�t do programu g��wnego
_dot_product ENDP

_replace_below_zero PROC
	push ebp ; zapisanie zawarto�ci EBP na stosie
	mov ebp,esp ; kopiowanie zawarto�ci ESP do EBP
	push ebx ; przechowanie zawarto�ci rejestru EBX
	mov esi, [ebp+8] ; adres tablicy tab
	mov ecx, [ebp+12] ; liczba element�w tablicy
	mov edi, [ebp+16] ; liczba na kt�r� b�dzie zamieniane

	;dec ecx
	; wpisanie kolejnego elementu tablicy do rejestru EAX
	ptl: mov eax, [esi]
		cmp eax, 0
		jge nie_zamieniaj
		mov [esi], edi
		nie_zamieniaj:
		add esi, 4 ; wyznaczenie adresu kolejnego elementu
	loop ptl ; organizacja p�tli
	mov eax, esi ;adres tablicy
	pop ebx ; odtworzenie zawarto�ci rejestr�w
	pop ebp
	ret ; powr�t do programu g��wnego
_replace_below_zero ENDP
END