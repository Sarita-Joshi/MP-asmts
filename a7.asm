%macro write 2 
      mov   ecx, %1
      mov   edx, %2
      mov   eax, 4
      mov   ebx, 1    
      int   80h
 %endmacro
%macro fwrite 2 
      mov   rsi, %1
      mov   rdi, [fd]
      mov   rax, 01
      mov   rdx, %2
      syscall  
 %endmacro

section .data
fname db 'abc.txt',0
msg db 'before sorting:  '
len equ $ - msg
msg1 db 10,'after sorting:  '
len1 equ $ - msg1
c: db 0x2


section .bss
y resb 1
fd resb 8
buffer resb 15
lenbuf resb 2
x: resb 10
arr: resb 5

section .text
global _start
_start:

	  mov   rsi, 02
      mov   rdi, fname
      mov   rax, 02
      mov   rdx,0777    
      syscall
      
      mov [fd],rax      
      
      mov   rsi, buffer
      mov   rdi, [fd]
      mov   rax, 00
      mov   rdx, 100
      syscall      

write msg,len
write buffer,100
call removeSpace

call bsort
write msg1,len1

write x,10
call addSpace
	 
fwrite msg1,len1
fwrite buffer,15			
	

mov rax,1
int 80h

bsort:
xor rdx,rdx
mov dh,4h
mov dl,4h
mov cl,4h
mov rsi,x
loopout:

loopin:
mov al,byte[rsi]
mov bl,byte[rsi+2h]

mov ah,byte[rsi+1h]
mov bh,byte[rsi+3h]
cmp al,bl
jl next1
je equal
jmp b1

equal:
cmp ah,bh
jl next1

b1:
mov [rsi],bl
mov [rsi+1h],bh
mov [rsi+2h],al
mov [rsi+3h],ah

next1:
add rsi,2h
dec dl
jnz loopin

mov rsi,x
dec cl
mov dl,cl
dec dh
jnz loopout

ret

removeSpace:
mov rsi,buffer
mov rdi,x
mov rcx,15
loop:
cmp byte[rsi],0xA
je store
mov al,[rsi]
mov [rdi],al
inc rdi
store:
inc rsi
dec rcx
jnz loop
ret

addSpace:
mov rsi,buffer
mov rdi,x
mov rcx,15
loop123:
cmp byte[rsi],0ax
je store123
mov al,[rdi]
mov [rsi],al
inc rdi
store123:
inc rsi
dec rcx
jnz loop123
ret

