; 按下“A"键后，除非不再松开，如果松开，就显示满屏幕的”A”，其他的键照常处理
; 注意：多次执行些程序，键盘其它键的中断将失效，因为再次绑定时，中断表已经是新的中断子例程，不是BIOS提供的了
assume cs:code
stack segment
	db 128 dup (0)
stack ends

code segment
start:	mov ax,stack
	mov ss,ax
	mov sp,128

	push cs
	pop ds

	mov ax,0
	mov es,ax

	; 中断子例程拷贝到特定内存位置
	mov si,offset int9
	mov di,204h
	mov cx,offset int9end-offset int9
	cld
	rep movsb

	; 暂存原先的int9中断地址
	push es:[9*4]
	pop es:[200h]
	push es:[9*4+2]
	pop es:[202h]

	; 设置中断表，注意先不响应可屏蔽中断，设置完中断表再恢复，防止设置一半突然产生中断，导致中断地址异常
	cli
	mov word ptr es:[9*4],204h
	mov word ptr es:[9*4+2],0
	sti

	mov ax,4c00h
	int 21h

int9:	push ax
	push bx
	push cx
	push es

	in al,60h
	
	pushf
	call dword ptr cs:[200h]

	cmp al,9eh ; 1eh+80h松开"A"的扫描码
	jne int9ret

	mov ax,0b800h
	mov es,ax
	mov bx,0
	mov cx,2000

s:	mov byte ptr es:[bx], 41h
	add bx,2
	loop s

int9ret:
	pop es
	pop cx
	pop bx
	pop ax
	iret

int9end:nop

code ends
end start
