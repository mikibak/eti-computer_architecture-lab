.686
.XMM ; zezwolenie na asemblacjê rozkazów grupy SSE
.model flat

public _random

.data

.code

_random PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	mov esi, [ebp+8] ; previous

	mov eax, 69069
	mul esi
	inc eax
	
	mov ebx, 2147483648
	div ebx
	mov eax, edx

	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_random ENDP

END