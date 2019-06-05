%macro write 2
	mov rax,4
	mov rbx,1
	mov rcx, %1
	mov rdx, %2
	int 80h
%endmacro

%macro mprintf 1
     mov rdi,formatpf
     sub rsp,8
     movsd xmm0, [%1]
     mov rax,1
     call printf
     add rsp, 8
%endmacro

section .data
x: dq 100.21, 102.42, 104.63
formatpf db "%lf", 10, 0
size1: dq 3

section .bss
mean resq 1
variance resq 1
sd resq 1

section .text
extern printf
global main
main:
finit

;--mean--display--

fldz
mov rsi,00
mov rbx,x
mov rcx,[size1]

label:
fadd qword[rbx + rsi * 8]
inc rsi
loop label

fidiv word[size1]
fst qword[mean]
mprintf mean


;--variance--display--

mov rsi,00
mov rbx,x
mov rcx,[size1]

fldz
label1:
fld qword[rbx + rsi * 8]
fsub qword[mean]
fmul st0
fadd
inc rsi
dec rcx
jnz label1

fidiv word[size1]
fst qword[variance]

mprintf variance

;--std deviation--

fsqrt
fstp qword[sd]
mprintf sd

mov eax,1
int 80h

