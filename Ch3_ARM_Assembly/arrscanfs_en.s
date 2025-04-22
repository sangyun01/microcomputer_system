    .data
    .equ SIZE, 5
arr: .space 4*SIZE @ input the number of value is 5, and integer is 4byte so 4*SIZE
string1: .asciz "input the integer number"
string2: .asciz "%d" @ scanf
string3: .asciz "the store the element value of array.\n"
string4: .asciz "%d" @ printf

    .text
    .global main
    .extern printf
    .extern scanf

main:
    push {lr}

    mov r4, #0      @ r4 = 0

    ldr r5, =arr    @ r5 is address about arr first element

scanfloop:
    ldr r0, =string1    @ r0 is address about string1 first element
    bl printf           @ print "input the integer number"

    ldr r0, =string2    @ r0 is address about string2 first element
    mov r1, r5          @ bring the address r5, and copy the r1
    bl scanf            @ user input the number than store the element value

    add r5, r5, #4      @ r5 = r5 + 4, move the address
    add r4, r4, #1      @ r4 = r4 + 1, cnt
    cmp r4, #SIZE       @ r4 - SIZE
    blt scanfloop       @ not satisfy, move the scanfloop, satisfy break

    ldr r0, =string3    @ r0 is address about string3 first element
    bl printf           @ print "the store the element value of array.\n"

    mov r4, #0          @ r4 = 0, It can be also expression r4 = r4 - 5, but r4 = 0 is more safe
    ldr r5, =arr        @ r5 is address about arr first element, also reset the address same as r5 = r5 - 20

printloop:
    ldr r0, =string4    @ r0 is address about string4 first element
    ldr r1, [r5], #4    @ r1 = r5, r5 + 4, r5 + 8, r5 + 12, r5 + 16
    bl printf

    add r4, r4, #1      @ r4 = r4 + 1, cnt
    cmp r4, #SIZE       @ r4 - SIZE
    blt printloop       @ not satisfy, move the printloop, satisfy break

    pop {pc}
    .end
