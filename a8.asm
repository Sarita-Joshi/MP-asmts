%macro write 2 
      mov   ecx, %1
      mov   edx, %2
      mov   eax, 4
      mov   ebx, 1    
      int   80h
 %endmacro

section .data
blen db 100
;msg db '0 arguments'
;len equ $ - msg

section .bss
fname resb 16
fd resb 8
fd2 resb 8
buffer resb 15

res resw 1
y resb 1

section .text
global _start

_start:

pop rbx
pop rbx
pop rdi

cmp byte[rdi],'T'
je type
cmp byte[rdi],'C'
je copy
cmp byte[rdi],'D'
je delete
jmp exit

type:
pop rdi
mov rsi,2
mov rax,2
mov rdx,0777
syscall

mov [fd],rax

mov rdi, [fd]
mov rsi,buffer
mov rax,0
mov rdx,100
syscall

write buffer,100

mov rax,3
mov rdi,[fd]
syscall
jmp exit

delete:
mov rax,87
pop rdi
syscall
jmp exit

copy:

pop rdi
mov rsi,2
mov rax,2
mov rdx,0777
syscall
mov [fd],rax

pop rdi
mov rsi,2
mov rax,2
mov rdx,0777
syscall
mov [fd2],rax

mov rdi, [fd]
mov rsi,buffer
mov rax,0
mov rdx,100
syscall

mov [blen],rax

mov rdi, [fd2]
mov rsi,buffer
mov rax,1
mov rdx,[blen]
syscall

mov rax,3
mov rdi,[fd]
syscall

mov rax,3
mov rdi,[fd2]
syscall

jmp exit

exit:
mov eax,1
int 80h
