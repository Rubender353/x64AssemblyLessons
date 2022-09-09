; Read
; Compile with: nasm -f elf64 read.asm
; Link with: ld -m elf_x86_64 read.o -o read
; Run with: ./read
 
%include    'functions.asm'
 
SECTION .data
filename db 'readme.txt', 0h    ; the filename to create
contents db 'Hello world!', 0h  ; the contents to write

SECTION .bss
fileContents resb 255,          ; variable to store file contents

SECTION .text
global  _start
 
_start:
 
    mov     rsi, 0777o          ; Create file from lesson 22
    mov     rdi, filename
    mov     rax, 85
    syscall
 
    mov     rdx, 12             ; Write contents to file from lesson 23
    mov     rsi, contents
    mov     rdi, rax
    mov     rax, 1
    syscall
 
    mov     rsi, 0              ; Open file from lesson 24
    mov     rdi, filename
    mov     rax, 2
    syscall
 
    mov     rdx, 12             ; number of bytes to read - one for each letter of the file contents
    mov     rsi, fileContents   ; move the memory address of our file contents variable into rsi
    mov     rdi, rax            ; move the opened file descriptor into rdi
    mov     rax, 0              ; invoke SYS_READ (kernel opcode 0)
    syscall                     ; call the kernel
 
    mov     rax, fileContents   ; move the memory address of our file contents variable into rax for printing
    call    sprintLF            ; call our string printing function
 
    call    quit                ; call our quit function