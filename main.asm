mov 3fh, #000h; carry32
carry32 equ 3fh

mov 30h, #0bch; OP0
mov 31h, #02ah; OP1
mov 32h, #073h; OP2
mov 33h, #0fah; OP3
op0 equ 30h
op1 equ 31h
op2 equ 32h
op3 equ 33h

mov 34h, #07bh; bol0
mov 35h, #000h; bol1
bol0 equ 34h
bol1 equ 35h


mov 64h, #000h; temp_bol0
mov 65h, #000h; temp_bol1
mov 66h, #000h; temp_bol2
mov 67h, #000h; temp_bol3
temp_bol0 equ 64h
temp_bol1 equ 65h
temp_bol2 equ 66h
temp_bol3 equ 67h

mov 6ch, #000h; temp2_bol0
mov 6dh, #000h; temp2_bol1
mov 6eh, #000h; temp2_bol2
mov 6fh, #000h; temp2_bol3
temp2_bol0 equ 6ch
temp2_bol1 equ 6dh
temp2_bol2 equ 6eh
temp2_bol3 equ 6fh

mov 74h, #000h; border0
mov 75h, #000h; border1
mov 76h, #000h; border2
mov 77h, #000h; border3
border0 equ 74h
border1 equ 75h
border2 equ 76h
border3 equ 77h

mov 44h, #000h; res0
mov 45h, #000h; res1
mov 46h, #000h; res2
mov 47h, #000h; res3
res0 equ 44h;
res1 equ 45h;
res2 equ 46h;
res3 equ 47h;

mov 54h, #001h; temp_res0
mov 55h, #000h; temp_res1
mov 56h, #000h; temp_res2
mov 57h, #000h; temp_res3
temp_res0 equ 54h;
temp_res1 equ 55h;
temp_res2 equ 56h;
temp_res3 equ 57h;

MAIN:
;	after gr32 and greq32
;	clear carry!
	ajmp DIV16
END: 
	mov a, #0
	jz END

DIV16:
;	if divisor>dividend
;	----------------
	mov temp_bol0, bol0
	mov temp_bol1, bol1
	mov temp2_bol0, bol0
	mov temp2_bol1, bol1
	mov acc, #temp_bol3
	push acc
	mov acc, #op3
	push acc
	acall GR32
	jnc GOTOEND
	mov a, #0
	addc a, #0
;	----------------
;	endif
	mov border0, temp_bol0
	mov border1, temp_bol1
	mov border2, temp_bol2
	mov border3, temp_bol3
DIV16WH1:
	mov acc, #border0
	push acc
	acall SHL32
	mov acc, carry32
	jnz DIV16WH1END
	mov acc, #border3
	push acc
	mov acc, #op3
	push acc
	acall GR32
	jnc DIV16WH1END
	mov a, #0
	addc a, #0
	mov acc, #temp_res0
	push acc
	acall SHL32
	mov acc, #temp_bol0
	push acc
	acall SHL32
	ajmp DIV16WH1

DIV16WH1END:
	mov res0, temp_res0
	mov res1, temp_res1
	mov res2, temp_res2
	mov res3, temp_res3
	
	mov acc, #op0
	push acc
	mov acc, #temp_bol0
	push acc
	acall SUB32
	ajmp D16WH2
GOTOEND:
	ajmp DIV16END

D16WH2:
	mov acc, #temp2_bol3
	push acc
	mov acc, #temp_bol3
	push acc
	acall GR32
	jnc DIV16END
	mov a, #0
	addc a, #0
D16WH3:
	mov acc, #op3
	push acc
	mov acc, #temp_bol3
	push acc
	acall GREQ32
	jnc D16WH3END
	mov a, #0
	addc a, #0

	mov acc, #temp_res3
	push acc
	acall SHR32
	mov acc, #temp_bol3
	push acc
	acall SHR32

	ajmp D16WH3

D16WH3END:
	mov acc, #op0
	push acc
	mov acc, #temp_bol0
	push acc
	acall SUB32
	mov acc, #res0
	push acc
	mov acc, #temp_res0
	push acc
	acall ADD32
	ajmp D16WH2
DIV16END:
	mov op0, res0
	mov op1, res1
	mov op2, res2
	mov op3, res3
	ajmp END

SHL32:
;	store ret adress
;	----------------
	pop acc
	mov R6, acc
	pop acc
	mov R7, acc
;	----------------
	pop acc
	mov R0, acc
	mov acc, @R0
	rlc a
	mov @R0, a
	ýnc R0
	mov acc, @R0
	rlc a
	mov @R0, a
	ýnc R0
	mov acc, @R0
	rlc a
	mov @R0, a
	ýnc R0
	mov acc, @R0
	rlc a
	mov @R0, a
	ýnc R0
	mov a, #0
	addc a, #0; clear carry
	mov carry32, a
