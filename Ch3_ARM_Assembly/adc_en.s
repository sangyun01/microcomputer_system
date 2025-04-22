    .data   @ data section 
string: .asciz "The result is %X%X\n"
            @ using hexadecimal
            @ this code will be overflow calculate, when add process so using %X%X

    .text   @ omit
    .global main
    .extern printf

@ #0xFF|FFFF|FFFF + #0xFF|FFFF|FFFF = #0x1FF|FFFF|FFFE

main:
    push {lr}
                        @ under 8-digit
    mov r5, #0xFFFFFFFF @ r5 = #0xFFFF|FFFF
    mov r6, #0xFFFFFFFF @ r6 = #0xFFFF|FFFF

    adds r7, r5, r6     @ r5 = #0xFFFF|FFFF
                        @ r6 = #0xFFFF|FFFF
                        @ r7 = #0xFFFF|FFFE @ occur overflow -> C=1

    mov r8, #0xFF       @ r8 = #0xFF
    mov r9, #0xFF       @ r9 = #0xFF
    adc r10, r8, r9     @ r10 = 0xFF + 0xFF + C -> #0x1FF

    ldr r0, =string
    mov r1, r10         @ 1FF
    mov r2, r7          @ FFFFFFFE

    bl printf
    pop {pc}
