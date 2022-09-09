; Calculator (Addition)
; Compile with: nasm -f elf64 calculator-addition.asm
; Link with: ld -m elf_x86_64 calculator-addition.o -o calculator-addition
; Run with: ./calculator-addition
 
%include        'functions.asm'
 
SECTION .text
global  _start
 
_start:
 
    mov     rax, 90     ; move our first number into rax
    mov     ebx, 9      ; move our second number into ebx
    add     rax, ebx    ; add ebx to rax
    call    iprintLF    ; call our integer print with linefeed function
 
    call    quit