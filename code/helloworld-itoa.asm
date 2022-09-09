; Hello World Program (Count to 10 itoa)
; Compile with: nasm -f elf64 helloworld-itoa.asm
; Link with: ld -m elf_x86_64 helloworld-itoa.o -o helloworld-itoa
; Run with: ./helloworld-itoa

%include        'functions.asm'
 
SECTION .text
global  _start
 
_start:
 
    mov     r8, 0
 
nextNumber:
    inc     r8
    mov     rax, r8
    call    iprintLF        ; NOTE call our new integer printing function (itoa)
    cmp     r8, 10
    jne     nextNumber
 
    call    quit