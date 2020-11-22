; 名称：中断例程实验13-2
; 功能：loop指令
; 参数：(cx)=循环次数，(dx)=位移
; 返回：无
assume cs:code

code segment
start:	; 拷贝中断例程到内存空间	
	mov ax,cs
	mov ds,ax
	mov si,offset lp
	mov ax,0
	mov es,ax
	mov di,200h
	mov cx,offset lpend - offset lp
	cld
	rep movsb

	; 设置中断向量表
	mov ax,0
	mov es,ax
	mov word ptr es:[7ch*4], 200h
	mov word ptr es:[7ch*4+2],0

	mov ax,4c00h
	int 21h

; 中断例程
lp:	push bp
	mov bp,sp
	dec cx
	jcxz lpret
	add [bp+2],bx ; bp的默认段寄存器是ss，所以bx的值会累加到系统栈中IP的值，从而使程序转移

lpret:	pop bp
	iret

lpend:	nop

code ends
end start
