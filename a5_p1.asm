
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
fname db 'abc.txt',0
global sc,lc,cc,wc
sc db 0
cc db 0
lc db 0
wc db 0

msg : db 0Ah
	  db "1.space count ", 0x0A
      db "2.line count ", 0x0A
      db "3.char count",0x0A
      db "4.word count",0x0A
      db "5.exit",0x0A
      db "Enter your Choice : "
len: equ $-msg 
msg1: db "count: "
len1: equ $-msg1
msg2: db "character: "
len2: equ $-msg2
msg3: db "word: "
len3: equ $-msg3
msg4: db "length of word: "
len4: equ $-msg4


section .bss
global buffer,lenbuf,word1
fd resb 8
buffer resb 100
lenbuf resb 2
choice resb 2
character resb 2
word1 resb 10
wordlen resb 1
section .text
extern print,space,line,char,word,asst
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
      mov   rdx, lenbuf
      syscall
      
      
menu:

write msg,len
read choice,2


cmp byte[choice],31h
je case1

cmp byte[choice],32h
je case2

cmp byte[choice],33h
je case3

cmp byte[choice],34h
je case4

mov rax,1
int 80h    


case1:
call space
write msg1,len1
mov edi,sc
call print
jmp menu

case2:
call line
write msg1,len1
mov edi,lc
call print
jmp menu

case3:
write msg2,len2
read character, 2
mov bl,byte[character]
call char
write msg1,len1
mov edi,cc
call print
jmp menu

case4:
write msg4,len4
read wordlen, 2
write msg3,len3
read word1, wordlen

lea rdi,[word1]
mov rcx,[wordlen]
sub rcx,30h


call asst
write msg1,len1
mov edi,wc
call print
jmp menu



