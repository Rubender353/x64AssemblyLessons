; Create
; Compile with: nasm -f elf64 create.asm
; Link with: ld -m elf_x86_64 create.o -o create
; Run with: ./create
 
%include    'functions.asm'
 
SECTION .data
filename db 'readme.txt', 0h    ; the filename to create
 
SECTION .text
global  _start
 
_start:
 
    mov     rsi, 0777o          ; set all permissions to read, write, execute
    mov     rdi, filename       ; filename we will create
    mov     rax, 85              ; invoke SYS_CREAT (kernel opcode 85)
    syscall                     ; call the kernel
 
    call    quit                ; call our quit function