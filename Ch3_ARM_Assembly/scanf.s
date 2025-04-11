    .data               @ data section
num: .word 0            @ num에 정수 0 초기화
string1: .asciz "%d"    @ for input the value - string1
string2: .asciz "The input number is %d\n"  @ for output - string2

    .text               @ code section
    .global main
    .extern printf
    .extern scanf

main:
    push {lr}           @ link register(r14)

    ldr r0, =string1    @ string1의 주소를 r0에 저장한다.
    ldr r1, =num        @ num의 주소를 r1에 저장한다
    bl scanf            @ %d를 호출하여 입력받은 값을 num의 주소에 저장한다
                        @ scanf("%d", &num)과 동일한 과정이다.

    ldr r0, =string2    @ r0에 string2의 주소를 저장한다.
    ldr r1, =num        @ r1에 num의 주소를 저장한다.
    ldr r1, [r1]        @ r1에 [r1]의 값을 저장한다.
    bl printf           @ printf 실행 printf("The input number is %d\n", num)

    pop {pc}



