; Fork
; Compile with: nasm -f elf64  fork.asm
; Link with: ld -m elf_x86_64 fork.o -o fork
; Run with: ./fork
 
%include        'functions.asm'
 
SECTION .data
childMsg        db      'This is the child process', 0h     ; a message string
parentMsg       db      'This is the parent process', 0h    ; a message string
 
SECTION .text
global  _start
 
_start:
 
    mov     rax, 57              ; invoke SYS_FORK (kernel opcode 57)
    syscall
 
    cmp     rax, 0              ; if rax is zero we are in the child process
    jz      child               ; jump if rax is zero to child label
 
parent:
    mov     rax, parentMsg      ; inside our parent process move parentMsg into rax
    call    sprintLF            ; call our string printing with linefeed function
 
    call    quit                ; quit the parent process
 
child:
    mov     rax, childMsg       ; inside our child process move childMsg into rax
    call    sprintLF            ; call our string printing with linefeed function
 
    call    quit                ; quit the child process