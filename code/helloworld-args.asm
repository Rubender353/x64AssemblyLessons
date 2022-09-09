; Hello World Program (Passing arguments from the command line)
; Compile with: nasm -f elf64 helloworld-args.asm
; Link with: ld -m elf_x86_64 helloworld-args.o -o helloworld-args
; Run with: ./helloworld-args
 
%include        'functions.asm'
 
SECTION .text
global  _start
 
_start:
 
    pop     rcx             ; first value on the stack is the number of arguments
    mov     r8,rcx          ; Sinc rcx gets clobbered lets move it into r8
 
nextArg:
    cmp     r8, 0h         ; check to see if we have any arguments left
    jz      noMoreArgs      ; if zero flag is set jump to noMoreArgs label (jumping over the end of the loop)
    pop     rax             ; pop the next argument off the stack
    call    sprintLF        ; call our print with linefeed function
    dec     r8             ; decrease rcx (number of arguments left) by 1
    jmp     nextArg         ; jump to nextArg label
 
noMoreArgs:
    call    quit