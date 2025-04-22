    .data
    .equ SIZE, 5    @ we input the 5 value to user
arr: .space 4*SIZE  @ integer has 4 byte so, multiply 4 about SIZE
string1: .asciz "input the integer number"
string2: .asciz "%d"
string3: .asciz "the store the element value of array.\n"
string4: .asciz "%d"

    .text
    .global main
    .extern printf

main:
    push {lr}

    mov r4, #0      @ same as int i = 0, for loop

    ldr r5, =arr    @ store array initial address to r5
@begin scanfloop => user input the value process
scanfloop:
    ldr r0, =string1    @ different the section about string1 so use ldr not adr
    bl printf           @ then printing the sentence "input the integer number"

    ldr r0, =string2    @ for store the value when input the integer type value
    mov r1, r5          @ I use the bl scanf so allocate r1 to r5 data(array address)
    bl scanf

    add r5, r5, #4      @ increase the address 4(integer)
    add r4, r4, #1      @ increase the count
    cmp r4, #SIZE       @ r4 - #SIZE = r4 - 5
    blt scanfloop       @ if r4 < 5 move the scanfloop again
                        @ when r4 = 5, break the loop
                        @ not consider r4 > 5, already break the loop why the r4 = 5
@ break the looop
    ldr r0, =string3    @ for print
    bl printf

    mov r4, #0          @ reset the value r4
    ldr r5, =arr        @ also reset the address original address
                        @ can use the r5 = r5 - 4*SIZE, but most safe about exam..and real... using ldr r5, =arr
                        @ 모르겠으면 걍 ldr r5, =arr 써라..! 입력을 다 못받은 예외상황도 발생할 수 있어서서

@begin the printloop
printloop:
    ldr r0, =string4    @ process about printing the value
    ldr r1, [r5], #4
    bl printf

    add r4, r4, #1      @ r4 = r4 + 1 @@ counting process
    cmp r4, #SIZE   
    blt printloop       @ if r4 = #SIZE -> r4 = 5, then break the printloop

    pop {pc}
    .end
