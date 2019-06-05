;nasm 2.11.08

%macro write 2
    mov eax,4            ; The system call for write (sys_write)
	mov ebx,1            ; File descriptor 1 - standard output
	mov ecx,%1        ; Put the offset of hello in ecx
	mov edx,%2     
	                    
	int 80h 
%endmacro
section .data
   count db 0h   
   c db 2h
   y db 1
   res db 2
section .text
	global _start    

_start:
    mov rax,6h
    
    label:
    push rax   
    inc byte[count]
    dec rax
    cmp rax,1h
    jne label
    
    mov rax,1h
    xor rcx,rcx
    xor rdx,rdx
    
    label2:
    pop rcx
    mul rcx
    dec byte[count]
    jnz label2
    
    mov [res],rax   

lea esi,[res+1h]
mov edi , 2h
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

mov byte[c],2h
dec rsi
dec rdi
jnz temp
   

	mov eax,1            ; The system call for exit (sys_exit)
	mov ebx,0            ; Exit with return code of 0 (no error)
	int 80h;