; Crawler
; Compile with: nasm -f elf64 crawler.asm
; Link with: ld -m elf_x86_64 crawler.o -o crawler
; Run with: ./crawler
 
%include    'functions.asm'
 
SECTION .data
; our request string
request db 'GET / HTTP/1.1', 0Dh, 0Ah, 'Host:142.250.217.110:80', 0Dh, 0Ah, 0Dh, 0Ah, 0h
 
SECTION .bss
buffer resb 1,                  ; variable to store response
 
SECTION .text
global  _start
 
_start:
 
    xor     rax, rax            ; initialize some registers
    xor     rdx, rdx
    xor     rdi, rdi
    xor     rsi, rsi
 
_socket:
 
    mov     rdi, 2              ; create socket from lesson 29
    mov     rsi, 1
    mov     rdx, 0
    mov     rax, 41
    syscall

_connect:
 
    mov     rdi, rax            ; move return value rax (file descriptor) of SYS_SOCKET into rdi
    push    dword 0x6ed9fa8e    ; push 142.250.217.110 onto the stack IP ADDRESS (reverse byte order)
    push    word 0x5000         ; push 80 onto stack PORT (reverse byte order)
    push    word 2              ; push 2 dec onto stack AF_INET
 
    mov     rsi,rsp             ; move address of arguments into rsi
    add     rdx, 16             ; push 16 dec onto stack (arguments length)
    mov     rax, 42             ; invoke SYS_CONNECT(kernel opcode 42)
    syscall                     ; call the kernel
 
_write:
 
    mov     rdx, 43             ; move 43 dec into rdx (length in bytes to write)
    mov     rsi, request        ; move address of our request variable into rsi
    mov     rax, 1              ; invoke SYS_WRITE (kernel opcode 1)
    syscall                     ; call the kernel 
                
_read:
    mov     rdx, 1              ; number of bytes to read (we will read 1 byte at a time)
    mov     rsi, buffer         ; move the memory address of our buffer variable into rsi
    mov     rax, 0              ; invoke SYS_READ (kernel opcode 0)
    syscall                     ; call the kernel
 
    cmp     rax, 0              ; if return value of SYS_READ in rax is zero, we have reached the end of the file
    jz      _close              ; jmp to _close if we have reached the end of the file (zero flag set)
 
    mov     rax, buffer         ; move the memory address of our buffer variable into rax for printing
    call    sprint              ; call our string printing function
    jmp     _read               ; jmp to _read 

_close:
    mov     rax, 3              ; invoke SYS_CLOSE (kernel opcode 3)
    syscall                     ; call the kernel

_exit:
 
    call    quit                ; call our quit function