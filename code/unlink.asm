; Unlink
; Compile with: nasm -f elf64 unlink.asm
; Link with: ld -m elf_x86_64 unlink.o -o unlink
; Run with: ./unlink
 
%include    'functions.asm'
 
SECTION .data
filename db 'readme.txt', 0h    ; the filename to delete
 
SECTION .text
global  _start
 
_start:
 
    mov     rdi, filename       ; filename we will delete
    mov     rax, 87             ; invoke SYS_UNLINK (kernel opcode 87)
    syscall                     ; call the kernel
 
    call    quit                ; call our quit function