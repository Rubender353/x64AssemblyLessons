; Calculator (Multiplication)
; Compile with: nasm -f elf64 calculator-multiplication.asm
; Link with: ld -m elf_x86_64 calculator-multiplication.o -o calculator-multiplication
; Run with: ./calculator-multiplication
 
%include        'functions.asm'
 
SECTION .text
global  _start
 
_start:
 
    mov     rax, 90     ; move our first number into rax
    mov     rbx, 9      ; move our second number into rbx
    mul     rbx         ; multiply rax by rbx
    call    iprintLF    ; call our integer print with linefeed function
 
    call    quit