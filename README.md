# microcomputer_system

터미널 창에 키면 이 순서로 파일을 생성 및 작동시킨다.

1. sudo vim function.s
2. i를 눌러 해당파일에 어셈블리어로 코드를 작성한다.
3. 작성 완료 후, esc -> : -> w -> q -> enter를 순서대로 한다.
4. ls를 입력하여 해당 파일이 write 되었는지 확인한다.
5. gcc function.s -o f //output file로 f를 만든다.
6. ./f //function.s에 작성한 코드의 결과가 출력된다.

참고사항
re f -> f 제거
@ 주석