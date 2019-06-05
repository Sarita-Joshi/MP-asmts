%macro write 2 
      mov   ecx, %1
      mov   edx, %2
      mov   eax, 4
      mov   ebx, 1    
      int   80h
 %endmacro
 %macro read 2 
      mov   ecx, %1
      mov   edx, %2
      mov   eax, 3
      mov   ebx, 2    
      int   80h
 %endmacro


section .data
x: dw 0
c: db 0x2
countA:  db 01h
space db " ", 0xA
lens equ $-space
msg : db "1.successive addition ", 0x0A
      db "2.Add and Shift", 0x0A
      db "3.Exit",0x0A
      db "Enter your Choice : "
len: equ $-msg 
msg1: db "enter number: "
len1: equ $-msg1


section .bss
choice resb 1
num1 resw 1
num2 resw 1
res resd 1
y resb 1

section .text

global _start

_start:
menu:
write space, lens
write msg,len
read choice,2


cmp byte[choice],31h
je case1

cmp byte[choice],32h
je case2

cmp byte[choice],33h
je exit

exit:
mov eax, 1
int 80h


case2:

write msg1,len1
read num1,3
mov rsi,num1
call aTh
mov [num1],bx

write msg1,len1
read num2,3
mov rsi,num2
call aTh
mov [num2],bx

xor rbx,rbx
xor rcx,rcx
xor rax,rax

mov  cl,[num1]
mov bl,[num2]
mov edi,8h
mov ax,00h

addShift:
shr cl,1h
jnc skip1
add ax,bx
skip1:
shl bx,01h
dec edi
jnz addShift

mov [res],ax
lea edi,[res+1h]
call print

jmp menu

case1:

write msg1,len1
read num1,3
mov rsi,num1
call aTh
mov [num1],bx

write msg1,len1
read num2,3
mov rsi,num2
call aTh
mov [num2],bx


xor rbx,rbx
mov rcx,0h
mov ecx,[num1]
label:
add ebx,[num2]
dec ecx
jnz label

mov [res],ebx

lea edi,[res+1h]
call print



jmp menu


aTh:

xor rbx,rbx  
xor rcx,rcx
xor rax,rax
xor rdx,rdx
mov rcx,02h
again:
rol bx,04h
mov al,[rsi]
debug:
cmp al,57
jbe p1
sub al,07
p1:
sub al,48
add bx,ax
inc rsi
dec rcx
jnz again
ret

print:
mov dx,2h

tem:
mov bl, [edi]  ; take value from array
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
push dx
write y, 1
pop dx
mov bl, byte[edi]   
dec byte[c]      ; run the loop twice
mov al, byte[c]
jnz l1

mov byte[c], 02
dec edi
dec dx;
jnz tem
ret





