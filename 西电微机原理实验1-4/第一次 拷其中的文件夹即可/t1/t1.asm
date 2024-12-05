DSEG SEGMENT
	next_row DB 0DH,0AH,24H
	buffer   DB 0100H dup('$')
	
	cmdpro   DB 'imput alpha >','$'
	STUID	 DB 'your id >','$'
	STUNAME  DB 'your name >','$'
DSEG ENDS

SSEG SEGMENT PARA STACK
		DW 256 DUP(?)
SSEG ENDS

CSEG SEGMENT
	ASSUME CS:CSEG,DS:DSEG
putchar proc
	push dx
	push ax
	mov  ah,02h
	mov  dl,al
	int  21h
	pop  ax
	pop  dx
	ret
putchar endp

getchar proc near
	mov ah,01h
	mov al,0
	int 21H
	retn
getchar endp


hex PROC near
		push ax
		push dx
		mov dx,ax
		mov ch,4
	L1:
		mov cl,4
		rol dx,cl
		mov al,dl
		and al,0FH
		add al,30h
		cmp al,3ah
		jl  printit
		add al,7h
	printit:
		call putchar
		dec  ch
		jnz  L1
		pop dx
		pop ax
		ret
hex ENDP

binary proc
		push bx
		push dx
		
		mov dh,0
	binaryagain:
	
		cmp dh,8
		je  binary
		rol ax,1
		mov bx,ax
		and ax,000
		mov dl,al
		add dl,48
		mov ah,2
		int 21h
		inc dh
		mov ax,bx
		jmp binary
	
	 binaryover:
	 	pop dx
	 	pop bx
	 	ret
	 	
binary endp

print proc near
		push bx
		push cx
		push dx
		
		mov dx,ax
		mov ah,09H
		mov al,00H
		int 21H
		
		pop dx
		pop cx
		pop bx
		ret
print endp

println proc near
		call print
		mov al,0DH
		call putchar
		mov al,0DH
		call putchar
		ret
println endp

newline proc near
		push ax
		lea ax,next_row
		call print                         
		pop ax
		ret
newline endp

input proc near
	push BX
	
	MOV DX,AX
	MOV BX,DX
	MOV byte ptr DS:[BX],0ffh
	
	mov ah,0ah
	mov al,0
	int 21h
	pop BX
	ret
	
input endp

circle proc near
	rolling:
	lea    ax,cmdpro
                      call   println
                      call   getchar
                      cmp    al,'q'
                      jz     fini
                      mov    ah,0
                      call newline
                      call   hex
                      call   newline
                      jmp    rolling
        fini:         
                      retn

circle endp


        ;调用约定：ax存放基地址，cx存放长度，bl存放目标字符
memset proc near
                      push   di
                      mov    di,ax
        memset_circle:
                      cmp    cx,0
                      jz     memset_fini
                      mov    ds:[di],bl
                      inc    di
                      dec    cx
                      jmp    memset_circle

        memset_fini:  
                      pop    di
                      ret
memset endp


exit proc near
                      mov    ah,4Ch
                      mov    al,0
                      int    21h
exit endp
       
        BEGIN:        
                      MOV    AX,DSEG
                      MOV    DS,AX


                      call   newline
                      lea    AX,STUID
                      call   print


                      call   newline
                      lea    AX,buffer
                      mov    cx,0ffh
                      mov    bl,'$'
                      call   memset
                      lea    AX,buffer
                      call   input


                      call   newline
                      lea    ax,[buffer+2]
                      call   print


                      call   newline
                      lea    AX,STUNAME
                      call   print


                      call   newline
                      lea    AX,buffer
                      mov    cx,0ffh
                      mov    bl,'$'
                      call   memset
                      lea    AX,buffer
                      call   input


                      call   newline
                      lea    ax,[buffer+2]
                      call   print
                      call   newline
                
                      call   circle


                      call   exit
CSEG ENDS
        END  BEGIN
