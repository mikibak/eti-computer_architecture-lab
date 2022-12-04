.686
.model flat
public _dot_product
public _replace_below_zero
.code
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