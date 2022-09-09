; Write
; Compile with: nasm -f elf64  write.asm
; Link with: ld -m elf_x86_64 write.o -o write
; Run with: ./write
 
%include    'functions.asm'
 
SECTION .data
filename db 'readme.txt', 0h    ; the filename to create
contents db 'Hello world!', 0h  ; the contents to write
 
SECTION .text
global  _start
 
_start:
 
    mov     rsi, 0777o          ; code continues from lesson 22
    mov     rdi, filename
    mov     rax, 85
    syscall
 
    mov     rdx, 12             ; number of bytes to write - one for each letter of our contents string
    mov     rsi, contents       ; move the memory address of our contents string into rsi
    mov     rdi, rax            ; move the file descriptor of the file we created into rdi
    mov     rax, 1              ; invoke SYS_WRITE (kernel opcode 1)
    syscall                     ; call the kernel
 
    call    quit                ; call our quit function