COM_ADD EQU 0273H 
PA_ADD EQU 0270H 
PB_ADD EQU 0271H 
PC_ADD EQU 0272H 
_STACK SEGMENT STACK 
 DW 100 DUP(?) 
_STACK ENDS 
_DATA SEGMENT WORD PUBLIC 'DATA' 
_DATA ENDS 
CODE SEGMENT 
START PROC NEAR 
	ASSUME CS:CODE, DS:_DATA, SS:_STACK 
	MOV AX,_DATA  ; 将数据段地址加载到AX寄存器
	MOV DS,AX ; 将数据段地址传送给数据段寄存器DS
	NOP 
	MOV DX,COM_ADD ; 将串口地址传送给DX寄存器
	MOV AL,82H ; 设置AL寄存器的值为82H
	OUT DX,AL 
	
 
INPUT:	
		 ; 清零操作
		MOV     AX, 0FFFFH 
		MOV	DX, PA_ADD
		OUT     DX, AX
		MOV	DX, PC_ADD
		OUT     DX, AX
		; 输入操作
		MOV	DX, PB_ADD
		IN	al, DX
		mov    ah, 0
		
		; 判断
		CMP	al, 0FFH ;全1
		JZ low1	
		CMP	al, 0 ;全0
		JZ high1			
		MOV	DX, PA_ADD	
		OUT	DX, al
		JMP	INPUT
; 处理输入值为0-7的情况
low1:
		MOV	al, 7FH ; 设置AL寄存器的值为7FH
		MOV	DX, PA_ADD ; 将并口PA地址传送给DX寄存器
low2:	
		ROL	al, 1 ; 将AL寄存器的值左循环移位1位
		OUT	DX, al	
		CALL    Delay
		CMP	al, 7FH
		JNE	low2
		MOV    AX, 0FFFFH ; 将AX寄存器的值设为0xFFFF
		OUT     DX, AX	
; 处理输入值为8-15的情况
low3:
		MOV	al, 7FH
		MOV	DX, PC_ADD
low4:
		ROL	al, 1
		OUT	DX, al	
		CALL    Delay
		CMP	al, 7FH
		JNE	low4		
		JMP	INPUT

; 处理输入值为15-8的情况		
high1:
		MOV	al, 0FEH
		MOV	DX, PC_ADD
high2:	
		ROR	al, 1
		OUT	DX, al	
		CALL    Delay
		CMP	al, 0FEH
		JNE	high2
		MOV    AX, 0FFFFH
		OUT     DX, AX	
; 处理输入值为7-0的情况
high3:
		MOV	al, 0FEH
		MOV	DX, PA_ADD
high4:
		ROR	al, 1
		OUT	DX, al	
		CALL    Delay
		CMP	al, 0FEH
		JNE	high4		
		JMP	INPUT




Delay 	PROC NEAR		
Delay1:	
XOR	CX,CX
		LOOP	$
		RET
Delay	ENDP


START ENDP 
CODE ENDS 
END START
