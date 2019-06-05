.model tiny
.286
ORG 0100h

code segment
 ASSUME CS:CODE,DS:CODE,ES:CODE
jmp trans

hr db ?
min db ?
sec db ?

resi:
push ax
push bx
push cx
push dx
push si
push di
push sp 
push bp
push ss
push ds
push es


mov ax,0B800h
mov es,ax
mov di,3650

mov ah,02h
int 1Ah
mov cs:hr, ch
mov cs:min, cl
mov cs:sec, dh

;mov hr,min,sec to reg

mov bl,cs:[hr]
shr bl,04h
and bl, 0fh
add bl,30h
MOV bh,17H
mov es:[di],bx
inc di
inc di

mov bl,cs:[hr]
and bl, 0fh
add bl,30h
MOV bh,17H
mov es:[di],bx
inc di
inc di

mov al,':'
mov ah,97h
mov es:[di],ax

inc di
inc di

mov cl,cs:[min]
shr cl,04h
and cl, 0fh
add cl,30h
MOV ch,17H
mov es:[di],cx
inc di
inc di

mov cl,cs:[min]
and cl, 0fh
add cl,30h
MOV ch,17H
mov es:[di],cx
inc di
inc di

mov al,':'
mov ah,97h
mov es:[di],ax

inc di
inc di

mov cl,cs:[sec]
shr cl,04h
and cl, 0fh
add cl,30h
MOV ch,17H
mov es:[di],cx
inc di
inc di

mov cl,cs:[sec]
and cl, 0fh
add cl,30h
MOV ch,17H
mov es:[di],cx


pop es
pop ds
pop ss
pop bp
pop sp
pop di
pop si
pop dx
pop cx
pop bx 
pop ax

jmp resi

trans:

mov ax,cs
mov ds,ax

cli

mov ah,35h
mov al,08h
int 21h

mov ah,25h
mov al,08h
mov dx,offset resi
int 21h


mov ah,31h
;mov al,00h
mov dx,offset trans
sti
int 21h

code ends

end
