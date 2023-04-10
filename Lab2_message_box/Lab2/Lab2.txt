; wczytywanie i wyświetlanie tekstu wielkimi literami
; (inne znaki się nie zmieniają)
.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC
extern _MessageBoxW@16 : PROC
extern __write : PROC ; (dwa znaki podkreślenia)
extern __read : PROC ; (dwa znaki podkreślenia)


public _main

.data
	tekst_pocz db 10, 'Prosz', 0A9H, ' napisa', 86H, ' jaki', 98H, ' tekst '
	db 'i nacisn', 0A5H, 86H, ' Enter', 10
	koniec_t db ?
	magazyn db 80 dup (?)
	magazyn_UTF_16 db 160 dup (?)
	nowa_linia db 10
	liczba_znakow dd ?
	utf16 dw ?
	liczba db 0
	;dh liczba_polskich

.code
_main PROC
	; wyświetlenie tekstu informacyjnego
	; liczba znaków tekstu
	mov ecx, OFFSET tekst_pocz
	mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
	push ecx
	push OFFSET tekst_pocz ; adres tekstu
	push 1 ; nr urządzenia (tu: ekran - nr 1)
	call __write ; wyświetlenie tekstu początkowego
	add esp, 12 ; usuniecie parametrów ze stosu
	; czytanie wiersza z klawiatury
	push 80 ; maksymalna liczba znaków
	push OFFSET magazyn
	push 0 ; nr urządzenia (tu: klawiatura - nr 0)
	call __read ; czytanie znaków z klawiatury
	add esp, 12 ; usuniecie parametrów ze stosu
	; kody ASCII napisanego tekstu zostały wprowadzone
	; do obszaru 'magazyn'
	; funkcja read wpisuje do rejestru EAX liczbę
	; wprowadzonych znaków
	mov liczba_znakow, eax
	; rejestr ECX pełni rolę licznika obiegów pętli
	mov ecx, eax
	mov ebx, 0 ; indeks początkowy
	ptl: mov dl, magazyn[ebx] ; pobranie kolejnego znaku

	;szukanie polskich znaków
	cmp dl, 0A4H
	je litera_pl ; skok, gdy 'ą'

	cmp dl, 08FH
	je litera_pl ; skok, gdy 'ć'

	cmp dl, 0A8H
	je litera_pl ; skok, gdy 'ę'

	cmp dl, 09DH
	je litera_pl ; skok, gdy 'ł'

	cmp dl, 0E3H
	je litera_pl ; skok, gdy 'ń'

	cmp dl, 0E0H
	je litera_pl ; skok, gdy 'ó'

	cmp dl, 097H
	je litera_pl ; skok, gdy 'ś'

	cmp dl, 08DH
	je litera_pl ; skok, gdy 'ż'

	cmp dl, 0BDH
	je litera_pl ; skok, gdy 'ź'

	;coś innego niż cyfra lub polska litera
	cmp dl, 30H
	jb dalej
	cmp dl, 39H
	ja dalej

	;cyfra
	sub dl, 30H
	mov liczba, dl

	dalej: inc ebx ; inkrementacja indeksu
	;loop ptl ; sterowanie pętlą
	dec ecx
	jnz ptl

	cmp liczba, dh ;porównanie ostatniej cyfry i liczby polskich znaków
	jb polska_gurom

	jmp liczba_wieksza

	wyswietl: push 0 ; stała MB_OK
	mov edi, OFFSET magazyn_UTF_16
	; adres obszaru zawierającego tytuł	
	push OFFSET magazyn_UTF_16
	; adres obszaru zawierającego tekst
	push OFFSET magazyn_UTF_16
	push 0 ; NULL
	call _MessageBoxW@16


	call _ExitProcess@4 ; zakończenie programu

	litera_pl:
	inc dh
	jmp dalej

	polska_gurom: 
	mov dl, dh
	add dl, 30H
	mov dh, 0
	mov word ptr magazyn_UTF_16, dx
	mov dword ptr [magazyn_UTF_16+2], 0DC14D83DH
	mov [magazyn_UTF_16+6], 0
	jmp wyswietl

	liczba_wieksza:
	mov dword ptr magazyn_UTF_16, 0DC38D83DH
	mov [magazyn_UTF_16+4], 0
	jmp wyswietl

_main ENDP
END