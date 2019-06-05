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
rmsg db 'real mode'
rlen equ $ - rmsg
pmsg db 'protected mode'
plen equ $ - pmsg
lmsg db 10,'LDT contents:  '
llen equ $ - lmsg
imsg db 10,'IDT contents:  '
ilen equ $ - imsg
gmsg db 10,'GDT contents:  '
glen equ $ - gmsg

c: db 0x2
countA:  dw 03

section .bss
y resb 1
msw resd 1
gdt resd 1
ldt resd 1
idt resd 1

section .text
global _start
_start:
smsw [msw];
mov ax,word[msw]
bt eax,1
jc p
write rmsg,rlen
p:
write pmsg,plen

sgdt [gdt]
sidt [idt]
sldt [ldt]

write gmsg,glen
lea rsi,[gdt+2h]
mov edi,3h
call print

write imsg,ilen
lea rsi,[idt+2h]
mov edi,3h
call print

write lmsg,llen
lea rsi,[ldt+1h]
mov edi,2h
call print


mov rax,1
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

mov byte[c], 02
inc esi
dec edi
jnz temp

ret



