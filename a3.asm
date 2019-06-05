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
x: dd 0
c: db 0x2
countA:  db 01h
space db " ", 0xA
lens equ $-space
msg : db "1.HEX to BCD ", 0x0A
      db "2.BCD to HEX ", 0x0A
      db "3.Exit",0x0A
      db "Enter your Choice : "
len: equ $-msg 
msg1: db "enter number: "
len1: equ $-msg1


section .bss
choice resb 2 
buf resb 1
res resw 1
y resb 1
num resb 1
temp resb 1
temp1 resb 1
temp2 resb 1
temp3 resb 1
temp4 resb 1
section .text

global _start

_start:
menu:

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

read num,5
lea rsi,[num]
call aTh
mov [num],bx
xor rbx,rbx  
xor rcx,rcx
xor rax,rax
xor rdx,rdx
mov byte[choice],bl
lea esi,[num]
l:
mov al,byte[esi]
and al,0Fh
add bl,al
l5:
mov al,byte[esi]
shr al,04h
and al,0Fh
mov cl,0Ah
mul cl
add bx,ax
l2:

mov ax,word[esi]
shr ax,08h
and al,0Fh
mov cl,64h
mul cl
add bx,ax
l3:
mov ax,word[esi]
shr ax,0Ch
and ax,0Fh
mov cx,3E8h
mul cx
add ebx,eax
l4:
write space, lens
mov [res],ebx

lea edi,[res+1h]

call print
jmp menu

case1:
write msg1,len1
read x,5
mov rsi,x
call aTh
mov [x],bx
xor rbx,rbx  
xor rcx,rcx
xor rax,rax
xor rdx,rdx

mov byte[choice],bl
lea esi,[x]
mov edi,1h


mov ax,[esi]
mov cx,0xa

mov dx,0
div cx
add dx,'0'
mov [temp], dx

mov dx,0 
div cx
add dx,'0'
mov [temp1], dx
mov dx,0 
div cx
add dx,'0'
mov [temp2], dx
mov dx,0 
div cx
add dx,'0'
mov [temp3], dx
add ax,'0'
mov [temp4], ax
write space, lens
write temp4,1
write temp3,1
write temp2,1
write temp1,1
write temp,1
jmp menu


aTh:

xor rbx,rbx  
xor rcx,rcx
xor rax,rax
xor rdx,rdx
mov rcx,04h
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

