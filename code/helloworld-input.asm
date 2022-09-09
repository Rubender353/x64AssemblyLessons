; Hello World Program (Getting input)
; Compile with: nasm -f elf64 helloworld-input.asm
; Link with ld -m elf_x86_64 helloworld-input.o -o helloworld-input
; Run with: ./helloworld-input
 
%include        'functions.asm'
 
SECTION .data
msg1        db      'Please enter your name: ', 0h      ; message string asking user for input
msg2        db      'Hello, ', 0h                       ; message string to use after user has entered their name
 
SECTION .bss
sinput:     resb    255                                 ; reserve a 255 byte space in memory for the users input string
 
SECTION .text
global  _start
 
_start:
 
    mov     rax, msg1
    call    sprint
 
    mov     rdx, 255        ; number of bytes to read
    mov     rsi, sinput     ; reserved space to store our input (known as a buffer)
    mov     rdi, 0          ; write to the STDIN file
    mov     rax, 0          ; invoke SYS_READ (kernel opcode 0)
    syscall
 
    mov     rax, msg2
    call    sprint
 
    mov     rax, sinput     ; move our buffer into eax (Note: input contains a linefeed)
    call    sprint          ; call our print function
 
    call    quit


    