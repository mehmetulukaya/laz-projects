mov r1, 5
mov r2, 0
cmp r1, 0
beq 10
add r2, r1
sub r1, 1
jmp 8
clz
mov r3, 100
mov 10(r3), r2
push r2
mov r2, 0
pop r4
halt
