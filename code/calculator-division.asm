; Calculator (Division)
; Compile with: nasm -f elf64 calculator-division.asm
; Link with: ld -m elf_x86_64 calculator-division.o -o calculator-division
; Run with: ./calculator-division
 
%include        'functions.asm'
 
SECTION .data
msg1        db      ' remainder '      ; a message string to correctly output result
 
SECTION .text
global  _start
 
_start:
 
    mov     rax, 90     ; move our first number into rax
    mov     rbx, 9      ; move our second number into rbx
    div     rbx         ; divide rax by rbx
    call    iprint      ; call our integer print function on the quotient
    mov     rax, msg1   ; move our message string into rax
    call    sprint      ; call our string print function
    mov     rax, rdx    ; move our remainder into rax
    call    iprintLF    ; call our integer printing with linefeed function
 
    call    quit