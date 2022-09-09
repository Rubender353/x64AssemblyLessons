; Calculator (ATOI)
; Compile with: nasm -f elf64 calculator-atoi.asm
;; Link with: ld -m elf_x86_64 calculator-atoi.o -o calculator-atoi
; Run with: ./calculator-atoi 20 1000 317
 
%include        'functions.asm'
 
SECTION .text
global  _start
 
_start:
 
    pop     rcx             ; first value on the stack is the number of arguments
    pop     rdx             ; second value on the stack is the program name (discarded when we initialise rdx)
    sub     rcx, 1          ; decrease rcx by 1 (number of arguments without program name)
    mov     rdx, 0          ; initialise our data register to store additions
 
nextArg:
    cmp     rcx, 0h         ; check to see if we have any arguments left
    jz      noMoreArgs      ; if zero flag is set jump to noMoreArgs label (jumping over the end of the loop)
    pop     rax             ; pop the next argument off the stack
    call    atoi            ; convert our ascii string to decimal integer
    add     rdx, rax        ; perform our addition logic
    dec     rcx             ; decrease rcx (number of arguments left) by 1
    jmp     nextArg         ; jump to nextArg label
 
noMoreArgs:
    mov     rax, rdx        ; move our data result into rax for printing
    call    iprintLF        ; call our integer printing with linefeed function
    call    quit            ; call our quit function