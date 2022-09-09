; Hello World Program (Count to 10)
; Compile with: nasm -f elf64 helloworld-10.asm
; Link with: ld -m elf_x86_64 helloworld-10.o -o helloworld-10
; Run with: ./helloworld-10
 
%include        'functions.asm'
 
SECTION .text
global  _start
 
_start:
 
    mov     r8, 0          ; r8 is initalised to zero.
 
nextNumber:
    inc     r8             ; increment r8
 
    mov     rax, r8        ; move the address of our integer into rax
    add     rax, 48         ; add 48 to our number to convert from integer to ascii for printing
    push    rax             ; push rax to the stack
    mov     rax, rsp        ; get the address of the character on the stack
    call    sprintLF        ; call our print function
 
    pop     rax             ; clean up the stack so we don't have unneeded bytes taking up space
    cmp     r8, 10         ; have we reached 10 yet? compare our counter with decimal 10
    jne     nextNumber      ; jump if not equal and keep counting
 
    call    quit