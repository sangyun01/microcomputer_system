.global _start

.section .text
_start:
    mov r0, #1          @ 파일 디스크립터 1 (stdout)
    ldr r1, =msg        @ 출력할 문자열 주소
    mov r2, #10         @ 출력 길이
    mov r7, #4          @ 시스템 콜 번호 (sys_write)
    swi 0               @ 소프트웨어 인터럽트

    mov r7, #1          @ 시스템 콜 번호 (sys_exit)
    swi 0               @ 종료

.section .data
msg:
    .ascii "Hello, Pi!\n"


@내일 변경하기 + 라파이 복붙되는지 확인하기