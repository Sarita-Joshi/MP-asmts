
%macro write 2 
	  mov   ecx, %1
      mov   edx, %2
      mov   eax, 4
      mov   ebx, 1    
      int   80h
 %endmacro
 

section .text
global _start

_start:


write msg, len
lea esi,[x]
mov edi,5h
call printArray

lea esi, [x+4h]
lea edi, [x+6h]
mov ecx, 5

l:
mov eax, [esi]
mov [edi], eax
dec esi
dec edi
dec ecx
jnz l

write msg2, len2

lea esi,[x]
mov edi,7h
call printArray

mov eax, 1
mov ebx, 0
int 80h

printArray:
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




section .bss
y: resb 1


section .data
global x
msg: db 'display array:  ' 
space db '  '
len equ $- msg
msg2 db 0xA, 'after overlap:  '
len2 equ $-msg2
c: db 02
countA:  db 5
x:
db 0xAB
db 0x3C
db 0x14
db 0x0F
db 0x21
n: db 0



