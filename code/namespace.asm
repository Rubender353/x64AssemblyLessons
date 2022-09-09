; Namespace
; Compile with: nasm -f elf64 namespace.asm
; Link with: ld -m elf_x86_64 namespace.o -o namespace
; Run with: ./namespace
 
%include        'functions.asm'
 
SECTION .data
msg1        db      'Jumping to finished label.', 0h        ; a message string
msg2        db      'Inside subroutine number: ', 0h        ; a message string
msg3        db      'Inside subroutine "finished".', 0h     ; a message string
 
SECTION .text
global  _start
 
_start:
 
subrountineOne:
    mov     rax, msg1       ; move the address of msg1 into rax
    call    sprintLF        ; call our string printing with linefeed function
    jmp     .finished       ; jump to the local label under the subrountineOne scope
 
.finished:
    mov     rax, msg2       ; move the address of msg2 into rax
    call    sprint          ; call our string printing function
    mov     rax, 1          ; move the value one into rax (for subroutine number one)
    call    iprintLF        ; call our integer printing function with linefeed function
 
subrountineTwo:
    mov     rax, msg1       ; move the address of msg1 into rax
    call    sprintLF        ; call our string print with linefeed function
    jmp     .finished       ; jump to the local label under the subrountineTwo scope
 
.finished:
    mov     rax, msg2       ; move the address of msg2 into rax
    call    sprint          ; call our string printing function
    mov     rax, 2          ; move the value two into rax (for subroutine number two)
    call    iprintLF        ; call our integer printing function with linefeed function
 
    mov     rax, msg1       ; move the address of msg1 into rax
    call    sprintLF        ; call our string printing with linefeed function
    jmp     finished        ; jump to the global label finished
 
finished:
    mov     rax, msg3       ; move the address of msg3 into rax
    call    sprintLF        ; call our string printing with linefeed function
    call    quit            ; call our quit function