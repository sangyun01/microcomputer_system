    .data
num: .word 0            @ num에 정수 0 저장
string1: .asciz "%d"    @ 입력받기 위해 string1 선언
string2: .asciz "The input number is %d\n"  @ 출력하기 위해 string2

    .text
    .global main
    .extern printf

main:
    push {lr}   @ link register(r14)

    ldr r0, =string1    @ string1의 주소를 r0에 저장한다.
    ldr r1, =num        @ num의 주소를 r1에 저장한다
    bl scanf            @ scanf하여 scanf("%d", &num)과 동일한 과정이다.

    ldr r0, =string2    @ r0에 string2의 주소를 저장한다.
    ldr r1, =num        @ r1에 num의 주소를 저장한다.
    ldr r1, [r1]        @ r1에 [r1]의 값을 저장한다.
    bl printf           @ printf 실행 printf("The input number is %d\n", num)

    pop {pc}



