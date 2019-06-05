%macro write 2 
	  mov   ecx, %1
      mov   edx, %2
      mov   eax, 4
      mov   ebx, 1    
      int   80h
 %endmacro

section .data
global x
space: db '  '
x:
db 0xAB
db 0x14
db 0x5C
c: db 0x2
countA:  dw 03h

section .bss
y resb 1
z resb 3
section .text

global _start

_start:
lea esi,[x]
mov edi,[countA]
call print

lea esi,[x]
lea edi,[z]
mov ecx, 03h
l:
mov eax, [esi]
mov [edi], eax
inc edi
inc esi
dec ecx
jnz l


lea esi,[z]
mov edi,03h
call print

mov eax, 1
mov ebx, 0
int 80h




print:
temp:
mov bl, [esi]  ; take value from array

rol bl, 04  ; to get higher nibble
l1:
mov al, bl
AND al, 0x0F  ; to make upper 4 bits zero
add al, 30h
cmp al, 39h
jbe next
add al, 07h

next:
mov byte[y], al  ; to print
write y, 1
mov bl, byte[esi]   
dec byte[c]      ; run the loop twice
mov al, byte[c]
jnz l1

write space, 1
mov byte[c], 02
inc esi
dec edi
jnz temp
ret


