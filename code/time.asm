; Time
; Compile with: nasm -f elf64 time.asm
; Link with: ld -m elf_x86_64 time.o -o time
; Run with: ./time
 
%include        'functions.asm'
 
SECTION .data
msg        db      'Seconds since Jan 01 1970: ', 0h     ; a message string
 
SECTION .text
global  _start
 
_start:
 
    mov     rax, msg        ; move our message string into rax for printing
    call    sprint          ; call our string printing function
 
    mov     rax, 200        ; invoke SYS_TIME (kernel opcode 200)
    syscall                 ; call the kernel
 
    call    iprintLF        ; call our integer printing function with linefeed
    call    quit            ; call our quit function