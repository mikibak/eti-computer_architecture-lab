.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC

public _main
	.data
		; deklaracja tablicy do przechowywania wprowadzanych cyfr
		; (w obszarze danych)
		obszar db 12 dup (?)
		znaki db 12 dup (?)
		dekoder db '0123456789ABC'
		dziesiec dd 13 ; mno�nik
	.code
	
		wyswietl_EAX_U2_b13 PROC
			pusha ;zmienic
			;sprawdzenie czy dodatnia czy ujemna
			cmp eax, 0
			jl mniejsza_od_zero
			;bt eax, 7
			;jc mniejsza_od_zero
			;je�li wieksza to znak '+'
			mov byte PTR znaki [1], 2BH
			wieksza_od_zero:  ;wi�ksza od zera LUB r�wna
			mov esi, 10 ; indeks w tablicy 'znaki'
			mov ebx, 13 ; dzielnik r�wny 10

			konwersja:
			mov edx, 0 ; zerowanie starszej cz�ci dzielnej
			div ebx ; dzielenie przez 10, reszta w EDX,
			; iloraz w EAX
			;add dl, 30H ; zamiana reszty z dzielenia na kod
			; ASCII
			movzx edi, dl
			mov dl, dekoder[edi]
			mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
			mov ecx, offset znaki
			dec esi ; zmniejszenie indeksu
			cmp eax, 0 ; sprawdzenie czy iloraz = 0
			jne konwersja ; skok, gdy iloraz niezerowy
			; wype�nienie pozosta�ych bajt�w spacjami i wpisanie
			; znak�w nowego wiersza

			wypeln:
			;or esi, esi ; sprawdzenie czy ESI = 0
			cmp esi, 1
			jz wyswietl ; skok, gdy ESI = 1
			mov byte PTR znaki [esi], 20H ; kod spacji
			dec esi ; zmniejszenie indeksu
			jmp wypeln

			wyswietl:
			mov byte PTR znaki [0], 0AH ; kod nowego wiersza
			mov byte PTR znaki [11], 0AH ; kod nowego wiersza
			; wy�wietlenie cyfr na ekranie
			push dword PTR 12 ; liczba wy�wietlanych znak�w
			push dword PTR OFFSET znaki ; adres wy�w. obszaru
			push dword PTR 1; numer urz�dzenia (ekran ma numer 1)
			call __write ; wy�wietlenie liczby na ekranie
			add esp, 12 ; usuni�cie parametr�w ze stosu


			popa
			ret
			mniejsza_od_zero:
				mov byte PTR znaki [1], 2DH ; znak '-'
				neg eax
				;add eax, 1 ;overflow?
				jmp wieksza_od_zero
		wyswietl_EAX_U2_b13 ENDP


		wczytaj_EAX_U2_b13 PROC
			; wczytywanie liczby dziesi�tnej z klawiatury � po
			; wprowadzeniu cyfr nale�y nacisn�� klawisz Enter
			; liczba po konwersji na posta� binarn� zostaje wpisana
			; do rejestru EAX
			; deklaracja tablicy do przechowywania wprowadzanych cyfr
			; (w obszarze danych)
			
			; max ilo�� znak�w wczytywanej liczby
			push dword PTR 12
			push dword PTR OFFSET obszar ; adres obszaru pami�ci
			push dword PTR 0; numer urz�dzenia (0 dla klawiatury)
			call __read ; odczytywanie znak�w z klawiatury
			; (dwa znaki podkre�lenia przed read)
			add esp, 12 ; usuni�cie parametr�w ze stosu
			; bie��ca warto�� przekszta�canej liczby przechowywana jest
			; w rejestrze EAX; przyjmujemy 0 jako warto�� pocz�tkow�
			mov eax, 0
			mov ebx, OFFSET obszar ; adres obszaru ze znakami

			;zamiana z lirerek
			pocz_konw:
				mov dl, [ebx] ; pobranie kolejnego bajtu
				inc esi ; inkrementacja indeksu
				cmp dl, 10 ; sprawdzenie czy naci�ni�to Enter
				je gotowe ; skok do ko�ca podprogramu
				cmp dl, 2DH ; sprawdzenie czy naci�ni�to -
				je minusik ; skok do ko�ca podprogramu
				cmp dl, 2BH ; sprawdzenie czy naci�ni�to +
				je plusik ; skok do ko�ca podprogramu
				; sprawdzenie czy wprowadzony znak jest cyfr� 0, 1, 2 , ..., 9
				cmp dl, '0'
				jb pocz_konw ; inny znak jest ignorowany
				cmp dl, '9'
				ja sprawdzaj_dalej
				sub dl, '0' ; zamiana kodu ASCII na warto�� cyfry
			dopisz:
				movzx ecx, dl ; przechowanie warto�ci cyfry w
				; rejestrze ECX
				; mno�enie wcze�niej obliczonej warto�ci razy 10
				mul dword PTR dziesiec
				add eax, ecx ; dodanie ostatnio odczytanej cyfry
				inc ebx
				jmp pocz_konw ; skok na pocz�tek p�tli konwersji
			; sprawdzenie czy wprowadzony znak jest cyfr� A, B, ..., F
			sprawdzaj_dalej:
				cmp dl, 'A'
				jb pocz_konw ; inny znak jest ignorowany
				cmp dl, 'C'
				ja sprawdzaj_dalej2
				sub dl, 'A' - 10 ; wyznaczenie kodu binarnego
				jmp dopisz
			; sprawdzenie czy wprowadzony znak jest cyfr� a, b, ..., f
			sprawdzaj_dalej2:
				cmp dl, 'a'
				jb pocz_konw ; inny znak jest ignorowany
				cmp dl, 'c'
				ja pocz_konw ; inny znak jest ignorowany
				sub dl, 'a' - 10
				jmp dopisz
			gotowe:
			;sprawdzenie czy by� minus
			cmp edi, 12
			je negacja
			ret
			minusik:
				mov edi, 12
			plusik:
				inc ebx
				jmp pocz_konw
			negacja:
				neg eax
				mov edi, 0
				jmp gotowe
		wczytaj_EAX_U2_b13 ENDP

		_main PROC
			;mov EAX, 144
			;call wyswietl_EAX_U2_b13   ; -> w konsoli powinno pojawi� si�: +b1
			;mov EAX, -144
			;call wyswietl_EAX_U2_b13   ; -> w konsoli powinno pojawi� si�: -b1

			call wczytaj_EAX_U2_b13    ; wpisujemy 5
			sub eax, 10
			call wyswietl_EAX_U2_b13       ; w konsoli wy�wietla si� -5

			push 0
			call _ExitProcess@4
		_main ENDP
END