.686
.model flat
public _odejmij_jeden
.code
_odejmij_jeden PROC
push ebp ; zapisanie zawarto�ci EBP na stosie
mov ebp,esp ; kopiowanie zawarto�ci ESP do EBP
push ebx ; przechowanie zawarto�ci rejestru EBX
; wpisanie do rejestru EBX adresu zmiennej zdefiniowanej
; w kodzie w j�zyku C
mov ebx, [ebp+8]
mov eax, [ebx] ; odczytanie warto�ci zmiennej
dec dword PTR [eax]
pop ebx
pop ebp
ret
_odejmij_jeden ENDP
END