; Hello World Program (Calculating string length)
; Compile with: nasm -f elf64 helloworld.asm
; Link with : ld -m elf_x86_64 helloworld.o -o helloworld
; Run with: ./helloworld-len

SECTION .data
msg     db      'Hello, brave new world!', 0Ah ; we can modify this now without having to update anywhere else in the program
 
SECTION .text
global  _start
 
_start:
 
    mov     rdi, msg        ; move the address of our message string into EBX
    mov     rax, rdi        ; move the address in EBX into EAX as well (Both now point to the same segment in memory)
 
nextchar:
    cmp     byte [rax], 0   ; compare the byte pointed to by EAX at this address against zero (Zero is an end of string delimiter)
    jz      finished        ; jump (if the zero flagged has been set) to the point in the code labeled 'finished'
    inc     rax             ; increment the address in EAX by one byte (if the zero flagged has NOT been set)
    jmp     nextchar        ; jump to the point in the code labeled 'nextchar'
 
finished:
    sub     rax, rdi        ; subtract the address in EBX from the address in EAX
                            ; remember both registers started pointing to the same address (see line 15)
                            ; but EAX has been incremented one byte for each character in the message string
                            ; when you subtract one memory address from another of the same type
                            ; the result is number of segments between them - in this case the number of bytes
 
    mov     rdx, rax        ; EAX now equals the number of bytes in our string
    mov     rsi, msg        ; the rest of the code should be familiar now
    mov     rdi, 1
    mov     rax, 1
    syscall
 
    mov     rdi, 0
    mov     rax, 60
    syscall