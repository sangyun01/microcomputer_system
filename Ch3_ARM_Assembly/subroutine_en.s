    .data
main_string: .asciz "main\n"
sub1_string: .asciz "subroutine 1\n"
sub2_string: .asciz "subroutine 2\n"

    .text
    .global main
    .extern printf

main:
    stmfd r13!, {r14}           @ 1, same as push {lr} and using stack pointer r13
    ldr r0, =main_string        @ 2,
    bl printf                   @ 3, printf "main\n"
    bl sub1                     @ 4, branch linked sub1
    ldmfd r13!, {pc}            @ 14, same as pop {pc}

sub1:
    stmfd r13!, {r0-r12, r14}   @ 5, using stack because store the register value where using the main function, This process prevent the override the main function register value
    ldr r0, =sub1_string        @ 6,
    bl printf                   @ 7, printf "subroutine 1\n"
    bl sub2                     @ 8, branch linked sub2
    ldmfd r13!, {r0-r12, pc}    @ 13, pop process, return main

sub2:
    stmfd r13!, {r0-r12, r14}   @ 9, same as sub1, prevent the override the sub1 function register value
    ldr r0, =sub2_string        @ 10
    bl printf                   @ 11, printf "subroutine 2\n"
    ldmfd r13!, {r0-r12, pc}    @ 12, pop process, return sub 1
