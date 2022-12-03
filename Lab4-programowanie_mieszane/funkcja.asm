.686
.model flat
public _odejmij_jeden
.code
_odejmij_jeden PROC
push ebp ; zapisanie zawartoœci EBP na stosie
mov ebp,esp ; kopiowanie zawartoœci ESP do EBP
push ebx ; przechowanie zawartoœci rejestru EBX
; wpisanie do rejestru EBX adresu zmiennej zdefiniowanej
; w kodzie w jêzyku C
mov ebx, [ebp+8]
mov eax, [ebx] ; odczytanie wartoœci zmiennej
dec dword PTR [eax]
pop ebx
pop ebp
ret
_odejmij_jeden ENDP
END