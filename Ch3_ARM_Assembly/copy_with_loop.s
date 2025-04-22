    .data
string: .asciz "The result is %d, %d, and %d\n"
    .align
TABLE1: .word 10, 20, 30
TABLE2: .word 0, 0, 0
@ before using the code copy_without_loop.s

    .text
    .global main
    .extern printf

main:
    push {lr}

    mov r4, #0
    @ r4 similar about C -> int i at for loop

    ldr r5, =TABLE1 @ store the TABLE1 initial address
    ldr r6, =TABLE2
@ begin loop
loop:
    ldr r7, [r5], #4    @ r7 load the r5 value, store after r5 = r5 + 4
                        @ r5에서 로드한 값을 r7에 저장하고, 이후에 r5를 4 더해준다.
    str r7, [r6], #4    @ where the r6 address about r7 value, and execute r6 = r6 + 4

    add r4, r4, #1      @ r4 = r4 + 1 => same as i++ 
    cmp r4, #3          @ r4 - 3 
    bne loop            @ if r4 < 3, then move(branch) the loop first part

    sub r6, r6, 12      @ r6 = r6 - 12
                        @ the reason why already r6 is increase 12 about initial r6
                        @ but we want the print r6 array so decrease 12

    ldr r0, =string     @ printing process
    ldr r1, [r6]        
    ldr r2, [r6, #4]    @ [r6, #4] means store the value locate r6+4 address, where the r2
    ldr r3, [r6, #8]    @ r6 + 8을 한 주소에 있는 값을 r3에 저장한다. @선행연산

    bl printf
    pop {pc}
    .end