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
		dziesiec dd 13 ; mnożnik
	.code
	
		wyswietl_EAX_U2_b13 PROC
			pusha ;zmienic
			;sprawdzenie czy dodatnia czy ujemna
			cmp eax, 0
			jl mniejsza_od_zero
			;bt eax, 7
			;jc mniejsza_od_zero
			;jeśli wieksza to znak '+'
			mov byte PTR znaki [1], 2BH
			wieksza_od_zero:  ;większa od zera LUB równa
			mov esi, 10 ; indeks w tablicy 'znaki'
			mov ebx, 13 ; dzielnik równy 10

			konwersja:
			mov edx, 0 ; zerowanie starszej części dzielnej
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
			; wypełnienie pozostałych bajtów spacjami i wpisanie
			; znaków nowego wiersza

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
			; wyświetlenie cyfr na ekranie
			push dword PTR 12 ; liczba wyświetlanych znaków
			push dword PTR OFFSET znaki ; adres wyśw. obszaru
			push dword PTR 1; numer urządzenia (ekran ma numer 1)
			call __write ; wyświetlenie liczby na ekranie
			add esp, 12 ; usunięcie parametrów ze stosu


			popa
			ret
			mniejsza_od_zero:
				mov byte PTR znaki [1], 2DH ; znak '-'
				neg eax
				;add eax, 1 ;overflow?
				jmp wieksza_od_zero
		wyswietl_EAX_U2_b13 ENDP


		wczytaj_EAX_U2_b13 PROC
			; wczytywanie liczby dziesiętnej z klawiatury – po
			; wprowadzeniu cyfr należy nacisnąć klawisz Enter
			; liczba po konwersji na postać binarną zostaje wpisana
			; do rejestru EAX
			; deklaracja tablicy do przechowywania wprowadzanych cyfr
			; (w obszarze danych)
			
			; max ilość znaków wczytywanej liczby
			push dword PTR 12
			push dword PTR OFFSET obszar ; adres obszaru pamięci
			push dword PTR 0; numer urządzenia (0 dla klawiatury)
			call __read ; odczytywanie znaków z klawiatury
			; (dwa znaki podkreślenia przed read)
			add esp, 12 ; usunięcie parametrów ze stosu
			; bieżąca wartość przekształcanej liczby przechowywana jest
			; w rejestrze EAX; przyjmujemy 0 jako wartość początkową
			mov eax, 0
			mov ebx, OFFSET obszar ; adres obszaru ze znakami

			;zamiana z lirerek
			pocz_konw:
				mov dl, [ebx] ; pobranie kolejnego bajtu
				inc esi ; inkrementacja indeksu
				cmp dl, 10 ; sprawdzenie czy naciśnięto Enter
				je gotowe ; skok do końca podprogramu
				cmp dl, 2DH ; sprawdzenie czy naciśnięto -
				je minusik ; skok do końca podprogramu
				cmp dl, 2BH ; sprawdzenie czy naciśnięto +
				je plusik ; skok do końca podprogramu
				; sprawdzenie czy wprowadzony znak jest cyfrą 0, 1, 2 , ..., 9
				cmp dl, '0'
				jb pocz_konw ; inny znak jest ignorowany
				cmp dl, '9'
				ja sprawdzaj_dalej
				sub dl, '0' ; zamiana kodu ASCII na wartość cyfry
			dopisz:
				movzx ecx, dl ; przechowanie wartości cyfry w
				; rejestrze ECX
				; mnożenie wcześniej obliczonej wartości razy 10
				mul dword PTR dziesiec
				add eax, ecx ; dodanie ostatnio odczytanej cyfry
				inc ebx
				jmp pocz_konw ; skok na początek pętli konwersji
			; sprawdzenie czy wprowadzony znak jest cyfrą A, B, ..., F
			sprawdzaj_dalej:
				cmp dl, 'A'
				jb pocz_konw ; inny znak jest ignorowany
				cmp dl, 'C'
				ja sprawdzaj_dalej2
				sub dl, 'A' - 10 ; wyznaczenie kodu binarnego
				jmp dopisz
			; sprawdzenie czy wprowadzony znak jest cyfrą a, b, ..., f
			sprawdzaj_dalej2:
				cmp dl, 'a'
				jb pocz_konw ; inny znak jest ignorowany
				cmp dl, 'c'
				ja pocz_konw ; inny znak jest ignorowany
				sub dl, 'a' - 10
				jmp dopisz
			gotowe:
			;sprawdzenie czy był minus
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
			;call wyswietl_EAX_U2_b13   ; -> w konsoli powinno pojawić się: +b1
			;mov EAX, -144
			;call wyswietl_EAX_U2_b13   ; -> w konsoli powinno pojawić się: -b1

			call wczytaj_EAX_U2_b13    ; wpisujemy 5
			sub eax, 10
			call wyswietl_EAX_U2_b13       ; w konsoli wyświetla się -5

			push 0
			call _ExitProcess@4
		_main ENDP
END