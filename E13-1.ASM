; 名称：中断例程实验13-1
; 功能：安装int 7ch中断例程，功能为显示一个用0结束的字符串，中断例程安装在0:200处
; 参数：(dh)=行号，(dl)=列号，(cl)=颜色，ds:si指向字符串首地址
; 返回：0:200处的中断例程
assume cs:code

code segment
start:	; 拷贝中断例程到内存空间	
	mov ax,cs
	mov ds,ax
	mov si,offset do0
	mov ax,0
	mov es,ax
	mov di,200h
	mov cx,offset do0end - offset do0
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
do0:	push di
	push si
	push ax
	push cx

	mov ax,0b800h
	mov es,ax

	; 计算显存偏移量
	mov di,0
	mov al,160
	mul dh
	add di,ax
	mov al,2
	mul dl
	add di,ax

	; 拷贝数量到显存
s:	mov al,[si]
	mov ah,0
	cmp ax,0
	je ok
	mov ah,cl
	mov es:[di],ax
	inc si
	add di,2
	jmp short s

ok:	pop cx
	pop ax
	pop si
	pop di
	iret

do0end:	nop
	
code ends
end start
