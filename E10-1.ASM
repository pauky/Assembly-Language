assume cs:code,ds:data
data segment
	db 'Welcome to masm!',0
data ends

code segment
start:	mov dh,8
	mov dl,3
	mov cl,2
	mov ax,data
	mov ds,ax
	mov si,0
	call show_str

	mov ax,4c00h
	int 21h

show_str: push ax
	push bp
	push si
	
	mov ax,0b800h
	mov es,ax

	; 计算行号对应的偏移地址
	mov al,160
	mul dh
	mov bp,ax

	; 计算列号对应的偏移地址, 与上述偏移地址叠加得到真正的偏移地址
	mov al,2
	mul dl
	add bp,ax

	; 遍历字符串，逐个字节复制到显存中
	mov si,0
	mov al,cl
s:	mov cl,ds:[si]
	mov ch,0
	jcxz ok ; 用cx==0判断是否遍历到字符串末尾，是则退出循环
	mov ch,al
	mov es:[bp],cx
	inc si
	add bp,2
	jmp s

ok:	pop si
	pop bp
	pop ax
	ret

code ends
end start

