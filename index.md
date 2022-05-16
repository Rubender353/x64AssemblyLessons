[Lesson 1](#lesson-1) <b>Hello, world!</b>
[Lesson 2](#lesson-2) <b>Proper program exit</b>
[Lesson 3](#lesson-3) <b>Calculate string length</b>
[Lesson 4](#lesson-4) <b>Subroutines</b>
[Lesson 5](#lesson-5) <b>External include files</b>
[Lesson 6](#lesson-6) <b>NULL terminating bytes</b>
[Lesson 7](#lesson-7) <b>Linefeeds</b>

[Lesson 8](#lesson-8) <b>Passing arguments</b>
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
RDI will be loaded with the file we want to write to – in this case STDOUT.
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

To calculate the length of the string we will use a technique called pointer arithmetic. Two registers are initialised pointing to the same address in memory. One register (in this case EAX) will be incremented forward one byte for each character in the output string until we reach the end of the string. The original pointer will then be subtracted from EAX. This is effectively like subtraction between two arrays and the result yields the number of elements between the two addresses. This result is then passed to sys_write replacing our hard coded count.

The CMP instruction compares the left hand side against the right hand side and sets a number of flags that are used for program flow. The flag we're checking is the ZF or Zero Flag. When the byte that EAX points to is equal to zero the ZF flag is set. We then use the JZ instruction to jump, if the ZF flag is set, to the point in our program labeled 'finished'. This is to break out of the nextchar loop and continue executing the rest of the program.

```

```
```

```


```markdown
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

