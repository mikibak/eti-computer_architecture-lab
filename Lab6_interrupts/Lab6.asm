.386
rozkazy SEGMENT use16
ASSUME cs:rozkazy
linia PROC
	; przechowanie rejestrów
	push ax
	push bx
	push cx
	push es
	push dx
	push si

	inc cs:licznik
	cmp cs:licznik, 2
	jb rysuj

	;inaczej trzeba zmienić kolor i zresetować licznik
	mov cs:licznik, 0

	cmp cs:aktualny_kolor, 0 ;czy czarny
	je zmiana_koloru_na_2
		;jak nie czarny to zmiana na czarny
		mov cs:aktualny_kolor, 0
	jmp rysuj

	zmiana_koloru_na_2:
	mov cl, cs:kolor_2
	mov cs:aktualny_kolor, cl

	rysuj:
	mov ax, 0A000H ; adres pamięci ekranu dla trybu 13H
	mov es, ax
	mov bx, 10 ; adres początkowy poziomy (x)
	mov ax, 0
	mov al, cs:aktualny_kolor
	mov cx, 50

	pionowe:
		mov dx, 0
		poziome:
			mov si, bx
			add si, dx
			add si, 320*10 ;pionowe y
			mov es:[si], al ; wpisanie kodu koloru do pamięci ekranu
			add dx, 1
			cmp dx, 50
			je kolejne_pionowe
		jmp poziome
		kolejne_pionowe:
		add bx, 320
	loop pionowe

	; odtworzenie rejestrów
	pop si
	pop dx
	pop es
	pop cx
	pop bx
	pop ax
	; skok do oryginalnego podprogramu obsługi przerwania
	; zegarowego
	jmp dword PTR cs:wektor8
	; zmienne procedury
	aktualny_kolor db 0 ; bieżący numer koloru
	kolor_2 db 14
	licznik dw 0
	wektor8 dd ?
linia ENDP
; INT 10H, funkcja nr 0 ustawia tryb sterownika graficznego
zacznij:
	mov ah, 0
	mov al, 13H ; nr trybu
	int 10H
	mov bx, 0
	mov es, bx ; zerowanie rejestru ES
	mov eax, es:[32] ; odczytanie wektora nr 8
	mov cs:wektor8, eax; zapamiętanie wektora nr 8
	; adres procedury 'linia' w postaci segment:offset
	mov ax, SEG linia
	mov bx, OFFSET linia
	cli ; zablokowanie przerwań
	; zapisanie adresu procedury 'linia' do wektora nr 8
	mov es:[32], bx
	mov es:[32+2], ax
	sti ; odblokowanie przerwań
czekaj:
	mov ah, 1 ; sprawdzenie czy jest jakiś znak
	int 16h ; w buforze klawiatury
jz czekaj
	mov ah, 0
	int 16H
	cmp al, 'r' ; porównanie z kodem litery 'r'
je zmien_kolor
jmp koniec


zmien_kolor:
	cmp cs:kolor_2, 14
	je z_zoltego
	mov cs:kolor_2, 14
jmp czekaj

z_zoltego:
	mov cs:kolor_2, 4
jmp czekaj

koniec:
	mov ah, 0 ; funkcja nr 0 ustawia tryb sterownika
	mov al, 3H ; nr trybu
	int 10H
	; odtworzenie oryginalnej zawartości wektora nr 8
	mov eax, cs:wektor8
	mov es:[32], eax
	; zakończenie wykonywania programu
	mov ax, 4C00H
	int 21H
rozkazy ENDS
stosik SEGMENT stack
db 256 dup (?)
stosik ENDS
END zacznij