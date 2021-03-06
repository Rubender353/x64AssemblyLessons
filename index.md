[Lesson 1](#lesson-1) <b>Hello, world!</b>
[Lesson 2](#lesson-2) <b>Proper program exit</b>
[Lesson 3](#lesson-3) <b>Calculate string length</b>
[Lesson 4](#lesson-4) <b>Subroutines</b>
[Lesson 5](#lesson-5) <b>External include files</b>
[Lesson 6](#lesson-6) <b>NULL terminating bytes</b>
[Lesson 7](#lesson-7) <b>Linefeeds</b>

[Lesson 8](#lesson-8) <b>Passing arguments</b>
[Lesson 8-1](#lesson-8-1)<b>Passing arguments 64-bit style</b>
[Lesson 9](#lesson-9) <b>User input</b>
[Lesson 10](#lesson-10) <b>Count to 10</b>
[Lesson 11](#lesson-11) <b>Count to 10 (itoa)</b>
[Lesson 12](#lesson-12) <b>Calculator - addition</b>
[Lesson 13](#lesson-13) <b>Calculator - subtraction</b>
[Lesson 14](#lesson-14) <b>Calculator - multiplication</b>

[Lesson 15](#lesson-15) <b>Calculator - division</b>
[Lesson 16](#lesson-16) <b>Calculator (atoi)</b>
[Lesson 17](#lesson-17) <b>Namespace</b>
[Lesson 18](#lesson-18) <b>Fizz Buzz</b>
[Lesson 19](#lesson-19) <b>Execute Command</b>
[Lesson 20](#lesson-20) <b>Process Forking</b>
[Lesson 21](#lesson-21) <b>Telling the time</b>

[Lesson 22](#lesson-22) <b>File Handling - Create</b>
[Lesson 23](#lesson-23) <b>File Handling - Write</b>
[Lesson 24](#lesson-24) <b>File Handling - Open</b>
[Lesson 25](#lesson-25) <b>File Handling - Read</b>
[Lesson 26](#lesson-26) <b>File Handling - Close</b>
[Lesson 27](#lesson-27) <b>File Handling - Update</b>
[Lesson 28](#lesson-28) <b>File Handling - Delete</b>

[Lesson 29](#lesson-29) <b>Sockets - Create</b>
[Lesson 30](#lesson-30) <b>Sockets - Bind</b>
[Lesson 31](#lesson-31) <b>Sockets - Listen</b>
[Lesson 32](#lesson-32) <b>Sockets - Accept</b>
[Lesson 33](#lesson-33) <b>Sockets - Read</b>
[Lesson 34](#lesson-34) <b>Sockets - Write</b>
[Lesson 35](#lesson-35) <b>Sockets - Close</b>
[Lesson 36](#lesson-36) <b>Download a Webpage</b>

## Lesson 1

Hello, world!

First, some background
Assembly language is bare-bones. The only interface a programmer has above the actual hardware is the kernel itself. In order to build useful programs in assembly we need to use the linux system calls provided by the kernel. These system calls are a library built into the operating system to provide functions such as reading input from a keyboard and writing output to the screen.

When you invoke a system call the kernel will immediately suspend execution of your program. It will then contact the necessary drivers needed to perform the task you requested on the hardware and then return control back to your program.

Note: Drivers are called drivers because the kernel literally uses them to drive the hardware.

We can accomplish this all in assembly by loading RAX (EAX in x86 32-bit) with the function number (operation code OPCODE) we want to execute and filling the remaining registers with the arguments we want to pass to the system call. A software interrupt in 32-bit is requested with the INT instruction and the kernel takes over and calls the function from the library with our arguments. In 64-bit it will use 32 bit registers, so we will need to use syscall interrupt in 64-bit assembly. [Click here to learn more about int 80h and syscall](https://stackoverflow.com/questions/46087730/what-happens-if-you-use-the-32-bit-int-0x80-linux-abi-in-64-bit-code)

For example requesting an interrupt when RAX=60 will call sys_exit and requesting an interrupt when RAX=1 will call sys_write instead. EBX, ECX & EDX is now RBX,RCX, & RDX in 64-bit x64. RBX,RCX, & RDX will be passed as arguments if the function requires them. [Click here to view an example of a 64-bit Linux System Call Table and its corresponding OPCODES.](https://chromium.googlesource.com/chromiumos/docs/+/HEAD/constants/syscalls.md#x86_64-64_bit)

The biggest difference from 32-bit is that after RAX 6 registers get used sequentially as parameters. After that other registers will be put on stack. In 32-bit you could write hello world using RBX register to store stuff in it. In 64-bit we now need to keep in mind the 6 parameters passed by register. Which are RDI,RSI,RDX,RCX,R8, and R9.

Keep in mind I will be using Linux specifically Ubuntu. Depending on your architecture and ABI used these may be called differently. So if using nasm for some other device refer to their documentation, calling tables, and ABI info.

<table>
 <thead>
    <tr>
        <th>Register</th>
        <th>Value</th>
    </tr>
</thead>

<tbody>
    <tr>
        <td>RAX</td>
        <td>System call number</td>
    </tr>
    <tr>
        <td>RDI</td>
        <td>1st argument</td>
    </tr>
    <tr>
        <td>RSI</td>
        <td>2nd argument</td>
    </tr>
    <tr>
        <td>RDX</td>
        <td>3rd argument</td>
    </tr>
    <tr>
        <td>RCX</td>
        <td>4th argument</td>
    </tr>
    <tr>
        <td>R8</td>
        <td>5th argument</td>
    </tr>
    <tr>
        <td>R9</td>
        <td>6th argument</td>
    </tr>
</tbody>
</table>
Writing our program
Firstly we create a variable 'msg' in our .data section and assign it the string we want to output in this case 'Hello, world!'. In our .text section we tell the kernel where to begin execution by providing it with a global label _start: to denote the programs entry point.

We will be using the system call sys_write to output our message to the console window. This function is assigned OPCODE 4 in the x86 Linux System Call Table. In x64 we will user OPCODE 1. The function also takes 3 arguments which are sequentially loaded into RDI, RSI and RDX before requesting a software interrupt which will perform the task.

The arguments passed are as follows:

RDX will be loaded with the length (in bytes) of the string.
RSI will be loaded with the address of our variable created in the .data section.
RDI will be loaded with the file we want to write to ??? in this case STDOUT.
The datatype and meaning of the arguments passed can be found in the function's definition.
We compile, link and run the program using the commands below.

### Hello World Code

```
; Hello World Program - 64-bit
; Compile with: nasm -f elf64 helloworld.asm
; Link with : ld -m elf_x86_64 helloworld.o -o helloworld
; Run with: ./helloworld
 
SECTION .data
msg     db      'Hello World!', 0Ah     ; assign msg variable with your message string
 
SECTION .text
global  _start
 
_start:
 
    mov     rdx, 13     ; number of bytes to write - one for each letter plus 0Ah (line feed character)
    mov     rsi, msg    ; move the memory address of our message string into ecx
    mov     rdi, 1      ; write to the STDOUT file
    mov     rax, 1      ; invoke SYS_WRITE (kernel opcode 1)
    syscall
```
```
~$ nasm -f elf64 helloworld.asm
~$ ld -m elf_x86_64 helloworld.o -o helloworld
~$ ./helloworld
Hello World!
Segmentation fault
```

## Lesson 2
Proper program exit

Some more background

After successfully learning how to execute a system call in Lesson 1 we now need to learn about one of the most important system calls in the kernel, sys_exit.

Notice how after our 'Hello, world!' program ran we got a Segmentation fault? Well, computer programs can be thought of as a long strip of instructions that are loaded into memory and divided up into sections (or segments). This general pool of memory is shared between all programs and can be used to store variables, instructions, other programs or anything really. Each segment is given an address so that information stored in that section can be found later.

To execute a program that is loaded in memory, we use the global label _start: to tell the operating system where in memory our program can be found and executed. Memory is then accessed sequentially following the program logic which determines the next address to be accessed. The kernel jumps to that address in memory and executes it.

It's important to tell the operating system exactly where it should begin execution and where it should stop. In Lesson 1 we didn't tell the kernel where to stop execution. So, after we called sys_write the program continued sequentially executing the next address in memory, which could have been anything. We don't know what the kernel tried to execute but it caused it to choke and terminate the process for us instead - leaving us the error message of 'Segmentation fault'. Calling sys_exit at the end of all our programs will mean the kernel knows exactly when to terminate the process and return memory back to the general pool thus avoiding an error.

Writing our program
sys_exit has a simple function definition. In the Linux System Call Table it is allocated OPCODE 60 and is passed a single argument through RDI.

In order to execute this function all we need to do is:

Load RDI with 0 to pass zero to the function meaning 'zero errors'.
Load RAX with 60 to call sys_exit.
Then request an interrupt on libc using syscall.
We then compile, link and run it again.

Note: Only new code added in each lesson will be commented.

```
; Hello World Program - asmtutor.com
; Compile with: nasm -f elf64 helloworld.asm
; Link with : ld -m elf_x86_64 helloworld.o -o helloworld
; Run with: ./helloworld
 
SECTION .data
msg     db      'Hello World!', 0Ah
 
SECTION .text
global  _start
 
_start:
 
    mov     rdx, 13
    mov     rsi, msg
    mov     rdi, 1
    mov     rax, 1
    syscall
 
    mov     rdi, 0      ; return 0 status on exit - 'No Errors'
    mov     rax, 60      ; invoke SYS_EXIT (kernel opcode 60)
    syscall

```
```
~$ nasm -f elf64 helloworld.asm
~$ ld -m elf_x86_64 helloworld.o -o helloworld
~$ ./helloworld
Hello World!
```
## Lesson 3
Calculate string length

Firstly, some background

Why do we need to calculate the length of a string?

Well sys_write requires that we pass it a pointer to the string we want to output in memory and the length in bytes we want to print out. If we were to modify our message string we would have to update the length in bytes that we pass to sys_write as well, otherwise it will not print correctly.

You can see what I mean using the program in Lesson 2. Modify the message string to say 'Hello, brave new world!' then compile, link and run the new program. The output will be 'Hello, brave ' (the first 13 characters) because we are still only passing 13 bytes to sys_write as its length. It will be particularly necessary when we want to print out user input. As we won't know the length of the data when we compile our program, we will need a way to calculate the length at runtime in order to successfully print it out.

Writing our program

To calculate the length of the string we will use a technique called pointer arithmetic. Two registers are initialised pointing to the same address in memory. One register (in this case RAX) will be incremented forward one byte for each character in the output string until we reach the end of the string. The original pointer will then be subtracted from RAX. This is effectively like subtraction between two arrays and the result yields the number of elements between the two addresses. This result is then passed to sys_write replacing our hard coded count.

The CMP instruction compares the left hand side against the right hand side and sets a number of flags that are used for program flow. The flag we're checking is the ZF or Zero Flag. When the byte that RAX points to is equal to zero the ZF flag is set. We then use the JZ instruction to jump, if the ZF flag is set, to the point in our program labeled 'finished'. This is to break out of the nextchar loop and continue executing the rest of the program.

```
; Hello World Program (Calculating string length)
; Compile with: nasm -f elf64 helloworld-len64.asm
; Link with : ld -m elf_x86_64 helloworld-len64.o -o helloworld-len64
; Run with: ./helloworld-len

SECTION .data
msg     db      'Hello, brave new world!', 0Ah ; we can modify this now without having to update anywhere else in the program
 
SECTION .text
global  _start
 
_start:
 
    mov     rdi, msg        ; move the address of our message string into RDI
    mov     rax, rdi        ; move the address in RDI into RAX as well (Both now point to the same segment in memory)
 
nextchar:
    cmp     byte [rax], 0   ; compare the byte pointed to by RAX at this address against zero (Zero is an end of string delimiter)
    jz      finished        ; jump (if the zero flagged has been set) to the point in the code labeled 'finished'
    inc     rax             ; increment the address in RAX by one byte (if the zero flagged has NOT been set)
    jmp     nextchar        ; jump to the point in the code labeled 'nextchar'
 
finished:
    sub     rax, rdi        ; subtract the address in RDI from the address in RAX
                            ; remember both registers started pointing to the same address (see line 15)
                            ; but RAX has been incremented one byte for each character in the message string
                            ; when you subtract one memory address from another of the same type
                            ; the result is number of segments between them - in this case the number of bytes
 
    mov     rdx, rax        ; RAX now equals the number of bytes in our string
    mov     rsi, msg        ; the rest of the code should be familiar now
    mov     rdi, 1
    mov     rax, 1
    syscall
 
    mov     rdi, 0
    mov     rax, 60
    syscall

```
```
nasm -f elf64 helloworld-len64.asm
ld -m elf_x86_64 helloworld-len64.o -o helloworld-len64
./helloworld-len64
Hello, brave new world!
```
## Lesson 4 
Subroutines

Introduction to subroutines

Subroutines are functions. They are reusable pieces of code that can be called by your program to perform various repeatable tasks. Subroutines are declared using labels just like we've used before (eg. _start:) however we don't use the JMP instruction to get to them - instead we use a new instruction CALL. We also don't use the JMP instruction to return to our program after we have run the function. To return to our program from a subroutine we use the instruction RET instead.
Why don't we JMP to subroutines?

The great thing about writing a subroutine is that we can reuse it. If we want to be able to use the subroutine from anywhere in the code we would have to write some logic to determine where in the code we had jumped from and where we should jump back to. This would litter our code with unwanted labels. If we use CALL and RET however, assembly handles this problem for us using something called the stack.
Introduction to the stack

The stack is a special type of memory. It's the same type of memory that we've used before however it's special in how it is used by our program. The stack is what is call Last In First Out memory (LIFO). You can think of the stack like a stack of plates in your kitchen. The last plate you put on the stack is also the first plate you will take off the stack next time you use a plate.

The stack in assembly is not storing plates though, its storing values. You can store a lot of things on the stack such as variables, addresses or other programs. We need to use the stack when we call subroutines to temporarily store values that will be restored later.

Any register that your function needs to use should have it's current value put on the stack for safe keeping using the PUSH instruction. Then after the function has finished it's logic, these registers can have their original values restored using the POP instruction. This means that any values in the registers will be the same before and after you've called your function. If we take care of this in our subroutine we can call functions without worrying about what changes they're making to our registers.

The CALL and RET instructions also use the stack. When you CALL a subroutine, the address you called it from in your program is pushed onto the stack. This address is then popped off the stack by RET and the program jumps back to that place in your code. This is why you should always JMP to labels but you should CALL functions.

```
; Hello World Program (Subroutines)
; Compile with: nasm -f elf64 helloworld-len64.asm
; Link with: ld -m elf_x86_64 helloworld-len64.o -o helloworld-len64
; Run with: ./helloworld-len64
 
SECTION .data
msg     db      'Hello, brave new world!', 0Ah
 
SECTION .text
global  _start
 
_start:
 
    mov     rax, msg        ; move the address of our message string into RAX
    call    strlen          ; call our function to calculate the length of the string
 
    mov     rdx, rax        ; our function leaves the result in RAX
    mov     rsi, msg        ; this is all the same as before
    mov     rdi, 1
    mov     rax, 1
    syscall
 
    mov     rdi, 0
    mov     rax, 60
    syscall
 
strlen:                     ; this is our first function declaration
    push    rdi             ; push the value in RDI onto the stack to preserve it while we use RDI in this function
    mov     rdi, rax        ; move the address in RAX into RDI (Both point to the same segment in memory)
 
nextchar:                   ; this is the same as lesson3
    cmp     byte [rax], 0
    jz      finished
    inc     rax
    jmp     nextchar
 
finished:
    sub     rax, rdi
    pop     rdi             ; pop the value on the stack back into RAX
    ret                     ; return to where the function was called
```
```
nasm -f elf64 helloworld-len64.asm
ld -m elf_x86_64 helloworld-len64.o -o helloworld-len64
./helloworld-len64
Hello, brave new world!
```
## Lesson 5 
External include files

External include files allow us to move code from our program and put it into separate files. This technique is useful for writing clean, easy to maintain programs. Reusable bits of code can be written as subroutines and stored in separate files called libraries. When you need a piece of logic you can include the file in your program and use it as if they are part of the same file.

In this lesson we will move our string length calculating subroutine into an external file. We fill also make our string printing logic and program exit logic a subroutine and we will move them into this external file. Once it's completed our actual program will be clean and easier to read.

We can then declare another message variable and call our print function twice in order to demonstrate how we can reuse code.

Note: I won't be showing the code in functions.asm after this lesson unless it changes. It will just be included if needed. 

functions.asm
```
;------------------------------------------
; int slen(String message)
; String length calculation function
slen:
    push    rdi
    mov     rdi, rax
 
nextchar:
    cmp     byte [rax], 0
    jz      finished
    inc     rax
    jmp     nextchar
 
finished:
    sub     rax, rdi
    pop     rdi
    ret
 
 
;------------------------------------------
; void sprint(String message)
; String printing function
sprint:
    push    rdx
    push    rsi
    push    rdi
    push    rax
    call    slen
 
    mov     rdx, rax
    pop     rax
 
    mov     rsi, rax
    mov     rdi, 1
    mov     rax, 1
    syscall
 
    pop     rdi
    pop     rsi
    pop     rdx
    ret
 
 
;------------------------------------------
; void exit()
; Exit program and restore resources
quit:
    mov     rdi, 0
    mov     rax, 60
    syscall
    ret
```
helloworld-inc64.asm
```
; Hello World Program (External file include)
; Compile with: nasm -f elf64 helloworld-inc64.asm
; Link with: ld -m elf_x86_64 helloworld-inc64.o -o helloworld-inc64
; Run with: ./helloworld-inc64
 
%include        'functions.asm'                             ; include our external file
 
SECTION .data
msg1    db      'Hello, brave new world!', 0Ah              ; our first message string
msg2    db      'This is how we recycle in NASM.', 0Ah      ; our second message string
 
SECTION .text
global  _start
 
_start:
 
    mov     rax, msg1       ; move the address of our first message string into RAX
    call    sprint          ; call our string printing function
 
    mov     rax, msg2       ; move the address of our second message string into RAX
    call    sprint          ; call our string printing function
 
    call    quit            ; call our quit function
```
```
nasm -f elf64 helloworld-inc64.asm
ld -m elf_x86_64 helloworld-inc64.o -o helloworld-inc64
./helloworld-inc64
Hello, brave new world!
This is how we recycle in NASM.
This is how we recycle in NASM.
Error: Our second message is outputted twice. This is fixed in the next lesson. 
```

## Lesson 6 
NULL terminating bytes
Ok so why did our second message print twice when we only called our sprint function on msg2 once? Well actually it did only print once. You can see what I mean if you comment out our second call to sprint. The output will be both of our message strings.

But how is this possible?

What is happening is we weren't properly terminating our strings. In assembly, variables are stored one after another in memory so the last byte of our msg1 variable is right next to the first byte of our msg2 variable. We know our string length calculation is looking for a zero byte so unless our msg2 variable starts with a zero byte it keeps counting as if it's the same string (and as far as assembly is concerned it is the same string). So we need to put a zero byte or 0h after our strings to let assembly know where to stop counting.

Note: In programming 0h denotes a null byte and a null byte after a string tells assembly where it ends in memory. 

```
; Hello World Program (External file include)
; Compile with: nasm -f elf64 helloworld-inc64.asm
; Link with: ld -m elf_x86_64 helloworld-inc64.o -o helloworld-inc64
; Run with: ./helloworld-inc64
 
%include        'functions.asm'
 
SECTION .data
msg1    db      'Hello, brave new world!', 0Ah, 0h          ; NOTE the null terminating byte
msg2    db      'This is how we recycle in NASM.', 0Ah, 0h  ; NOTE the null terminating byte
 
SECTION .text
global  _start
 
_start:
 
    mov     rax, msg1
    call    sprint
 
    mov     rax, msg2
    call    sprint
 
    call    quit
```
```
~$ nasm -f elf64 helloworld-inc64.asm
~$ ld -m elf_x86_64 helloworld-inc64.o -o helloworld-inc64
~$ ./helloworld-inc64                                     
Hello, brave new world!
This is how we recycle in NASM.
```
## Lesson 7
Linefeeds

Linefeeds are essential to console programs like our 'hello world' program. They become even more important once we start building programs that require user input. But linefeeds can be a pain to maintain. Sometimes you will want to include them in your strings and sometimes you will want to remove them. If we continue to hard code them in our variables by adding 0Ah after our declared message text, it will become a problem. If there's a place in the code that we don't want to print out the linefeed for that variable we will need to write some extra logic remove it from the string at runtime.

It would be better for the maintainability of our program if we write a subroutine that will print out our message and then print a linefeed afterwards. That way we can just call this subroutine when we need the linefeed and call our current sprint subroutine when we don't.

A call to sys_write requires we pass a pointer to an address in memory of the string we want to print so we can't just pass a linefeed character (0Ah) to our print function. We also don't want to create another variable just to hold a linefeed character so we will instead use the stack.

The way it works is by moving a linefeed character into RAX. We then push RAX onto the stack and get the address pointed to by the Extended Stack Pointer. RSP is another register. When you push items onto the stack, RSP is decremented to point to the address in memory of the last item and so it can be used to access that item directly from the stack. Since RSP points to an address in memory of a character, sys_write will be able to use it to print.

functions.asm
```
;------------------------------------------
; int slen(String message)
; String length calculation function
slen:
    push    rdi
    mov     rdi, rax
 
nextchar:
    cmp     byte [rax], 0
    jz      finished
    inc     rax
    jmp     nextchar
 
finished:
    sub     rax, rdi
    pop     rdi
    ret
 
 
;------------------------------------------
; void sprint(String message)
; String printing function
sprint:
    push    rdx
    push    rsi
    push    rdi
    push    rax
    call    slen
 
    mov     rdx, rax
    pop     rax
 
    mov     rsi, rax
    mov     rdi, 1
    mov     rax, 1
    syscall
 
    pop     rdi
    pop     rsi
    pop     rdx
    ret
 
;------------------------------------------
; void sprintLF(String message)
; String printing with line feed function
sprintLF:
    call    sprint
 
    push    rax         ; push eax onto the stack to preserve it while we use the eax register in this function
    mov     rax, 0Ah    ; move 0Ah into eax - 0Ah is the ascii character for a linefeed
    push    rax         ; push the linefeed onto the stack so we can get the address
    mov     rax, rsp    ; move the address of the current stack pointer into eax for sprint
    call    sprint      ; call our sprint function
    pop     rax         ; remove our linefeed character from the stack
    pop     rax         ; restore the original value of eax before our function was called
    ret                 ; return to our program

;------------------------------------------
; void exit()
; Exit program and restore resources
quit:
    mov     rdi, 0
    mov     rax, 60
    syscall
    ret
```
helloworld-inc64.asm
```
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
```
```
nasm -f elf64 helloworld-inc64.asm
ld -m elf_x86_64 helloworld-inc64.o -o helloworld-inc64
./helloworld-inc64
Hello, brave new world!
This is how we recycle in NASM.
```
## Lesson 8
Passing arguments

In x86 we used to be able to use ECX register as our counter for the loop. Although it's a general-purpose register it's original intention was to be used as a counter. Passing arguments to your program from the command line is as easy as popping them off the stack in NASM. When we run our program in x86, any passed arguments are loaded onto the stack in reverse order. The name of the program is then loaded onto the stack and lastly the total number of arguments is loaded onto the stack. The last two stack items for a NASM compiled program are always the name of the program and the number of passed arguments.

So in x86 all we have to do to use them is pop the number of arguments off the stack first, then iterate once for each argument and perform our logic. In our program that means calling our print function.

helloworld-args.asm
```
; Hello World Program (Passing arguments from the command line)
; Compile with: nasm -f elf64 helloworld-args.asm
; Link with: ld -m elf_x86_64 helloworld-args.o -o helloworld-args
; Run with: ./helloworld-args
 
%include        'functions.asm'
 
SECTION .text
global  _start
 
_start:
 
    pop     rcx             ; first value on the stack is the number of arguments
 
nextArg:
    cmp     rcx, 0h         ; check to see if we have any arguments left
    jz      noMoreArgs      ; if zero flag is set jump to noMoreArgs label (jumping over the end of the loop)
    pop     rax             ; pop the next argument off the stack
    call    sprintLF        ; call our print with linefeed function
    dec     rcx             ; decrease rcx (number of arguments left) by 1
    jmp     nextArg         ; jump to nextArg label
 
noMoreArgs:
    call    quit
```
```
~$ nasm -f elf64 helloworld-args.asm
~$ ld -m elf_x86_64 helloworld-args.o -o helloworld-args
~$ ./helloworld-args "This is one argument" "This is another" 101 
./helloworld-args
This is one argument
This is another 101
Error Segmentation Fault
```

If we were to compile the x86 version from Lesson 8 tutorial in asmtutor.com using the nasm -g option we could see the counter gets decremented correctly in GDB. As shown below we start with 3 in ECX. After continously clicking s to step in or n for next in Gdb eventually the program will exit. With ECX showing zero and no segmentation fault.

```
nasm -g -f elf helloworld-args.asm
ld -m elf_i386 helloworld-args.o -o helloworld-args
gdb --args ./helloworld-args "cars" "too"
break _start
run
s
info registers
```

![Image x86 register start](assets/images/x86gdbreg.png)
![Image x86 register zero](assets/images/x86inforegzero.png)

Now if we go back to our 64-bit example and compile it with nasm -g option for debugging we get a segmentation fault. We can see that at first we have 3 in ecx. Our program even prints out the correct stuff. This is due to helloworld-args saving the rcx through pop rcx. However once we get into sprint our code uses a syscall which clobbers the rcx value with a random value. d

```
nasm -g -f elf64 helloworld-args.asm
ld -m elf_x86_64 helloworld-args.o -o helloworld-args
gdb --args ./helloworld-args "cars" "too"
break _start
run
n
info registers
```

![Image x64 register start](assets/images/lesson8gdbstart.png)
![Image x64 register start2](assets/images/lesson8gdbregister.png)

Now that rcx has been clobbered the code will run even printing the right arguments. However the code will return back and never hit jz    noMoreArgs The reason being that it will think there are still more arguments left. eventually hitting a segmentation fault while in our functions.asm. [Click here to learn more about syscall clobber](https://peaku.co/questions/20070-%C2%BFcuando-linux-x86-64-syscall-clobber-%25r8%252C-%25r9-y-%25r10) What we know need to do is find a way to print the arguments without relying on RCX. 

![Image x64 rcx clobber](assets/images/lesson8GdbRcxClobber.png)

```
nasm -g -f elf64 helloworld-args.asm
ld -m elf_x86_64 helloworld-args.o -o helloworld-args
gdb --args ./helloworld-args "cars" "too"
```
## Lesson 8-1
Passing arguments 64-bit style

Seeing that RCX won't work like we could do in x86 using ECX. We need to use a different technique to print out arguments. Since we start without calling syscall we still have RCX holding the amount of arguments. So what we can do is move RCX into a placeholder and clear it when done using it. In this case I have updated the code to use r8. we move RCX in R8 and can now forget about RCX which will get clobbered by SYSCALL (SYSCALL also clobbers r11 register). Keep in mind if r8 was going to be used by other areas of your code you can run into issues. As we can see below it works succesfully.

[This example shows another way we can do this in 64-bit](https://gist.github.com/Gydo194/730c1775f1e05fdca6e9b0c175636f5b)

helloworld-args.asm
```
; Hello World Program (Passing arguments from the command line)
; Compile with: nasm -f elf64 helloworld-args.asm
; Link with: ld -m elf_x86_64 helloworld-args.o -o helloworld-args
; Run with: ./helloworld-args
 
%include        'functions.asm'
 
SECTION .text
global  _start
 
_start:
 
    pop     rcx             ; first value on the stack is the number of arguments
    mov     r8,rcx          ; Since rcx gets clobbered lets move it into r8
 
nextArg:
    cmp     r8, 0h         ; check to see if we have any arguments left
    jz      noMoreArgs      ; if zero flag is set jump to noMoreArgs label (jumping over the end of the loop)
    pop     rax             ; pop the next argument off the stack
    call    sprintLF        ; call our print with linefeed function
    dec     r8             ; decrease rcx (number of arguments left) by 1
    jmp     nextArg         ; jump to nextArg label
 
noMoreArgs:
    call    quit
```
```
~$ nasm -f elf64 helloworld-args.asm
~$ ld -m elf_x86_64 helloworld-args.o -o helloworld-args
~$ ./helloworld-args "This is one argument" "This is another" 101 
./helloworld-args
This is one argument
This is another
101
```
## lesson-9
User input

Introduction to the .bss section

So far we've used the .text and .data section so now it's time to introduce the .bss section. BSS stands for Block Started by Symbol. It is an area in our program that is used to reserve space in memory for uninitialised variables. We will use it to reserve some space in memory to hold our user input since we don't know how many bytes we'll need to store.

The syntax to declare variables is as follows:
.bss section example
```
SECTION .bss
variableName1:      RESB    1       ; reserve space for 1 byte
variableName2:      RESW    1       ; reserve space for 1 word
variableName3:      RESD    1       ; reserve space for 1 double word
variableName4:      RESQ    1       ; reserve space for 1 double precision float (quad word)
variableName5:      REST    1       ; reserve space for 1 extended precision float
```
Writing our program

We will be using the system call sys_read to receive and process input from the user. This function is assigned OPCODE 0 in the Linux System Call Table. Just like sys_write this function also takes 3 arguments which will be loaded into RDX, RSI and RDI before requesting a software interrupt that will call the function.

The arguments passed are as follows:
   - RDX will be loaded with the maximum length (in bytes) of the space in memory.
   - RSI will be loaded with the address of our variable created in the .bss section.
   - RDI will be loaded with the file we want to write to ??? in this case STDIN.

As always the datatype and meaning of the arguments passed can be found in the function's definition.

When sys_read detects a linefeed, control returns to the program and the users input is located at the memory address you passed in RSI.

helloworld-input.asm
```
; Hello World Program (Getting input)
; Compile with: nasm -f elf64 helloworld-input.asm
; Link with ld -m elf_x86_64 helloworld-input.o -o helloworld-input
; Run with: ./helloworld-input
 
%include        'functions.asm'
 
SECTION .data
msg1        db      'Please enter your name: ', 0h      ; message string asking user for input
msg2        db      'Hello, ', 0h                       ; message string to use after user has entered their name
 
SECTION .bss
sinput:     resb    255                                 ; reserve a 255 byte space in memory for the users input string
 
SECTION .text
global  _start
 
_start:
 
    mov     rax, msg1
    call    sprint
 
    mov     rdx, 255        ; number of bytes to read
    mov     rsi, sinput     ; reserved space to store our input (known as a buffer)
    mov     rdi, 0          ; write to the STDIN file
    mov     rax, 0          ; invoke SYS_READ (kernel opcode 0)
    syscall
 
    mov     rax, msg2
    call    sprint
 
    mov     rax, sinput     ; move our buffer into eax (Note: input contains a linefeed)
    call    sprint          ; call our print function
 
    call    quit
```

## lesson-10
Count to 10

Firstly, some background

Counting by numbers is not as straight forward as you would think in assembly. Firstly we need to pass sys_write an address in memory so we can't just load our register with a number and call our print function. Secondly, numbers and strings are very different things in assembly. Strings are represented by what are called ASCII values. ASCII stands for American Standard Code for Information Interchange. A good reference for ASCII can be found [here](https://www.asciitable.com/). ASCII was created as a way to standardise the representation of strings across all computers.

Remember, we can't print a number - we have to print a string. In order to count to 10 we will need to convert our numbers from standard integers to their ASCII string representations. Have a look at the ASCII values table and notice that the string representation for the number '1' is actually '49' in ASCII. In fact, adding 48 to our numbers is all we have to do to convert them from integers to their ASCII string representations.
Writing our program

What we will do with our program is count from 1 to 10 using the R8 register. We will then add 48 to our counter to convert it from a number to it's ASCII string representation. We will then push this value to the stack and call our print function passing RSP as the memory address to print from. Once we have finished counting to 10 we will exit our counting loop and call our quit function.

helloworld-10.asm
```
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
```
```
~$ nasm -f elf helloworld-10.asm 
~$ ld -m elf_i386 helloworld-10.o -o helloworld-10 
~$ ./helloworld-10 
1 
2 
3 
4 
5 
6 
7 
8 
9 
:
```
Error: Our number 10 prints a colon (:) character instead. What's going on? 

## lesson-11
Count to 10 (itoa)

So why did our program in Lesson 10 print out a colon character instead of the number 10?. Well lets have a look at our ASCII table. We can see that the colon character has a ASCII value of 58. We were adding 48 to our integers to convert them to their ASCII string representations so instead of passing sys_write the value '58' to print ten we actually need to pass the ASCII value for the number 1 followed by the ASCII value for the number 0. Passing sys_write '4948' is the correct string representation for the number '10'. So we can't just simply add 48 to our numbers to convert them, we first have to divide them by 10 because each place value needs to be converted individually.

We will write 2 new subroutines in this lesson 'iprint' and 'iprintLF'. These functions will be used when we want to print ASCII string representations of numbers. We achieve this by passing the number in RAX. We then initialise a counter in R8. We will repeatedly divide the number by 10 and each time convert the remainder to a string by adding 48. We will then push this onto the stack for later use. Once we can no longer divide the number by 10 we will enter our second loop. In this print loop we will print the now converted string representations from the stack and pop them off. Popping them off the stack moves RSP forward to the next item on the stack. Each time we print a value we will decrease our counter R8. Once all numbers have been converted and printed we will return to our program.

How does the divide instruction work?

The DIV and IDIV instructions work by dividing whatever is in RAX by the value passed to the instruction. The quotient part of the value is left in RAX and the remainder part is put into RDX (Originally called the data register).

For example.
IDIV instruction example
```
mov     rax, 10         ; move 10 into rax
mov     rsi, 10         ; move 10 into rsi
idiv    rsi             ; divide rax by rsi (rax will equal 1 and rdx will equal 0)
idiv    rsi             ; divide rax by rsi again (rax will equal 0 and rdx will equal 1)
```
If we are only storing the remainder won't we have problems?

No, because these are integers, when you divide a number by an even bigger number the quotient in RAX is 0 and the remainder is the number itself. This is because the number divides zero times leaving the original value as the remainder in RDX. How good is that?

Note: Only the new functions iprint and iprintLF have comments. 

functions.asm
```
;------------------------------------------
; void iprint(Integer number)
; Integer printing function (itoa)
iprint:
    push    rax             ; preserve rax on the stack to be restored after function runs
    push    r8             ; preserve r8 on the stack to be restored after function runs
    push    rdx             ; preserve rdx on the stack to be restored after function runs
    push    rsi             ; preserve rsi on the stack to be restored after function runs
    mov     r8, 0          ; counter of how many bytes we need to print in the end
 
divideLoop:
    inc     r8             ; count each byte to print - number of characters
    mov     rdx, 0          ; empty rdx
    mov     rsi, 10         ; mov 10 into rsi
    idiv    rsi             ; divide rax by rsi
    add     rdx, 48         ; convert rdx to it's ascii representation - rdx holds the remainder after a divide instruction
    push    rdx             ; push rdx (string representation of an intger) onto the stack
    cmp     rax, 0          ; can the integer be divided anymore?
    jnz     divideLoop      ; jump if not zero to the label divideLoop
 
printLoop:
    dec     r8             ; count down each byte that we put on the stack
    mov     rax, rsp        ; mov the stack pointer into rax for printing
    call    sprint          ; call our string print function
    pop     rax             ; remove last character from the stack to move esp forward
    cmp     r8, 0          ; have we printed all bytes we pushed onto the stack?
    jnz     printLoop       ; jump is not zero to the label printLoop
 
    pop     rsi             ; restore rsi from the value we pushed onto the stack at the start
    pop     rdx             ; restore rdx from the value we pushed onto the stack at the start
    pop     r8             ; restore r8 from the value we pushed onto the stack at the start
    pop     rax             ; restore rax from the value we pushed onto the stack at the start
    ret
 
 
;------------------------------------------
; void iprintLF(Integer number)
; Integer printing function with linefeed (itoa)
iprintLF:
    call    iprint          ; call our integer printing function
 
    push    rax             ; push rax onto the stack to preserve it while we use the rax register in this function
    mov     rax, 0Ah        ; move 0Ah into rax - 0Ah is the ascii character for a linefeed
    push    rax             ; push the linefeed onto the stack so we can get the address
    mov     rax, esp        ; move the address of the current stack pointer into rax for sprint
    call    sprint          ; call our sprint function
    pop     rax             ; remove our linefeed character from the stack
    pop     rax             ; restore the original value of rax before our function was called
    ret
;------------------------------------------
; int slen(String message)
; String length calculation function
slen:
    push    rdi
    mov     rdi, rax
 
nextchar:
    cmp     byte [rax], 0
    jz      finished
    inc     rax
    jmp     nextchar
 
finished:
    sub     rax, rdi
    pop     rdi
    ret
 
 
;------------------------------------------
; void sprint(String message)
; String printing function
sprint:
    push    rdx
    push    rsi
    push    rdi
    push    rax
    call    slen
 
    mov     rdx, rax
    pop     rax
 
    mov     rsi, rax
    mov     rdi, 1
    mov     rax, 1
    syscall
 
    pop     rdi
    pop     rsi
    pop     rdx
    ret
 
;------------------------------------------
; void sprintLF(String message)
; String printing with line feed function
sprintLF:
    call    sprint
 
    push    rax     
    mov     rax, 0Ah
    push    rax
    mov     rax, rsp
    call    sprint
    pop     rax
    pop     rax
    ret

;------------------------------------------
; void exit()
; Exit program and restore resources
quit:
    mov     rdi, 0
    mov     rax, 60
    syscall
    ret
```
helloworld-itoa.asm
```
; Hello World Program (Count to 10 itoa)
; Compile with: nasm -f elf64 helloworld-itoa.asm
; Link with: ld -m elf_x86_64 helloworld-itoa.o -o helloworld-itoa
; Run with: ./helloworld-itoa

%include        'functions.asm'
 
SECTION .text
global  _start
 
_start:
 
    mov     r8, 0
 
nextNumber:
    inc     r8
    mov     rax, r8
    call    iprintLF        ; NOTE call our new integer printing function (itoa)
    cmp     r8, 10
    jne     nextNumber
 
    call    quit
```
It should now print 1-10 correctly after compile and link
 
## lesson-12
Calculator - addition

In this program we will be adding the registers RAX and RBX together and we'll leave our answer in RAX. Firstly we use the MOV instruction to load RAX with an integer (in this case 90). We then MOV an integer into RBX (in this case 9). Now all we need to do is use the ADD instruction to perform our addition. RBX & RAX will be added together leaving our answer in the left most register in this instruction (in our case RAX). Then all we need to do is call our integer printing function to complete the program.
calculator-addition.asm
```
; Calculator (Addition)
; Compile with: nasm -f elf64 calculator-addition.asm
; Link with: ld -m elf_x86_64 calculator-addition.o -o calculator-addition
; Run with: ./calculator-addition
 
%include        'functions.asm'
 
SECTION .text
global  _start
 
_start:
 
    mov     rax, 90     ; move our first number into rax
    mov     rbx, 9      ; move our second number into rbx
    add     rax, rbx    ; add rbx to rax
    call    iprintLF    ; call our integer print with linefeed function
 
    call    quit
```
After link and compile running it should print out 99
$ ./calculator-addition
99

## lesson-13
Calculator - subtraction
In this program we will be subtracting the value in the register RBX from the value in the register RAX. Firstly we load RAX and RBX with integers in the same way as Lesson 12. The only difference is we will be using the SUB instruction to perform our subtraction logic, leaving our answer in the left most register of this instruction (in our case RAX). Then all we need to do is call our integer printing function to complete the program.
calculator-subtraction.asm
```
; Calculator (Subtraction)
; Compile with: nasm -f elf64 calculator-subtraction.asm
; Link with: ld -m elf_x86_64 calculator-subtraction.o -o calculator-subtraction
; Run with: ./calculator-subtraction
 
%include        'functions.asm'
 
SECTION .text
global  _start
 
_start:
 
    mov     rax, 90     ; move our first number into rax
    mov     rbx, 9      ; move our second number into rbx
    sub     rax, rbx    ; subtract rbx from rax
    call    iprintLF    ; call our integer print with linefeed function
 
    call    quit
```

## lesson-14
Calculator - multiplication
In this program we will be multiplying the value in RBX by the value present in RAX. Firstly we load RAX and RBX with integers in the same way as Lesson 12. This time though we will be calling the MUL instruction to perform our multiplication logic. The MUL instruction is different from many instructions in NASM, in that it only accepts one further argument. The MUL instruction always multiples RAX by whatever value is passed after it. The answer is left in RAX.

calculator-multiplication.asm
```
; Calculator (Multiplication)
; Compile with: nasm -f elf64 calculator-multiplication.asm
; Link with: ld -m elf_x86_64 calculator-multiplication.o -o calculator-multiplication
; Run with: ./calculator-multiplication
 
%include        'functions.asm'
 
SECTION .text
global  _start
 
_start:
 
    mov     rax, 90     ; move our first number into rax
    mov     rbx, 9      ; move our second number into rbx
    mul     rbx         ; multiply rax by rbx
    call    iprintLF    ; call our integer print with linefeed function
 
    call    quit
```
## lesson-15
Calculator - division

In this program we will be dividing the value in RBX by the value present in RAX. We've used division before in our integer print subroutine. Our program requires a few extra strings in order to print out the correct answer but otherwise there's nothing complicated going on.

Firstly we load RAX and RBX with integers in the same way as Lesson 12. Division logic is performed using the DIV instruction. The DIV instruction always divides RAX by the value passed after it. It will leave the quotient part of the answer in RAX and put the remainder part in RDX (the original data register). We then MOV and call our strings and integers to print out the correct answer.

calculator-division.asm
```
; Calculator (Division)
; Compile with: nasm -f elf64 calculator-division.asm
; Link with: ld -m elf_x86_64 calculator-division.o -o calculator-division
; Run with: ./calculator-division
 
%include        'functions.asm'
 
SECTION .data
msg1        db      ' remainder '      ; a message string to correctly output result
 
SECTION .text
global  _start
 
_start:
 
    mov     rax, 90     ; move our first number into rax
    mov     rbx, 9      ; move our second number into rbx
    div     rbx         ; divide rax by rbx
    call    iprint      ; call our integer print function on the quotient
    mov     rax, msg1   ; move our message string into rax
    call    sprint      ; call our string print function
    mov     rax, rdx    ; move our remainder into rax
    call    iprintLF    ; call our integer printing with linefeed function
 
    call    quit
```

## lesson-16
Calculator (atoi)
Our program will take several command line arguments and add them together printing out the result in the terminal.

### Writing our program

Our program begins by using the POP instruction to get the number of passed arguments off the stack. This value is stored in RCX (originally known as the counter register). It will then POP the next value off the stack containing the program name and remove it from the number of arguments stored in RCX. It will then loop through the rest of the arguments popping each one off the stack and performing our addition logic. As we know, arguments passed via the command line are received by our program as strings. Before we can add the arguments together we will need to convert them to integers otherwise our result will not be correct. We do this by calling our Ascii to Integer function (atoi). This function will convert the ascii value into an integer and place the result in RAX. We can then add this value to EDX (originally known as the data register) where we will store the result of our additions. If the value passed to atoi is not an ascii representation of an integer our function will return zero instead. When all arguments have been converted and added together we will print out the result and call our quit function.

### How does the atoi function work

Converting an ascii string into an integer value is not a trivial task. We know how to convert an integer to an ascii string so the process should essentially work in reverse. Firstly we take the address of the string and move it into RSI (originally known as the source register). We will then move along the string byte by byte (think of each byte as being a single digit or decimal placeholder). For each digit we will check if it's value is between 48-57 (ascii values for the digits 0-9).

Once we have performed this check and determined that the byte can be converted to an integer we will perform the following logic. We will subtract 48 from the value ??? converting the ascii value to it's decimal equivalent. We will then add this value to RAX (the general purpose register that will store our result). We will then multiple RAX by 10 as each byte represents a decimal placeholder and continue the loop.

When all bytes have been converted we need to do one last thing before we return the result. The last digit of any number represents a single unit (not a multiple of 10) so we have multiplied our result one too many times. We simple divide it by 10 once to correct this and then return. If no integer arguments were pass however, we skip this divide instruction.

### What is the BL register

You may have noticed that the atoi function references the BL register. So far in these tutorials we have been exclusively using 32bit registers. These 32bit general purpose registers contain segments of memory that can also be referenced. These segments are available in 16bits and 8bits. We wanted a single byte (8bits) because a byte is the size of memory that is required to store a single ascii character. If we used a larger memory size we would have copied 8bits of data into 32bits of space leaving us with 'rubbish' bits - because only the first 8bits would be meaningful for our calculation.

The RBX register is 32bits. RBX's 16 bit segment is referenced as BX. BX contains the 8bit segments BL and BH (Lower and Higher bits). We wanted the first 8bits (lower bits) of RBX and so we referenced that storage area using BL.

Almost every assembly language tutorial begins with a history of the registers, their names and their sizes. These tutorials however were written to provide a foundation in NASM by first writing code and then understanding the theory. The full story about the size of registers, their history and importance are beyond the scope of this tutorial but we will return to that story in later tutorials.

Note: Only the new function in this file 'atoi' is shown below. Also functions.asm does have RCX changed to R8 register since 64-bit clobbers RCX in syscalls. However the main calculator-atoi.asm doesn't use syscall until the end when it calls iprintLF, which eventually calls a syscall in functions.asm. This is why I changed ECX to RCX and left it at that, since we would have already pulled our arguments off the stack, and it won't matter anymore that RCX gets clobbered. 

functions.asm
```
;------------------------------------------
; int atoi(Integer number)
; Ascii to integer function (atoi)
atoi:
    push    rbx             ; preserve rbx on the stack to be restored after function runs
    push    r8             ; preserve r8 on the stack to be restored after function runs
    push    rdx             ; preserve rdx on the stack to be restored after function runs
    push    rsi             ; preserve rsi on the stack to be restored after function runs
    mov     rsi, rax        ; move pointer in rax into rsi (our number to convert)
    mov     rax, 0          ; initialise rax with decimal value 0
    mov     r8, 0          ; initialise r8 with decimal value 0
 
.multiplyLoop:
    xor     rbx, rbx        ; resets both lower and uppper bytes of rbx to be 0
    mov     bl, [rsi+r8]   ; move a single byte into rbx register's lower half
    cmp     bl, 48          ; compare rbx register's lower half value against ascii value 48 (char value 0)
    jl      .finished       ; jump if less than to label finished
    cmp     bl, 57          ; compare rbx register's lower half value against ascii value 57 (char value 9)
    jg      .finished       ; jump if greater than to label finished
 
    sub     bl, 48          ; convert rbx register's lower half to decimal representation of ascii value
    add     rax, rbx        ; add rbx to our interger value in rax
    mov     rbx, 10         ; move decimal value 10 into rbx
    mul     rbx             ; multiply rax by rbx to get place value
    inc     r8             ; increment r8 (our counter register)
    jmp     .multiplyLoop   ; continue multiply loop
 
.finished:
    cmp     r8, 0          ; compare r8 register's value against decimal 0 (our counter register)
    je      .restore        ; jump if equal to 0 (no integer arguments were passed to atoi)
    mov     rbx, 10         ; move decimal value 10 into rbx
    div     rbx             ; divide rax by value in rbx (in this case 10)
 
.restore:
    pop     rsi             ; restore rsi from the value we pushed onto the stack at the start
    pop     rdx             ; restore rdx from the value we pushed onto the stack at the start
    pop     r8             ; restore r8 from the value we pushed onto the stack at the start
    pop     rbx             ; restore rbx from the value we pushed onto the stack at the start
    ret
```
calculator-atoi.asm
```
; Calculator (ATOI)
; Compile with: nasm -f elf64 calculator-atoi.asm
;; Link with: ld -m elf_x86_64 calculator-atoi.o -o calculator-atoi
; Run with: ./calculator-atoi 20 1000 317
 
%include        'functions.asm'
 
SECTION .text
global  _start
 
_start:
 
    pop     rcx             ; first value on the stack is the number of arguments
    pop     rdx             ; second value on the stack is the program name (discarded when we initialise rdx)
    sub     rcx, 1          ; decrease rcx by 1 (number of arguments without program name)
    mov     rdx, 0          ; initialise our data register to store additions
 
nextArg:
    cmp     rcx, 0h         ; check to see if we have any arguments left
    jz      noMoreArgs      ; if zero flag is set jump to noMoreArgs label (jumping over the end of the loop)
    pop     rax             ; pop the next argument off the stack
    call    atoi            ; convert our ascii string to decimal integer
    add     rdx, rax        ; perform our addition logic
    dec     rcx             ; decrease rcx (number of arguments left) by 1
    jmp     nextArg         ; jump to nextArg label
 
noMoreArgs:
    mov     rax, rdx        ; move our data result into rax for printing
    call    iprintLF        ; call our integer printing with linefeed function
    call    quit            ; call our quit function
```
```
~$ nasm -f elf64 calculator-atoi.asm
~$ ld -m elf_x86_64 calculator-atoi.o -o calculator-atoi
~$ ./calculator-atoi 20 1000 317
1337
```

## lesson-17 
Namespace



## lesson-18
Fizz Buzz

## lesson-19
Execute Command

## lesson-20
Process Forking

## lesson-21
Telling the time

```
markdown
Syntax highlighted code block

# Header 1
## Header 2
### Header 3

- Bulleted
- List

1. Numbered
2. List

**Bold** and _Italic_ and `Code` text

[Link](url) and ![Image](src)
```

