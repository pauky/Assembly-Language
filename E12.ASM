; 安装中断程序
assume cs:code
code segment
start:	mov ax,cs
	mov ds,ax
	mov si,offset do0 ; 设置ds:si指向源地址
	mov ax,0
	mov es,ax
	mov di,200h ; 设置es:di指向目的地址，因为中断向量表的长度不超过256个字节，所以后面的内存空间可以存储中断程序
	
	mov cx,offset do0end-offset do0 ; 设置cx为传输长度
	
	cld ; 设置传输方向为正
	rep movsb

	; 设置中断表
	mov ax,0
	mov es,ax
	mov word ptr es:[0*4],200h
	mov word ptr es:[0*4+2],0

	mov ax,4c00h
	int 21h

; 中断程序
do0:	jmp short do0start
	db "divide error!"

do0start:mov ax,cs
	mov ds,ax
	mov si,202h ; 设置ds:si指向字符串，因为上面的jmp指令占两个字节

	mov ax,0b800h
	mov es,ax
	mov di,12*160+36*2 ; 设置es:di指向显存空间的中间位置

	mov cx,13
s:	mov ax,[si]
	mov es:[di],al
	inc si
	add di,2
	loop s

	mov ax,4c00h
	int 21h

do0end:	nop

code ends
end start
