    .data
string: .asciz "The result is %X%X\n"
@ %X => 16진수 대문자 출력 
@ 255 / %x -> ff / %X -> FF

    .text
    .global main
    .extern printf

main:
    push {lr}

    @ 32bit 2개를 이용하여 64bit 계산 과정
    mov r5, #0xFFFFFFFF @ overflow 발생 => 0xFFFFFFFF 로 32bit로 제한
    mov r6, #0xFFFFFFFF @ overflow 발생 => 0xFFFFFFFF 로 32bit로 제한

    adds r7, r5, r6 @ r7 = r5 + r6을 하고 캐리를 저장한다.
    @ r5 = 1111 / 1111 / 1111 / 1111 / 1111 / 1111 / 1111 / 1111 
    @ r6 = 1111 / 1111 / 1111 / 1111 / 1111 / 1111 / 1111 / 1111

    @ r7 = 1(carry로 빠짐) || 1111(F) / 1111(F) / 1111(F) / 1111(F) / 1111(F) / 1111(F) / 1111(F) / 1110(E)
    @ r7 => 0xFFFFFFFE

    mov r8, #0xFF   @ r5에서 남은 0xFF
    mov r9, #0xFF   @ r6에서 남은 0xFF
    adc r10, r8, r9
    @ r8 = 1111 / 1111
    @ r9 = 1111 / 1111
    @ r10 = r8 + r9 + 1
    @ r8 + r9
    @ => 1 / 1111 / 1110
    @ r8 + r9 + 1
    @ => 1 / 1111(F) / 1111(F)
    @ r10 = 1FF

    ldr r0, =string
    mov r1, r10 @1FF
    mov r2, r7 @FFFFFFFE
    
    bl printf
    pop {pc}