    .data
main_string: .asciz "main\n"
sub1_string: .asciz "subroutine 1\n"
sub2_string: .asciz "subroutine 2\n"

    .text
    .global main
    .extern printf

@ I will type the number of process
main:
    stmfd r13!, {r14}           @ 1
    ldr r0, =main_string        @ 2
    bl printf                   @ 3
    bl sub1                     @ 4
    ldmfd r13!, {pc}            @ 14
sub1:                           
    stmfd r13!, {r0-r12, r14}   @ 5
    ldr r0, =sub1_string        @ 6
    bl printf                   @ 7
    bl sub2                     @ 8
    ldmfd r13!, {r0-r12, pc}    @ 13
sub2:
    stmfd r13!, {r0-r12, r14}   @ 9
    ldr r0, =sub2_string        @ 10
    bl printf                   @ 11
    ldmfd r13!, {r0-r12, pc}    @ 12

@ explain the code about sub1, other code similar
sub1:                           @ subfunction where the main                   
    stmfd r13!, {r0-r12, r14}   @ r14 is lr, linked register. And it stored first input
                                @ r14, r12, r11...r1, r0, about using register value main code
    ldr r0, =sub1_string        @ override r0 value
    bl printf                   @ using branch linked printf where extern
    bl sub2                     @ move the sub2
    ldmfd r13!, {r0-r12, pc}    @ pop process, and lastly located pc is r14, so can return main code