;	push ret adress
;	----------------
	mov acc, R7
	push acc
	mov acc, R6
	push acc
;	----------------	
	ret

SHR32:
;	store ret adress
;	----------------
	pop acc
	mov R6, acc
	pop acc
	mov R7, acc
;	----------------
	pop acc
	mov R0, acc
	mov acc, @R0
	rrc a
	mov @R0, a
	dec R0
	mov acc, @R0
	rrc a
	mov @R0, a
	dec R0
	mov acc, @R0
	rrc a
	mov @R0, a
	dec R0
	mov acc, @R0
	rrc a
	mov @R0, a
	dec R0
	mov a, #0
	addc a, #0; clear carry
;	push ret adress
;	----------------
	mov acc, R7
	push acc
	mov acc, R6
	push acc
;	----------------	
	ret

ADD32:
;	store ret adress
;	----------------
	pop acc
	mov R6, acc
	pop acc
	mov R7, acc
;	----------------
	pop acc
	mov R0, acc
	mov acc, @R0
	mov R2, acc
	pop acc
	mov R1, acc
	mov acc, @R1
	mov R3, acc
	mov b, R2
	mov acc, R3
	addc a, b
	mov @R1, acc
	ýnc R0
	ýnc R1

	mov acc, @R0
	mov R2, acc
	mov acc, @R1
	mov R3, acc
	mov b, R2
	mov acc, R3
	addc a, b
	mov @R1, acc
	ýnc R0
	ýnc R1

	mov acc, @R0
	mov R2, acc
	mov acc, @R1
	mov R3, acc
	mov b, R2
	mov acc, R3
	addc a, b
	mov @R1, acc
	ýnc R0
	ýnc R1

	mov acc, @R0
	mov R2, acc
	mov acc, @R1
	mov R3, acc
	mov b, R2
	mov acc, R3
	addc a, b
	mov @R1, acc
	addc a, #0; clear carry
;	push ret adress
;	----------------
	mov acc, R7
	push acc
	mov acc, R6
	push acc
;	----------------	
	ret

SUB32:
;	store ret adress
;	----------------
	pop acc
	mov R6, acc
	pop acc
	mov R7, acc
;	----------------
	pop acc
	mov R0, acc
	mov acc, @R0
	mov R2, acc
	pop acc
	mov R1, acc
	mov acc, @R1
	mov R3, acc
	mov b, R2
	mov acc, R3
	subb a, b
	mov @R1, acc
	ýnc R0
	ýnc R1

	mov acc, @R0
	mov R2, acc
	mov acc, @R1
	mov R3, acc
	mov b, R2
	mov acc, R3
	subb a, b
	mov @R1, acc
	ýnc R0
	ýnc R1

	mov acc, @R0
	mov R2, acc
	mov acc, @R1
	mov R3, acc
	mov b, R2
	mov acc, R3
	subb a, b
	mov @R1, acc
	ýnc R0
	ýnc R1

	mov acc, @R0
	mov R2, acc
	mov acc, @R1
	mov R3, acc
	mov b, R2
	mov acc, R3
	subb a, b
	mov @R1, acc

	addc a, #0; clear carry
;	push ret adress
;	----------------
	mov acc, R7
	push acc
	mov acc, R6
	push acc
;	----------------	
	ret

GR32:
;	store ret adress
;	----------------
	pop acc
	mov R6, acc
	pop acc
	mov R7, acc
;	----------------
	pop acc
	mov R0, acc
	pop acc
	mov R1, acc
	mov R4, #4
GRLOOP:
	mov a, R4
	jz GREND
	mov acc, @R0
	mov R2, acc
	mov acc, @R1
	mov R3, acc
	mov acc, R3
	mov b, R2
	subb a, b
	dec R4
	dec R1
	dec R0
	jz GRLOOP
	ajmp GREND
GREND2:
	mov a, #0ffh
	add a, #1
GREND:
;	push ret adress
;	----------------
	mov acc, R7
	push acc
	mov acc, R6
	push acc
;	----------------	
	ret

GREQ32:
;	store ret adress
;	----------------
	pop acc
	mov R6, acc
	pop acc
	mov R7, acc
;	----------------
	pop acc
	mov R0, acc
	pop acc
	mov R1, acc
	mov R4, #4
GREQLOOP:
	mov a, R4
	jz GREQEND
	mov acc, @R0
	mov R2, acc
	mov acc, @R1
	mov R3, acc
	mov acc, R3
	mov b, R2
	subb a, b
	dec R4
	dec R1
	dec R0
	jz GREQLOOP

GREQEND:
;	push ret adress
;	----------------
	mov acc, R7
	push acc
	mov acc, R6
	push acc
;	----------------	
	ret
