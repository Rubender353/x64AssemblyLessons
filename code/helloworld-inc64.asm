; Hello World Program (External file include)
; Compile with: nasm -f elf64 helloworld-inc64.asm
; Link with: ld -m elf_x86_64 helloworld-inc64.o -o helloworld-inc64
; Run with: ./helloworld-inc64
 
%include        'functions.asm'
 
SECTION .data
msg1    db      'Hello, brave new world!', 0h              ; NOTE we have removed the line feed character 0Ah
msg2    db      'This is how we recycle in NASM.', 0h      ; NOTE we have removed the line feed character 0Ah
 
SECTION .text
global  _start
 
_start:
 
    mov     rax, msg1
    call    sprintLF         ; NOTE we are calling our new print with linefeed function
 
    mov     rax, msg2
    call    sprintLF         ; NOTE we are calling our new print with linefeed function
 
    call    quit