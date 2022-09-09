; Fizzbuzz
; Compile with: nasm -f elf64 fizzbuzz.asm
; Link with: ld -m elf_x86_64 fizzbuzz.o -o fizzbuzz
; Run with: ./fizzbuzz
 
%include        'functions.asm'
 
SECTION .data
fizz        db      'Fizz', 0h     ; a message string
buzz        db      'Buzz', 0h     ; a message string
 
SECTION .text
global  _start
 
_start:
 
    mov     rsi, 0          ; initialise our checkFizz boolean variable
    mov     rdi, 0          ; initialise our checkBuzz boolean variable
    mov     r8, 0          ; initialise our counter variable
 
nextNumber:
    inc     r8             ; increment our counter variable
 
.checkFizz:
    mov     rdx, 0          ; clear the rdx register - this will hold our remainder after division
    mov     rax, r8        ; move the value of our counter into rax for division
    mov     rbx, 3          ; move our number to divide by into rbx (in this case the value is 3)
    div     rbx             ; divide rax by rbx
    mov     rdi, rdx        ; move our remainder into rdi (our checkFizz boolean variable)
    cmp     rdi, 0          ; compare if the remainder is zero (meaning the counter divides by 3)
    jne     .checkBuzz      ; if the remainder is not equal to zero jump to local label checkBuzz
    mov     rax, fizz       ; else move the address of our fizz string into rax for printing
    call    sprint          ; call our string printing function
 
.checkBuzz:
    mov     rdx, 0          ; clear the rdx register - this will hold our remainder after division
    mov     rax, r8        ; move the value of our counter into rax for division
    mov     rbx, 5          ; move our number to divide by into rbx (in this case the value is 5)
    div     rbx             ; divide rax by rbx
    mov     rsi, rdx        ; move our remainder into rdi (our checkBuzz boolean variable)
    cmp     rsi, 0          ; compare if the remainder is zero (meaning the counter divides by 5)
    jne     .checkInt       ; if the remainder is not equal to zero jump to local label checkInt
    mov     rax, buzz       ; else move the address of our buzz string into rax for printing
    call    sprint          ; call our string printing function
 
.checkInt:
    cmp     rdi, 0          ; rdi contains the remainder after the division in checkFizz
    je     .continue        ; if equal (counter divides by 3) skip printing the integer
    cmp     rsi, 0          ; rsi contains the remainder after the division in checkBuzz
    je     .continue        ; if equal (counter divides by 5) skip printing the integer
    mov     rax, r8        ; else move the value in r8 (our counter) into rax for printing
    call    iprint          ; call our integer printing function
 
.continue:
    mov     rax, 0Ah        ; move an ascii linefeed character into rax
    push    rax             ; push the address of rax onto the stack for printing
    mov     rax, rsp        ; get the stack pointer (address on the stack of our linefeed char)
    call    sprint          ; call our string printing function to print a line feed
    pop     rax             ; pop the stack so we don't waste resources
    cmp     r8, 100        ; compare if our counter is equal to 100
    jne     nextNumber      ; if not equal jump to the start of the loop
 
    call    quit            ; else call our quit function