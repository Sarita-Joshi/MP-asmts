
%macro write 2 
      mov   ecx, %1
      mov   edx, %2
      mov   eax, 4
      mov   ebx, 1    
      int   80h
 %endmacro
 
section .data

extern sc,lc,cc,wc
x db 0
c: db 0x2
temp db 0
countA:  db 01h


section .bss
extern buffer,lenbuf,word1
y resb 1

section .text
global print,space,line,char,asst


space:
mov al,0h
mov byte[sc],al
mov rsi,buffer
mov rdi, 100

up:
mov al,byte[rsi]
cmp al,20h
jne next3

inc byte[sc]

next3:
inc rsi
dec rdi
jnz up
debug:

ret

line:
mov al,0h
mov byte[lc],al
mov rsi,buffer
mov rdi, 100

up1:
mov al,byte[rsi]
cmp al,0Ah
jne next31

inc byte[lc]

next31:
inc rsi
dec rdi
jnz up1

ret

char:
mov al,0h
mov byte[cc],al
mov rsi,buffer
mov rdi, 100

up2:
mov al,byte[rsi]
cmp al,bl
jne next32

inc byte[cc]

next32:
inc rsi
dec rdi
jnz up2

ret

asst:
mov al,0h
mov byte[wc],al
mov rsi,buffer
mov rdx, 100
				;rdi holds word and rcx hold len of word
up3:
mov al,byte[rsi]
mov bl,byte[rdi]

cmp al, bl
jne notEqu

inc rdi
inc byte[temp]
cmp cl, [temp]

je found
jmp n3

found:
inc byte[wc]

notEqu:
mov rdi,word1
next323:
mov ch,0h
mov byte[temp], ch
n3:
inc rsi
dec rdx
jnz up3

ret

print:
mov dx,1h

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






