; Calculator (Subtraction)
; Compile with: nasm -f elf64 calculator-subtraction.asm
; Link with: ld -m elf_x86_64 calculator-subtraction.o -o calculator-subtraction
; Run with: ./calculator-subtraction
 
%include        'functions.asm'
 
SECTION .text
global  _start
 
_start:
 
    mov     rax, 90     ; move our first number into rax
    mov     rbx, 9      ; move our second number into rbx
    sub     rax, rbx    ; subtract rbx from rax
    call    iprintLF    ; call our integer print with linefeed function
 
    call    quit
    

