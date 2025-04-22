    .data   @ data section
string: .asciz "The result is %d\n" @ ascii string type

    .text           @ code section
    .global main    @ defined the main function global not local
    .extern printf  @ declaring printf as external

main:
    push {lr}       @ store the address at link register r14 

    mov r5, #3      @ r5 = 3
    mov r6, #7      @ r6 = 7

    add r7, r5, r6  @ r7 = r5 + r6 = 3 + 7 = 10

    ldr r0, =string @ bring the address at string of first address
    mov r1, r7      @ r1 = r7 = 10, this process to using the printf

    bl printf       @ branch linked printf of extern function
    pop {pc}        @ load return address from stack(r14) into PC
