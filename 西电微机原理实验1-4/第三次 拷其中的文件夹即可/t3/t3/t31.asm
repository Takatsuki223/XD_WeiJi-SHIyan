IO244	EQU	0230H	
IO273	EQU	0230H	

_STACK	SEGMENT	STACK
		DW	100	DUP(?)
_STACK	ENDS

_DATA	SEGMENT WORD	 PUBLIC 'DATA'
_DATA	ENDS

CODE		SEGMENT
ASSUME CS:CODE, DS:_DATA, SS:_STACK
START	PROC	 NEAR
		MOV	AX, _DATA
        	MOV DS, AX
INPUT:	
		MOV	DX, IO244
		IN	AL, DX
		CMP	AL, 0FFH	;若开关全为低电平
		JZ Q1			;从右往左依次点亮	
		CMP	AL, 0		;若开关全为高电平
		JZ Q2			;从左往右依次点亮
		MOV	DX, IO273
		NOT	AL			;AX取非送给273,点亮对应的二极管
		OUT	DX, AL
		JMP	INPUT
Q1:
		MOV	AL, 7FH
		MOV	DX, IO273
R2L:
		CALL	 DELAY		;延时
		OUT	DX, AL		;送给273,点亮对应的二极管
		ROL	AL, 1
		CMP	AL, 7FH
		JNE	R2L			;若相等,说明一轮从右往左已经完成,若不等,则继续循环
		JMP	INPUT
		
Q2:
		MOV	AL, 0FEH
		MOV	DX, IO273
L2R:
		CALL	 DELAY
		OUT	DX, AL
		ROR	AL, 1
		CMP	AL, 0FEH
		JNE	L2R			;若相等,说明一轮从左往右已经完成,若不等,则继续循环
		JMP	INPUT		;继续读入开关状态
Delay 	PROC NEAR		;延时子程序
Delay1:	
XOR	CX,CX		;做一个异或操作将CX清零,仅循环一次
		LOOP	$
		RET
Delay	ENDP
START	ENDP		
CODE		ENDS		
END		START
