; Hello World Program (Subroutines)
; Compile with: nasm -f elf64 helloworld-len64.asm
; Link with: ld -m elf_x86_64 helloworld-len64.o -o helloworld-len64
; Run with: ./helloworld-len64
 
SECTION .data
msg     db      'Hello, brave new world!', 0Ah
 
SECTION .text
global  _start
 
_start:
 
    mov     rax, msg        ; move the address of our message string into RAX
    call    strlen          ; call our function to calculate the length of the string
 
    mov     rdx, rax        ; our function leaves the result in RAX
    mov     rsi, msg        ; this is all the same as before
    mov     rdi, 1
    mov     rax, 1
    syscall
 
    mov     rdi, 0
    mov     rax, 60
    syscall
 
slen:                     ; this is our first function declaration
    push    rdi             ; push the value in RDI onto the stack to preserve it while we use RDI in this function
    mov     rdi, rax        ; move the address in RAX into RDI (Both point to the same segment in memory)
 
nextchar:                   ; this is the same as lesson3
    cmp     byte [rax], 0
    jz      finished
    inc     rax
    jmp     nextchar
 
finished:
    sub     rax, rdi
    pop     rdi             ; pop the value on the stack back into RAX
    ret                     ; return to where the function was called