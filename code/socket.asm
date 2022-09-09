; Socket
; Compile with: nasm -f elf64 socket.asm
; Link with: ld -m elf_x86_64 socket.o -o socket
; Run with: ./socket
 
%include    'functions.asm'

SECTION .data
; our response string
response db 'HTTP/1.1 200 OK', 0Dh, 0Ah, 'Content-Type: text/html', 0Dh, 0Ah, 'Content-Length: 14', 0Dh, 0Ah, 0Dh, 0Ah, 'Hello World!', 0Dh, 0Ah, 0h

SECTION .bss
buffer resb 255,                ; variable to store request headers

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

_bind:
 
    mov     rdi, rax            ; bind socket from lesson 30
    push    dword 0x00000000
    push    word 0x2923
    push    word 2
    mov     r9, rdi             ; store rdi in r9 to save parent file descriptor
    mov     rsi,rsp              ; store rsp in rsi
    add     rdx, 16
    mov     rax, 49
    syscall

_listen:
    mov     rsi, 4              ; listen socket from lesson 31
    mov     rax, 50
    syscall

_accept:
    xor     rsi, rsi            ; clear rsi
    mov     rdi, r9             ; r9 which has parent fd put into rdi. prevents fork loop error
    mov     rdx, rsi            ; accept socket from lesson 32
    mov     rax, 43
    syscall
    ;mov     rdi, rax            ; move client fd into rdi

_fork:
 
    mov     rdi, rax            ; move return value of SYS_SOCKET into rdi (file descriptor for accepted socket, or -1 on error)
    mov     rax, 57             ; invoke SYS_FORK (kernel opcode 57)
    syscall                     ; call the kernel
 
    cmp     rax, 0              ; if return value of SYS_FORK in rax is zero we are in the child process
    jz      _read               ; jmp in child process to _read
 
    jmp     _accept          ; jmp in parent process to _accept
 
_read:
    ;mov     rdi, rax
    mov     rdx, 255            ; number of bytes to read (we will only read the first 255 bytes for simplicity)
    mov     rsi, buffer         ; move the memory address of our buffer variable into rsi
    mov     rax, 0              ; invoke SYS_READ (kernel opcode 0)
    syscall                     ; call the kernel
 
    mov     rax, buffer         ; move the memory address of our buffer variable into rax for printing
    call    sprintLF            ; call our string printing function

_write:
 
    mov     rdx, 78             ; move 78 dec into edx (length in bytes to write)
    mov     rsi, response       ; move address of our response variable into ecx
    ;mov     rdi, esi            ; move file descriptor into ebx (accepted socket id)
    mov     rax, 1              ; invoke SYS_WRITE (kernel opcode 1)
    syscall                 ; call the kernel

_close:
 
    ;mov     rdi, esi            ; move esi into ebx (accepted socket file descriptor)
    mov     rax, 3              ; invoke SYS_CLOSE (kernel opcode 3)
    syscall                 ; call the kernel

_exit:
 
    call    quit                ; call our quit function