;nasm 2.11.08
%macro write 2 
	mov eax,4            
	mov ebx,1            
	mov ecx,%1      	 
	mov edx,%2     		 
	int 80h      
%endmacro


section .data
    msg:     db 'positive numbers  ' 
    len:  equ $-msg           
	msg2:     db 10,'negative numbers  '  
    len2:  equ $-msg2
    x: db 5h, 23h, 10, 0Ah, 84h, 4Ch, 99h, 81h, 88h,0Ah
    cp: db 00h
    cn: db 00h
section .text
	global _start

_start:

    lea esi, [x]
    mov di, 0Ah
    mov bl, 00h
    mov cl, 00h
	
    l:
    mov al, byte[esi]
    shl al, 01
    jnc pos
	
    neg:
    inc cl
    inc si
    dec di
    jnz l
    jmp display
	
    pos:
    inc bl
    inc esi
    dec edi
    jnz l
    
   
    display:
    add bl, '0'
    add cl, '0'
    mov byte[cp], bl
    mov byte[cn], cl
    
    write msg, len
    write cp,1
    write msg2, len2
    write cn,1
    

	mov eax,1          
	mov ebx,0            
	int 80h;