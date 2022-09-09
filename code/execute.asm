; Execute
; Compile with: nasm -f elf64 execute.asm
; Link with: ld -m elf_x86_64 execute.o -o execute
; Run with: ./execute
 
%include        'functions.asm'
 
SECTION .data
command         db      '/home/rbs/nasm/echo', 0h    ; command to execute
arg1            db      'Hello World! cooksdf afdsdf adfsdf adsfds', 0h
arguments       dq      command
                dq      arg1                ; arguments to pass to commandline (in this case just one)
                dq      0h                  ; end the struct
environment     dq      0h                  ; arguments to pass as environment variables (inthis case none) end the struct
 
SECTION .text
global  _start
 
_start:
 
    mov     rdx, environment    ; address of environment variables
    mov     rsi, arguments      ; address of the arguments to pass to the commandline
    mov     rdi, command        ; address of the file to execute
    mov     rax, 59             ; invoke SYS_EXECVE (kernel opcode 59)
    syscall
 
    call    quit                ; call our quit function