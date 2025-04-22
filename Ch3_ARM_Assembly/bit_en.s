    .data   @ data section
string: .asciz "The result %08X (AND) %08X (BIC)"
            @ using 8-digit hexadecimal
    .text   @ code section
    .global main    @ define the main function global
    .extern printf  @ using the printf at extern

main:
    push {lr}

    mov r5, #0x000000FF @ r5 = #0x000000FF 
    mov r6, #0xFFFFFFFF @ r6 = #0xFFFFFFFF

    and r7, r5, r6      @ #0x000000FF

    bic r8, r5, r6      @ r5 =  #0x000000FF
                        @ ~r6 = #0x00000000
                        @ r8 =  #0x00000000
                        @ same as other code
    ldr r0, =string
    mov r1, r7
    mov r2, r8

    bl printf
    pop {pc}
    .end
