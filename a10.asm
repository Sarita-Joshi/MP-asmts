
 %macro mprintf 1
     mov rdi,formatpf
     sub rsp,8
     movsd xmm0, [%1]
     mov rax,1
     call printf
     add rsp, 8
 %endmacro
 
 %macro mscanf 1
     mov rdi,formatsf
     mov rax, 0
     sub rsp,8
     mov rsi,rsp
     call scanf
     mov r8, qword[rsp]
     mov qword[%1], r8 
     add rsp,8
%endmacro

section .data
ff1 db "%lf + i %lf", 10, 0
ff2 db "%lf - i %lf", 10, 0
formatpi db "%d", 10, 0
formatpf db "%lf", 10, 0
formatsf db "%lf", 0
four dq 4
two dq 2
ipart1 db "+i",10
ipart2 db "-i",10

section .bss
a resq 1
b resq 1
c resq 1
b2 resq 1
delta resq 1
r1 resq 1
r2 resq 1
fac resq 1
ta resq 1
buffer resb 50
y resb 1


section .text
extern printf
extern scanf
global main
main:

mscanf a
mscanf b
mscanf c

;mprintf a
;mprintf b
;mprintf c

fld qword[b]
fmul qword[b]
fstp qword[b2]

fild qword[four]
fmul qword[a]
fmul qword[c]
fstp qword[fac]

fld qword[b2]
fsub qword[fac]
fstp qword[delta]

fild qword[two]
fmul qword[a]
fstp qword[ta]

btr qword[delta],63
jc imaginary

real:
fld qword[delta]
fsqrt 
fstp qword[delta]

fldz
fsub qword[b]
fadd qword[delta]
fdiv qword[ta]
fstp qword[r1]
mprintf r1

fldz
fsub qword[b]
fsub qword[delta]
fdiv qword[ta]
fstp qword[r2]
mprintf r2

jmp exit

imaginary:
fld qword[delta]
fsqrt 
fstp qword[delta]

fldz
fsub qword[b]
fdiv qword[ta]
fstp qword[r1]

fld qword[delta]
fdiv qword[ta]
fstp qword[r2]

mov rdi,ff1
sub rsp,8
movsd xmm0,[r1]
movsd xmm1,[r2]
mov rax,2
call printf
add rsp,8

mov rdi,ff2
sub rsp,8
movsd xmm0,[r1]
movsd xmm1,[r2]
mov rax,2
call printf
add rsp,8



exit:
mov eax,1
int 80h

