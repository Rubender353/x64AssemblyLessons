; Seek
; Compile with: nasm -f elf64 seek.asm
; Link with: ld -m elf_x86_64 seek.o -o seek
; Run with: ./seek
 
%include    'functions.asm'
 
SECTION .data
filename db 'readme.txt', 0h    ; the filename to create
contents  db '-updated-', 0h     ; the contents to write at the start of the file
 
SECTION .text
global  _start
 
_start:
 
    mov     rsi, 1              ; flag for writeonly access mode (O_WRONLY)
    mov     rdi, filename       ; filename of the file to open
    mov     rax, 2              ; invoke SYS_OPEN (kernel opcode 2)
    syscall                     ; call the kernel
 
    mov     rdx, 2              ; whence argument (SEEK_END)
    mov     rsi, 0              ; move the cursor 0 bytes
    mov     rdi, rax            ; move the opened file descriptor into rdi
    mov     rax, 8             ; invoke SYS_LSEEK (kernel opcode 8)
    syscall                     ; call the kernel
 
    mov     rdx, 9              ; number of bytes to write - one for each letter of our contents string
    mov     rsi, contents       ; move the memory address of our contents string into rsi
    mov     rdi, rdi            ; move the opened file descriptor into rdi (not required as rdi already has the FD)
    mov     rax, 1              ; invoke SYS_WRITE (kernel opcode 1)
    syscall                     ; call the kernel
 
    call    quit                ; call our quit function