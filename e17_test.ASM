assume cs:code
code segment
; 从磁盘的逻辑扇区2读取数据显示到屏幕上
start:	mov ax,0b800h
	mov es,ax
	mov ax,0
	mov dx,2
	mov bx,0
	int 7ch

	mov ax,4c00h
	int 21h
code ends
end start
